--TODO Instancing players?

BountyPlayerId = nil


RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	if bountyServerPlayerId then
		BountyPlayerId = bountyServerPlayerId
	else
		BountyPlayerId = nil
		return
	end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	local bountyReward = '$'..tostring(math.floor(Settings.bountyEventReward))
	if tonumber(GetPlayerServerId(PlayerId())) == BountyPlayerId then
		Gui.DisplayNotification('Watch out, someone has put a Bounty of '..bountyReward..' on you.', 'CHAR_LESTER_DEATHWISH', 'Unknown')
	else
		Gui.DisplayNotification('A Bounty of '..bountyReward..' has been set on '..Gui.GetPlayerName(BountyPlayerId, '~p~'))
	end
end)


AddEventHandler('lsv:onPlayerKilled', function(source, killer)
	if tonumber(GetPlayerServerId(PlayerId())) == tonumber(killer) then
		if tonumber(source) == BountyPlayerId then
			TriggerServerEvent('lsv:bountyKilled')
		end
	end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killerId)
	BountyPlayerId = nil

	if tonumber(killerId) == tonumber(GetPlayerServerId(PlayerId())) then
		Player.ChangeMoney(Settings.bountyEventReward)
	end

	Gui.DisplayNotification(Gui.GetPlayerName(killerId, '~p~')..' received a Bounty.')
end)