Player = { }


Player.Frozen = false
Player.Loaded = false
Player.Kills = 0
Player.Skin = nil
Player.Moderator = nil

Player.Killstreak = 0
Player.Deathstreak = 0
Player.Vehicle = nil

local cash = 0
local serverId = nil


function Player.Init(playerData)
	cash = playerData.Cash

	serverId = GetPlayerServerId(PlayerId())

	Player.Kills = playerData.Kills
	Player.PatreonTier = playerData.PatreonTier
	Player.Moderator = playerData.Moderator

	SetPlayerMaxArmour(PlayerId(), Settings.maxArmour)

	StatSetInt(GetHashKey('MP0_LUNG_CAPACITY'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_STAMINA'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_STRENGTH'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), playerData.SkillStat, true)

	Skin.ChangePlayerSkin(playerData.SkinModel, true)

	Player.GiveWeapons(playerData.Weapons)
end


function Player.IsActive()
	return not IsPlayerDead(PlayerId()) and not Player.Frozen and not IsPlayerSwitchInProgress() and not GetIsLoadingScreenActive()
end


function Player.IsOnMission()
	return Player.IsActive() and MissionManager.Mission
end


function Player.IsInFreeroam()
	return Player.IsActive() and not MissionManager.Mission and not World.DuelPlayer
end


function Player.ServerId()
	return serverId
end


function Player.GetPlayerWeapons()
	local player = PlayerPedId()
	local ammoTypes = { }
	local result = { }

	table.foreach(Weapon.GetWeapons(), function(weapon, id)
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
			table.foreach(weapon.components, function(component)
				if HasPedGotWeaponComponent(player, weaponHash, component.hash) then
					table.insert(playerWeapon.components, component.hash)
				end
			end)

			playerWeapon.tintIndex = GetPedWeaponTintIndex(player, weaponHash)

			table.insert(result, playerWeapon)
		end
	end)

	return result
end


function Player.GiveWeapons(weapons)
	local player = PlayerPedId()

	table.foreach(weapons, function(weapon)
		local weaponHash = GetHashKey(weapon.id)

		GiveWeaponToPed(player, weaponHash, weapon.ammo, false, weapon.selected or false)

		table.foreach(weapon.components, function(component)
			GiveWeaponComponentToPed(player, GetHashKey(weapon.id), component)
		end)

		SetPedWeaponTintIndex(player, weaponHash, weapon.tintIndex)
	end)
end


function Player.SaveWeapons()
	TriggerServerEvent('lsv:savePlayerWeapons', Player.GetPlayerWeapons())
end


function Player.Save()
	Player.SaveWeapons()

	TriggerServerEvent('lsv:playerSaved')
end

function Player.Position(alive)
	return GetEntityCoords(PlayerPedId(), alive)
end


function Player.DistanceTo(position, useZ)
	local playerPosition = Player.Position()
	return Vdist(playerPosition.x, playerPosition.y, playerPosition.z, position.x, position.y, position.z, useZ)
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


function Player.SetFreeze(freeze)
	SetEntityAlpha(PlayerPedId(), freeze and 128 or 255)
	SetPlayerControl(PlayerId(), not freeze, false)
	FreezeEntityPosition(PlayerPedId(), freeze)
	SetEntityCollision(PlayerPedId(), not freeze)
	SetPlayerInvincible(PlayerId(), freeze)

	Player.Frozen = freeze
end


function Player.Kill()
	SetEntityHealth(PlayerPedId(), 0)
end


RegisterNetEvent('lsv:cashUpdated')
AddEventHandler('lsv:cashUpdated', function(cashDiff)
	cash = cash + cashDiff
end)


RegisterNetEvent('lsv:savePlayer')
AddEventHandler('lsv:savePlayer', function()
	Player.Save()
end)
