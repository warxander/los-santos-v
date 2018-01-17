AddEventHandler('playerConnecting', function(name, setReason)
	local maxPlayersCount = GetConvarInt('sv_maxclients', 32)
	local playersCount = #GetPlayers()

	if playersCount >= maxPlayersCount then
		setReason('This server is full (past ' .. tostring(maxPlayersCount) .. ' players).')
		CancelEvent()
	end
end)