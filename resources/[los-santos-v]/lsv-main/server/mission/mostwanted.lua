RegisterNetEvent('lsv:finishMostWanted')
AddEventHandler('lsv:finishMostWanted', function(timeSurvived)
	local player = source

	if not MissionManager.IsPlayerOnMission(player) or timeSurvived <= 0 then
		return
	end

	local cash = math.floor(math.min(Settings.mostWanted.rewards.maxCash, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.rewards.maxCash))
	local exp = math.floor(math.min(Settings.mostWanted.rewards.maxExp, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.rewards.maxExp))

	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)
	PlayerData.GiveDrugBusinessSupply(player)

	TriggerClientEvent('lsv:finishMostWanted', player, true, '')
end)
