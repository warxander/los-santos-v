local _targets = nil

local function removeTarget(index)
	local data = _targets[index]

	RemoveBlip(data.blip)
	World.MarkPedToDelete(data.ped, 5000)

	if data.vehicle then
		World.MarkVehicleToDelete(data.vehicle, 5000)
	end
end

local function finishMission(success, reason)
	local targetsLeft = #_targets

	if success or targetsLeft < Settings.headhunter.count then
		TriggerServerEvent('lsv:headhunterFinished', Settings.headhunter.count - targetsLeft)
	else
		TriggerEvent('lsv:headhunterFinished', false, reason or '')
	end
end

RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	table.iforeach(_targets, function(_, index)
		removeTarget(index)
	end)
	_targets = nil

	Gui.FinishMission('Headhunter', success, reason)
end)

AddEventHandler('lsv:startHeadhunter', function()
	_targets = table.irandom_n(Settings.headhunter.locations, Settings.headhunter.count)

	table.iforeach(_targets, function(target)
		local model = table.random(Settings.headhunter.models)
		Streaming.RequestModelAsync(model)

		local modelHash = GetHashKey(model)
		local ped = CreatePed(11, modelHash, target.x, target.y, target.z, GetRandomFloatInRange(0.0, 360.0), false, true)
		SetPedRandomComponentVariation(ped, false)
		SetModelAsNoLongerNeeded(modelHash)

		local vehicle = nil
		if target.inVehicle then
			local vehicleModel = table.random(Settings.headhunter.vehicles)
			local vehicleModelHash = GetHashKey(vehicleModel)
			Streaming.RequestModelAsync(vehicleModel)
			vehicle = CreateVehicle(vehicleModelHash, target.x, target.y, target.z, target.heading, false, true)
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
			SetVehicleModKit(vehicle, 0)
			SetVehicleMod(vehicle, 16, 4)
			SetVehicleTyresCanBurst(vehicle, false)
			SetModelAsNoLongerNeeded(vehicleModelHash)

			SetPedCombatAttributes(ped, 3, false)
			SetPedCombatAttributes(ped, 52, true)
			TaskWarpPedIntoVehicle(ped, vehicle, -1)
		end

		local weaponHash = GetHashKey(vehicle and 'WEAPON_MINISMG' or table.random(Settings.headhunter.weapons))
		GiveWeaponToPed(ped, weaponHash, 99999, false)
		SetPedInfiniteAmmo(ped, true, weaponHash)

		SetEntityHealth(ped, 200)
		SetPedArmour(ped, 100)
		SetPedDropsWeaponsWhenDead(ped, false)
		SetPedFleeAttributes(ped, 0, false)
		SetPedCombatRange(ped, 2)
		SetPedCombatMovement(ped, 2)
		SetPedCombatAttributes(ped, 46, true)
		SetPedCombatAttributes(ped, 20, true)
		SetPedCombatAbility(ped, 2)
		SetPedAsEnemy(ped, true)
		SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)

		local blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, Blip.HEADHUNTER_TARGET)
		SetBlipColour(blip, Color.BLIP_RED)
		SetBlipAsShortRange(blip, false)
		Map.SetBlipText(blip, 'Target')
		Map.SetBlipFlashes(blip)

		target.ped = ped
		target.blip = blip
		target.vehicle = vehicle
	end)

	Gui.StartMission('Headhunter', 'Assassinate all targets before the time runs out.')

	local missionTimer = Timer.New()

	World.EnableWanted(true)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				Gui.DrawTimerBar('MISSION TIME', Settings.headhunter.time - missionTimer:elapsed(), 1)
				Gui.DrawBar('TARGETS REMAINING', #_targets, 2)
				Gui.DisplayObjectiveText('Assassinate the ~r~targets~w~.')
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			finishMission(false)
			return
		end

		if missionTimer:elapsed() >= Settings.headhunter.time then
			finishMission(false, 'Time is over.')
			return
		end

		local playerPosition = Player.Position()
		for i = #_targets, 1, -1 do
			local data = _targets[i]

			if IsPedDeadOrDying(data.ped) then
				Gui.DisplayPersonalNotification('You have assassinated a target.')
				removeTarget(i)
				table.remove(_targets, i)
			elseif not data.wasTaskActivated and World.GetDistance(playerPosition, data) < Settings.headhunter.taskActivateDistance then
				NetworkRegisterEntityAsNetworked(data.ped)
				SetNetworkIdExistsOnAllMachines(PedToNet(data.ped), true)

				if data.vehicle then
					NetworkRegisterEntityAsNetworked(data.vehicle)
					SetNetworkIdExistsOnAllMachines(VehToNet(data.vehicle), true)
					TaskVehicleDriveWander(data.ped, data.vehicle, 20., 319)
				else
					TaskWanderStandard(data.ped, 10., 10)
				end

				data.wasTaskActivated = true
			end
		end

		if #_targets == 0 then
			TriggerServerEvent('lsv:headhunterFinished', 0)
			return
		end
	end
end)
