local _waveSettings = {
	{
		count = 4,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG` },
		ability = 0,
		bossCount = 0,
	},

	{
		count = 6,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG`, `WEAPON_SMG` },
		ability = 1,
		bossCount = 0,
	},

	{
		count = 8,
		weapons = { `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE` },
		ability = 1,
		bossCount = 1,
	},

	{
		count = 10,
		weapons = { `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE`, `WEAPON_ASSAULTSHOTGUN` },
		ability = 2,
		bossCount = 1,
	},

	{
		count = 12,
		weapons = { `WEAPON_SMG`, `WEAPON_ASSAULTRIFLE`, `WEAPON_ASSAULTSHOTGUN`, `WEAPON_ADVANCEDRIFLE` },
		ability = 2,
		bossCount = 2,
	},
}

local _bossSettings = {
	model = `u_m_y_juggernaut_01`,
	armour = 50,
	weapons = { `WEAPON_MINIGUN`, `WEAPON_COMBATMG`, `WEAPON_MARKSMANRIFLE` },
}

local _endlessWaveBoost = {
	armour = 5,
	count = 1,
	bossChance = 50,
}

local _locations = Settings.survival.places

local _survivalId = nil
local _location = nil

local _survivalRecords = { }

local function getSurvivalRecord(survivalId)
	local recordData = _survivalRecords[survivalId]
	if recordData then
		return recordData.PlayerName..' | '..recordData.Waves..' Waves'
	else
		return '-'
	end
end

local function getPlayerSurvivalBest(survivalId)
	local record = Player.Records[survivalId]

	if record then
		return record..' Waves'
	else
		return '-'
	end
end

local function finishMission(success, reason)
	if success or _location.waveIndex > _location.waveCount then
		TriggerServerEvent('lsv:finishSurvival', _survivalId, math.max(0, _location.waveIndex - _location.waveCount - 1), _location.waveIndex - 1)
	else
		TriggerEvent('lsv:finishSurvival', false, reason or '')
	end
end

