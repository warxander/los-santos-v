local _blockedEvents = {
	'ambulancier:selfRespawn',
	'bank:transfer',
	'esx_ambulancejob:revive',
	'esx-qalle-jail:openJailMenu',
	'esx_jailer:wysylandoo',
	'esx_society:openBossMenu',
	'esx:spawnVehicle',
	'esx_status:set',
	'HCheat:TempDisableDetection',
	'UnJP',
}

local _globalVars = {
	'oTable',
}

local _banned = false

table.iforeach(_blockedEvents, function(eventName)
	AddEventHandler(eventName, function()
		TriggerEvent('lsv:autoBanPlayer', 'Cheating', 'TriggerEvent(\''..eventName..'\')')
		CancelEvent()
	end)
end)

AddEventHandler('lsv:autoBanPlayer', function(reason, message)
	if not _banned then
		TriggerServerEvent('lsv:autoBanPlayer', reason, message)
		_banned = true
	end

	CancelEvent()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if _banned then
			return
		end

		-- Player visibility
		SetEntityVisible(PlayerPedId(), true)
		if not Player.InPassiveMode then
			ResetEntityAlpha(PlayerPedId())
		end

		-- Disable weapon firing
		if Player.InPassiveMode then
			DisablePlayerFiring(PlayerId())
		end

		-- Infinite ammo
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(250)

		-- Check global variables
		for _, var in ipairs(_globalVars) do
			if _G[var] ~= nil then
				TriggerEvent('lsv:autoBanPlayer', 'Cheating', '_G['..var..']')
				return
			end
		end

		-- Player invincibility, health/armour modifications
		if Player.IsActive() then
			if GetPlayerInvincible(PlayerId()) or GetEntityHealth(PlayerPedId()) > 200 or GetPedArmour(PlayerId()) > Settings.armour.max then
				TriggerEvent('lsv:autoBanPlayer', 'God Mode')
				return
			end
		end

		-- Player modifiers
		if math.ceil(GetPlayerWeaponDamageModifier(PlayerId())) > 1 or math.ceil(GetPlayerWeaponDefenseModifier(PlayerId())) > 1 then
			TriggerEvent('lsv:autoBanPlayer', 'Cheating', 'PlayerModifier')
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
					TriggerEvent('lsv:autoBanPlayer', 'Explosive Ammo')
					return
				end
			end
		end

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
