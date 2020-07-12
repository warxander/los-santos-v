local _vehicle = nil
local _vehicleNet = nil
local _vehicleBlip = nil
local _detonationSound = nil

local _helpHandler = nil

RegisterNetEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function(success, reason)
	if _helpHandler then
		_helpHandler:cancel()
	end

	MissionManager.FinishMission(success)

	if not HasSoundFinished(_detonationSound) then
		StopSound(_detonationSound)
	end
	ReleaseSoundId(_detonationSound)
	_detonationSound = nil

	if _vehicleNet then
		_vehicle = NetToVeh(_vehicleNet)
	end

	if not success and not IsPedInVehicle(PlayerPedId(), _vehicle, false) then
		if _vehicleNet then
			_vehicle = NetToVeh(_vehicleNet)
			SetVehicleDoorsLockedForAllPlayers(_vehicle, true)
			Network.DeleteVehicle(_vehicleNet, 5000)
		else
			World.DeleteEntity(_vehicle)
		end
	end
	_vehicle = nil
	_vehicleNet = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	Gui.FinishMission('Velocity', success, reason)
end)

AddEventHandler('lsv:startVelocity', function()
	local location = table.random(Settings.velocity.locations)

	Streaming.RequestModelAsync(`voltic2`)
	_vehicle = CreateVehicle(`voltic2`, location.x, location.y, location.z, location.heading, false, true)
	SetVehicleModKit(_vehicle, 0)
	SetVehicleMod(_vehicle, 16, 4)
	SetVehicleTyresCanBurst(_vehicle, false)
	SetModelAsNoLongerNeeded(`voltic2`)

	_detonationSound = GetSoundId()

	local isInVehicle = false
	local preparationStage = nil
	local detonationStage = nil

	local missionTimer = GetGameTimer()
	local startTimeToDetonate = GetGameTimer()
	local startPreparationStageTime = GetGameTimer()
	local almostDetonated = 0

	_vehicleBlip = AddBlipForEntity(_vehicle)
	SetBlipHighDetail(_vehicleBlip, true)
	SetBlipSprite(_vehicleBlip, Blip.ROCKET_VOLTIC)
	SetBlipColour(_vehicleBlip, Color.BLIP_GREEN)
	SetBlipRouteColour(_vehicleBlip, Color.BLIP_GREEN)
	SetBlipRoute(_vehicleBlip, true)
	Map.SetBlipFlashes(_vehicleBlip)

	Gui.StartMission('Velocity', 'Enter the Rocket Voltic and stay at the top speed to avoid detonation.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			SetBlipAlpha(_vehicleBlip, isInVehicle and 0 or 255)

			if Player.IsActive() then
				local totalTime = Settings.velocity.enterVehicleTime

				if preparationStage then
					totalTime = Settings.velocity.preparationTime
				elseif isInVehicle then
					totalTime = Settings.velocity.driveTime
				end

				if isInVehicle then
					if _vehicleNet then
						_vehicle = NetToVeh(_vehicleNet)
					end

					Gui.DrawBar('SPEED', string.to_speed(GetEntitySpeed(_vehicle)), 2)

					if detonationStage then
						Gui.DrawProgressBar('DETONATING', 1.0 - (Settings.velocity.detonationTime - GetGameTimer() + startTimeToDetonate) / Settings.velocity.detonationTime, 3, Color.RED)
					end
				end

				local title = preparationStage and 'BOMB ACTIVE IN' or 'MISSION TIME'
				local startTime = preparationStage and startPreparationStageTime or missionTimer
				local timeLeft = totalTime - GetGameTimer() + startTime

				Gui.DrawTimerBar(title, timeLeft, 1)

				Gui.DisplayObjectiveText(isInVehicle and 'Stay above '..string.to_speed(Settings.velocity.minSpeed)..' to avoid detonation.' or 'Enter the ~g~Rocket Voltic~w~.')
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:velocityFinished', false)
			return
		end

		if not DoesEntityExist(_vehicle) or not IsVehicleDriveable(_vehicle, false) then
			TriggerEvent('lsv:velocityFinished', false, 'A vehicle has been destroyed.')
			return
		end

		if _vehicleNet then
			_vehicle = NetToVeh(_vehicleNet)
		end

		isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)
		if isInVehicle then
			if not _vehicleNet then
				_vehicleNet = Network.RegisterVehicle(_vehicle)
			else
				if preparationStage == nil then
					preparationStage = true
					startPreparationStageTime = GetGameTimer()
				elseif preparationStage then
					if GetTimeDifference(GetGameTimer(), startPreparationStageTime) >= Settings.velocity.preparationTime then
						preparationStage = false
						missionTimer = GetGameTimer()
						_helpHandler = HelpQueue.PushFront('Avoid almost detonated state to get extra reward.')
					end
				elseif GetTimeDifference(GetGameTimer(), missionTimer) < Settings.velocity.driveTime then
					local vehicleSpeed = GetEntitySpeed(_vehicle)

					if vehicleSpeed < Settings.velocity.minSpeed then
						if not detonationStage then
							detonationStage = true
							startTimeToDetonate = GetGameTimer()
							TriggerServerEvent('lsv:velocityAboutToDetonate')
							almostDetonated = almostDetonated + 1
							PlaySoundFrontend(_detonationSound, '5s_To_Event_Start_Countdown', 'GTAO_FM_Events_Soundset', false)
						end

						if GetTimeDifference(GetGameTimer(), startTimeToDetonate) >= Settings.velocity.detonationTime then
							NetworkExplodeVehicle(_vehicle, true, false, false)
							Network.DeleteVehicle(_vehicleNet, 5000)

							TriggerEvent('lsv:velocityFinished', false, 'The bomb has detonated.')
							return
						end
					elseif detonationStage then
						if not HasSoundFinished(_detonationSound) then StopSound(_detonationSound) end
						detonationStage = false
					end
				else
					TriggerServerEvent('lsv:velocityFinished')
					return
				end
			end
		else
			if _vehicleNet then
				TriggerEvent('lsv:velocityFinished', false, 'You have left the vehicle.')
				return
			end

			if GetTimeDifference(GetGameTimer(), missionTimer) >= Settings.velocity.enterVehicleTime then
				TriggerEvent('lsv:velocityFinished', false, 'Time is over.')
				return
			end
		end
	end
end)
