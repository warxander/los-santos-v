local _alreadyInvited = false

RegisterNetEvent('lsv:crewMemberLeft')
AddEventHandler('lsv:crewMemberLeft', function(player, disconnected)
	if not Player.IsInCrew() then
		return
	end

	if player == Player.ServerId() then
		Prompt.Hide()
		Player.CrewLeader = nil
		Player.CrewMembers = { }
	else
		Player.CrewMembers[player] = nil
		if not disconnected then
			FlashMinimapDisplay()
			PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
			Gui.DisplayPersonalNotification(Gui.GetPlayerName(player, '~b~')..' has left the Crew.')
		end
	end
end)

RegisterNetEvent('lsv:crewFormed')
AddEventHandler('lsv:crewFormed', function()
	Prompt.Hide()

	if Player.IsInCrew() then
		return
	end

	Player.CrewLeader = Player.ServerId()
	Player.CrewMembers = { }
	Player.CrewMembers[Player.ServerId()] = true

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('You have formed the Crew.')
end)

RegisterNetEvent('lsv:crewDisbanded')
AddEventHandler('lsv:crewDisbanded', function()
	if not Player.IsInCrew() then
		return
	end

	Prompt.Hide()
	Player.CrewLeader = nil
	Player.CrewMembers = { }

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('Crew was disbanded.')
end)

RegisterNetEvent('lsv:invitedToCrew')
AddEventHandler('lsv:invitedToCrew', function(player)
	if _alreadyInvited or Player.IsInCrew() then
		TriggerServerEvent('lsv:declineCrewInvitation', player)
		return
	end

	_alreadyInvited = true

	local playerId = GetPlayerFromServerId(player)
	local handle = RegisterPedheadshot(GetPlayerPed(playerId))
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
		Citizen.Wait(0)
	end
	local txd = GetPedheadshotTxdString(handle)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('I\'d like to invite you in my Crew.', txd, GetPlayerName(playerId), '', 7)

	local invitationTimer = Timer.New()
	while true do
		Citizen.Wait(0)

		if invitationTimer:elapsed() >= Settings.crew.invitationTimeout then
			Gui.DisplayPersonalNotification('You have declined Crew invitation from '..Gui.GetPlayerName(player)..'.')
			TriggerServerEvent('lsv:declineCrewInvitation', player)
			_alreadyInvited = false
			return
		end

		Gui.DisplayHelpText('Press ~INPUT_SELECT_CHARACTER_MICHAEL~ to accept Crew invitation from '..Gui.GetPlayerName(player))

		if IsControlPressed(0, 166) then
			TriggerServerEvent('lsv:acceptCrewInvitation', player)
			_alreadyInvited = false
			return
		end
	end
end)

RegisterNetEvent('lsv:crewInvitationAccepted')
AddEventHandler('lsv:crewInvitationAccepted', function(leader, crewMembers)
	if Player.IsInCrew() then
		return
	end

	Player.CrewLeader = leader
	table.iforeach(crewMembers, function(member)
		Player.CrewMembers[member] = true
	end)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('You have joined to '..Gui.GetPlayerName(leader)..' Crew.')
end)

RegisterNetEvent('lsv:crewMemberJoined')
AddEventHandler('lsv:crewMemberJoined', function(member)
	if not Player.IsInCrew() then
		return
	end

	Player.CrewMembers[member] = true
	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification(Gui.GetPlayerName(member)..' has joined to your Crew.')
end)

RegisterNetEvent('lsv:crewInvitationDeclined')
AddEventHandler('lsv:crewInvitationDeclined', function(player)
	if Player.CrewLeader ~= Player.ServerId() then
		return
	end

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'MP_IDLE_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
	Gui.DisplayPersonalNotification(Gui.GetPlayerName(player)..' has declined your Crew Invitation.')
end)
