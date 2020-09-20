RegisterNetEvent('lsv:finishMostWanted')
AddEventHandler('lsv:finishMostWanted', function(timeSurvived)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or timeSurvived <= 0 then
		return
	end

	local rewardMultiplier = 1 + math.floor(timeSurvived / Settings.mostWanted.minTime) * Settings.mostWanted.rewardMultiplier

	PlayerData.UpdateCash(player, Settings.mostWanted.rewardPerSecond.cash * timeSurvived / 1000 * rewardMultiplier)
	PlayerData.UpdateExperience(player, Settings.mostWanted.rewardPerSecond.exp * timeSurvived / 1000 * rewardMultiplier)

	if timeSurvived >= Settings.mostWanted.minTime then
		PlayerData.GiveDrugBusinessSupply(player)
	end

	TriggerClientEvent('lsv:mostWantedFinished', player, true, '')
end)
