AddEventHandler('lsv:startMostWanted', function()
	local eventStartTime = Timer.New()

	Gui.StartMission('Most Wanted', 'Survive the longest with a wanted level.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			if Player.IsActive() then
				Gui.DrawTimerBar('MISSION TIME', Settings.mostWanted.time - eventStartTime:Elapsed())
				Gui.DrawTimerBar('TIME SURVIVED', eventStartTime:Elapsed())
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

		if eventStartTime:Elapsed() < Settings.mostWanted.time then
			World.SetWantedLevel(5)

			if IsPlayerDead(PlayerId()) then
				TriggerServerEvent('lsv:mostWantedFinished', eventStartTime:Elapsed())
				return
			end
		else
			TriggerServerEvent('lsv:mostWantedFinished', Settings.mostWanted.time)
			return
		end
	end
end)


RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.SetWantedLevel(0)

	Gui.FinishMission('Most Wanted', success, reason)
end)