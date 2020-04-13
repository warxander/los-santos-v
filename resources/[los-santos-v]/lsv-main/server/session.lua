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

local function initPlayer(player, playerName, playerStats, isRegistered)
	if not playerStats.Weapons then
		playerStats.Weapons = Settings.defaultPlayerWeapons
	else
		playerStats.Weapons = json.decode(playerStats.Weapons)
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

	playerStats.ServerRestartIn = os.time(_serverRestartDate) - nowTime

	playerStats.Identifier = PlayerData.GetIdentifier(player)
	playerStats.PlayerName = playerName

	local spawnPoints = Settings.spawn.points
	if _lastSpawnPointIndex then
		spawnPoints = table.filter(spawnPoints, function(_, i)
			return i ~= _lastSpawnPointIndex
		end)
	end

	_lastSpawnPointIndex = math.random(#spawnPoints)
	playerStats.SpawnPoint = spawnPoints[_lastSpawnPointIndex]

	PlayerData.Add(player, playerStats)

	TriggerClientEvent('lsv:playerLoaded', player, playerStats, isRegistered)
end

RegisterNetEvent('lsv:playerInitialized')
AddEventHandler('lsv:playerInitialized', function()
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	TriggerSignal('lsv:playerConnected', player)
	TriggerClientEvent('lsv:playerConnected', -1, player)
end)

RegisterNetEvent('lsv:loadPlayer')
AddEventHandler('lsv:loadPlayer', function()
	local player = source
	local playerName = GetPlayerName(player)
	local identifier = PlayerData.GetIdentifier(player)

	Db.FindPlayer(player, function(data)
		if not data then
			Db.RegisterPlayer(player, function(data)
				initPlayer(player, playerName, data, true)
				logger:info('Register { '..playerName..', '..player..', '..identifier..' }')
			end)
		else
			initPlayer(player, playerName, data, false)
			logger:info('Loaded { '..playerName..', '..player..', '..identifier..' }')
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
	if not PlayerData.IsExists(player) or PlayerData.GetRank(player) < Settings.minPrestigeRank then
		return
	end

	local prestige = PlayerData.GetPrestige(player)
	if prestige >= Settings.maxPrestige then
		return
	end

	prestige = prestige + 1
	Db.UpdatePrestige(player, function()
		logger:info('Prestige { '..player..', '..prestige..' }')
		DropPlayer(player, 'Congratulations, you have earned Prestige '..prestige..'!\nPlease, re-login to the server and sorry for inconvenience.')
	end)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	local player = source

	deferrals.defer()

	if string.len(playerName) > Settings.maxPlayerNameLength then
		deferrals.done('Your name is too long (limit of '..Settings.maxPlayerNameLength..' characters)')
		return
	end

	local playerId = PlayerData.GetIdentifier(player)
	local playerDiscordId = Discord.GetIdentifier(player)
	local license = playerId and '\n\nCopy and provide your identifier for ban appeal in Discord:\n'..playerId or ''

	deferrals.update('Checking player profile...')

	Db.GetFields(player, { 'Banned', 'BanExpiresDate', 'PatreonTier', 'Moderator' }, function(data)
		local needToBeUnbanned = false
		if data then
			if data.Banned then
				if data.BanExpiresDate then
					if os.time() <= data.BanExpiresDate then
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
			logger:info('Roles { '..playerName..', '..tostring(playerDiscordId)..', '..#roles..' }')

			local newPatreonTier = nil
			local newModeratorLevel = nil

			if #roles ~= 0 then
				table.iforeach(Settings.patreon.roleIds, function(roleId, roleIndex)
					if table.ifind(roles, roleId) then
						newPatreonTier = roleIndex
					end
				end)

				table.iforeach(Settings.moderator.roleIds, function(roleId, roleIndex)
					if table.ifind(roles, roleId) then
						newModeratorLevel = roleIndex
					end
				end)
			end

			if needToBeUnbanned then
				Db.UnbanPlayerById(playerId)
			end

			if patreonTier ~= newPatreonTier then
				Db.UpdatePatreonTierById(playerId, newPatreonTier)
			end

			if moderatorLevel ~= newModeratorLevel then
				Db.UpdateModeratorById(playerId, newModeratorLevel)
			end

			deferrals.done()
		end)
	end)
end)

AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerName = GetPlayerName(player) or '<Unknown name>'

	logger:info('Dropped { '..playerName..', '..player..', '..reason..' }')

	TriggerSignal('lsv:playerDropped', player)

	PlayerData.Remove(player)
	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player, reason)
end)
