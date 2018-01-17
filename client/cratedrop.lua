CrateBlip = nil

local crate = nil


local function RemoveCrate()
	RemovePickup(crate)
	crate = nil
end

local function TryRemoveCrateBlip()
	if CrateBlip then
		RemoveBlip(CrateBlip)
		CrateBlip = nil
	end
end


RegisterNetEvent('lsv:removeCrate')
AddEventHandler('lsv:removeCrate', function(source)
	TryRemoveCrateBlip()

	if crate then
		RemoveCrate()

		if PlayerId() ~= GetPlayerFromServerId(source) then
			Gui.DisplayNotification(Gui.GetPlayerName(source, '~y~')..' has opened a Crate.')
		end
	end
end)


RegisterNetEvent('lsv:spawnCrate')
AddEventHandler('lsv:spawnCrate', function(position)
	TryRemoveCrateBlip()
	if crate then RemoveCrate() end

	crate = CreatePickupRotate(GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED'), position.x, position.y, position.z, 0.0, 0.0, 0.0, 512)

	CrateBlip = Map.CreatePlaceBlip(Blip.CrateDrop(), position.x, position.y, position.z)
	SetBlipAsShortRange(CrateBlip, false)
	SetBlipColour(CrateBlip, 5)
	SetBlipFlashes(CrateBlip, true)
	SetTimeout(5000, function()
		if CrateBlip then
			SetBlipFlashes(CrateBlip, false)
		end
	end)
	SetBlipScale(CrateBlip, 1.5)

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('~y~A Crate has been dropped.')
end)


Citizen.CreateThread(function()
	local crateMoney = Settings.crateDropMoney
	local crateWeapon = {
		--Heavy Weapons
		{ id = "WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher" },
		{ id = "WEAPON_GRENADELAUNCHER", name = "Grenade Launcher" },
		{ id = "WEAPON_RPG", name = "Rocket Laucher" },
		{ id = "WEAPON_HOMINGLAUNCHER", name = "Homing Laucher" },
		{ id = "WEAPON_MINIGUN", name = "Minigun" },

		--Sniper Rifles
		{ id = "WEAPON_HEAVYSNIPER", name = "Heavy Sniper" },
		{ id = "WEAPON_SNIPERRIFLE", name = "Sniper Rifle" },
		{ id = "WEAPON_MARKSMANRIFLE", name = "Marksman Rifle" },
	}

	while true do
		if crate and HasPickupBeenCollected(crate) then
			RemoveCrate()
			TryRemoveCrateBlip()

			local weapon = crateWeapon[GetRandomIntInRange(1, Utils.GetTableLength(crateWeapon) + 1)]

			Player.ChangeMoney(crateMoney)

			local playerPed = GetPlayerPed(-1)
			SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))

			local weaponHash = GetHashKey(weapon.id)
			GiveWeaponToPed(playerPed, weaponHash, GetWeaponClipSize(weaponHash) * Settings.crateDropWeaponClipCount, false, true)

			Gui.DisplayNotification('~y~Crate Contents:~w~\n+ $'..tostring(crateMoney)..'\n+ '..weapon.name..'\n+ Body Armor')

			TriggerServerEvent('lsv:cratePickedUp')
		elseif DoesPickupExist(crate) then
			local pickupX, pickupY, pickupZ = table.unpack(GetPickupCoords(crate))
			DrawMarker(1, pickupX, pickupY, pickupZ - 1, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 256.0, 240, 200, 80, 128, false, nil, nil, false)
		end

		Citizen.Wait(0)
	end
end)