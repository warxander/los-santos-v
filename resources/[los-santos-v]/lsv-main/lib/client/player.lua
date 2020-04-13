Player = { }
Player.__index = Player

Player.Loaded = false

Player.TimePlayed = 0

Player.InPassiveMode = false
Player.Kills = 0
Player.Deaths = 0
Player.Skin = nil
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

Player.Headshots = 0
Player.MaxKillstreak = 0
Player.MissionsDone = 0
Player.EventsWon = 0

Player.Faction = Settings.faction.Neutral

Player.CrewMembers = { }

local _serverId = nil
local _prevSkinId = nil

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

	Player.Kills = playerData.Kills
	Player.Headshots = playerData.Headshots
	Player.MaxKillstreak = playerData.MaxKillstreak
	Player.Deaths = playerData.Deaths
	Player.PatreonTier = playerData.PatreonTier
	Player.Moderator = playerData.Moderator

	Player.Cash = playerData.Cash
	Player.Experience = playerData.Experience
	Player.Rank = playerData.Rank
	Player.Prestige = playerData.Prestige

	Player.MissionsDone = playerData.MissionsDone
	Player.EventsWon = playerData.EventsWon

	setSkillStats(playerData.SkillStats)

	SetPlayerMaxArmour(PlayerId(), Settings.armour.max)
end

function Player.IsActive()
	return not IsPlayerDead(PlayerId()) and not Player.InPassiveMode and not IsPlayerSwitchInProgress() and not GetIsLoadingScreenActive()
end

function Player.IsOnMission()
	return Player.IsActive() and MissionManager.Mission
end

function Player.IsInFreeroam()
	return Player.IsActive() and not MissionManager.Mission and not World.ChallengingPlayer
end

function Player.ServerId()
	return _serverId
end

function Player.IsCrewMember(id)
	return table.ifind(Player.CrewMembers, id)
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
		FreezeEntityPosition(playerPedId, not allowMovement)
		SetEntityCollision(playerPedId, allowMovement)
	else
		FreezeEntityPosition(playerPedId, false)
		SetEntityCollision(playerPedId, true)
	end

	World.EnablePvp(not passive)

	SetEntityAlpha(playerPedId, passive and 128 or 255)
	SetPlayerInvincible(playerId, passive)

	Player.InPassiveMode = passive
end

function Player.SetModel(id, isTemp)
	if not id or Player.Skin == id then
		return
	end

	ResetPedMovementClipset(PlayerPedId(), 0.0)

	local model = GetHashKey(id)

	Streaming.RequestModelAsync(id)

	local weapons = Player.GetPlayerWeapons()
	local health = GetEntityHealth(PlayerPedId())
	local armor = GetPedArmour(PlayerPedId())
	local hasParachute = HasPedGotWeapon(PlayerPedId(), `GADGET_PARACHUTE`, false)

	SetPlayerModel(PlayerId(), model)
	SetPedRandomComponentVariation(PlayerPedId())

	if isTemp then
		_prevSkinId = Player.Skin
	else
		_prevSkinId = nil
	end

	Player.Skin = id

	SetPedArmour(PlayerPedId(), armor)
	SetEntityHealth(PlayerPedId(), health)

	if Settings.giveParachuteAtSpawn then
		if hasParachute then
			GiveWeaponToPed(PlayerPedId(), `GADGET_PARACHUTE`, 1, false, false)
		end
	end

	Player.GiveWeapons(weapons)
	SetPedDropsWeaponsWhenDead(PlayerPedId(), false)

	SetModelAsNoLongerNeeded(model)
end

function Player.ResetModel()
	Player.SetModel(_prevSkinId)
end

function Player.Kill()
	SetEntityHealth(PlayerPedId(), 0)
end

function Player.ExplodePersonalVehicle()
	if not Player.VehicleHandle then
		return false
	end

	local explodeTimer = Timer.New()

	NetworkRequestControlOfEntity(Player.VehicleHandle)
	while not NetworkHasControlOfEntity(Player.VehicleHandle) do
		Citizen.Wait(0)
		if explodeTimer:elapsed() >= 1000 then
			Gui.DisplayPersonalNotification('Unable to get control of Personal Vehicle.')
			return false
		end
	end

	NetworkExplodeVehicle(Player.VehicleHandle, true, false, false)
	SetEntityAsNoLongerNeeded(Player.VehicleHandle)

	return true
end

RegisterNetEvent('lsv:cashUpdated')
AddEventHandler('lsv:cashUpdated', function(cashDiff)
	Player.Cash = Player.Cash + cashDiff
end)

RegisterNetEvent('lsv:maxKillstreakUpdated')
AddEventHandler('lsv:maxKillstreakUpdated', function(maxKillstreak)
	Player.MaxKillstreak = maxKillstreak
end)

RegisterNetEvent('lsv:headshotsUpdated')
AddEventHandler('lsv:headshotsUpdated', function(headshots)
	Player.Headshots = headshots
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

RegisterNetEvent('lsv:playerJoinedFaction')
AddEventHandler('lsv:playerJoinedFaction', function(player, faction)
	if player == Player.ServerId() then
		Player.Faction = faction
	end
end)

RegisterNetEvent('lsv:savePlayer')
AddEventHandler('lsv:savePlayer', function()
	Player.Save()
end)
