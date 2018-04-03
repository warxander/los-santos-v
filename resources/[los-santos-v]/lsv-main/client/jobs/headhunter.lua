local targetBlip = nil


local function removeTargetBlip()
	if not targetBlip then return end
	RemoveBlip(targetBlip)
	targetBlip = nil
end


AddEventHandler('lsv:startHeadhunter', function()
	local target = Settings.headhunter.targets[GetRandomIntInRange(1, Utils.GetTableLength(Settings.headhunter.targets) + 1)]

	Streaming.RequestModel(target.pedModel)

	local targetPedModelHash = GetHashKey(target.pedModel)
	local targetPed = CreatePed(11, targetPedModelHash, target.location.x, target.location.y, target.location.z, GetRandomFloatInRange(0.0, 360.0), true, true)
	SetPedRelationshipGroupHash(targetPed, GetHashKey("HATES_PLAYER"))
	SetPedArmour(targetPed, 500)
	SetEntityHealth(targetPed, 500)
	GiveDelayedWeaponToPed(targetPed, GetHashKey(Settings.headhunter.weapons[GetRandomIntInRange(1, Utils.GetTableLength(Settings.headhunter.weapons) + 1)]), 25000, true)
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

	Player.StartJob('Headhunter')

	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayNotification('You have started Headhunter. Assassinate the target and lose the cops.')

	local eventStartTime = GetGameTimer()
	local loseTheCopsStage = false

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if Player.isJobInProgress then Gui.DrawTimerBar(0.13, 'TIME LEFT', math.floor((Settings.headhunter.time - GetGameTimer() + eventStartTime) / 1000))
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
	Player.FinishJob('Headhunter')

	removeTargetBlip()

	World.SetWantedLevel(0)

	StartScreenEffect("SuccessMichael", 0, false)

	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true) end

	local status = success and 'COMPLETED' or 'FAILED'
	local message = success and '+'..Settings.headhunter.reward..' RP' or reason or ''

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'HEADHUNTER '..status, message)
	scaleform:RenderFullscreenTimed(5000)

	scaleform:Delete()
end)