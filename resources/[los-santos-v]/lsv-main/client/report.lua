RegisterNetEvent('lsv:reportSuccess')
AddEventHandler('lsv:reportSuccess', function(targetName)
	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('<C>'..targetName..'</C> ~r~has been reported.')
end)


RegisterNetEvent('lsv:playerKicked')
AddEventHandler('lsv:playerKicked', function(playerName)
	Gui.DisplayNotification('<C>'..playerName..'</C> has been kicked from the session by players.')
end)