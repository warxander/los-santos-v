RegisterNetEvent('lsv:finishAssetRecovery')
AddEventHandler('lsv:finishAssetRecovery', function(vehicleHealthRatio)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) then
		return
	end

	local cash = math.min(Settings.assetRecovery.rewards.cash.max, Settings.assetRecovery.rewards.cash.min + math.floor(vehicleHealthRatio * (Settings.assetRecovery.rewards.cash.max - Settings.assetRecovery.rewards.cash.min)))
	local exp = math.min(Settings.assetRecovery.rewards.exp.max, Settings.assetRecovery.rewards.exp.min + math.floor(vehicleHealthRatio * (Settings.assetRecovery.rewards.exp.max - Settings.assetRecovery.rewards.exp.min)))

	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)
	PlayerData.GiveDrugBusinessSupply(player)

	TriggerClientEvent('lsv:finishAssetRecovery', player, true, '')
end)
