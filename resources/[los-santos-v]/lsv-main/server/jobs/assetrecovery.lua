RegisterServerEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(vehicleHealthRatio)
	local player = source

	local reward = Settings.assetRecovery.minReward + math.floor(vehicleHealthRatio * (Settings.assetRecovery.maxReward - Settings.assetRecovery.minReward))

	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:assetRecoveryFinished', player, true)
	end)
end)