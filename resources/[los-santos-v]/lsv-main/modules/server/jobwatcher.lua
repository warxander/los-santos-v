JobWatcher = { }


RegisterServerEvent('lsv:jobStarted')
AddEventHandler('lsv:jobStarted', function(job)
	local player = source
	TriggerClientEvent('lsv:jobStarted', -1, player, job)
end)


RegisterServerEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(job)
	local player = source
	TriggerClientEvent('lsv:jobFinished', -1, player, job)
end)