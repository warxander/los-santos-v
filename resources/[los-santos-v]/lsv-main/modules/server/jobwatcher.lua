JobWatcher = { }


local players = { }


function JobWatcher.IsDoingJob(player)
	return Utils.IndexOf(players, player)
end


RegisterServerEvent('lsv:jobStarted')
AddEventHandler('lsv:jobStarted', function(job)
	local player = source
	table.insert(players, player)
	TriggerClientEvent('lsv:jobStarted', -1, player, job)
end)


RegisterServerEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(job)
	local player = source
	Utils.SafeRemove(players, player)
	TriggerClientEvent('lsv:jobFinished', -1, player, job)
end)


AddEventHandler('lsv:playerDropped', function(player)
	Utils.SafeRemove(players, player)
end)