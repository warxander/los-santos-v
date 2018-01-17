--TODO Instancing players?

BountyPlayerId = nil


RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	BountyPlayerId = bountyServerPlayerId

	if not BountyPlayerId then return end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	local bountyReward = '$'..tostring(math.floor(Settings.bountyEventReward))
	if GetPlayerServerId(PlayerId()) == BountyPlayerId then
		Gui.DisplayNotification('Watch out, someone has put a Bounty of '..bountyReward..' on you.', 'CHAR_LESTER_DEATHWISH', 'Unknown')
	else
		Gui.DisplayNotification('A Bounty of '..bountyReward..' has been set on '..Gui.GetPlayerName(BountyPlayerId, '~p~'))
	end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killer)
	BountyPlayerId = nil
	Gui.DisplayNotification(Gui.GetPlayerName(killer, '~p~')..' received a Bounty.')
end)