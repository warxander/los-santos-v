RegisterNetEvent('lsv:finishHeadhunter')
AddEventHandler('lsv:finishHeadhunter', function(targetsLeft)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or targetsLeft < 0 then
		return
	end

	PlayerData.UpdateCash(player, Settings.headhunter.reward.cash * (Settings.headhunter.count - targetsLeft))
	PlayerData.UpdateExperience(player, Settings.headhunter.reward.exp * (Settings.headhunter.count - targetsLeft))
	PlayerData.GiveDrugBusinessSupply(player)

	TriggerClientEvent('lsv:headhunterFinished', player, true, '')
end)
