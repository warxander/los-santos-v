local logger = Logger.New('Fast Travel')

RegisterNetEvent('lsv:useFastTravel')
AddEventHandler('lsv:useFastTravel', function(travelIndex)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	if PlayerData.GetCash(player) >= Settings.travel.cash then
		PlayerData.UpdateCash(player, -Settings.travel.cash)
		TriggerClientEvent('lsv:useFastTravel', player, travelIndex)
		logger:info('Use { '..player..', '..travelIndex..' }')
	else
		TriggerClientEvent('lsv:useFastTravel', player, nil)
	end
end)
