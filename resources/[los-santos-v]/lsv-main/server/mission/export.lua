RegisterNetEvent('lsv:vehicleExportFinished')
AddEventHandler('lsv:vehicleExportFinished', function(success, vehicleIndex, vehicleTier, healthRatio)
	local player = source
	if not PlayerData.IsExists(player) or vehicleIndex > table.length(PlayerData.GetVehicles(player)) then
		return
	end

	PlayerData.RemoveVehicle(player, vehicleIndex)

	if success then
		PlayerData.UpdateCash(player, math.floor(Settings.vehicleExport.rewards[vehicleTier].cash * healthRatio))
		PlayerData.UpdateExperience(player, Settings.vehicleExport.rewards[vehicleTier].exp)
	end

	TriggerClientEvent('lsv:vehicleExportFinished', player, success, success and '' or 'A vehicle has been destroyed.')
end)
