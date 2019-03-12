local logger = Logger:CreateNamedLogger('AutoSave')

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

	logger:Debug('Save { '..player..', '..GetPlayerIdentifiers(player)[1]..' }')

	players[player]:Restart()
end)


AddEventHandler('lsv:playerConnected', function(player)
	players[player] = Timer.New()
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)