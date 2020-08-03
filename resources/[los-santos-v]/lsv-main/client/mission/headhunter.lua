local _targets = nil

local function createTargetBlip(ped)
	local blip = AddBlipForEntity(ped)

	SetBlipSprite(blip, Blip.HEADHUNTER_TARGET)
	SetBlipColour(blip, Color.BLIP_RED)
	SetBlipAsShortRange(blip, false)
	Map.SetBlipText(blip, 'Target')
	Map.SetBlipFlashes(blip)

	return blip
end

local function removeTarget(index)
	local data = _targets[index]

	RemoveBlip(data.blip)

	if data.pedNet then
		Network.DeletePed(data.pedNet, 5000)
	end

	if data.vehicleNet then
		Network.DeleteVehicle(data.vehicleNet, 5000)
	end
end

AddEventHandler('lsv:finishHeadhunter', function(success, reason)
	local targetsLeft = #_targets

	if success or targetsLeft < Settings.headhunter.count then
		TriggerServerEvent('lsv:finishHeadhunter', Settings.headhunter.count - targetsLeft)
	else
		TriggerEvent('lsv:headhunterFinished', false, reason or '')
	end

	World.EnableWanted(false)

	table.iforeach(_targets, function(_, index)
		removeTarget(index)
	end)
	_targets = nil
end)

RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(success, reason)
	if not MissionManager.Mission then
		return
	end

	MissionManager.FinishMission(success)
	Gui.FinishMission('Headhunter', success, reason)
end)

AddEventHandler('lsv:startHeadhunter', function()
	_targets = table.irandom_n(Settings.headhunter.locations, Settings.headhunter.count)

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

	table.iforeach(_targets, function(target)
		target.blip = Map.CreatePlaceBlip(Blip.HEADHUNTER_TARGET, target.x, target.y, target.z, 'Target', Color.BLIP_RED)
		SetBlipAsShortRange(target.blip, false)
		Map.SetBlipFlashes(target.blip)
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			return
		end

		if missionTimer:elapsed() >= Settings.headhunter.time then
			TriggerEvent('lsv:finishHeadhunter', false, 'Time is over.')
			return
		end

		local playerPosition = Player.Position()
		for i = #_targets, 1, -1 do
			local data = _targets[i]

			if not data.pedNet then
				if World.GetDistance(playerPosition, data, true) < Settings.worldModifierDistance then
					if data.inVehicle then
						if not data.vehicleNet then
							data.vehicleNet = Network.CreateVehicleAsync(table.random(Settings.headhunter.vehicles), data, data.heading)
						elseif NetworkDoesNetworkIdExist(data.vehicleNet) then
							data.pedNet = Network.CreatePedInsideVehicleAsync(data.vehicleNet, 11, table.random(Settings.headhunter.models), -1)
						end
					else
						data.pedNet = Network.CreatePedAsync(11, table.random(Settings.headhunter.models), data)
					end
				end
			end

			if data.pedNet and NetworkDoesNetworkIdExist(data.pedNet) and (not data.inVehicle or NetworkDoesNetworkIdExist(data.vehicleNet)) then
				local ped = NetToPed(data.pedNet)

				if not data.active then
					-- Blips
					RemoveBlip(data.blip)
					data.blip = nil

					-- Target ped
					SetPedRandomComponentVariation(ped, false)

					local weaponHash = data.inVehicle and `WEAPON_MINISMG` or table.random(Settings.headhunter.weapons)
					GiveWeaponToPed(ped, weaponHash, 99999, false)
					SetPedInfiniteAmmo(ped, true, weaponHash)

					SetEntityHealth(ped, 200)
					SetPedArmour(ped, 100)
					SetPedDropsWeaponsWhenDead(ped, false)
					SetPedFleeAttributes(ped, 0, false)
					SetRagdollBlockingFlags(ped, 1)
					SetPedCombatRange(ped, 2)
					SetPedCombatMovement(ped, 2)
					SetPedCombatAttributes(ped, 46, true)
					SetPedCombatAttributes(ped, 20, true)
					SetPedCombatAbility(ped, 2)
					SetPedAsEnemy(ped, true)
					SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)

					if data.inVehicle then
						SetPedCombatAttributes(ped, 3, false)
						SetPedCombatAttributes(ped, 52, true)
					end

					-- Vehicle
					if data.inVehicle then
						local vehicle = NetToVeh(data.vehicleNet)
						SetVehicleDoorsLockedForAllPlayers(vehicle, true)
						SetVehicleModKit(vehicle, 0)
						SetVehicleMod(vehicle, 16, 4)
						SetVehicleTyresCanBurst(vehicle, false)
					end

					-- Brain
					if data.inVehicle then
						TaskVehicleDriveWander(ped, NetToVeh(data.vehicleNet), 20., 319)
					else
						TaskWanderStandard(ped, 10., 10)
					end

					-- Mark as activated
					data.active = true
				else
					if not data.blip then
						data.blip = createTargetBlip(ped)
					end

					if IsPedDeadOrDying(ped) then
						Gui.DisplayPersonalNotification('You have assassinated a target.')
						removeTarget(i)
						table.remove(_targets, i)
					end
				end
			end
		end

		if #_targets == 0 then
			TriggerEvent('lsv:finishHeadhunter', true)
			return
		end
	end
end)
