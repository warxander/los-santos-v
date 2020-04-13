local _vehicle = nil
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

	if not success and not IsPedInVehicle(PlayerPedId(), _vehicle, false) then
		SetEntityAsMissionEntity(_vehicle, true, true)
		DeleteVehicle(_vehicle)
	end
	_vehicle = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	Gui.FinishMission('Velocity', success, reason)
end)

AddEventHandler('lsv:startVelocity', function()
	local location = table.random(Settings.velocity.locations)

	Streaming.RequestModelAsync('voltic2')
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
				if preparationStage then totalTime = Settings.velocity.preparationTime
				elseif detonationStage then totalTime = Settings.velocity.detonationTime
				elseif isInVehicle and not preparationStage then totalTime = Settings.velocity.driveTime end

				local title = 'MISSION TIME'
				if preparationStage then title = 'BOMB ACTIVE IN'
				elseif detonationStage then title = 'DETONATING' end

				local startTime = missionTimer
				if detonationStage then
					startTime = startTimeToDetonate
				elseif preparationStage then
					startTime = startPreparationStageTime
				end

				if isInVehicle then
					local speed = math.floor(GetEntitySpeed(_vehicle) * 2.236936) --mph
					Gui.DrawBar('SPEED', string.format('%d MPH', speed), 1)
				end

				local timeLeft = totalTime - GetGameTimer() + startTime
				if detonationStage then
					Gui.DrawProgressBar(title, 1.0 - timeLeft / Settings.velocity.detonationTime, 2, Color.RED)
				else
					Gui.DrawTimerBar(title, timeLeft, 2)
				end

				Gui.DisplayObjectiveText(isInVehicle and 'Stay above '..Settings.velocity.minSpeed..' mph to avoid detonation.' or 'Enter the ~g~Rocket Voltic~w~.')
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
			TriggerEvent('lsv:velocityFinished', false, 'A _vehicle has been destroyed.')
			return
		end

		isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)
		if isInVehicle then
			if not NetworkGetEntityIsNetworked(_vehicle) then NetworkRegisterEntityAsNetworked(_vehicle) end

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
				local vehicleSpeedMph = math.floor(GetEntitySpeed(_vehicle) * 2.236936) -- https://runtime.fivem.net/doc/reference.html#_0xD5037BA82E12416F

				if vehicleSpeedMph < Settings.velocity.minSpeed then
					if not detonationStage then
						detonationStage = true
						startTimeToDetonate = GetGameTimer()
						TriggerServerEvent('lsv:velocityAboutToDetonate')
						almostDetonated = almostDetonated + 1
						PlaySoundFrontend(_detonationSound, '5s_To_Event_Start_Countdown', 'GTAO_FM_Events_Soundset', false)
					end

					if GetTimeDifference(GetGameTimer(), startTimeToDetonate) >= Settings.velocity.detonationTime then
						local vehicleNetId = NetworkGetNetworkIdFromEntity(_vehicle)
						NetworkRequestControlOfNetworkId(vehicleNetId)
						while not NetworkHasControlOfNetworkId(vehicleNetId) do
							Citizen.Wait(0)
						end

						NetworkExplodeVehicle(_vehicle, true, false, false)

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
		elseif GetTimeDifference(GetGameTimer(), missionTimer) >= Settings.velocity.enterVehicleTime then
			TriggerEvent('lsv:velocityFinished', false, 'Time is over.')
			return
		end
	end
end)
