local targetPed = nil
local targetBlip = nil
local targetAreaBlip = nil


local function removeTargetBlip()
	if not targetBlip then return end
	RemoveBlip(targetBlip)
	RemoveBlip(targetAreaBlip)
	targetBlip = nil
	targetAreaBlip = nil
end


AddEventHandler('lsv:startHeadhunter', function()
	local target = Utils.GetRandom(Settings.headhunter.targets)

	Streaming.RequestModel(target.pedModel)

	targetBlip = AddBlipForCoord(target.location.x, target.location.y, target.location.z)
	SetBlipColour(targetBlip, Color.BlipRed())
	SetBlipHighDetail(targetBlip, true)
	SetBlipColour(targetBlip, Color.BlipRed())

	targetAreaBlip = Map.CreateRadiusBlip(target.location.x, target.location.y, target.location.z, Settings.headhunter.radius, Color.BlipRed())

	local targetPedModelHash = GetHashKey(target.pedModel)
	targetPed = CreatePed(26, targetPedModelHash, target.location.x, target.location.y, target.location.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	SetPedArmour(targetPed, 1500)
	SetEntityHealth(targetPed, 1500)
	GiveDelayedWeaponToPed(targetPed, GetHashKey(Utils.GetRandom(Settings.headhunter.weapons)), 25000, false)
	SetPedDropsWeaponsWhenDead(targetPed, false)
	SetModelAsNoLongerNeeded(targetPedModelHash)

	JobWatcher.StartJob('Headhunter')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()
	local loseTheCopsStage = false
	local loseTheCopsStageStartTime = nil
	local isTargetBlipHided = false
	local isTargetWandering = false

	Citizen.CreateThread(function()
		Gui.StartJob(jobId, 'Headhunter', 'Find and assassinate the target.')

		while true do
			Citizen.Wait(0)

			if JobWatcher.IsJobInProgress(jobId) then Gui.DrawTimerBar('MISSION TIME', math.floor((Settings.headhunter.time - GetGameTimer() + eventStartTime) / 1000))
			else return end
		end
	end)

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.headhunter.time then
			local isTargetDead = IsEntityDead(targetPed)
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			local isInJobArea = GetDistanceBetweenCoords(playerX, playerY, playerZ, target.location.x, target.location.y, target.location.z, false) < Settings.headhunter.radius

			if not isTargetWandering then
				if not IsEntityWaitingForWorldCollision(targetPed) and HasCollisionLoadedAroundEntity(targetPed) then
					TaskWanderStandard(targetPed, 10., 10)
					isTargetWandering = true
				end
			end

			if isInJobArea and not isTargetBlipHided then
				isTargetBlipHided = true
				SetTimeout(1000, function() Gui.DisplayHelpText('Use distance meter at the bottom right corner to locate the target.') end)
			end

			if isTargetDead then
				removeTargetBlip()
			else
				local targetX, targetY, targetZ = table.unpack(GetEntityCoords(targetPed, true))
				if GetDistanceBetweenCoords(targetX, targetY, targetZ, target.location.x, target.location.y, target.location.z, false) > Settings.headhunter.radius then
					TriggerEvent('lsv:headhunterFinished', false, 'Target has left the area.')
					return
				elseif isInJobArea and not IsPlayerDead(PlayerId()) then
					Gui.DrawProgressBar('DISTANCE', 1.0 - GetDistanceBetweenCoords(targetX, targetY, targetZ, playerX, playerY, playerZ, false) / Settings.headhunter.radius, Color.GetHudFromBlipColor(Color.BlipRed()), 2)
				end

				SetBlipAlpha(targetAreaBlip, isInJobArea and 96 or 0)
				SetBlipAlpha(targetBlip, isInJobArea and 0 or 255)
			end

			local missionText = isInJobArea and 'Find and assassinate the ~r~target~w~.' or 'Go to the ~r~marked area~w~.'
			if isTargetDead then missionText = 'Lose the cops.' end

			Gui.DisplayObjectiveText(missionText)

			if isTargetDead and not loseTheCopsStage then
				StartScreenEffect("SuccessTrevor", 0, false)
				World.SetWantedLevel(Settings.headhunter.wantedLevel)
				SetTimeout(1000, function() Gui.DisplayHelpText('Lose the cops faster to get extra cash.') end)
				loseTheCopsStage = true
				loseTheCopsStageStartTime = GetGameTimer()
			end

			if loseTheCopsStage and IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:headhunterFinished', false)
				return
			end

			if loseTheCopsStage and GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerServerEvent('lsv:headhunterFinished', eventStartTime, loseTheCopsStageStartTime, GetGameTimer())
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
	JobWatcher.FinishJob('Headhunter')

	removeTargetBlip()
	if DoesEntityExist(targetPed) then RemovePedElegantly(targetPed) end

	World.SetWantedLevel(0)

	Gui.FinishJob('Headhunter', success, reason)
end)
