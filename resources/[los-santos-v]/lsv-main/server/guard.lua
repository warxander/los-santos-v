RegisterNetEvent('lsv:autoBanPlayer')
AddEventHandler('lsv:autoBanPlayer', function(reason)
	local target = source
	local targetName = GetPlayerName(target)

	Db.BanPlayer(target, function()
		Discord.ReportAutoBanPlayer(target, reason)
		DropPlayer(target, 'You\'re permanently banned from this server for '..reason..'.')
		TriggerClientEvent('lsv:playerBanned', -1, targetName, reason)
	end)
end)