AddEventHandler('lsv:startMostWanted', function()
	World.SetWantedLevel(5)

	JobWatcher.StartJob('Most Wanted')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()

	Gui.StartJob(jobId, 'You have started Most Wanted. Stay alive with a wanted level.')

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

	Gui.FinishJob('Most Wanted', success, reason)
end)