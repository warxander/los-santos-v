local players = { }


RegisterNetEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function()
	local player = source

	local cash = Settings.velocity.rewards.cash.max
	local exp = Settings.velocity.rewards.exp.max

	if players[player] then
		cash = cash - math.min(Settings.velocity.rewards.cash.max - Settings.velocity.rewards.cash.min, players[player] * Settings.velocity.rewards.cash.perAboutToDetonate)
		exp = exp - math.min(Settings.velocity.rewards.exp.max - Settings.velocity.rewards.exp.min, players[player] * Settings.velocity.rewards.exp.perAboutToDetonate)
	end

	Db.UpdateCash(player, cash)
	Db.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:velocityFinished', player, true, '')

	players[player] = nil
end)


RegisterNetEvent('lsv:velocityAboutToDetonate')
AddEventHandler('lsv:velocityAboutToDetonate', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)