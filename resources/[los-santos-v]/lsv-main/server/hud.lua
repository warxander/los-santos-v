local _hud = nil

AddEventHandler('lsv:playerConnected', function(player)
	if not _hud then
		_hud = { }

		_hud.discordUrl = GetConvar('discord_url', '')
		_hud.pauseMenuTitle = GetConvar('pause_menu_title', '')
	end

	TriggerClientEvent('lsv:setupHud', player, _hud)
end)
