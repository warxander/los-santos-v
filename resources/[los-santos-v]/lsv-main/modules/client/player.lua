Player = { }

Player.isLoaded = false

Player.skin = nil

Player.RP = 0
Player.killstreak = 0
Player.kills = 0
Player.deaths = 0

Player.isEventInProgress = false

Player.crewMembers = { } -- { serverPlayerId }


function Player.StartVipWork(eventName)
	Player.isEventInProgress = true
	TriggerServerEvent('lsv:vipWorkStarted', eventName)
end


function Player.FinishVipWork(eventName)
	Player.isEventInProgress = false
	TriggerServerEvent('lsv:vipWorkFinished', eventName)
end


function Player.GetPlayerWeapons()
	local player = PlayerPedId()
	local ammoTypes = { }
	local result = { }

	for id, weapon in pairs(Weapon.GetWeapons()) do
		local weaponHash = GetHashKey(id)

		if HasPedGotWeapon(player, weaponHash, false) then
			local playerWeapon = { }

			playerWeapon.id = id

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
			for _, component in ipairs(weapon.components) do
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

	for _, weapon in ipairs(weapons) do
		local weaponHash = GetHashKey(weapon.id)

		GiveWeaponToPed(player, weaponHash, weapon.ammo, false, weapon.selected or false)

		for _, component in ipairs(weapon.components) do
			GiveWeaponComponentToPed(player, GetHashKey(weapon.id), component)
		end

		SetPedWeaponTintIndex(player, weaponHash, weapon.tintIndex)
	end
end


function Player.SaveWeapons()
	TriggerServerEvent('lsv:savePlayerWeapons', Player.GetPlayerWeapons())
end


function Player.Save()
	Player.SaveWeapons()

	TriggerServerEvent('lsv:playerSaved')
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
	Gui.DisplayNotification('Gained '..RP..' RP.')
end)


RegisterNetEvent('lsv:savePlayer')
AddEventHandler('lsv:savePlayer', function()
	Player.Save()
end)