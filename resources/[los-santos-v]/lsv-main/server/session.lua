local logger = Logger.New('Session')

local lastSpawnPointIndex = nil

local function initPlayer(player, playerStats, isRegistered)
	if not playerStats.Weapons then playerStats.Weapons = Settings.defaultPlayerWeapons
	else playerStats.Weapons = json.decode(playerStats.Weapons) end

	playerStats.Rank = Rank.CalculateRank(playerStats.Experience)
	playerStats.SkillStats = Stat.CalculateStats(playerStats.Rank)

	if not playerStats.PatreonTier then playerStats.PatreonTier = 0 end

	playerStats.Identifier = Scoreboard.GetPlayerIdentifier(player)

	local spawnPoints = Settings.spawn.points
	if lastSpawnPointIndex then
		spawnPoints = table.filter(spawnPoints, function(_, i) return i ~= lastSpawnPointIndex end)
	end

	lastSpawnPointIndex = math.random(#spawnPoints)
	playerStats.SpawnPoint = spawnPoints[lastSpawnPointIndex]

	Scoreboard.AddPlayer(player, playerStats)

	local time = os.time()
	Db.UpdateLoginTime(player, time, function()
		if playerStats.PatreonTier ~= 0 then
			if playerStats.LoginTime and time - playerStats.LoginTime >= Settings.patreonDailyReward.time then
				Db.UpdateCash(player, Settings.patreonDailyReward.cash)
				Db.UpdateExperience(player, Settings.patreonDailyReward.exp)
				TriggerClientEvent('lsv:patreonDailyRewarded', player)
			end
		end
	end)

	TriggerClientEvent('lsv:playerLoaded', player, playerStats, isRegistered)
	TriggerClientEvent('lsv:playerConnected', -1, player)

	TriggerEvent('lsv:playerConnected', player)
end


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()

	if string.len(playerName) > Settings.maxPlayerNameLength then
		deferrals.done('Your name is too long (limit of '..Settings.maxPlayerNameLength..' characters)')
		return
	end

	local player = source
	local license = '\n\nCopy and provide your identifier for ban appeal in Discord:\n'..Scoreboard.GetPlayerIdentifier(player)

	if Scoreboard.IsPlayerOnline(player) then
		Db.BanPlayer(player, function()
			local reason = 'Abusing Multiple Accounts'
			Discord.ReportAutoBanPlayer(player, reason)
			deferrals.done('You\'re permanently banned from this server for '..reason..'.'..license)
		end)
		return
	end

	deferrals.update('Checking player profile...')

	Db.GetBanStatus(player, function(data)
		if #data == 0 or not data[1].Banned then
			deferrals.done()
			return
		end

		if data[1].BanExpiresDate then
			if os.time() <= data[1].BanExpiresDate then
				deferrals.done('You\'re temporarily banned from this server.\nBan expires in '..os.date('%Y-%m-%d %X '..Settings.serverTimeZone, data[1].BanExpiresDate)..license)
			else
				Db.UnbanPlayer(player, function()
					deferrals.done()
				end)
			end
		else
			deferrals.done('You\'re permanently banned from this server.'..license)
		end
	end)
end)


AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerName = GetPlayerName(player)

	logger:Info('Dropped { '..playerName..', '..player..', '..reason..' }')

	Scoreboard.RemovePlayer(player)

	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player, reason)

	TriggerEvent('lsv:playerDropped', player)
end)


RegisterNetEvent('lsv:loadPlayer')
AddEventHandler('lsv:loadPlayer', function()
	local player = source
	local playerName = GetPlayerName(player)
	local identifier = Scoreboard.GetPlayerIdentifier(player)

	Db.FindPlayer(player, function(data)
		if #data == 0 then
			Db.RegisterPlayer(player, function(data)
				initPlayer(player, data[1], true)
				logger:Info('Register { '..playerName..', '..player..', '..identifier..' }')
			end)
		else
			initPlayer(player, data[1], false)
			logger:Info('Loaded { '..playerName..', '..player..', '..identifier..' }')
		end
	end)
end)


RegisterNetEvent('lsv:savePlayerWeapons')
AddEventHandler('lsv:savePlayerWeapons', function(weapons)
	local player = source

	if #weapons == 0 then return end

	local prohibitedWeapon = table.ifind_if(weapons, function(weapon) return weapon.id == 'WEAPON_RAILGUN' or weapon.id == 'WEAPON_BULLPUPRIFLE' or weapon.id == 'WEAPON_GUSENBERG' end)

	if prohibitedWeapon then
		DropPlayer(player, 'You have received a prohibited weapon due to hacker activity.\nYour progress is saved, but you need to manually reconnect to the server.')
		return
	end

	Db.SetValue(player, 'Weapons', Db.ToString(json.encode(weapons)))
end)


RegisterNetEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	local player = source

	logger:Info('Drop AFK player { '..player..' }')

	DropPlayer(player, 'You were AFK for more than '..math.ceil(Settings.afkTimeout / 60)..' minutes.')
end)


RegisterNetEvent('lsv:getPrestige')
AddEventHandler('lsv:getPrestige', function()
	local player = source
	if not Scoreboard.IsPlayerOnline(player) or Scoreboard.GetPlayerRank(player) < Settings.minPrestigeRank then return end

	local prestige = Scoreboard.GetPlayerPrestige(player)
	if prestige >= Settings.maxPrestige then return end

	prestige = prestige + 1
	Db.UpdatePrestige(player, function()
		logger:Info('Prestige { '..player..', '..prestige..' }')
		DropPlayer(player, 'Congratulations, you have earned Prestige '..prestige..'!\nPlease, re-login to the server and sorry for inconvenience.')
	end)
end)
