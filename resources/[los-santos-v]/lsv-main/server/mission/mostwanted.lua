RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(timeSurvived)
	local player = source

	local reward = math.floor(math.min(Settings.mostWanted.maxReward, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.maxReward))

	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:mostWantedFinished', player, true, '')
	end)
end)