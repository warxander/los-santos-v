local _reportedPlayers = { }

RegisterNetEvent('lsv:reportPlayer')
AddEventHandler('lsv:reportPlayer', function(target, reason)
	local player = source
	if player == target or not _reportedPlayers[target] then
		return
	end

	local targetName = GetPlayerName(target)

	_reportedPlayers[target] = _reportedPlayers[target] + 1
	TriggerClientEvent('lsv:playerReported', -1, targetName)

	Discord.ReportPlayer(player, target, reason)

	if PlayerData.GetCount() > 3 and _reportedPlayers[target] > PlayerData.GetCount() / 2 and not PlayerData.IsModerator(target) then
		Discord.ReportKickedPlayer(target)
		DropPlayer(target, 'You have been kicked from the session by other players.')
		TriggerClientEvent('lsv:playerKicked', -1, targetName)
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	_reportedPlayers[player] = 0
end)

AddEventHandler('lsv:playerDropped', function(player)
	_reportedPlayers[player] = nil
end)
