local logger = Logger:CreateNamedLogger('Guard')

RegisterServerEvent('lsv:banPlayer')
AddEventHandler('lsv:banPlayer', function(cheatName)
	local player = source

	local bannedPlayerId = GetPlayerIdentifiers(player)[1]
	local bannedPlayerName = GetPlayerName(player)

	Db.BanPlayer(player, function()
		logger:Info('Player banned { '..bannedPlayerName..', '..bannedPlayerId..', '..cheatName..' }')

		DropPlayer(player, 'You\'re permanently banned from this server ('..cheatName..').')

		TriggerClientEvent('lsv:playerBanned', -1, bannedPlayerName, cheatName)
	end)
end)