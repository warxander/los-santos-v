local logger = Logger.New('VehicleShop')


RegisterNetEvent('lsv:rentVehicle')
AddEventHandler('lsv:rentVehicle', function(model, vehicleCategory)
	local player = source
	if not Scoreboard.IsPlayerOnline(player) then return end

	local vehiclePrestige = Settings.personalVehicle.vehicles[vehicleCategory][model].prestige
	if vehiclePrestige and Scoreboard.GetPlayerPrestige(player) < vehiclePrestige then return end

	local vehicleRank = Settings.personalVehicle.vehicles[vehicleCategory][model].rank
	if vehicleRank and Scoreboard.GetPlayerRank(player) < vehicleRank then return end

	local vehiclePrice = Settings.personalVehicle.vehicles[vehicleCategory][model].cash
	if Scoreboard.GetPlayerCash(player) >= vehiclePrice then
		Db.UpdateCash(player, -vehiclePrice, function()
			logger:Info('Rented { '..player..', '..model..', '..vehiclePrice..' }')
			TriggerClientEvent('lsv:vehicleRented', player, model, Settings.personalVehicle.vehicles[vehicleCategory][model].name)
		end)
	else TriggerClientEvent('lsv:vehicleRented', player, nil) end
end)
