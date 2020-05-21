RegisterNetEvent('lsv:sightseerFinished')
AddEventHandler('lsv:sightseerFinished', function(packageCount)
	local player = source
	if not PlayerData.IsExists(player) or packageCount > Settings.sightseer.count then
		return
	end

	PlayerData.UpdateCash(player, packageCount * Settings.sightseer.reward.cash)
	PlayerData.UpdateExperience(player, packageCount * Settings.sightseer.reward.exp)

	TriggerClientEvent('lsv:sightseerFinished', player, true, '')
end)
