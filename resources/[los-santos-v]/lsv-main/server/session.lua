local logger = Logger.New('Session')

local _lastSpawnPointIndex = nil

local _nowDate = os.date('*t')
local _serverRestartTime = table.ifind_if(Settings.serverRestart.times, function(time)
	return _nowDate.hour < time.hour
end)

local _serverRestartDate = _nowDate
_serverRestartDate.hour = _serverRestartTime.hour
_serverRestartDate.min = _serverRestartTime.min
_serverRestartDate.sec = 0

logger:info('Next server restart at '.._serverRestartDate.hour..':'.._serverRestartDate.min)

local _maxPlayersCount = GetConvarInt('sv_maxclients', 32)
local _playersQueue = { }

local _isOneSyncEnabled = false
Citizen.CreateThread(function()
	_isOneSyncEnabled = GetConvar('onesync', '') == 'on'
end)

local function sortPlayersQueue(l, r)
	if l.isPatreon and not r.isPatreon then return true end
	if not l.isPatreon and r.isPatreon then return false end

	if l.isModerator and not r.isModerator then return true end
	if not l.isModerator and r.isModerator then return false end

	return l.loginTime < r.loginTime
end

local function getPlayerPositionInQueue(playerId)
	local unk, position = table.ifind_if(_playersQueue, function(data)
		return data.id == playerId
	end)

	return position
end

local function initPlayer(player, playerName, playerStats, isRegistered)
	if not playerStats.SkinModel then
		playerStats.SkinModel = Settings.defaultPlayerModel
	else
		playerStats.SkinModel = json.decode(playerStats.SkinModel)
	end

	if not playerStats.Weapons then
		playerStats.Weapons = Settings.defaultPlayerWeapons
	else
		playerStats.Weapons = json.decode(playerStats.Weapons)
	end

	if not playerStats.WeaponStats then
		playerStats.WeaponStats = { }
	else
		playerStats.WeaponStats = json.decode(playerStats.WeaponStats)
	end

	playerStats.Rank = Rank.CalculateRank(playerStats.Experience)
	playerStats.SkillStats = Stat.CalculateStats(playerStats.Rank)

	if not playerStats.PatreonTier then
		playerStats.PatreonTier = 0
	end

	local nowTime = os.time()
	if not playerStats.LoginTime then
		playerStats.LoginTime = nowTime
	end

	playerStats.Seed = nowTime

	playerStats.ServerRestartIn = os.time(_serverRestartDate) - nowTime

	local spawnPoints = Settings.spawn.points
	if _lastSpawnPointIndex then
		spawnPoints = table.ifilter(spawnPoints, function(_, i)
			return i ~= _lastSpawnPointIndex
		end)
	end

	_lastSpawnPointIndex = math.random(#spawnPoints)
	playerStats.SpawnPoint = spawnPoints[_lastSpawnPointIndex]

	if not playerStats.Garages then
		playerStats.Garages = { }
	else
		playerStats.Garages = json.decode(playerStats.Garages)
	end

	if not playerStats.Vehicles then
		playerStats.Vehicles = { }
	else
		playerStats.Vehicles = json.decode(playerStats.Vehicles)
	end

	if not playerStats.DrugBusiness then
		playerStats.DrugBusiness = { }
	else
		playerStats.DrugBusiness = json.decode(playerStats.DrugBusiness)
	end

	if not playerStats.Records then
		playerStats.Records = { }
	else
		playerStats.Records = json.decode(playerStats.Records)
	end

	if not playerStats.Settings then
		playerStats.Settings = { }
	else
		playerStats.Settings = json.decode(playerStats.Settings)
	end

	if not isRegistered then
		if not playerStats.PlayerName or playerStats.PlayerName ~= playerName then
			Db.UpdatePlayerName(player, playerName)
			playerStats.PlayerName = playerName
		end
	end

	if not playerStats.DiscordID then
		local discordId = Discord.GetIdentifier(player)
		if discordId then
			Db.UpdateDiscordId(player, discordId)
		end
	end

	PlayerData.Add(player, playerStats)
	TriggerClientEvent('lsv:playerLoaded', player, playerStats, isRegistered)
	logger:info('Loaded { '..playerName..', '..player..', '..PlayerData.GetIdentifier(player)..', '..tostring(isRegistered)..' }')

	if _isOneSyncEnabled then
		TriggerClientEvent('lsv:oneSyncEnabled', player)
	end
end

RegisterNetEvent('lsv:playerInitialized')
AddEventHandler('lsv:playerInitialized', function()
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	TriggerEvent('lsv:playerConnected', player)
	TriggerClientEvent('lsv:playerConnected', -1, player)
end)

RegisterNetEvent('lsv:loadPlayer')
AddEventHandler('lsv:loadPlayer', function()
	local player = source
	local playerName = GetPlayerName(player)

	Db.FindPlayer(player, function(data)
		if not data then
			Db.RegisterPlayer(player, playerName, function(data)
				initPlayer(player, playerName, data, true)
			end)
		else
			initPlayer(player, playerName, data, false)
		end
	end)
end)

RegisterNetEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	local player = source

	logger:info('Drop AFK player { '..player..' }')

	DropPlayer(player, 'You were AFK for more than '..math.ceil(Settings.afkTimeout / 60)..' minutes.')
end)

