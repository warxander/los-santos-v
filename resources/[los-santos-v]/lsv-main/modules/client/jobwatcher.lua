JobWatcher = { }

local isAnyJobInProgress = false
local jobId = 0

local players = { }


function JobWatcher.IsAnyJobInProgress()
	return isAnyJobInProgress
end


function JobWatcher.IsJobInProgress(jobId)
	return isAnyJobInProgress and jobId == jobId
end


function JobWatcher.GetJobId()
	return jobId
end


function JobWatcher.StartJob(jobName)
	isAnyJobInProgress = true
	jobId = jobId + 1
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
	if Player.ServerId() ~= player then
		table.insert(players, player)

		FlashMinimapDisplay()
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has started '..job..' Job.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)


RegisterNetEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(player, job)
	if Player.ServerId() ~= player then
		Utils.SafeRemove(players, player)
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has finished '..job..' Job.')
	end
end)


AddEventHandler('lsv:playerDisconnected', function(name, player)
	Utils.SafeRemove(players, player)
end)


