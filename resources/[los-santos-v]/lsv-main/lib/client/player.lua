Player = { }
Player.__index = Player

Player.Loaded = false

Player.TimePlayed = 0

Player.InPassiveMode = false
Player.Kills = 0
Player.Deaths = 0
Player.SkinModel = nil
Player.Moderator = nil

Player.Killstreak = 0
Player.Deathstreak = 0

Player.VehicleHandle = nil
Player.Vehicle = nil

Player.PatreonTier = nil

Player.Cash = 0
Player.Experience = 0
Player.Rank = 1
Player.Prestige = 0

Player.MoneyWasted = 0
Player.Headshots = 0
Player.VehicleKills = 0
Player.MaxKillstreak = 0
Player.LongestKillDistance = 0
Player.MissionsDone = 0
Player.EventsWon = 0

Player.Garages = { }
Player.Vehicles = { }

Player.DrugBusiness = { }

Player.CrewLeader = nil
Player.CrewMembers = { }

Player.Records = { }

Player.Settings = { }

local _serverId = nil
local _prevSkinModel = nil

local function setSkillStats(stats)
	StatSetInt(`MP0_STRENGTH`, stats.strength, true)
	StatSetInt(`MP0_SHOOTING_ABILITY`, stats.shooting, true)
	StatSetInt(`MP0_FLYING_ABILITY`, stats.flying, true)
	StatSetInt(`MP0_WHEELIE_ABILITY`, stats.driving, true)
	StatSetInt(`MP0_LUNG_CAPACITY`, stats.lung, true)
	StatSetInt(`MP0_STEALTH_ABILITY`, stats.stealth, true)
	StatSetInt(`MP0_STAMINA`, stats.stamina, true)
end

function Player.Init(playerData)
	_serverId = GetPlayerServerId(PlayerId())

	Player.TimePlayed = playerData.TimePlayed
	Player.MoneyWasted = playerData.MoneyWasted

	Player.Kills = playerData.Kills
	Player.Headshots = playerData.Headshots
	Player.VehicleKills = playerData.VehicleKills
	Player.MaxKillstreak = playerData.MaxKillstreak
	Player.LongestKillDistance = playerData.LongestKillDistance
	Player.Deaths = playerData.Deaths
	Player.PatreonTier = playerData.PatreonTier
	Player.Moderator = playerData.Moderator

	Player.Settings = playerData.Settings

	Player.Cash = playerData.Cash
	Player.Experience = playerData.Experience
	Player.Rank = playerData.Rank
	Player.Prestige = playerData.Prestige

	Player.MissionsDone = playerData.MissionsDone
	Player.EventsWon = playerData.EventsWon

	Player.Records = playerData.Records

	Player.Garages = playerData.Garages
	Player.Vehicles = playerData.Vehicles

	Player.DrugBusiness = playerData.DrugBusiness

	setSkillStats(playerData.SkillStats)

	SetPlayerMaxArmour(PlayerId(), Settings.armour.max)
end

function Player.IsActive()
	return Player.Loaded and not IsPlayerDead(PlayerId())
end

function Player.IsOnMission()
	return Player.IsActive() and MissionManager.Mission
end

function Player.IsInFreeroam()
	return Player.IsActive() and not MissionManager.Mission
end

function Player.HasGarage(garage)
	return Player.Garages[garage] ~= nil
end

function Player.GetGaragesCapacity()
	local capacity = 0

	table.foreach(Player.Garages, function(_, garage)
		capacity = capacity + Settings.garages[garage].capacity
	end)

	return capacity
end

function Player.HasDrugBusiness(type)
	return Player.DrugBusiness[type] ~= nil
end

function Player.ServerId()
	return _serverId
end

function Player.IsInCrew()
	return Player.CrewLeader or Player.CrewMembers[Player.ServerId()]
end

function Player.IsACrewLeader()
	return Player.CrewLeader == Player.ServerId()
end

function Player.GetWaypoint()
	return GetFirstBlipInfoId(8)
end

