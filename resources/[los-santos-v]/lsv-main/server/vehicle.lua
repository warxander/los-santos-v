RegisterServerEvent('lsv:purchaseVehicle')
AddEventHandler('lsv:purchaseVehicle', function(settingsIndex, vehicleIndex)
	local player = source
	local price = Settings.vehicleSettings[settingsIndex].vehicles[vehicleIndex].price

	if Scoreboard.GetPlayerStats(player).money >= price then
		Db.UpdateMoney(player, -price, function()
			TriggerClientEvent('lsv:vehiclePurchasingApproved', player, settingsIndex, vehicleIndex)
		end)
	else TriggerClientEvent('lsv:vehiclePurchasingDeclined', player) end
end)


RegisterServerEvent('lsv:repairPersonalVehicle')
AddEventHandler('lsv:repairPersonalVehicle', function()
	local player = source

	if Scoreboard.GetPlayerStats(player).money >= Settings.repairPersonalVehiclePrice then
		TriggerClientEvent('lsv:repairPersonalVehicleSuccess', player)
	else TriggerClientEvent('lsv:repairPersonalVehicleError', player) end
end)