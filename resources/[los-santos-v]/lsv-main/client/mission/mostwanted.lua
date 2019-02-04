AddEventHandler('lsv:startMostWanted', function()
	MissionManager.StartMission('Most Wanted')

	local eventStartTime = GetGameTimer()
	local passedTime = 0
	local lastNotificationTime = nil

	Gui.StartMission('Most Wanted', 'Survive the longest with a wanted level.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			if Player.IsActive() then
				Gui.DrawTimerBar('MISSION TIME', Settings.mostWanted.time - passedTime)
				Gui.DrawTimerBar('TIME SURVIVED', passedTime, nil, 2)
				Gui.DisplayObjectiveText('Survive the longest with a wanted level.')
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:mostWantedFinished', false)
			return
		end

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.mostWanted.time then
			World.SetWantedLevel(5)

			passedTime = GetGameTimer() - eventStartTime

			if IsPlayerDead(PlayerId()) then
				TriggerServerEvent('lsv:mostWantedFinished', passedTime)
				return
			end

			if not lastNotificationTime or GetTimeDifference(GetGameTimer(), lastNotificationTime) >= Settings.mostWanted.notification.timeout then
				Gui.DisplayNotification(table.random(Settings.mostWanted.notification.messages), 'CHAR_DEFAULT', GetPlayerName(PlayerId()))
				lastNotificationTime = GetGameTimer()
			end
		else
			TriggerServerEvent('lsv:mostWantedFinished', Settings.mostWanted.time)
			return
		end
	end
end)


RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(success, reason)
	MissionManager.FinishMission('Most Wanted')

	World.SetWantedLevel(0)

	Gui.FinishMission('Most Wanted', success, reason)
end)