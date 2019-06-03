local players = { }


RegisterNetEvent('lsv:marketManipulationFinished')
AddEventHandler('lsv:marketManipulationFinished', function()
	local player = source

	if not players[player] then
		TriggerClientEvent('lsv:marketManipulationFinished', player, false, 'Time is over.')
		return
	end

	local cash = Settings.marketManipulation.rewards.cash.min +
		math.min(Settings.marketManipulation.rewards.cash.max - Settings.marketManipulation.rewards.cash.min, players[player] * Settings.marketManipulation.rewards.cash.perRobbery)
	local exp = Settings.marketManipulation.rewards.exp.min +
		math.min(Settings.marketManipulation.rewards.exp.max - Settings.marketManipulation.rewards.exp.min, players[player] * Settings.marketManipulation.rewards.exp.perRobbery)		

	Db.UpdateCash(player, cash)
	Db.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:marketManipulationFinished', player, true, '')

	players[player] = nil
end)


RegisterNetEvent('lsv:marketManipulationRobbed')
AddEventHandler('lsv:marketManipulationRobbed', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)