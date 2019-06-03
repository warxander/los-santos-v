local targetPed = nil
local targetBlip = nil
local targetAreaBlip = nil

local helpHandler = nil


local function removeTargetBlip()
	if not targetBlip then return end
	RemoveBlip(targetBlip)
	RemoveBlip(targetAreaBlip)
	targetBlip = nil
	targetAreaBlip = nil
end


AddEventHandler('lsv:startHeadhunter', function()
	local target = table.random(Settings.headhunter.targets)

	local eventStartTime = Timer.New()
	local loseTheCopsStage = false
	local loseTheCopsStageStartTime = nil
	local isTargetBlipHided = false
	local isTargetWandering = false
	local isInMissionArea = false
	local isTargetDead = false

	Streaming.RequestModel(target.pedModel, true)
	local targetPedModelHash = GetHashKey(target.pedModel)
	targetPed = CreatePed(26, targetPedModelHash, target.location.x, target.location.y, target.location.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	SetPedArmour(targetPed, 1500)
	SetEntityHealth(targetPed, 1500)
	GiveDelayedWeaponToPed(targetPed, GetHashKey(table.random(Settings.headhunter.weapons)), 25000, false)
	SetPedDropsWeaponsWhenDead(targetPed, false)
	SetPedHearingRange(targetPed, 1500.)
	SetPedSeeingRange(targetPed, 1500.)
	SetPedRelationshipGroupHash(targetPed, GetHashKey('HATES_PLAYER'))
	SetModelAsNoLongerNeeded(targetPedModelHash)

	targetBlip = AddBlipForCoord(target.location.x, target.location.y, target.location.z)
	SetBlipScale(targetBlip, 0.85)
	SetBlipColour(targetBlip, Color.BlipRed())
	SetBlipHighDetail(targetBlip, true)
	SetBlipColour(targetBlip, Color.BlipRed())
	SetBlipRouteColour(targetBlip, Color.BlipRed())
	SetBlipRoute(targetBlip, true)
	Map.SetBlipFlashes(targetBlip)

	targetAreaBlip = Map.CreateRadiusBlip(target.location.x, target.location.y, target.location.z, Settings.headhunter.radius, Color.BlipRed())

	Gui.StartMission('Headhunter', 'Find and assassinate the target.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			if isTargetDead then
				removeTargetBlip()

				if not loseTheCopsStage then
					World.SetWantedLevel(Settings.headhunter.wantedLevel)
					Gui.DisplayPersonalNotification('You have assassinated a target.')
					helpHandler = HelpQueue.PushFront('Lose the cops faster to get extra reward.')
					loseTheCopsStage = true
					loseTheCopsStageStartTime = GetGameTimer()					
				end
			else
				SetBlipAlpha(targetAreaBlip, isInMissionArea and 96 or 0)
				SetBlipAlpha(targetBlip, isInMissionArea and 0 or 255)
			end

			if isInMissionArea and not isTargetBlipHided then
				SetBlipRoute(targetBlip, false)
				isTargetBlipHided = true
				helpHandler = HelpQueue.PushFront('Use distance meter at the bottom right corner to locate the target.')
			end	

			if Player.IsActive() then
				local missionText = isInMissionArea and 'Find and assassinate the ~r~target~w~.' or 'Go to the ~r~marked area~w~.'
				if isTargetDead then missionText = 'Lose the cops.' end
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

		if eventStartTime:Elapsed() < Settings.headhunter.time then
			Gui.DrawTimerBar('MISSION TIME', Settings.headhunter.time - eventStartTime:Elapsed())

			isTargetDead = IsEntityDead(targetPed)
			isInMissionArea = Player.DistanceTo(target.location) < Settings.headhunter.radius

			if not isTargetWandering then
				if not IsEntityWaitingForWorldCollision(targetPed) and HasCollisionLoadedAroundEntity(targetPed) then
					TaskWanderStandard(targetPed, 10., 10)
					isTargetWandering = true
				end
			end

			if not isTargetDead then
				local targetPosition = GetEntityCoords(targetPed, true)
				if GetDistanceBetweenCoords(targetPosition.x, targetPosition.y, targetPosition.z, target.location.x, target.location.y, target.location.z, false) > Settings.headhunter.radius then
					TriggerEvent('lsv:headhunterFinished', false, 'Target has left the area.')
					return
				elseif isInMissionArea and Player.IsActive() then
					Gui.DrawProgressBar('TARGET DISTANCE', 1.0 - Player.DistanceTo(targetPosition) / Settings.headhunter.radius, Color.GetHudFromBlipColor(Color.BlipRed()))
				end
			end

			if loseTheCopsStage and IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:headhunterFinished', false)
				return
			end

			if loseTheCopsStage and GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerServerEvent('lsv:headhunterFinished', eventStartTime._startTime, loseTheCopsStageStartTime, GetGameTimer())
				return
			end
		else
			TriggerEvent('lsv:headhunterFinished', false, 'Time is over.')
			return
		end
	end
end)


RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(success, reason)
	if helpHandler then helpHandler:Cancel() end

	MissionManager.FinishMission(success)

	World.SetWantedLevel(0)
	if DoesEntityExist(targetPed) then RemovePedElegantly(targetPed) end

	removeTargetBlip()

	Gui.FinishMission('Headhunter', success, reason)
end)