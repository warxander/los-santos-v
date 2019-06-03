AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		-- Player invincibility
		if Player.IsActive() and GetPlayerInvincible(PlayerId()) then
			TriggerServerEvent('lsv:autoBanPlayer', 'God Mode')
			return
		end

		-- Max health and armour
		if GetEntityHealth(PlayerPedId()) > 200 or GetPedArmour(PlayerId()) > Settings.maxArmour then
			TriggerServerEvent('lsv:autoBanPlayer', 'God Mode')
			return
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
		SetPlayerWeaponDamageModifier(PlayerId(), 1.)
		SetPlayerVehicleDamageModifier(PlayerId(), 1.)
		SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.)

		-- Defense modifiers
		SetPlayerWeaponDefenseModifier(PlayerId(), 1.)
		SetPlayerVehicleDefenseModifier(PlayerId(), 1.)
		SetPlayerMeleeWeaponDefenseModifier(PlayerId(), 1.)

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