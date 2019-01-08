AddEventHandler('lsv:startMostWanted', function()
	JobWatcher.StartJob('Most Wanted')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()
	local lastNotificationTime = nil

	Citizen.CreateThread(function()
		Gui.StartJob(jobId, 'Most Wanted', 'Survive the longest with a wanted level.')
	end)

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.mostWanted.time then
			World.SetWantedLevel(5)

			local passedTime = GetGameTimer() - eventStartTime

			if IsPlayerDead(PlayerId()) then
				TriggerServerEvent('lsv:mostWantedFinished', passedTime)
				return
			end

			if not lastNotificationTime or GetTimeDifference(GetGameTimer(), lastNotificationTime) >= Settings.mostWanted.notification.timeout then
				Gui.DisplayNotification(Utils.GetRandom(Settings.mostWanted.notification.messages), 'CHAR_DEFAULT', GetPlayerName(PlayerId()))
				lastNotificationTime = GetGameTimer()
			end

			local secondsLeft = math.floor((Settings.mostWanted.time - passedTime) / 1000)
			Gui.DrawTimerBar('MISSION TIME', secondsLeft)
			Gui.DrawTimerBar('TIME SURVIVED', math.floor(passedTime / 1000), nil, 2)
			Gui.DisplayObjectiveText('Survive the longest with a wanted level.')
		else
			TriggerServerEvent('lsv:mostWantedFinished', Settings.mostWanted.time)
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
