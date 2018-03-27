local logger = Logger:CreateNamedLogger('AutoSave')

local players = { }


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local time = GetGameTimer()
		for player, lastSavedTime in pairs(players) do
			if time - lastSavedTime > Settings.autoSavingTimeout then
				TriggerClientEvent('lsv:savePlayer', player)
			end
		end
	end
end)


RegisterServerEvent('lsv:playerSaved')
AddEventHandler('lsv:playerSaved', function()
	local player = source

	logger:Debug('Save { '..player..', '..GetPlayerIdentifiers(player)[1]..' }')

	players[player] = GetGameTimer()
end)


AddEventHandler('lsv:playerConnected', function(player)
	players[player] = GetGameTimer()
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)