local logger = Logger:CreateNamedLogger('Session')

local function initPlayer(player, playerStats)
	Scoreboard.AddPlayer(player, playerStats)

	TriggerClientEvent('lsv:playerLoaded', player, playerStats)
	TriggerClientEvent('lsv:playerConnected', -1, player)

	TriggerEvent('lsv:playerConnected', player)
end


AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerName = GetPlayerName(player)

	logger:Info('Dropped { '..playerName..', '..player..', '..reason..' }')

	Scoreboard.RemovePlayer(player)

	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player)

	TriggerEvent('lsv:playerDropped', player)
end)


RegisterServerEvent('lsv:loadPlayer')
AddEventHandler('lsv:loadPlayer', function()
	local player = source
	local playerName = GetPlayerName(player)

	logger:Info('Load { '..playerName..', '..player..', '..GetPlayerIdentifiers(player)[1]..' }')

	Db.FindPlayer(player, function(data)
		if Utils.IsTableEmpty(data) then
			Db.RegisterPlayer(player, function(data)
				logger:Info('Register { '..playerName..', '..player..' }')
				initPlayer(player, data[1])
			end)
		else
			logger:Info('Loaded { '..playerName..', '..player..' }')
			initPlayer(player, data[1])
		end
	end)
end)


RegisterServerEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	local player = source

	logger:Info('Drop AFK player { '..player..' }')

	DropPlayer(player, "You were AFK for more than "..tostring(math.ceil(Settings.afkTimeout / 60)).." minutes.")
end)