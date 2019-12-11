AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(250)

		-- Player invincibility, health/armour modifications
		if Player.IsActive() then
			if GetPlayerInvincible(PlayerId()) or GetEntityHealth(PlayerPedId()) > 200 or GetPedArmour(PlayerId()) > Settings.maxArmour then
				TriggerServerEvent('lsv:autoBanPlayer', 'God Mode')
				return
			end
		end

		-- Explosive ammo
		local weaponHash = GetSelectedPedWeapon(PlayerPedId())
		if weaponHash ~= 0 then
			local weaponTypeGroup = GetWeapontypeGroup(weaponHash) -- https://wiki.rage.mp/index.php?title=Weapon::getWeapontypeGroup
			if weaponTypeGroup == 2685387236 or weaponTypeGroup == 416676503 or
					weaponTypeGroup == 3337201093 or weaponTypeGroup == 860033945 or
					weaponTypeGroup == 970310034 or weaponTypeGroup == 1159398588 or
					weaponTypeGroup == 3082541095 then
				if GetWeaponDamageType(weaponHash) == 5 then
					TriggerServerEvent('lsv:autoBanPlayer', 'Explosive Ammo')
					return
				end
			end
		end

		-- Player visibility
		SetEntityVisible(PlayerPedId(), true)
		if not Player.Frozen then ResetEntityAlpha(PlayerPedId()) end

		-- Infinite ammo
		SetPedInfiniteAmmoClip(PlayerPedId(), false)

		-- Damage modifiers
		SetPlayerWeaponDamageModifier(PlayerId(), Settings.weaponDamageModifier)
		SetPlayerVehicleDamageModifier(PlayerId(), Settings.weaponDamageModifier)
		SetPlayerMeleeWeaponDamageModifier(PlayerId(), Settings.weaponDamageModifier)

		-- Defense modifiers
		SetPlayerWeaponDefenseModifier(PlayerId(), Settings.defenseModifier)
		SetPlayerVehicleDefenseModifier(PlayerId(), Settings.defenseModifier)
		SetPlayerMeleeWeaponDefenseModifier(PlayerId(), Settings.defenseModifier)

		-- Max speed
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
				SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
			end
		else
			local maxSpeed = (IsPedFalling(PlayerPedId()) or IsPedRagdoll(PlayerPedId()) or GetPedParachuteState(PlayerPedId()) >= 0) and 80.0 or 7.1
			SetEntityMaxSpeed(PlayerPedId(), maxSpeed)
		end
	end
end)
