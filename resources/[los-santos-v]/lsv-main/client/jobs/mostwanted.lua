AddEventHandler('lsv:startMostWanted', function()
	World.SetWantedLevel(5)

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('You have started Most Wanted. Stay alive with a wanted level.')

	JobWatcher.StartJob('Most Wanted')

	local eventStartTime = GetGameTimer()

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.mostWanted.time then
			if IsPlayerDead(PlayerId()) then
				TriggerEvent('lsv:mostWantedFinished', false)
				return
			end

			if GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerEvent('lsv:mostWantedFinished', false, 'You lose the cops.')
				return
			end

			local passedTime = GetGameTimer() - eventStartTime
			local secondsLeft = math.floor((Settings.mostWanted.time - passedTime) / 1000)
			Gui.DrawTimerBar(0.13, 'TIME LEFT', secondsLeft)
			Gui.DisplayObjectiveText('Stay alive with a wanted level.')
		else
			TriggerServerEvent('lsv:mostWantedFinished')
			return
		end
	end
end)


RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(success, reason)
	JobWatcher.FinishJob('Most Wanted')

	World.SetWantedLevel(0)

	StartScreenEffect("SuccessMichael", 0, false)

	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true) end

	local status = success and 'COMPLETED' or 'FAILED'
	local message = success and '+'..Settings.mostWanted.reward..' RP' or reason or ''

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'MOST WANTED '..status, message)
	scaleform:RenderFullscreenTimed(5000)

	scaleform:Delete()
end)