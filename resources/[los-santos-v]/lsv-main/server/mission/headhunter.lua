RegisterServerEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(eventStartTime, loseTheCopsStartTime, eventEndTime)
	local player = source

	local totalLoseTheCopsTime = eventStartTime + Settings.headhunter.time - loseTheCopsStartTime
	local reward = Settings.headhunter.minReward + math.floor((eventEndTime - totalLoseTheCopsTime) / totalLoseTheCopsTime * (Settings.headhunter.maxReward - Settings.headhunter.minReward))

	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:headhunterFinished', player, true)
	end)
end)