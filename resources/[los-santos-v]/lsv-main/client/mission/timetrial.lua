local _missionName = 'Time Trial'

local _markerRadius = 5.0
local _markerHeight = 2.0
local _markerScale = 2.0
local _markerColor = { r = Color.YELLOW.r, g = Color.YELLOW.g, b = Color.YELLOW.b, a = 72 }

local _checkpointRadius = 3.5
local _checkpointThreshold = 2.0
local _checkpointScale = 5.0
local _checkpointColor = { r = Color.BLUE.r, g = Color.BLUE.g, b = Color.BLUE.b, a = 228 }

local _trialRecords = { }
local _trialBlips = { }

local _trialId = nil
local _trialCheckpoint = nil

local function clearCheckpoint()
	if not _trialCheckpoint then
		return
	end

	DeleteCheckpoint(_trialCheckpoint.id)
	table.iforeach(_trialCheckpoint.blips, function(blip)
		RemoveBlip(blip)
	end)

	_trialCheckpoint = nil
end

local function createCheckpoint(index)
	local isFinish = index == #Settings.timeTrial.tracks[_trialId].checkpoints

	local checkpoint1 = Settings.timeTrial.tracks[_trialId].checkpoints[index]
	local checkpoint2 = isFinish and checkpoint1 or Settings.timeTrial.tracks[_trialId].checkpoints[index + 1]

	local blipSprite = isFinish and Blip.CREW_RACE_FINISH or Blip.STANDARD
	local blipColour = isFinish and Color.BLIP_WHITE or Color.BLIP_YELLOW

	_trialCheckpoint = { }
	_trialCheckpoint.id = CreateCheckpoint(isFinish and 19 or checkpoint1.type, checkpoint1.x, checkpoint1.y, checkpoint1.z + 3.0, checkpoint2.x, checkpoint2.y, checkpoint2.z, _checkpointScale, _checkpointColor.r, _checkpointColor.g, _checkpointColor.b, _checkpointColor.a)

	_trialCheckpoint.blips = { }
	local blip = Map.CreatePlaceBlip(blipSprite, checkpoint1.x, checkpoint1.y, checkpoint1.z, nil, blipColour)
	SetBlipAsShortRange(blip, false)
	table.insert(_trialCheckpoint.blips, blip)

	if not isFinish then
		local blip = Map.CreatePlaceBlip(blipSprite, checkpoint2.x, checkpoint2.y, checkpoint2.z, nil, Color.BLIP_YELLOW)
		SetBlipScale(blip, 0.65)
		SetBlipAsShortRange(blip, false)
		table.insert(_trialCheckpoint.blips, blip)
	end
end

local function updateCheckpoint(index)
	clearCheckpoint()
	createCheckpoint(index)
end

RegisterNetEvent('lsv:initTimeTrialRecords')
AddEventHandler('lsv:initTimeTrialRecords', function(records)
	_trialRecords = records
end)

RegisterNetEvent('lsv:updateTimeTrialRecord')
AddEventHandler('lsv:updateTimeTrialRecord', function(trialId, vehicleClass, data)
	_trialRecords[trialId][vehicleClass].records = data
end)

RegisterNetEvent('lsv:timeTrialFinished')
AddEventHandler('lsv:timeTrialFinished', function(success, reason, trialId, vehicleClass, trialTime)
	MissionManager.FinishMission(success)

	clearCheckpoint()

	if success then
		AnimpostfxPlay('SuccessMichael', 0, false)
	end

	-- If its a personal best, update local records
	if trialTime ~= nil then
		_trialRecords[trialId][vehicleClass].personalBest = trialTime
	end

	Gui.FinishMission(_missionName, success, reason)
end)

