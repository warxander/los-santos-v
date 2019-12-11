local logger = Logger.New('AutoSave')

local players = { }


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for player, lastSavedTime in pairs(players) do
			if lastSavedTime:Elapsed() > Settings.autoSavingTimeout then
				TriggerClientEvent('lsv:savePlayer', player)
			end
		end
	end
end)


RegisterNetEvent('lsv:playerSaved')
AddEventHandler('lsv:playerSaved', function()
	local player = source
	if not Scoreboard.IsPlayerOnline(player) then return end

	players[player]:Restart()
end)


AddEventHandler('lsv:playerConnected', function(player)
	players[player] = Timer.New()
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)