RegisterNetEvent('lsv:finishSurvival')
AddEventHandler('lsv:finishSurvival', function(success, reason)
	MissionManager.FinishMission(success)

	table.iforeach(_location.pedModels, function(model)
		SetModelAsNoLongerNeeded(model)
	end)
	SetModelAsNoLongerNeeded(_bossSettings.model)

	table.iforeach(_location.enemies, function(pedNet)
		Network.DeletePed(pedNet)
	end)

	RemoveBlip(_location.areaBlip)

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

AddEventHandler('lsv:startSurvival', function(id)
	_survivalId = id
	_location = _locations[_survivalId]

	table.iforeach(_location.pedModels, function(model)
		Streaming.RequestModelAsync(model)
	end)
	Streaming.RequestModelAsync(_bossSettings.model)

	_location.areaBlip = Map.CreateRadiusBlip(_location.position.x, _location.position.y, _location.position.z, Settings.survival.radius, Color.BLIP_ORANGE)

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
				local barIndex = 2

				if Player.Records[_survivalId] then
					Gui.DrawBar('PERSONAL BEST', Player.Records[_survivalId]..' Waves', barIndex)
					barIndex = barIndex + 1
				end

				if _survivalRecords[_survivalId] then
					Gui.DrawBar('SERVER BEST', _survivalRecords[_survivalId].Waves..' Waves', barIndex)
					barIndex = barIndex + 1
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

				_location.bossCount = waveData.bossCount
				for i = 1, waveBoostLevel do
					if GetRandomIntInRange(0, 100) < _endlessWaveBoost.bossChance then
						_location.bossCount = _location.bossCount + 1
					end
				end

				if _location.enemies and #_location.enemies ~= 0 then
					table.iforeach(_location.enemies, function(pedNet)
						Network.DeletePed(pedNet)
					end)
				end

				_location.enemies = { }
				local bossCount = 0

				while #_location.enemies ~= _location.totalEnemyCount do
					Citizen.Wait(0)

					if not MissionManager.Mission then
						return
					end

					local location = table.random(_location.spawnPoints)
					local isBoss = bossCount < _location.bossCount
					local modelHash = isBoss and _bossSettings.model or table.random(_location.pedModels)

					Streaming.RequestModelAsync(modelHash)
					local netId = Network.CreatePed(11, modelHash, location, nil, { survival = true, isBoss = isBoss })

					local ped = NetToPed(netId)

					SetPedRandomComponentVariation(ped, false)
					SetEntityLoadCollisionFlag(ped, true)
					PlaceObjectOnGroundProperly(ped)

					local weaponHash = table.random(isBoss and _bossSettings.weapons or waveData.weapons)
					GiveWeaponToPed(ped, weaponHash, 99999, false, true)
					SetPedInfiniteAmmo(ped, true, weaponHash)

					local armour = _endlessWaveBoost.armour * waveBoostLevel
					if isBoss then
						armour = armour + _bossSettings.armour
					end
					SetPedArmour(ped, armour)

					SetPedSuffersCriticalHits(ped, false)
					SetPedDropsWeaponsWhenDead(ped, false)
					SetPedFleeAttributes(ped, 0, false)
					SetPedCombatRange(ped, 2)
					SetPedCombatMovement(ped, 2)
					SetPedCombatAttributes(ped, 46, true)
					SetPedCombatAttributes(ped, 20, true)
					SetPedCombatAbility(ped, isBoss and 2 or waveData.ability)
					SetRagdollBlockingFlags(ped, 1)

					SetPedAsEnemy(ped, true)
					SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)

					local playerPed = PlayerPedId()
					TaskCombatPed(ped, playerPed, 0, 16)
					if IsPedInAnyVehicle(playerPed, false) then
						AddVehicleSubtaskAttackPed(ped, playerPed)
					end
					SetPedKeepTask(ped, true)

					table.insert(_location.enemies, netId)
					if isBoss then
						bossCount = bossCount + 1
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
				return not IsEntityDead(ped)
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
	local _survivalMenuId = nil

	Gui.CreateMenu('survival', 'Survival')
	WarMenu.SetTitleBackgroundColor('survival', Color.ORANGE.r, Color.ORANGE.g, Color.ORANGE.b, Color.ORANGE.a)

	table.foreach(_locations, function(location)
		location.blip = Map.CreatePlaceBlip(Blip.SURVIVAL, location.position.x, location.position.y, location.position.z, 'Survival', Color.BLIP_ORANGE)
	end)

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = Player.Position()

		for survivalId, location in pairs(_locations) do
			SetBlipAlpha(location.blip, isPlayerInFreeroam and 255 or 0)

			if isPlayerInFreeroam then
				Gui.DrawPlaceMarker(location.position, Color.ORANGE)

				if World.GetDistance(playerPosition, location.position, true) <= Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to start Survival.')

						if IsControlJustReleased(0, 46) then
							_survivalMenuId = survivalId
							WarMenu.SetSubTitle('survival', location.name)
							Gui.OpenMenu('survival')
						end
					end
				elseif _survivalMenuId == survivalId and WarMenu.IsMenuOpened('survival') then
					WarMenu.CloseMenu()
				end
			end
		end

		if WarMenu.IsMenuOpened('survival') then
			if WarMenu.Button('Start') then
				WarMenu.CloseMenu()
				MissionManager.StartMission('Survival', 'Survival')
				TriggerEvent('lsv:startSurvival', _survivalMenuId)
			elseif WarMenu.Button('Server Best', getSurvivalRecord(_survivalMenuId)) then
			elseif WarMenu.Button('Personal Best', getPlayerSurvivalBest(_survivalMenuId)) then
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	World.AddPedHandler(function(ped)
		if not NetworkGetEntityIsNetworked(ped) then
			return
		end

		local netId = PedToNet(ped)
		if not Network.DoesEntityExistWithNetworkId(netId) or not Network.GetData(netId, 'survival') then
			return
		end

		local creator = Network.GetCreator(netId)
		if creator ~= Player.ServerId() and not Player.CrewMembers[creator] then
			return
		end

		local blip = GetBlipFromEntity(ped)
		if IsEntityDead(ped) then
			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		elseif not DoesBlipExist(blip) then
			local blip = AddBlipForEntity(ped)
			local isBoss = Network.GetData(netId, 'isBoss')
			if isBoss then
				SetBlipSprite(blip, Blip.SURVIVAL_BOSS)
			end
			Map.SetBlipText(blip, isBoss and 'Boss' or 'Enemy')
			SetBlipColour(blip, Color.BLIP_RED)
			SetBlipScale(blip, isBoss and 0.75 or 0.65)
		end
	end)
end)
