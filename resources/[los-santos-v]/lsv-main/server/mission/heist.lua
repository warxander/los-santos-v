RegisterNetEvent('lsv:heistFinished')
AddEventHandler('lsv:heistFinished', function(take)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local exp = math.floor(take * Settings.heist.take.rate.exp)

	PlayerData.UpdateCash(player, take)
	PlayerData.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:heistFinished', player, true, '')
end)
