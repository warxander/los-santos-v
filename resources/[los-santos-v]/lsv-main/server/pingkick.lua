local _players = { }

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)

		table.foreach(_players, function(warned, player)
			local ping = GetPlayerPing(player)

			if ping >= Settings.pingThreshold then
				if warned then
					DropPlayer(player, 'Your ping is too high ('..ping..' ms)')
				else
					TriggerClientEvent('lsv:playerHighPingWarned', player, ping)
					_players[player] = true
				end
			elseif warned then
				_players[player] = false
			end
		end)
	end
end)

AddSignalHandler('lsv:playerConnected', function(player)
	_players[player] = false
end)

AddSignalHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
