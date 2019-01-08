local hud = { }

Citizen.CreateThread(function()
	math.randomseed(os.time())
	math.random(); math.random(); math.random();

	hud.discordUrl = GetConvar("discord_url", "")
	hud.pauseMenuTitle = GetConvar("pause_menu_title", "")
end)


AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:setupHud', player, hud)
end)