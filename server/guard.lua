RegisterServerEvent('lsv:banPlayer')
AddEventHandler('lsv:banPlayer', function(cheatName)
	local bannedPlayerId = GetPlayerIdentifiers(source)[1]
	local bannedPlayerName = tostring(GetPlayerName(source))

	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET Banned=1 WHERE PlayerID=@playerId', { ['@playerId'] = bannedPlayerId }, function()
			Citizen.Trace('>>> playerBanned: { '..bannedPlayerName..', '..tostring(bannedPlayerId)..', '..tostring(cheatName)..' }\n')
			DropPlayer(source, 'You\'re permanently banned from this server ('..tostring(cheatName)..').')
			TriggerClientEvent('lsv:playerBanned', -1, bannedPlayerName, cheatName)
		end)
	end)
end)