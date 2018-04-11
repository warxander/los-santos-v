RegisterServerEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(eventStartTime, loseTheCopsStartTime, eventEndTime)
	local player = source

	local reward = Settings.headhunter.minReward + math.floor(((eventEndTime - loseTheCopsStartTime) / (eventStartTime + Settings.headhunter.time - loseTheCopsStartTime)) *
		(Settings.headhunter.maxReward - Settings.headhunter.minReward))

	Db.UpdateRP(player, reward, function()
		TriggerClientEvent('lsv:headhunterFinished', player, true)
	end)
end)