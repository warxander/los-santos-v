Player = { }

Player.isLoaded = false

Player.skin = nil

Player.RP = 0
Player.killstreak = 0
Player.kills = 0
Player.deaths = 0

Player.meleeWeapon = nil
Player.primaryWeapon = nil
Player.secondaryWeapon = nil
Player.gadget1 = nil
Player.gadget2 = nil

Player.crewMembers = { } -- { serverPlayerId }


function Player.GetPlayerWeapons()
	local player = PlayerPedId()
	local ammoTypes = { }
	local result = { }

	for _, weapon in pairs(Weapon.GetWeapons()) do
		local weaponHash = GetHashKey(weapon.id)

		if HasPedGotWeapon(player, weaponHash, false) then
			local playerWeapon = { }

			playerWeapon.id = weapon.id

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

			playerWeapon.components = { }
			for _, component in pairs(weapon.components) do
				if HasPedGotWeaponComponent(player, weaponHash, component.hash) then
					table.insert(playerWeapon.components, component.hash)
				end
			end

			playerWeapon.tintIndex = GetPedWeaponTintIndex(player, weaponHash)

			table.insert(result, playerWeapon)
		end
	end

	return result
end


function Player.GiveWeapons(weapons)
	local player = PlayerPedId()

	for _, weapon in pairs(weapons) do
		local weaponHash = GetHashKey(weapon.id)

		GiveWeaponToPed(player, weaponHash, weapon.ammo, false, weapon.selected or false)

		for _, component in pairs(weapon.components) do
			GiveWeaponComponentToPed(player, GetHashKey(weapon.id), component.hash)
		end

		SetPedWeaponTintIndex(player, weaponHash, weapon.tintIndex)
	end
end


function Player.UpdateMeleeWeapon(meleeWeapon)
	if Player.meleeWeapon then RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Player.meleeWeapon)) end
	Player.meleeWeapon = meleeWeapon
	GiveWeaponToPed(PlayerPedId(), GetHashKey(Player.meleeWeapon), 1, false, true)
end


function Player.UpdatePrimaryWeapon(primaryWeapon)
	if Player.primaryWeapon then RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Player.primaryWeapon)) end
	Player.primaryWeapon = primaryWeapon
	GiveWeaponToPed(PlayerPedId(), GetHashKey(Player.primaryWeapon), Weapon.GetSpawningAmmo(GetHashKey(Player.primaryWeapon)), false, true)
end


function Player.UpdateSecondaryWeapon(secondaryWeapon)
	if Player.secondaryWeapon then RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Player.secondaryWeapon)) end
	Player.secondaryWeapon = secondaryWeapon
	GiveWeaponToPed(PlayerPedId(), GetHashKey(Player.secondaryWeapon), Weapon.GetSpawningAmmo(GetHashKey(Player.secondaryWeapon)), false, true)
end


function Player.UpdateGadget1(gadget1)
	if Player.gadget1 then RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Player.gadget1)) end
	Player.gadget1 = gadget1
	GiveWeaponToPed(PlayerPedId(), GetHashKey(Player.gadget1), Weapon.GetSpawningAmmo(GetHashKey(Player.gadget1)), false, true)
end


function Player.UpdateGadget2(gadget2)
	if Player.gadget2 then RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Player.gadget2)) end
	Player.gadget2 = gadget2
	GiveWeaponToPed(PlayerPedId(), GetHashKey(Player.gadget2), Weapon.GetSpawningAmmo(GetHashKey(Player.gadget2)), false, true)
end

function Player.Teleport(position)
	local playerPed = PlayerPedId()

	ClearPedTasksImmediately(playerPed)
	SetEntityCoords(playerPed, position.x, position.y, position.z)

	RequestCollisionAtCoord(position.x, position.y, position.z)
	while not HasCollisionLoadedAroundEntity(playerPed) do
		Citizen.Wait(0)
		RequestCollisionAtCoord(position.x, position.y, position.z)
	end
end


RegisterNetEvent('lsv:RPUpdated')
AddEventHandler('lsv:RPUpdated', function(RP)
	Player.RP = Player.RP + RP
end)