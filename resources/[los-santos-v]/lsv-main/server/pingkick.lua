local players = { }


Citizen.CreateThread(function()
	Citizen.Wait(60000)

	for player, warned in ipairs(players) do
		local ping = GetPlayerPing(player)
		if ping >= Settings.pingThreshold then
			if warned then DropPlayer(player, 'Your ping is too high ('..ping..' ms)')
			else
				TriggerClientEvent('lsv:playerHighPingWarned', player, ping)
				players[player] = true
			end
		elseif warned then players[player] = false end
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	players[player] = false
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)