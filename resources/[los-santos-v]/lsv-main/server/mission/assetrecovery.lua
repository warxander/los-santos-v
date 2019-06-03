RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(vehicleHealthRatio)
	local player = source

	local cash = Settings.assetRecovery.rewards.cash.min + math.floor(vehicleHealthRatio * (Settings.assetRecovery.rewards.cash.max - Settings.assetRecovery.rewards.cash.min))
	local exp = Settings.assetRecovery.rewards.exp.min + math.floor(vehicleHealthRatio * (Settings.assetRecovery.rewards.exp.max - Settings.assetRecovery.rewards.exp.min))

	Db.UpdateCash(player, cash)
	Db.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:assetRecoveryFinished', player, true, '')
end)