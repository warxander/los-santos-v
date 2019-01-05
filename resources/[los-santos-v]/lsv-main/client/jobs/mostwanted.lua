AddEventHandler('lsv:startMostWanted', function()
	World.SetWantedLevel(2)

	JobWatcher.StartJob('Most Wanted')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()
	local copsKilled = 0
	local killedCopPeds = { }
	local lastNotificationTime = nil

	Citizen.CreateThread(function()
		Gui.StartJob(jobId, 'Most Wanted', 'Stay alive with a wanted level.', 'Kill cops to get extra cash.')
	end)

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

			if not lastNotificationTime or GetTimeDifference(GetGameTimer(), lastNotificationTime) >= Settings.mostWanted.notification.timeout then
				Gui.DisplayNotification(Utils.GetRandom(Settings.mostWanted.notification.messages), 'CHAR_DEFAULT', GetPlayerName(PlayerId()))
				lastNotificationTime = GetGameTimer()
			end

			local handle, ped = FindFirstPed()
			if handle ~= -1 then
				repeat
					if IsPedDeadOrDying(ped, true) then
						local pedType = GetPedType(ped)
						local isPedCop = pedType == 6 or pedType == 27

						if isPedCop and GetPedSourceOfDeath(ped) == PlayerPedId() and not Utils.IndexOf(killedCopPeds, NetworkGetNetworkIdFromEntity(ped)) then
							table.insert(killedCopPeds, PedToNet(ped))
							TriggerServerEvent('lsv:mostWantedCopKilled')
							copsKilled = copsKilled + 1
						end
					end
					status, ped = FindNextPed(handle)
				until not status
				EndFindPed(handle)
			end

			local passedTime = GetGameTimer() - eventStartTime
			local secondsLeft = math.floor((Settings.mostWanted.time - passedTime) / 1000)
			Gui.DrawTimerBar('MISSION TIME', secondsLeft)
			Gui.DrawBar('COPS KILLED', copsKilled, nil, 2)
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
