Player = { }

Player.initialized = false

Player.skin = nil

Player.money = 0
Player.killstreak = 0
Player.kills = 0
Player.deaths = 0

Player.vehicle = nil
Player.vehicleModel = nil
Player.vehicleBlip = nil

Player.startingWeapon = nil
Player.currentWeaponHash = nil

Player.crewMembers = { } -- { serverPlayerId }


function Player.GetMoney()
	return Player.money
end


function Player.ChangeMoney(money)
	Player.money = math.max(Player.GetMoney() + math.floor(money), 0)
	TriggerServerEvent('lsv:updateScoreboard', Player.money, Player.kills, Player.deaths)
end


function Player.GetPlayerWeapons()
	local player = GetPlayerPed(-1)
	local ammoTypes = { }
	local result = { }

	for _, weapon in pairs(Weapon.GetWeapons()) do
		local weaponHash = GetHashKey(weapon.id)

		if HasPedGotWeapon(player, weaponHash, false) then
			local playerWeapon = weapon

			local ammoType = GetPedAmmoTypeFromWeapon(player, weaponHash)
			if ammoTypes[ammoType] == nil then
				ammoTypes[ammoType] = true
				playerWeapon.ammo = GetAmmoInPedWeapon(player, weaponHash)
			else
				playerWeapon.ammo = 0
			end

			if weaponHash == GetSelectedPedWeapon(player) then
				playerWeapon.selected = true
			end

			for _, component in pairs(weapon.components) do
				if HasPedGotWeaponComponent(player, weaponHash, component.hash) then
					component.owned = true
				end
			end

			table.insert(result, playerWeapon)
		end
	end

	return result
end


function Player.GiveWeaponsToPlayer(weapons)
	local player = GetPlayerPed(-1)

	for _, weapon in pairs(weapons) do
		GiveWeaponToPed(player, GetHashKey(weapon.id), weapon.ammo, false, weapon.selected or false)

		for _, component in pairs(weapon.components) do
			if component.owned then
				GiveWeaponComponentToPed(player, GetHashKey(weapon.id), component.hash)
			end
		end
	end
end


function Player.IsEnoughMoney(money)
	return Player.money >= money
end


function Player.SpawnVehicle(coords) -- { x, y, z, heading }
	RequestModel(Player.vehicleModel)
	while not HasModelLoaded(Player.vehicleModel) do
		Citizen.Wait(0)
	end

	Player.vehicle = CreateVehicle(Player.vehicleModel, coords.x, coords.y, coords.z, coords.heading, true, false)

	SetVehicleOnGroundProperly(Player.vehicle)
	SetVehicleNumberPlateText(Player.vehicle, GetPlayerName(PlayerId()))
	SetVehicleModKit(Player.vehicle, 0)
	SetVehicleMod(Player.vehicle, 16, 4) --Attempt to set 100% Armour
	SetEntityAsMissionEntity(Player.vehicle, true, true)

	local vehNetId = NetworkGetNetworkIdFromEntity(Player.vehicle)
	SetNetworkIdExistsOnAllMachines(vehNetId, true)
	SetNetworkIdCanMigrate()

	SetModelAsNoLongerNeeded(Player.vehicleModel)

	Player.vehicleBlip = AddBlipForEntity(Player.vehicle)
	SetBlipSprite(Player.vehicleBlip, Blip.PersonalVehicleCar())
	SetBlipHighDetail(Player.vehicleBlip, true)
	SetBlipFlashes(Player.vehicleBlip, true)
	SetTimeout(5000, function()
		if Player.vehicleBlip then
			SetBlipFlashes(Player.vehicleBlip, false)
		end
	end)
end