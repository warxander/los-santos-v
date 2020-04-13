local _targetPed = nil
local _targetBlip = nil
local _targetAreaBlip = nil

local _helpHandler = nil

local function removeTargetBlip()
	if not _targetBlip then
		return
	end

	RemoveBlip(_targetBlip)
	RemoveBlip(_targetAreaBlip)
	_targetBlip = nil
	_targetAreaBlip = nil
end

RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(success, reason)
	if _helpHandler then
		_helpHandler:cancel()
	end

	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	if DoesEntityExist(_targetPed) then
		RemovePedElegantly(_targetPed)
	end

	removeTargetBlip()

	Gui.FinishMission('Headhunter', success, reason)
end)

AddEventHandler('lsv:startHeadhunter', function()
	local target = table.random(Settings.headhunter.targets)

	local missionTimer = Timer.New()
	local loseTheCopsStage = false
	local loseTheCopsStageStartTime = nil
	local isTargetBlipHided = false
	local isTargetWandering = false
	local isInMissionArea = false
	local isTargetDead = false

	Streaming.RequestModelAsync(target.pedModel)
	local targetPedModelHash = GetHashKey(target.pedModel)
	_targetPed = CreatePed(26, targetPedModelHash, target.location.x, target.location.y, target.location.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	SetPedArmour(_targetPed, 5000)
	SetEntityHealth(_targetPed, 5000)
	GiveDelayedWeaponToPed(_targetPed, GetHashKey(table.random(Settings.headhunter.weapons)), 25000, false)
	SetPedDropsWeaponsWhenDead(_targetPed, false)
	SetPedHearingRange(_targetPed, 1500.)
	SetPedSeeingRange(_targetPed, 1500.)
	SetPedRelationshipGroupHash(_targetPed, `HATES_PLAYER`)
	SetModelAsNoLongerNeeded(targetPedModelHash)

	_targetBlip = AddBlipForCoord(target.location.x, target.location.y, target.location.z)
	SetBlipScale(_targetBlip, 0.85)
	SetBlipColour(_targetBlip, Color.BLIP_RED)
	SetBlipHighDetail(_targetBlip, true)
	SetBlipColour(_targetBlip, Color.BLIP_RED)
	SetBlipRouteColour(_targetBlip, Color.BLIP_RED)
	SetBlipRoute(_targetBlip, true)
	Map.SetBlipFlashes(_targetBlip)

	_targetAreaBlip = Map.CreateRadiusBlip(target.location.x, target.location.y, target.location.z, Settings.headhunter.radius, Color.BLIP_RED)

	Gui.StartMission('Headhunter', 'Find and assassinate the target.')

	World.EnableWanted(true)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if isTargetDead then
				removeTargetBlip()

				if not loseTheCopsStage then
					World.SetWantedLevel(Settings.headhunter.wantedLevel)
					Gui.DisplayPersonalNotification('You have assassinated a target.')
					_helpHandler = HelpQueue.PushFront('Lose the cops faster to get extra reward.')
					loseTheCopsStage = true
					loseTheCopsStageStartTime = GetGameTimer()
				end
			else
				SetBlipAlpha(_targetAreaBlip, isInMissionArea and 96 or 0)
				SetBlipAlpha(_targetBlip, isInMissionArea and 0 or 255)
			end

			if isInMissionArea and not isTargetBlipHided then
				SetBlipRoute(_targetBlip, false)
				isTargetBlipHided = true
				_helpHandler = HelpQueue.PushFront('Use distance meter at the bottom right corner to locate the target.')
			end

			if Player.IsActive() then
				local missionText = isInMissionArea and 'Find and assassinate the ~r~target~w~.' or 'Go to the ~r~marked area~w~.'
				if isTargetDead then
					missionText = 'Lose the cops.'
				end
				Gui.DisplayObjectiveText(missionText)
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:headhunterFinished', false)
			return
		end

		if missionTimer:elapsed() < Settings.headhunter.time then
			Gui.DrawTimerBar('MISSION TIME', Settings.headhunter.time - missionTimer:elapsed(), 1)

			isTargetDead = IsEntityDead(_targetPed)
			isInMissionArea = Player.DistanceTo(target.location) < Settings.headhunter.radius

			if not isTargetWandering then
				if not IsEntityWaitingForWorldCollision(_targetPed) and HasCollisionLoadedAroundEntity(_targetPed) then
					TaskWanderStandard(_targetPed, 10., 10)
					isTargetWandering = true
				end
			end

			if not isTargetDead then
				local targetPosition = GetEntityCoords(_targetPed, true)
				if GetDistanceBetweenCoords(targetPosition.x, targetPosition.y, targetPosition.z, target.location.x, target.location.y, target.location.z, false) > Settings.headhunter.radius then
					TriggerEvent('lsv:headhunterFinished', false, 'Target has left the area.')
					return
				elseif isInMissionArea and Player.IsActive() then
					Gui.DrawProgressBar('TARGET DISTANCE', 1.0 - Player.DistanceTo(targetPosition) / Settings.headhunter.radius, 2, Color.RED)
				end
			end

			if loseTheCopsStage and IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:headhunterFinished', false)
				return
			end

			if loseTheCopsStage and GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerServerEvent('lsv:headhunterFinished', missionTimer._startTime, loseTheCopsStageStartTime, GetGameTimer())
				return
			end
		else
			TriggerEvent('lsv:headhunterFinished', false, 'Time is over.')
			return
		end
	end
end)
