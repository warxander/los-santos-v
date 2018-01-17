CrateBlip = nil

local crateDropData = nil


local function resetCrateDropData()
	RemovePickup(crateDropData.pickup)
	RemoveBlip(CrateBlip)

	CrateBlip = nil
	crateDropData = nil
end


local function spawnCrateGuard(positionIndex)
	local modelHash = GetHashKey(Settings.crateDropSettings.guards.hash)

	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do Citizen.Wait(1) end

	for i = 1, Settings.crateDropSettings.guards.count do
		local x = Settings.crateDropSettings.positions[positionIndex].x + GetRandomIntInRange(-Settings.crateDropSettings.guards.radius, Settings.crateDropSettings.guards.radius)
		local y = Settings.crateDropSettings.positions[positionIndex].y + GetRandomIntInRange(-Settings.crateDropSettings.guards.radius, Settings.crateDropSettings.guards.radius)
		local _, z = GetGroundZFor_3dCoord(x, y, Settings.crateDropSettings.positions[positionIndex].z + 1000.)

		local guard = CreatePed(5, modelHash, x, y, z + 1., GetRandomFloatInRange(0.0, 360.0), true, true)
		SetPedRelationshipGroupHash(guard, GetHashKey("CRATE_DROP_GUARDS"))

		SetPedArmour(guard, Settings.crateDropSettings.guards.armor)
		SetPedDropsWeaponsWhenDead(guard, false)
		SetPedDiesWhenInjured(guard, true)
		SetPedDiesInWater(guard, false)

		local weaponHash = GetHashKey(Settings.crateDropSettings.guards.weapons[GetRandomIntInRange(1, Utils.GetTableLength(Settings.crateDropSettings.guards.weapons) + 1)])
		GiveWeaponToPed(guard, weaponHash, -1, false, true)
		SetPedInfiniteAmmo(guard, true, weaponHash)

		SetPedCombatAbility(guard, 2) -- Proffesional
		SetPedCombatAttributes(guard, 0, true) -- CanUseCovers
		SetPedCombatAttributes(guard, 46, true) -- AlwaysFight
		SetPedCombatRange(guard, 2) -- Far

		TaskWanderInArea(guard, x, y, z, Settings.crateDropSettings.guards.radius, Settings.crateDropSettings.guards.radius / 2, 30000) -- Is it good enough?

		Citizen.Wait(50) -- This is dirty hack for better randomness
	end

	SetModelAsNoLongerNeeded(modelHash)
end


AddEventHandler('lsv:init', function()
	while true do
		if crateDropData then
			if HasPickupBeenCollected(crateDropData.pickup) then
				TriggerServerEvent('lsv:cratePickedUp')
			elseif DoesPickupExist(crateDropData.pickup) then
				local pickupX, pickupY, pickupZ = table.unpack(GetPickupCoords(crateDropData.pickup))
				Gui.DrawPlaceMarker(pickupX, pickupY, pickupZ - 1, Settings.placeMarkerRadius, 240, 200, 80, Settings.placeMarkerOpacity)
			end
		end

		Citizen.Wait(0)
	end
end)


RegisterNetEvent('lsv:spawnCrate')
AddEventHandler('lsv:spawnCrate', function(positionIndex, weaponIndex)
	crateDropData = { }
	crateDropData.pickup = CreatePickupRotate(GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED'), Settings.crateDropSettings.positions[positionIndex].x,
		Settings.crateDropSettings.positions[positionIndex].y, Settings.crateDropSettings.positions[positionIndex].z, 0.0, 0.0, 0.0, 512)
	crateDropData.weaponIndex = weaponIndex

	CrateBlip = Map.CreatePlaceBlip(Blip.CrateDrop(), Settings.crateDropSettings.positions[positionIndex].x, Settings.crateDropSettings.positions[positionIndex].y,
		Settings.crateDropSettings.positions[positionIndex].z)
	SetBlipAsShortRange(CrateBlip, false)
	SetBlipColour(CrateBlip, 5)
	SetBlipFlashes(CrateBlip, true)
	SetTimeout(5000, function()
		if CrateBlip then
			SetBlipFlashes(CrateBlip, false)
		end
	end)
	SetBlipScale(CrateBlip, 1.5)

	if NetworkIsHost() then spawnCrateGuard(positionIndex) end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('~y~A Special Crate has been dropped.')
end)


RegisterNetEvent('lsv:removeCrate')
AddEventHandler('lsv:removeCrate', function(player, weaponClipCount, money)
	if PlayerId() ~= GetPlayerFromServerId(player) then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~y~')..' picked up Special Crate.')
	else
		local playerPed = PlayerPedId()
		SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))

		local weapon = Settings.crateDropSettings.weapons[crateDropData.weaponIndex]
		local weaponHash = GetHashKey(weapon.id)
		GiveWeaponToPed(playerPed, weaponHash, GetWeaponClipSize(weaponHash) * weaponClipCount, false, true)

		Gui.DisplayNotification('Crate Contents:~w~\n+ $'..tostring(money)..'\n+ '..weapon.name..'\n+ Body Armor')
	end

	resetCrateDropData()
end)


Citizen.CreateThread(function()
	AddRelationshipGroup("CRATE_DROP_GUARDS")
	SetRelationshipBetweenGroups(5, GetHashKey("CRATE_DROP_GUARDS"), GetHashKey("PLAYER")) -- 5 means HATES
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("CRATE_DROP_GUARDS"))
end)