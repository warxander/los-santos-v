local pickups = { }

local pickupColors = {
	['PICKUP_HEALTH_STANDARD'] = Color.BlipGreen(),
	['PICKUP_ARMOUR_STANDARD'] = Color.BlipBlue(),
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
			local pedDrop = table.find_if(Settings.pickup.drops, function(drop) return GetRandomFloatInRange(0.0, 1.0) <= drop.chance end)
			if pedDrop then
				local x, y, z = table.unpack(GetEntityCoords(ped))
				local pickup = { }
				pickup.pickup = CreatePickupRotate(GetHashKey(pedDrop.id), x, y, z, 0.0, 0.0, 0.0, 8, 1)
				pickup.blip = Map.CreatePickupBlip(pickup.pickup, pedDrop.id, pickupColors[pedDrop.id])
				pickup.armour = pedDrop.armour
				table.insert(pickups, pickup)
			end
		end
	end
end)