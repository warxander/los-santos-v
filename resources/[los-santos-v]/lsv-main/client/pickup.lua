-- Format: { pickup, blip, name, x, y }
local pickups =  { }


local function GetValidRandomPickupRadius()
	local randomSpawnRadius = Settings.pickupMaxSpawnRadius - Settings.pickupMinSpawnRadius
	local result = GetRandomFloatInRange(-randomSpawnRadius, randomSpawnRadius)

	if result < 0 then
		result = result - Settings.pickupMinSpawnRadius
	else
		result = result + Settings.pickupMinSpawnRadius
	end

	return result
end


local function CheckDistanceBetweenPickups(coords)
	local x, y = table.unpack(coords)

	for _, pickup in ipairs(pickups) do
		if math.abs(pickup.x - x) < Settings.pickupMinDistance or math.abs(pickup.y - y) < Settings.pickupMinDistance then return false end
	end

	return true
end


AddEventHandler('lsv:init', function()
	while true do
		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

		-- Creating new pickups if necessary
		if Utils.GetTableLength(pickups) < Settings.pickupMaxCount then
			local pickup = { }

			local x = playerX + GetValidRandomPickupRadius()
			local y = playerY + GetValidRandomPickupRadius()
			local isValidCoords, coords = GetSafeCoordForPed(x, y, playerZ, false, 16)
			local pickupX, pickupY, pickupZ = table.unpack(coords)
			pickupZ = pickupZ - 0.4

			if isValidCoords and CheckDistanceBetweenPickups(coords) and math.abs(pickupX - playerX) <= Settings.pickupMaxSpawnRadius and math.abs(pickupY - playerY) <= Settings.pickupMaxSpawnRadius then
				local pickupId = Pickup.GetRandomPickup()
				local pickupHash = GetHashKey(pickupId.id)
				local weaponHash = GetWeaponHashFromPickup(pickupHash)

				local amount = 1
				if weaponHash ~= 0 then amount = Weapon.GetSpawningAmmo(weaponHash) end

				pickup = CreatePickupRotate(pickupHash, pickupX, pickupY, pickupZ, 0.0, 0.0, 0.0, 512, amount)

				local blip = Map.CreatePickupBlip(pickup, pickupId.id, pickupId.color)

				table.insert(pickups, { ['pickup'] = pickup, ['blip'] = blip, ['name'] = Pickup.GetName(pickupId.id), ['ammo'] = pickupId.ammo,
					['armor'] = pickupId.armor, ['x'] = pickupX, ['y'] = pickupY, ['z'] = pickupZ })
			end
		end

		-- Main pickup logic
		for i, pickup in ipairs(pickups) do
			if pickup['pickup'] then
				if HasPickupBeenCollected(pickup['pickup']) then
					pickup['pickup'] = nil

					if pickup.armor then SetPedArmour(PlayerPedId(), GetPlayerMaxArmour(PlayerId())) end

					Gui.DisplayNotification("Picked up "..pickup.name..".")
				elseif math.abs(pickup.x - playerX) > Settings.pickupMaxSpawnRadius or math.abs(pickup.y - playerY) > Settings.pickupMaxSpawnRadius then
					RemoveBlip(pickup['blip'])
					RemovePickup(pickup['pickup'])
					pickup['pickup'] = nil
				end
			end
		end

		-- Safe removing unnecessary pickups
		for i = Utils.GetTableLength(pickups), 1, -1 do
			if not pickups[i]['pickup'] then
				table.remove(pickups, i)
			end
		end

		Citizen.Wait(0)
	end
end)