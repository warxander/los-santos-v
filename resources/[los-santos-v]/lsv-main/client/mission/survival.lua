local _waveSettings = {
	{
		count = 8,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG` },
		ability = 0,
	},

	{
		count = 12,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG`, `WEAPON_SMG` },
		ability = 1,
	},

	{
		count = 16,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE` },
		ability = 1,
	},

	{
		count = 19,
		weapons = { `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE`, `WEAPON_ASSAULTSHOTGUN` },
		ability = 2,
	},

	{
		count = 21,
		weapons = { `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE`, `WEAPON_ASSAULTSHOTGUN`, `WEAPON_ADVANCEDRIFLE` },
		ability = 2,
	},
}

local _endlessWaveBoost = {
	armour = 10,
	count = 1,
}

local _locations = Settings.survival.places

local _survivalId = nil
local _location = nil

local _survivalRecords = { }

local function getSurvivalRecord(survivalId)
	local record = 'Server Record: '

	local recordData = _survivalRecords[survivalId]
	if recordData then
		record = record..recordData.PlayerName..' ('..recordData.Waves..' Waves)'
	else
		record = record..'-'
	end

	return record
end

local function finishMission(success, reason)
	if success or _location.waveIndex > _location.waveCount then
		TriggerServerEvent('lsv:survivalFinished', _survivalId, math.max(0, _location.waveIndex - _location.waveCount - 1), _location.waveIndex - 1)
	else
		TriggerEvent('lsv:survivalFinished', false, reason or '')
	end
end

RegisterNetEvent('lsv:survivalFinished')
AddEventHandler('lsv:survivalFinished', function(success, reason)
	MissionManager.FinishMission(success)

	table.iforeach(_location.pedModels, function(model)
		SetModelAsNoLongerNeeded(model)
	end)

	table.iforeach(_location.enemies, function(pedNet)
		Network.DeletePed(pedNet)
	end)

	_survivalId = nil
	_location = nil

	Gui.FinishMission('Survival', success, reason)
end)

RegisterNetEvent('lsv:initSurvivalRecords')
AddEventHandler('lsv:initSurvivalRecords', function(records)
	_survivalRecords = records
end)

RegisterNetEvent('lsv:updateSurvivalRecord')
AddEventHandler('lsv:updateSurvivalRecord', function(survivalId, data)
	_survivalRecords[survivalId] = data
end)

AddEventHandler('lsv:startSurvival', function(id, location)
	_survivalId = id
	_location = location

	table.iforeach(location.pedModels, function(model)
		Streaming.RequestModelAsync(model)
	end)

	_location.waveIndex = 1
	_location.waveCount = #_waveSettings
	_location.totalEnemyCount = 0
	_location.enemiesLeft = 0
	_location.enemies = { }

	local nextWaveTimer = nil
	local enemyWaveSpawned = false

	Gui.StartMission('Survival', 'Survive and take out the enemies.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if _location.waveIndex > _location.waveCount then
				if _survivalRecords[_survivalId] then
					Gui.DrawBar('SERVER RECORD', _survivalRecords[_survivalId].Waves..' Waves', 2)
				end
			end

			if nextWaveTimer then
				Gui.DisplayObjectiveText('Prepare for the next enemy wave.')
				Gui.DrawTimerBar('NEXT WAVE IN', Settings.survival.waveInterval - nextWaveTimer:elapsed(), 1)
			else
				Gui.DisplayObjectiveText('Take out the ~r~enemies~w~.')
				Gui.DrawProgressBar('WAVE '..tostring(_location.waveIndex), (_location.totalEnemyCount - _location.enemiesLeft) / _location.totalEnemyCount, 1)
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			finishMission(false)
			return
		end

		if IsPlayerDead(PlayerId()) then
			finishMission(false)
			return
		end

		if Player.DistanceTo(_location.position, true) > Settings.survival.radius then
			finishMission(false, 'You have left the mission area.')
			return
		end

		if not enemyWaveSpawned then
			if not nextWaveTimer then
				nextWaveTimer = Timer.New()
			elseif nextWaveTimer:elapsed() > Settings.survival.waveInterval then
				local waveData = _waveSettings[math.min(_location.waveIndex, _location.waveCount)]

				local waveBoostLevel = math.max(0, _location.waveIndex - _location.waveCount)

				_location.totalEnemyCount = waveData.count + _endlessWaveBoost.count * waveBoostLevel
				_location.enemiesLeft = _location.totalEnemyCount

				if _location.enemies and #_location.enemies ~= 0 then
					table.iforeach(_location.enemies, function(pedNet)
						Network.DeletePed(pedNet)
					end)
				end

				_location.enemies = { }

				while #_location.enemies ~= _location.totalEnemyCount do
					Citizen.Wait(0)

					if not MissionManager.Mission then
						return
					end

					local location = table.random(_location.spawnPoints)
					local modelHash = table.random(_location.pedModels)

					local netId = Network.CreatePedAsync(11, modelHash, location)

					if netId then
						local ped = NetToPed(netId)

						SetPedRandomComponentVariation(ped, false)
						PlaceObjectOnGroundProperly(ped)

						local weaponHash = table.random(waveData.weapons)
						GiveWeaponToPed(ped, weaponHash, 99999, false, true)
						SetPedInfiniteAmmo(ped, true, weaponHash)
						SetPedArmour(ped, _endlessWaveBoost.armour * waveBoostLevel)
						SetPedDropsWeaponsWhenDead(ped, false)
						SetPedFleeAttributes(ped, 0, false)
						SetPedCombatRange(ped, 2)
						SetPedCombatMovement(ped, 2)
						SetPedCombatAttributes(ped, 46, true)
						SetPedCombatAttributes(ped, 20, true)
						SetPedCombatAbility(ped, waveData.ability)

						SetPedAsEnemy(ped, true)
						SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)

						local blip = AddBlipForEntity(ped)
						SetBlipColour(blip, Color.BLIP_RED)
						SetBlipScale(blip, 0.65)
						Map.SetBlipText(blip, 'Enemy')

						local playerPed = PlayerPedId()
						TaskCombatPed(ped, playerPed, 0, 16)
						if IsPedInAnyVehicle(playerPed, false) then
							AddVehicleSubtaskAttackPed(ped, playerPed)
						end
						SetPedKeepTask(ped, true)

						table.insert(_location.enemies, netId)
					end
				end

				Gui.DisplayPersonalNotification('Wave '..tostring(_location.waveIndex))
				nextWaveTimer = nil
				enemyWaveSpawned = true
			end
		end

		if enemyWaveSpawned then
			local enemyCount = table.icount_if(_location.enemies, function(pedNet)
				local ped = NetToPed(pedNet)

				local isDead = IsPedDeadOrDying(ped, true)

				if isDead then
					local blip = GetBlipFromEntity(ped)
					if DoesBlipExist(blip) then
						RemoveBlip(blip)
					end
				end

				return not isDead
			end)

			_location.enemiesLeft = enemyCount

			if _location.enemiesLeft == 0 then
				_location.waveIndex = _location.waveIndex + 1
				enemyWaveSpawned = false
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	table.foreach(_locations, function(location)
		location.blip = Map.CreatePlaceBlip(Blip.SURVIVAL, location.position.x, location.position.y, location.position.z, 'Survival', Color.BLIP_ORANGE)
	end)

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = Player.Position()

		table.foreach(_locations, function(location, survivalId)
			SetBlipAlpha(location.blip, isPlayerInFreeroam and 255 or 0)

			if isPlayerInFreeroam then
				Gui.DrawPlaceMarker(location.position, Color.ORANGE)

				if World.GetDistance(playerPosition, location.position, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to start ~o~'..location.name..'~w~ Survival.\n'..getSurvivalRecord(survivalId))

						if IsControlJustReleased(0, 46) then
							MissionManager.StartMission('survival', 'Survival')
							TriggerEvent('lsv:startSurvival', survivalId, location)
						end
					end
				end
			end
		end)
	end
end)
