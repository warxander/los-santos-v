local _target = nil
local _targetsKilled = nil

local function removeTarget()
	if not _target then
		return
	end

	if _target.blip then
		RemoveBlip(_target.blip)
	end

	if _target.pedNet then
		Network.DeletePed(_target.pedNet, 5000)
	end

	if _target.vehicleNet then
		Network.DeleteVehicle(_target.vehicleNet, 5000)
	end

	_target = nil
end

AddEventHandler('lsv:finishHeadhunter', function(success, reason)
	if success or _targetsKilled > 0 then
		TriggerServerEvent('lsv:finishHeadhunter', _targetsKilled)
	else
		TriggerEvent('lsv:headhunterFinished', false, reason or '')
	end
end)

RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	removeTarget()
	_targetsKilled = nil

	Gui.FinishMission('Headhunter', success, reason)
end)

AddEventHandler('lsv:startHeadhunter', function()
	Gui.StartMission('Headhunter', 'Survive and assassinate as much targets as possible.')

	_targetsKilled = 0

	World.EnableWanted(true)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				Gui.DrawBar('REWARD MULTIPLIER', 'x'..tostring(1 + (math.floor(_targetsKilled / Settings.headhunter.minTargetCount) * Settings.headhunter.rewardMultiplier)), 3)
				Gui.DrawBar('MISSION REWARD', '$'..tostring(_targetsKilled * Settings.headhunter.reward.cash), 2)
				Gui.DrawBar('TARGETS KILLED', _targetsKilled, 1)
				Gui.DisplayObjectiveText('Survive and assassinate the ~r~targets~w~.')
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			return
		end

		if IsPlayerDead(PlayerId()) then
			TriggerEvent('lsv:finishHeadhunter', false)
			return
		end

		if not _target then
			_target = table.random(Settings.headhunter.locations)

			_target.blip = Map.CreatePlaceBlip(Blip.HEADHUNTER_TARGET, _target.x, _target.y, _target.z, 'Target', Color.BLIP_RED)
			SetBlipAsShortRange(_target.blip, false)
			Map.SetBlipFlashes(_target.blip)

			_target.pedModel = table.random(Settings.headhunter.models)
			if _target.inVehicle then
				_target.vehicleModel = table.random(Settings.headhunter.vehicles)
			end
		end

		if _target then
			if not _target.pedNet then
				if Player.DistanceTo(_target, true) < Settings.worldModifierDistance then
					if _target.inVehicle then
						if not _target.vehicleNet and Streaming.RequestModel(_target.vehicleModel) then
							_target.vehicleNet = Network.CreateVehicle(_target.vehicleModel, _target, _target.heading)
						elseif Streaming.RequestModel(_target.pedModel) and NetworkDoesEntityExistWithNetworkId(_target.vehicleNet) and Network.RequestEntityControl(_target.vehicleNet) then
							_target.pedNet = Network.CreatePedInsideVehicle(_target.vehicleNet, 11, _target.pedModel, -1)
						end
					elseif Streaming.RequestModel(_target.pedModel) then
						_target.pedNet = Network.CreatePed(11, _target.pedModel, _target)
					end
				end
			end

			if _target.pedNet and NetworkDoesEntityExistWithNetworkId(_target.pedNet) and (not _target.inVehicle or NetworkDoesEntityExistWithNetworkId(_target.vehicleNet)) then
				local ped = NetToPed(_target.pedNet)

				if not _target.active and Network.RequestEntityControl(_target.pedNet) then
					-- Blips
					RemoveBlip(_target.blip)
					_target.blip = nil

					-- Target ped
					SetPedRandomComponentVariation(ped, false)

					local weaponHash = _target.inVehicle and `WEAPON_MINISMG` or table.random(Settings.headhunter.weapons)
					GiveWeaponToPed(ped, weaponHash, 99999, false)
					SetPedInfiniteAmmo(ped, true, weaponHash)

					SetEntityHealth(ped, 200)
					SetPedArmour(ped, 100)
					SetEntityLoadCollisionFlag(ped, true)
					SetPedDropsWeaponsWhenDead(ped, false)
					SetPedFleeAttributes(ped, 0, false)
					SetRagdollBlockingFlags(ped, 1)
					SetPedSuffersCriticalHits(ped, false)
					SetPedCombatRange(ped, 2)
					SetPedCombatMovement(ped, 2)
					SetPedCombatAttributes(ped, 46, true)
					SetPedCombatAttributes(ped, 20, true)
					SetPedCombatAbility(ped, 2)
					SetPedAsEnemy(ped, true)
					SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)

					if _target.inVehicle then
						SetPedCombatAttributes(ped, 3, false)
						SetPedCombatAttributes(ped, 52, true)
					end

					-- Vehicle
					if _target.inVehicle then
						local vehicle = NetToVeh(_target.vehicleNet)
						SetVehicleDoorsLockedForAllPlayers(vehicle, true)
						SetVehicleModKit(vehicle, 0)
						SetVehicleMod(vehicle, 16, 4)
						SetVehicleTyresCanBurst(vehicle, false)
						SetEntityLoadCollisionFlag(vehicle, true)
					end

					-- Brain
					if _target.inVehicle then
						TaskVehicleDriveWander(ped, NetToVeh(_target.vehicleNet), 20., 319)
					else
						TaskWanderStandard(ped, 10., 10)
					end

					-- Mark as activated
					_target.active = true
				else
					if not _target.blip then
						_target.blip = Map.CreateEntityBlip(ped, Blip.HEADHUNTER_TARGET, 'Target', Color.BLIP_RED)
						Map.SetBlipFlashes(_target.blip)
					end

					if IsEntityDead(ped) then
						Gui.DisplayPersonalNotification('You have assassinated a target.')
						_targetsKilled = _targetsKilled + 1
						removeTarget()
					end
				end
			end
		end
	end
end)