RegisterNetEvent('lsv:upPrestigeLevel')
AddEventHandler('lsv:upPrestigeLevel', function()
	local player = source
	if not PlayerData.IsExists(player) or PlayerData.GetRank(player) < Settings.prestige.minRank then
		return
	end

	local prestige = PlayerData.GetPrestige(player) + 1
	Db.UpdatePrestige(player, function()
		logger:info('Prestige { '..player..', '..prestige..' }')
		DropPlayer(player, 'Congratulations, you have earned Prestige '..prestige..'!\nPlease, re-login to the server and sorry for inconvenience.')
	end)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	local player = source

	local loginTime = os.time()
	local playerId = PlayerData.GetIdentifier(player)
	local playerDiscordId = Discord.GetIdentifier(player)
	local license = playerId and '\n\nCopy and provide your identifier for ban appeal in Discord:\n'..playerId or ''

	deferrals.defer()
	Citizen.Wait(0) -- mandatory (omfg)

	if string.len(playerName) > Settings.maxPlayerNameLength then
		deferrals.done('Your name is too long (limit of '..Settings.maxPlayerNameLength..' characters)')
		return
	end

	if string.match(playerName, '[^%w%s._]') then
		deferrals.done('Using non-alphanumeric characters for username is prohibited.')
		return
	end

	if not Settings.allowMultipleAccounts then
		if PlayerData.IsExistsById(playerId) then
			deferrals.done('Using multiple accounts at the same time is prohibited.')
			return
		end
	end

	deferrals.update('Checking player profile...')

	Db.GetFields(playerId, { 'Banned', 'BanExpiresDate', 'PatreonTier', 'Moderator' }, function(data)
		local needToBeUnbanned = false
		if data then
			if data.Banned then
				if data.BanExpiresDate then
					if loginTime <= data.BanExpiresDate then
						deferrals.done('You\'re temporarily banned from this server.\nBan expires in '..os.date('%Y-%m-%d %X '..Settings.serverTimeZone, data.BanExpiresDate)..license)
					else
						needToBeUnbanned = true
					end
				else
					deferrals.done('You\'re permanently banned from this server.'..license)
				end
			end
		end

		local patreonTier = nil
		local moderatorLevel = nil
		if data then
			patreonTier = data.PatreonTier
			moderatorLevel = data.Moderator
		end

		Discord.GetRolesById(playerDiscordId, function(roles)
			if roles then
				logger:info('Roles { '..playerName..', '..tostring(playerDiscordId)..', '..table.length(roles)..' }')

				if patreonTier ~= roles.PatreonTier then
					patreonTier = roles.PatreonTier
					Db.UpdatePatreonTierById(playerId, patreonTier)
				end

				if moderatorLevel ~= roles.Moderator then
					moderatorLevel = roles.Moderator
					Db.UpdateModeratorById(playerId, moderatorLevel)
				end
			end

			if needToBeUnbanned then
				Db.UnbanPlayerById(playerId)
			end

			if PlayerData.GetCount() >= _maxPlayersCount then
				if not getPlayerPositionInQueue(playerId) then
					table.insert(_playersQueue, {
						id = playerId,
						loginTime = loginTime,
						isModerator = moderatorLevel,
						isPatreon = patreonTier,
					})
					table.sort(_playersQueue, sortPlayersQueue)
					logger:info('Added to login queue { '..getPlayerPositionInQueue(playerId)..', '..#_playersQueue..' }')
				end

				while true do
					Citizen.Wait(1000)

					local position = getPlayerPositionInQueue(playerId)
					if not position then
						deferrals.done()
						return
					end

					if PlayerData.GetCount() < _maxPlayersCount and position == 1 then
						deferrals.done()
						return
					else
						deferrals.update('Server is Full\nPosition in Queue: '..position..' ('..#_playersQueue..')')
					end
				end
			else
				deferrals.done()
			end
		end)
	end)
end)

AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerId = PlayerData.GetIdentifier(player)
	local playerName = GetPlayerName(player) or '<Unknown name>'

	if playerId then
		local position = getPlayerPositionInQueue(playerId)
		if position then
			table.remove(_playersQueue, position)
		end
	end

	TriggerEvent('lsv:playerDropped', player)

	PlayerData.Remove(player)
	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player, reason)

	logger:info('Dropped { '..playerName..', '..player..', '..tostring(position)..', '..reason..' }')
end)

AddEventHandler('lsv:playerConnected', function(player)
	local position = getPlayerPositionInQueue(PlayerData.GetIdentifier(player))
	if position then
		table.remove(_playersQueue, position)
		logger:info('Removed from login queue { '..position..', '..#_playersQueue..' }')
	end
end)
