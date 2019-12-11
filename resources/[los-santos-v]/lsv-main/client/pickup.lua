local pickups = { }

local pickupColors = {
	['PICKUP_HEALTH_STANDARD'] = Color.BLIP_GREEN,
	['PICKUP_ARMOUR_STANDARD'] = Color.BLIP_BLUE,
	['PICKUP_VEHICLE_HEALTH_STANDARD'] = Color.BLIP_GREEN,
	['PICKUP_VEHICLE_ARMOUR_STANDARD'] = Color.BLIP_BLUE,
}


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		for i = #pickups, 1, -1 do
			local needToRemove = HasPickupBeenCollected(pickups[i].pickup)
			if needToRemove and pickups[i].armour then
				SetPedArmour(PlayerPedId(), Settings.maxArmour)
			end

			if not needToRemove then
				needToRemove = not DoesPickupExist(pickups[i].pickup)
			end

			if not needToRemove then
				needToRemove = Player.DistanceTo(GetPickupCoords(pickups[i].pickup), true) > Settings.pickup.radius
			end

			if needToRemove then
				RemoveBlip(pickups[i].blip)
				RemovePickup(pickups[i].pickup)
				table.remove(pickups, i)
			end
		end
	end
end)


AddEventHandler('lsv:onPlayerKilled', function(player, killer)
	local victim = GetPlayerFromServerId(player)
	if killer == Player.ServerId() and NetworkIsPlayerActive(victim) then
		local ped = GetPlayerPed(victim)
		if DoesEntityExist(ped) then
			local isInVehicle = Player.VehicleHandle and IsPedInVehicle(PlayerPedId(), Player.VehicleHandle)
			local drops = table.filter(Settings.pickup.drops, function(drop) if isInVehicle then return drop.vehicle else return not drop.vehicle end end)
			local pedDrop = table.find_if(drops, function(drop) return GetRandomFloatInRange(0.0, 1.0) <= drop.chance end)
			if pedDrop then
				local x, y, z = table.unpack(GetEntityCoords(ped))
				if pedDrop.vehicle then z = z + 0.5 end
				local pickup = { }
				pickup.pickup = CreatePickupRotate(GetHashKey(pedDrop.id), x, y, z, 0.0, 0.0, 0.0, 8, 1)
				local name = nil
				if pedDrop.vehicle then name = pedDrop.armour and 'Vehicle Armour' or 'Vehicle Health' end
				pickup.blip = Map.CreatePickupBlip(pickup.pickup, pedDrop.id, pickupColors[pedDrop.id], name)
				pickup.armour = pedDrop.armour
				table.insert(pickups, pickup)
			end
		end
	end
end)
