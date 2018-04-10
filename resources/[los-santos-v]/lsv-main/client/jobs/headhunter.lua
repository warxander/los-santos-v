local targetBlip = nil


local function removeTargetBlip()
	if not targetBlip then return end
	RemoveBlip(targetBlip)
	targetBlip = nil
end


AddEventHandler('lsv:startHeadhunter', function()
	local target = Utils.GetRandom(Settings.headhunter.targets)

	Streaming.RequestModel(target.pedModel)

	local targetPedModelHash = GetHashKey(target.pedModel)
	local targetPed = CreatePed(11, targetPedModelHash, target.location.x, target.location.y, target.location.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	SetPedRelationshipGroupHash(targetPed, GetHashKey("HATES_PLAYER"))
	SetPedArmour(targetPed, 500)
	SetEntityHealth(targetPed, 500)
	GiveDelayedWeaponToPed(targetPed, GetHashKey(Utils.GetRandom(Settings.headhunter.weapons)), 25000, true)
	TaskWanderStandard(targetPed, 10.0, 10)

	SetModelAsNoLongerNeeded(targetPedModelHash)

	targetBlip = AddBlipForEntity(targetPed)
	SetBlipColour(targetBlip, Color.BlipRed())
	SetBlipHighDetail(targetBlip, true)
	SetBlipSprite(targetBlip, Blip.Target())
	SetBlipColour(targetBlip, Color.BlipRed())
	SetBlipRouteColour(targetBlip, Color.BlipRed())
	SetBlipRoute(targetBlip, true)

	Map.SetBlipFlashes(targetBlip)

	JobWatcher.StartJob('Headhunter')

	Gui.StartJob('You have started Headhunter. Assassinate the target and lose the cops.')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()
	local loseTheCopsStage = false

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if JobWatcher.IsJobInProgress(jobId) then Gui.DrawTimerBar(0.13, 'TIME LEFT', math.floor((Settings.headhunter.time - GetGameTimer() + eventStartTime) / 1000))
			else return end
		end
	end)

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.headhunter.time then
			local isTargetDead = IsEntityDead(targetPed)

			if isTargetDead then removeTargetBlip() end

			Gui.DisplayObjectiveText(isTargetDead and 'Lose the cops.' or 'Assassinate the ~r~target~w~.')

			if isTargetDead and not loseTheCopsStage then
				StartScreenEffect("SuccessTrevor", 0, false)
				World.SetWantedLevel(Settings.headhunter.wantedLevel)
				loseTheCopsStage = true
			end

			if loseTheCopsStage and IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:headhunterFinished', false)
				return
			end

			if loseTheCopsStage and GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerServerEvent('lsv:headhunterFinished')
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

	World.SetWantedLevel(0)

	Gui.FinishJob('Headhunter', success, reason, Settings.headhunter.reward)
end)