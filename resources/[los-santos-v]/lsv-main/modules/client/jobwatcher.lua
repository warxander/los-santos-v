JobWatcher = { }

local isAnyJobInProgress = false

local players = { }


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


function JobWatcher.IsDoingJob(serverId)
	return Utils.IndexOf(players, serverId)
end


RegisterNetEvent('lsv:jobStarted')
AddEventHandler('lsv:jobStarted', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then
		table.insert(players, player)
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has started '..job..' Job.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)


RegisterNetEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then
		Utils.SafeRemove(players, player)
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has finished '..job..' Job.')
	end
end)


AddEventHandler('lsv:playerDisconnected', function(name, player)
	Utils.SafeRemove(players, player)
end)


