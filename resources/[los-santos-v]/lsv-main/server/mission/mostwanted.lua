RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(timeSurvived)
	local player = source

	local cash = math.floor(math.min(Settings.mostWanted.rewards.maxCash, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.rewards.maxCash))
	local exp = math.floor(math.min(Settings.mostWanted.rewards.maxExp, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.rewards.maxExp))

	Db.UpdateCash(player, cash)
	Db.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:mostWantedFinished', player, true, '')
end)