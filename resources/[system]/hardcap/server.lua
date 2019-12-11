local playerCount = 0
local players = { }


RegisterServerEvent('hardcap:playerActivated')
AddEventHandler('hardcap:playerActivated', function()
	if not players[source] then
		playerCount = playerCount + 1
		players[source] = true
	end
end)


AddEventHandler('playerDropped', function()
	if players[source] then
		playerCount = playerCount - 1
		players[source] = nil
	end
end)


AddEventHandler('playerConnecting', function(name, setReason)
	local maxPlayers = GetConvarInt('sv_maxclients', 32)

	if playerCount >= maxPlayers then
		setReason('Server is full, please try again later.')
		CancelEvent()
	end
end)
