RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(eventStartTime, loseTheCopsStartTime, eventEndTime)
	local player = source

	local totalLoseTheCopsTime = eventEndTime - loseTheCopsStartTime
	local totalTimeLeft = eventStartTime + Settings.headhunter.time - loseTheCopsStartTime
	local cash = Settings.headhunter.rewards.cash.min + math.floor((1.0 - totalLoseTheCopsTime / totalTimeLeft) * (Settings.headhunter.rewards.cash.max - Settings.headhunter.rewards.cash.min))
	local exp = Settings.headhunter.rewards.exp.min + math.floor((1.0 - totalLoseTheCopsTime / totalTimeLeft) * (Settings.headhunter.rewards.exp.max - Settings.headhunter.rewards.exp.min))

	Db.UpdateCash(player, cash)
	Db.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:headhunterFinished', player, true, '')
end)