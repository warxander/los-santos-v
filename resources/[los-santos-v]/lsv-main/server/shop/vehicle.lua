local logger = Logger.New('VehicleShop')

RegisterNetEvent('lsv:rentVehicle')
AddEventHandler('lsv:rentVehicle', function(model, vehicleCategory)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	if PlayerData.GetRank(player) >= Settings.personalVehicle.freeMaxRank and vehicleCategory == 'Free' then
		return
	end

	if PlayerData.GetFaction(player) ~= Settings.faction.Enforcer and vehicleCategory == 'Enforcer' then
		return
	end

	local vehiclePrestige = Settings.personalVehicle.vehicles[vehicleCategory][model].prestige
	if vehiclePrestige and PlayerData.GetPrestige(player) < vehiclePrestige then
		return
	end

	local vehicleRank = Settings.personalVehicle.vehicles[vehicleCategory][model].rank
	if vehicleRank and PlayerData.GetRank(player) < vehicleRank then
		return
	end

	local vehiclePrice = Settings.personalVehicle.vehicles[vehicleCategory][model].cash

	local patreonTier = PlayerData.GetPatreonTier(player)
	if patreonTier ~= 0 then
		vehiclePrice = math.floor(vehiclePrice * Settings.patreon.rent[patreonTier])
	end

	if PlayerData.GetCash(player) >= vehiclePrice then
		PlayerData.UpdateCash(player, -vehiclePrice)
		logger:info('Rented { '..player..', '..model..', '..vehiclePrice..' }')
		TriggerClientEvent('lsv:vehicleRented', player, model, Settings.personalVehicle.vehicles[vehicleCategory][model].name)
	else
		TriggerClientEvent('lsv:vehicleRented', player, nil)
	end
end)
