--TODO Instancing players?


RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	World.SetBountyPlayerId(bountyServerPlayerId)

	if not bountyServerPlayerId then return end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	if GetPlayerServerId(PlayerId()) == bountyServerPlayerId then
		Gui.DisplayNotification('Watch out, someone has put a Bounty on you.', 'CHAR_LESTER_DEATHWISH', 'Unknown')
	else
		Gui.DisplayNotification('A Bounty has been set on '..Gui.GetPlayerName(bountyServerPlayerId, '~p~'))
	end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killer)
	World.SetBountyPlayerId(nil)
	Gui.DisplayNotification(Gui.GetPlayerName(killer, '~p~')..' received a Bounty.')
end)