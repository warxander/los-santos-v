local blip = nil

AddEventHandler('lsv:distractCops', function()
	Player.isEventInProgress = true

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('Distract the cops in the area marked by blue circle.')

	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	blip = Map.CreateRadiusBlip(x, y, z, Settings.distractCopsRadius, Color.BlipBlue())

	Citizen.Wait(5000)

	StartScreenEffect("SuccessMichael", 0, false)

	World.SetWantedLevel(2)

	local eventStartTime = GetGameTimer()

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.distractCopsTime then
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

			if IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:distractCopsFinished', false)
				return
			end

			if GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerEvent('lsv:distractCopsFinished', false, 'You lose the cops.')
				return
			end

			if GetDistanceBetweenCoords(playerX, playerY, playerZ, x, y, z, false) > Settings.distractCopsRadius then
				TriggerEvent('lsv:distractCopsFinished', false, 'You left the event area.')
				return
			end

			local passedTime = GetGameTimer() - eventStartTime
			local secondsLeft = math.floor((Settings.distractCopsTime - passedTime) / 1000)
			Gui.DrawTimerBar(0.13, 'DISTRACT TIME', secondsLeft)
			Gui.DisplayObjectiveText('Stay in the ~b~area~w~.')
			World.SetWantedLevel(math.floor(passedTime / Settings.distractCopsWantedInterval) + 1)
		else
			TriggerServerEvent('lsv:distractCopsFinished')
			return
		end
	end
end)


RegisterNetEvent('lsv:distractCopsFinished')
AddEventHandler('lsv:distractCopsFinished', function(success, reason)
	RemoveBlip(blip)
	World.SetWantedLevel(0)

	StartScreenEffect("SuccessMichael", 0, false)

	Citizen.Wait(1000)

	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true) end

	local status = success and 'COMPLETED' or 'FAILED'
	local message = success and '+'..Settings.distractCopsReward..' RP' or reason or ''

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'DISTRACT COPS '..status, message)
	scaleform:RenderFullscreenTimed(5000)

	scaleform:Delete()

	Player.isEventInProgress = false
end)