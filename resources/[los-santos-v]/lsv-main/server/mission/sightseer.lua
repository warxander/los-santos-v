RegisterNetEvent('lsv:finishSightseer')
AddEventHandler('lsv:finishSightseer', function(packageCount)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or packageCount > Settings.sightseer.count then
		return
	end

	PlayerData.UpdateCash(player, packageCount * Settings.sightseer.reward.cash)
	PlayerData.UpdateExperience(player, packageCount * Settings.sightseer.reward.exp)
	PlayerData.GiveDrugBusinessSupply(player)

	TriggerClientEvent('lsv:sightseerFinished', player, true, '')
end)
