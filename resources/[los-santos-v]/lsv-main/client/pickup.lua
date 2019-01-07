local pickups = { }


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))

		for i = Utils.GetTableLength(pickups), 1, -1 do
			local needToRemove = HasPickupBeenCollected(pickups[i].pickup) or not DoesPickupExist(pickups[i].pickup)
			if not needToRemove then
				local pickupX, pickupY, pickupZ = table.unpack(GetPickupCoords(pickups[i].pickup))
				needToRemove = GetDistanceBetweenCoords(playerX, playerY, playerZ, pickupX, pickupY, pickupZ, true) > Settings.pickup.radius
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
			local pedDrop = nil
			for _, drop in ipairs(Settings.pickup.drops) do
				if GetRandomFloatInRange(0.0, 1.0) <= drop.chance then
					pedDrop = drop
					break
				end
			end
			if pedDrop then
				local x, y, z = table.unpack(GetEntityCoords(ped))
				local pickup = { }
				pickup.pickup = CreatePickupRotate(GetHashKey(pedDrop.id), x, y, z, 0.0, 0.0, 0.0, 8, 1)
				pickup.blip = Map.CreatePickupBlip(pickup.pickup, pedDrop.id)
				table.insert(pickups, pickup)
			end
		end
	end
end)