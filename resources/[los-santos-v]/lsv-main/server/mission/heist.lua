RegisterNetEvent('lsv:finishHeist')
AddEventHandler('lsv:finishHeist', function(take)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or take > Settings.heist.take.rate.cash.limit then
		return
	end

	local exp = math.floor(take * Settings.heist.take.rate.exp)

	PlayerData.UpdateCash(player, take)
	PlayerData.UpdateExperience(player, exp)
	PlayerData.GiveDrugBusinessSupply(player)

	TriggerClientEvent('lsv:finishHeist', player, true, '+ $'..take..'\n+ '..exp..' Exp')
end)
