local logger = Logger:CreateNamedLogger('Session')


local function initPlayer(player, playerStats, isRegistered)
	if not playerStats.Weapons then playerStats.Weapons = Settings.defaultPlayerWeapons
	else playerStats.Weapons = json.decode(playerStats.Weapons) end

	playerStats.SkillStat = Settings.skillStat

	if not playerStats.PatreonTier then playerStats.PatreonTier = 0 end

	Scoreboard.AddPlayer(player, playerStats)

	TriggerClientEvent('lsv:playerLoaded', player, playerStats, isRegistered)
	TriggerClientEvent('lsv:playerConnected', -1, player)

	TriggerEvent('lsv:playerConnected', player)
end


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

	logger:Info('Load { '..playerName..', '..player..', '..GetPlayerIdentifiers(player)[1]..' }')

	Db.FindPlayer(player, function(data)
		if #data == 0 then
			Db.RegisterPlayer(player, function(data)
				initPlayer(player, data[1], true)
				logger:Info('Register { '..playerName..', '..player..' }')
			end)
		else
			if data[1].Banned then
				DropPlayer(player, 'You\'re permanently banned from this server.')
				return
			end

			initPlayer(player, data[1], false)
			logger:Info('Loaded { '..playerName..', '..player..' }')
		end
	end)
end)


RegisterNetEvent('lsv:savePlayerWeapons')
AddEventHandler('lsv:savePlayerWeapons', function(weapons)
	local player = source

	if #weapons ~= 0 then
		Db.SetValue(player, 'Weapons', Db.ToString(json.encode(weapons)))
	end
end)


RegisterNetEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	local player = source

	logger:Info('Drop AFK player { '..player..' }')

	DropPlayer(player, 'You were AFK for more than '..math.ceil(Settings.afkTimeout / 60)..' minutes.')
end)


RegisterNetEvent('lsv:playerSessionFailed')
AddEventHandler('lsv:playerSessionFailed', function()
	local player = source

	logger:Warning('Drop broken player { '..player..' }')

	DropPlayer(player, 'Your session was broken somehow (very likely). Please try reconnecting or contact with the server owner.')
end)