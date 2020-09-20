RegisterNetEvent('lsv:finishHeadhunter')
AddEventHandler('lsv:finishHeadhunter', function(targetsKilled)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) then
		return
	end

	local rewardMultiplier = 1 + (math.floor(targetsKilled / Settings.headhunter.minTargetCount) * Settings.headhunter.rewardMultiplier)

	PlayerData.UpdateCash(player, Settings.headhunter.reward.cash * targetsKilled * rewardMultiplier)
	PlayerData.UpdateExperience(player, Settings.headhunter.reward.exp * targetsKilled * rewardMultiplier)

	if targetsKilled >= Settings.headhunter.minTargetCount then
		PlayerData.GiveDrugBusinessSupply(player)
	end

	TriggerClientEvent('lsv:headhunterFinished', player, true, '')
end)
