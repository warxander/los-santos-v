-- TODO Instancing players?

local bountyText = 'Watch out, someone has put a Bounty on you.'

RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	World.SetBountyPlayerId(bountyServerPlayerId)

	if not bountyServerPlayerId then return end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	if GetPlayerServerId(PlayerId()) == bountyServerPlayerId then
		Gui.DisplayNotification(bountyText, 'CHAR_LESTER_DEATHWISH', 'Unknown', '', 2)

		Citizen.Wait(1500)

		local bountyScaleform = Scaleform:Request('MIDSIZED_MESSAGE')

		bountyScaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'BOUNTY', bountyText)
		bountyScaleform:RenderFullscreenTimed(5000)

		bountyScaleform:Delete()
	else Gui.DisplayNotification('A Bounty has been set on '..Gui.GetPlayerName(bountyServerPlayerId, '~r~')..'.') end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killer)
	if GetPlayerServerId(PlayerId()) ~= killer then
		Gui.DisplayNotification('The Bounty on '..Gui.GetPlayerName(World.GetBountyPlayerId(), nil, true)..' has been claimed by '..Gui.GetPlayerName(killer))
	end

	World.SetBountyPlayerId(nil)
end)