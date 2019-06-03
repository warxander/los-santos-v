local reportedPlayers = { }


RegisterNetEvent('lsv:reportPlayer')
AddEventHandler('lsv:reportPlayer', function(target, reason)
	local player = source
	if player == target then return end

	if not Scoreboard.IsPlayerOnline(target) then return end

	local targetName = GetPlayerName(target)

	Db.UpdateReports(target)
	reportedPlayers[target] = reportedPlayers[target] + 1
	TriggerClientEvent('lsv:reportSuccess', -1, targetName)

	Discord.ReportPlayer(player, target, reason)

	if Scoreboard.GetPlayersCount() > 3 and reportedPlayers[target] > Scoreboard.GetPlayersCount() / 2 and not Scoreboard.IsPlayerModerator(target) then
		Discord.ReportKickedPlayer(target)
		DropPlayer(target, 'You have been kicked from the session by other players.')
		TriggerClientEvent('lsv:playerKicked', -1, targetName)
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	reportedPlayers[player] = 0
end)


AddEventHandler('lsv:playerDropped', function(player)
	reportedPlayers[player] = nil
end)