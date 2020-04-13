local function getPlayerByEntityId(entity)
	for _, id in ipairs(GetActivePlayers()) do
		if GetPlayerPed(id) == entity then
			return id
		end
	end

	return nil
end

local function getPedVehicleSeat(ped)
	local vehicle = GetVehiclePedIsIn(ped, false)

	for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
		if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
	end

	return -2
end

AddEventHandler('lsv:init', function()
	local isDead = false
	local hasBeenDead = false
	local diedAt = nil

	while true do
		Citizen.Wait(0)

		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local ped = PlayerPedId()

			if IsPedFatallyInjured(ped) and not isDead then
				isDead = true
				if not diedAt then
					diedAt = GetGameTimer()
				end

				local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
				local killerweapongroup = 0
				local killertype = -1
				local killerinvehicle = false
				local killervehiclename = ''
				local killervehicleseat = 0
				local killedbyheadshot = false

				local killerentitytype = GetEntityType(killer)
				if killerentitytype == 1 then
					killertype = GetPedType(killer)
					if IsPedInAnyVehicle(killer, false) == 1 then
						killerinvehicle = true
						killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
						killervehicleseat = getPedVehicleSeat(killer)
					else
						killerinvehicle = false
					end
				end

				local killerid = getPlayerByEntityId(killer)
				if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
					killerid = GetPlayerServerId(killerid)
					local hasDamagedBone, damagedBone = GetPedLastDamageBone(ped)
					if hasDamagedBone and damagedBone == 31086 then
						killedbyheadshot = true
					end
					if killerweapon ~= 0 then
						killerweapongroup = GetWeapontypeGroup(killerweapon)
					end
				else
					killerid = -1
				end

				if killer == ped or killer == -1 then
					TriggerServerEvent('lsv:onPlayerDied', killertype, { table.unpack(GetEntityCoords(ped)) })
					hasBeenDead = true
				else
					TriggerServerEvent('lsv:onPlayerKilled', killerid, { killertype = killertype, killerheadshot = killedbyheadshot, weaponhash = killerweapon, weapongroup = killerweapongroup, killerinveh = killerinvehicle, killervehseat = killervehicleseat, killervehname = killervehiclename, killerpos = { table.unpack(GetEntityCoords(ped)) } })
					hasBeenDead = true
				end
			elseif not IsPedFatallyInjured(ped) then
				isDead = false
				diedAt = nil
			end

			-- Check if the player has to respawn in order to trigger an event
			if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
				TriggerServerEvent('lsv:onPlayerWasted', { table.unpack(GetEntityCoords(ped)) })
				hasBeenDead = true
			elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
				hasBeenDead = false
			end
		end
	end
end)
