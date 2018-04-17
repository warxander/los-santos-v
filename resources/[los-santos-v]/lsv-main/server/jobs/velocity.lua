local players = { }


RegisterServerEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function()
	local player = source

	local reward = Settings.velocity.maxReward
	if players[player] then reward = reward - math.min(Settings.velocity.maxReward - Settings.velocity.minReward, players[player] * Settings.velocity.cashPerAboutToDetonate) end

	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:velocityFinished', player, true)
		players[player] = nil
	end)
end)


RegisterServerEvent('lsv:velocityAboutToDetonate')
AddEventHandler('lsv:velocityAboutToDetonate', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)