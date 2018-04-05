JobWatcher = { }

local isAnyJobInProgress = false


function JobWatcher.IsAnyJobInProgress()
	return isAnyJobInProgress
end


function JobWatcher.StartJob(jobName)
	isAnyJobInProgress = true
	TriggerServerEvent('lsv:jobStarted', jobName)
end


function JobWatcher.FinishJob(jobName)
	isAnyJobInProgress = false
	TriggerServerEvent('lsv:jobFinished', jobName)
end


RegisterNetEvent('lsv:jobStarted')
AddEventHandler('lsv:jobStarted', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has started '..job..' Job.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)


RegisterNetEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has finished '..job..' Job.') end
end)


