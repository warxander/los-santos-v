local pickups = { }


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))

		for i = Utils.GetTableLength(pickups), 1, -1 do
			local needToRemove = HasPickupBeenCollected(pickups[i].pickup)
			if needToRemove then Gui.DisplayNotification('Picked up First Aid Kit.') else
				needToRemove = DoesPickupExist(pickups[i].pickup)
				if not needToRemove then
					local pickupX, pickupY, pickupZ = table.unpack(GetPickupCoords(pickups[i].pickup))
					needToRemove = GetDistanceBetweenCoords(playerX, playerY, playerZ, pickupX, pickupY, pickupZ, false) > Settings.pickup.radius
				end
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
		if DoesEntityExist(ped) and GetRandomFloatInRange(0.0, 1.0) <= Settings.pickup.chance then
			local x, y, z = table.unpack(GetEntityCoords(ped))
			SetTimeout(1000, function()
				local pickup = { }
				pickup.pickup = CreatePickupRotate(GetHashKey('PICKUP_HEALTH_STANDARD'), x, y, z, 0.0, 0.0, 0.0, 8, 1)
				pickup.blip = Map.CreatePickupBlip(pickup.pickup, 'PICKUP_HEALTH_STANDARD', Color.BlipGreen())
				table.insert(pickups, pickup)
			end)
		end
	end
end)