Player = { }

Player.isLoaded = false

Player.isFreeze = nil

Player.serverId = nil

Player.skin = nil

Player.cash = 0
Player.killstreak = 0
Player.kills = 0
Player.deaths = 0

Player.crewMembers = { } -- { serverPlayerId }


function Player.Init(playerData)
	Player.serverId = GetPlayerServerId(PlayerId())
	Player.cash = playerData.Cash
	Player.kills = playerData.Kills
	Player.deaths = playerData.Deaths

	StatSetInt(GetHashKey('MP0_LUNG_CAPACITY'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_STAMINA'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_STRENGTH'), playerData.SkillStat, true)
	StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), playerData.SkillStat, true)

	Skin.ChangePlayerSkin(playerData.SkinModel, true)

	Player.GiveWeapons(playerData.Weapons)
end


function Player.ServerId()
	return Player.serverId
end


function Player.isCrewMember(serverId)
	return Utils.IndexOf(Player.crewMembers, serverId)
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


function Player.SetFreeze(freeze)
	SetEntityAlpha(PlayerPedId(), freeze and 128 or 255)
	SetPlayerControl(PlayerId(), not freeze, false)
	FreezeEntityPosition(PlayerPedId(), freeze)
	SetEntityCollision(PlayerPedId(), not freeze)
	SetPlayerInvincible(PlayerId(), freeze)

	Player.isFreeze = freeze
end


RegisterNetEvent('lsv:cashUpdated')
AddEventHandler('lsv:cashUpdated', function(cash)
	Player.cash = Player.cash + cash
end)


RegisterNetEvent('lsv:savePlayer')
AddEventHandler('lsv:savePlayer', function()
	Player.Save()
end)
