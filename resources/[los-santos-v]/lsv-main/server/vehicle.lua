RegisterNetEvent('lsv:requestVehicle')
AddEventHandler('lsv:requestVehicle', function(model, vehicleCategory)
	local player = source

	local vehiclePrice = Settings.requestVehicle.vehicles[vehicleCategory][model].cash
	if Scoreboard.GetPlayerCash(player) >= vehiclePrice then
		Db.UpdateCash(player, -vehiclePrice, function()
			TriggerClientEvent('lsv:vehicleRequested', player, model)
		end)
	else TriggerClientEvent('lsv:vehicleRequested', player, nil) end
end)