AddEventHandler('lsv:startTimeTrial', function(trialId, vehicleClassName)
	_trialId = trialId

	local startingPosition = Settings.timeTrial.tracks[trialId].position

	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	FreezeEntityPosition(vehicle, true)
	SetEntityCoords(vehicle, startingPosition.x, startingPosition.y, startingPosition.z)
	SetEntityHeading(vehicle, startingPosition.heading)

	local checkpoints = Settings.timeTrial.tracks[trialId].checkpoints

	local checkpointIndex = 1

	local wasTrialStarted = false
	local countdownScaleform = Scaleform.NewAsync('COUNTDOWN')
	local countdownMessages = { '3', '2', '1', 'GO' }
	local countdownTimer = Timer.New()

	local missionTimer = nil

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission or IsPlayerDead(PlayerId()) then
			TriggerEvent('lsv:timeTrialFinished', false)
			return
		end

		if not IsPedInAnyVehicle(PlayerPedId()) then
			TriggerEvent('lsv:timeTrialFinished', false, 'You have left the vehicle.')
			return
		end

		if not IsVehicleDriveable(GetVehiclePedIsIn(PlayerPedId())) then
			TriggerEvent('lsv:timeTrialFinished', false, 'A vehicle has been destroyed.')
			return
		end

		local playerPosition = Player.Position()
		if not wasTrialStarted and World.GetDistance(playerPosition, startingPosition, true) > _markerRadius then
			TriggerEvent('lsv:timeTrialFinished', false, 'You have left the starting position.')
			return
		end

		if not wasTrialStarted then
			if countdownTimer:elapsed() > 1000 then
				local isGo = #countdownMessages == 1
				local color = isGo and Color.RED or Color.WHITE

				PlaySoundFrontend(-1, isGo and 'GO' or '3_2_1', 'HUD_MINI_GAME_SOUNDSET', true)
				countdownScaleform:call('SET_MESSAGE', countdownMessages[1], color.r, color.g, color.b, false)

				if isGo then
					AnimpostfxPlay('SuccessMichael', 0, false)

					missionTimer = Timer.New()

					Citizen.CreateThread(function()
						while true do
							Citizen.Wait(0)

							if not MissionManager.Mission then
								return
							end

							if Player.IsActive() then
								-- Server record
								if _trialRecords[trialId][vehicleClassName].records[1] ~= nil then
									Gui.DrawTimerBar('SERVER RECORD', _trialRecords[trialId][vehicleClassName].records[1].time , 3, false, Color.WHITE, true)
								end

								-- Personal best
								if _trialRecords[trialId][vehicleClassName].personalBest ~= nil then
									Gui.DrawTimerBar('PERSONAL RECORD', _trialRecords[trialId][vehicleClassName].personalBest , 2, false, Color.GREY, true)
								end

								-- Current time elapsed
								Gui.DrawTimerBar('TIME', missionTimer:elapsed(), 1, false, Color.WHITE, true)
							end
						end
					end)

					countdownTimer:restart()
					FreezeEntityPosition(vehicle, false)
					updateCheckpoint(checkpointIndex)
					wasTrialStarted = true
				else
					table.remove(countdownMessages, 1)
					countdownTimer:restart()
				end
			end

			countdownScaleform:render(0.5, 0.25, 1.0, 1.0)
		else
			if countdownTimer:elapsed() < 1000 then
				countdownScaleform:render(0.5, 0.25, 1.0, 1.0)
			end

			Gui.DrawPlaceMarker(checkpoints[checkpointIndex], _markerColor, _checkpointRadius)

			if World.GetDistance(playerPosition, checkpoints[checkpointIndex], true) < _checkpointRadius + _checkpointThreshold then
				if checkpointIndex == #checkpoints then
					TriggerServerEvent('lsv:finishTimeTrial', _trialId, Settings.timeTrial.vehicleClassNames[GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) + 1], missionTimer:elapsed())
					return
				else
					PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', true)
					checkpointIndex = checkpointIndex + 1
					updateCheckpoint(checkpointIndex)
				end
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	table.foreach(Settings.timeTrial.tracks, function(track, id)
		_trialBlips[id] = Map.CreatePlaceBlip(Blip.TIME_TRIAL, track.position.x,  track.position.y,  track.position.z, _missionName, Color.BLIP_PURPLE)
	end)

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = Player.Position()

		table.foreach(Settings.timeTrial.tracks, function(track, trialId)
			SetBlipAlpha(_trialBlips[trialId], isPlayerInFreeroam and 255 or 0)

			if isPlayerInFreeroam then
				Gui.DrawPlaceMarker(track.position, Color.PURPLE, _markerRadius, _markerHeight)
				Gui.DrawMarker(36, { x = track.position.x, y = track.position.y, z = track.position.z + _markerHeight }, Color.PURPLE, _markerScale, nil, true)

				if World.GetDistance(playerPosition, track.position, true) < _markerRadius then
					if not WarMenu.IsMenuOpened() then
						local playerPed = PlayerPedId()
						if not IsPedInAnyVehicle(playerPed) or IsPedInAnyHeli(playerPed) or IsPedInAnyPlane(playerPed) then
							Gui.DisplayHelpText('You need to be in a suitable vehicle to start the Time Trial.')
						else
							local vehicleClassName = Settings.timeTrial.vehicleClassNames[GetVehicleClass(GetVehiclePedIsIn(playerPed)) + 1]

							Gui.DisplayHelpText('Press ~INPUT_TALK~ to start ~p~'..track.name..'~w~ '.._missionName)
							ScoreboardTT.DisplayThisFrame(track.name, vehicleClassName, _trialRecords[trialId][vehicleClassName])

							if IsControlJustReleased(0, 46) then
								MissionManager.StartMission('timeTrial', _missionName)
								TriggerEvent('lsv:startTimeTrial', trialId, vehicleClassName)
							end
						end
					end
				end
			end
		end)
	end
end)
