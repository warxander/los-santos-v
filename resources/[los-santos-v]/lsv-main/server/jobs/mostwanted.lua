local players = { }


RegisterServerEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function()
	local player = source

	local reward = Settings.mostWanted.minReward
	if players[player] then reward = reward + math.min(Settings.mostWanted.maxReward - Settings.mostWanted.minReward, players[player] * Settings.mostWanted.RPPerCop) end

	Db.UpdateRP(player, reward, function()
		TriggerClientEvent('lsv:mostWantedFinished', player, true)
		players[player] = nil
	end)
end)


RegisterServerEvent('lsv:mostWantedCopKilled')
AddEventHandler('lsv:mostWantedCopKilled', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)