function Player.GetPlayerWeapons()
	local player = PlayerPedId()
	local ammoTypes = { }
	local result = { }

	table.foreach(Weapon, function(weapon, id)
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
			table.iforeach(weapon.components, function(component)
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
	return World.GetDistance(Player.Position(), position, useZ)
end

function Player.Teleport(position)
	local playerPed = PlayerPedId()

	ClearPedTasksImmediately(playerPed)
	SetEntityCoords(playerPed, position.x, position.y, position.z - 1.0)

	RequestCollisionAtCoord(position.x, position.y, position.z)
	while not HasCollisionLoadedAroundEntity(playerPed) do
		Citizen.Wait(0)
		RequestCollisionAtCoord(position.x, position.y, position.z)
	end

	PlaceObjectOnGroundProperly(playerPed)
end

function Player.SetPassiveMode(passive, allowMovement)
	local playerPedId = PlayerPedId()
	local playerId = PlayerId()

	if passive then
		SetEntityCollision(playerPedId, allowMovement)
		FreezeEntityPosition(playerPedId, not allowMovement)
	else
		if not IsPedInAnyVehicle(playerPedId) then
			SetEntityCollision(playerPedId, true)
		end
		FreezeEntityPosition(playerPedId, false)
	end

	World.EnablePvp(not passive)

	SetEntityAlpha(playerPedId, passive and 128 or 255)
	SetPlayerInvincible(playerId, passive)

	Player.InPassiveMode = passive
end

function Player.SetModelAsync(skinModel, isTemp)
	if not skinModel then
		return
	end

	local weapons = nil
	local health = nil
	local armour = nil
	local hasParachute = nil
	local playerPed = nil

	if Player.Loaded then
		weapons = Player.GetPlayerWeapons()
		playerPed = PlayerPedId()
		health = GetEntityHealth(playerPed)
		armour = GetPedArmour(playerPed)
		hasParachute = HasPedGotWeapon(playerPed, `GADGET_PARACHUTE`, false)
	end

	local modelHash = nil
	if not Player.Loaded or skinModel.model ~= Player.SkinModel.model then
		modelHash = GetHashKey(skinModel.model)
		Streaming.RequestModelAsync(modelHash)
		SetPlayerModel(PlayerId(), modelHash)
	end

	playerPed = PlayerPedId()

	if Player.Loaded then
		ClearPedEnvDirt(playerPed)
		ClearPedBloodDamage(playerPed)
		ClearPedWetness(playerPed)
	end

	if skinModel.components then
		table.foreach(skinModel.components, function(componentData, componentId)
			SetPedPreloadVariationData(playerPed, tonumber(componentId), componentData[1], componentData[2])
			SetPedComponentVariation(playerPed, tonumber(componentId), componentData[1], componentData[2], 0)
		end)
	else
		skinModel.components = { }
	end

	_prevSkinModel = isTemp and Player.SkinModel or nil
	Player.SkinModel = skinModel

	if Player.Loaded then
		SetPedArmour(playerPed, armour)
		SetEntityHealth(playerPed, health)

		if hasParachute then
			GiveWeaponToPed(playerPed, `GADGET_PARACHUTE`, 1, false, false)
		end

		Player.GiveWeapons(weapons)
		SetPedDropsWeaponsWhenDead(playerPed, false)
	end

	if modelHash then
		SetModelAsNoLongerNeeded(modelHash)
	end

	ReleasePedPreloadVariationData(playerPed)
end

function Player.GetModel()
	local skinModel = { }

	skinModel.model = Player.SkinModel.model
	skinModel.components = { }

	local playerPed = PlayerPedId()
	for componentId = 0, 11 do
		local drawableId = GetPedDrawableVariation(playerPed, componentId)
		local textureId = GetPedTextureVariation(playerPed, componentId)

		if drawableId ~= 0 or textureId ~= 0 then
			skinModel.components[componentId] = { drawableId, textureId }
		end
	end

	return skinModel
end

function Player.ResetModelAsync()
	Player.SetModelAsync(_prevSkinModel)
	_prevSkinModel = nil
end

function Player.Kill()
	SetEntityHealth(PlayerPedId(), 0)
end

function Player.GetVehicleName(vehicleIndex)
	local vehicle = Player.Vehicles[vehicleIndex]
	return vehicle.userName or vehicle.name
end

function Player.LeaveVehicle(vehicle, exitFlag)
	local playerPed = PlayerPedId()
	if DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false) then
		TaskLeaveVehicle(playerPed, vehicle, exitFlag or 0)
	end
end

function Player.DestroyPersonalVehicle()
	if not Player.VehicleHandle then
		return
	end

	if NetworkDoesEntityExistWithNetworkId(Player.VehicleHandle) then
		local blip = GetBlipFromEntity(NetToVeh(Player.VehicleHandle))
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end

	Network.DeleteVehicle(Player.VehicleHandle)
	Player.VehicleHandle = nil
end

RegisterNetEvent('lsv:cashUpdated')
AddEventHandler('lsv:cashUpdated', function(cashDiff)
	Player.Cash = Player.Cash + cashDiff

	if cashDiff < 0 then
		Player.MoneyWasted = Player.MoneyWasted + math.abs(cashDiff)
	end
end)

RegisterNetEvent('lsv:maxKillstreakUpdated')
AddEventHandler('lsv:maxKillstreakUpdated', function(maxKillstreak)
	Player.MaxKillstreak = maxKillstreak
end)

RegisterNetEvent('lsv:longestKillDistanceUpdated')
AddEventHandler('lsv:longestKillDistanceUpdated', function(killDistance)
	Player.LongestKillDistance = killDistance
end)

RegisterNetEvent('lsv:headshotsUpdated')
AddEventHandler('lsv:headshotsUpdated', function(headshots)
	Player.Headshots = headshots
end)

RegisterNetEvent('lsv:vehicleKillsUpdated')
AddEventHandler('lsv:vehicleKillsUpdated', function(vehicleKills)
	Player.VehicleKills = vehicleKills
end)

RegisterNetEvent('lsv:missionsDoneUpdated')
AddEventHandler('lsv:missionsDoneUpdated', function(missionsDone)
	Player.MissionsDone = missionsDone
end)

RegisterNetEvent('lsv:eventsWonUpdated')
AddEventHandler('lsv:eventsWonUpdated', function(eventsWon)
	Player.EventsWon = eventsWon
end)

RegisterNetEvent('lsv:experienceUpdated')
AddEventHandler('lsv:experienceUpdated', function(exp)
	Player.Experience = Player.Experience + exp
	TriggerEvent('lsv:showExperience', exp)
end)

RegisterNetEvent('lsv:playerRankChanged')
AddEventHandler('lsv:playerRankChanged', function(rank, skillStats)
	if rank > Player.Rank then
		TriggerEvent('lsv:rankUp', rank)
	end

	Player.Rank = rank
	setSkillStats(skillStats)
end)

RegisterNetEvent('lsv:garageUpdated')
AddEventHandler('lsv:garageUpdated', function(garage)
	Player.Garages[garage] = true
end)

RegisterNetEvent('lsv:drugBusinessUpdated')
AddEventHandler('lsv:drugBusinessUpdated', function(type, data)
	Player.DrugBusiness[type] = data
end)

RegisterNetEvent('lsv:recordUpdated')
AddEventHandler('lsv:recordUpdated', function(id, record)
	Player.Records[id] = record
end)

RegisterNetEvent('lsv:vehicleAdded')
AddEventHandler('lsv:vehicleAdded', function(vehicle)
	table.insert(Player.Vehicles, vehicle)
end)

RegisterNetEvent('lsv:vehicleReplaced')
AddEventHandler('lsv:vehicleReplaced', function(vehicleIndex, vehicle)
	Player.Vehicles[vehicleIndex] = vehicle
end)

RegisterNetEvent('lsv:vehicleRemoved')
AddEventHandler('lsv:vehicleRemoved', function(vehicleIndex)
	table.remove(Player.Vehicles, vehicleIndex)
end)

RegisterNetEvent('lsv:settingUpdated')
AddEventHandler('lsv:settingUpdated', function(key, value)
	Player.Settings[key] = value
	TriggerSignal('lsv:settingUpdated', key, value)
end)

RegisterNetEvent('lsv:savePlayer')
AddEventHandler('lsv:savePlayer', function()
	Player.Save()
end)
