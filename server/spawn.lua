local firstSpawn = { }


AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerName = tostring(GetPlayerName(source))

	Citizen.Trace('>>> playerDropped: { '..playerName..', '..player..', '..reason..' }\n')

	firstSpawn[player] = nil

	TriggerEvent('lsv:bountyOnPlayerDropped', player)
	TriggerEvent('lsv:scoreboardOnPlayerDropped', player)
	TriggerEvent('lsv:crateDropOnPlayerDropped', player)

	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player)
end)


RegisterServerEvent('lsv:playerConnected')
AddEventHandler('lsv:playerConnected', function()
	local player = source

	TriggerClientEvent('lsv:playerConnected', -1, player)
	TriggerEvent('lsv:bountyOnPlayerConnected', player)
	TriggerEvent('lsv:crateDropOnPlayerConnected', player)
end)


RegisterServerEvent('lsv:playerSpawned')
AddEventHandler('lsv:playerSpawned', function()
	if not firstSpawn[source] then
		firstSpawn[source] = true
		Citizen.Trace('>>> loadingPlayer: { '..tostring(GetPlayerName(source))..', '..source..' }\n')
		TriggerEvent('lsv:loadPlayer', source)
	end
end)


AddEventHandler('lsv:loadPlayer', function(player)
	local queryParameter = {['@playerId'] = GetPlayerIdentifiers(player)[1]}
	local playerName = tostring(GetPlayerName(player))

	MySQL.ready(function()
		MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', queryParameter, function(playerData)
			if not playerData or Utils.IsEmpty(playerData) then
				Citizen.Trace('>>> registerPlayer: { '..playerName..', '..player..' }\n')
				MySQL.Async.execute('INSERT INTO Players (PlayerID) VALUES (@playerId)', queryParameter, function()
					MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', queryParameter, function(playerData)
						Citizen.Trace('>>> playerRegistered: { '..playerName..', '..player..' }\n')
						TriggerEvent('lsv:firstSpawnPlayer', player, playerData[1])
						TriggerClientEvent('lsv:firstSpawnPlayer', player, playerData[1])
					end)
				end)
			else
				if playerData[1].Banned == true then
					DropPlayer(player, "You're permanently banned from this server.")
					return
				end

				Citizen.Trace('>>> playerLoaded: { '..playerName..', '..player..' }\n')
				TriggerEvent('lsv:firstSpawnPlayer', player, playerData[1])
				TriggerClientEvent('lsv:firstSpawnPlayer', player, playerData[1])
			end
		end)
	end)
end)


RegisterServerEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	DropPlayer(source, "You were AFK for more than "..tostring(math.ceil(Settings.afkTimeout / 60)).." minutes.")
end)