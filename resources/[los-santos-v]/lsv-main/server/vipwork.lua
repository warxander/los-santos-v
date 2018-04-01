RegisterServerEvent('lsv:vipWorkStarted')
AddEventHandler('lsv:vipWorkStarted', function(vipWork)
	local player = source
	TriggerClientEvent('lsv:vipWorkStarted', -1, player, vipWork)
end)


RegisterServerEvent('lsv:vipWorkFinished')
AddEventHandler('lsv:vipWorkFinished', function(vipWork)
	local player = source
	TriggerClientEvent('lsv:vipWorkFinished', -1, player, vipWork)
end)