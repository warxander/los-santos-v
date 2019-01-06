RegisterServerEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(eventStartTime, loseTheCopsStartTime, eventEndTime)
	local player = source

	local totalLoseTheCopsTime = eventStartTime + Settings.headhunter.time - loseTheCopsStartTime
	local reward = math.max(Settings.headhunter.minReward, math.floor((eventEndTime - totalLoseTheCopsTime) / totalLoseTheCopsTime * Settings.headhunter.maxReward))

	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:headhunterFinished', player, true)
	end)
end)