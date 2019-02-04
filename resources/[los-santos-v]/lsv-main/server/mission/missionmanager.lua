MissionManager = { }


local players = { }


function MissionManager.IsPlayerOnMission(player)
	return table.find(players, player)
end


RegisterServerEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(missionName)
	local player = source
	if players[player] then return end
	players[player] = true
	TriggerClientEvent('lsv:missionStarted', -1, player, missionName)
end)


RegisterServerEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(missionName)
	local player = source
	if not players[player] then return end
	players[player] = nil
	TriggerClientEvent('lsv:missionFinished', -1, player, missionName)
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)