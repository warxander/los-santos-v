local _alreadyInvited = false

RegisterNetEvent('lsv:crewLeaved')
AddEventHandler('lsv:crewLeaved', function(player)
	if player == Player.ServerId() then
		Player.CrewMembers = { }
		Gui.DisplayNotification('You have left the Crew.')
		return
	end

	if table.try_remove(Player.CrewMembers, player) then
		Gui.DisplayPersonalNotification(Gui.GetPlayerName(player, '~b~')..' has left the Crew.')
	end
end)

RegisterNetEvent('lsv:invitedToCrew')
AddEventHandler('lsv:invitedToCrew', function(player)
	if #Player.CrewMembers ~= 0 or _alreadyInvited then
		TriggerServerEvent('lsv:alreadyInCrew', player)
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

		if invitationTimer:elapsed() >= Settings.crewInvitationTimeout then
			Gui.DisplayPersonalNotification('You have declined Crew invitation from '..Gui.GetPlayerName(player)..'.')
			TriggerServerEvent('lsv:declineInvitation', player)
			_alreadyInvited = false
			return
		end

		Gui.DisplayHelpText('Press ~INPUT_SELECT_CHARACTER_MICHAEL~ to accept Crew Invitation from '..Gui.GetPlayerName(player))

		if IsControlPressed(0, 166) then
			table.insert(Player.CrewMembers, player)
			TriggerServerEvent('lsv:acceptInvitation', player)
			Gui.DisplayPersonalNotification('You have accepted Crew Invitation from '..Gui.GetPlayerName(player)..'.')
			_alreadyInvited = false
			return
		end
	end
end)

RegisterNetEvent('lsv:crewInvitationAccepted')
AddEventHandler('lsv:crewInvitationAccepted', function(player)
	TriggerServerEvent('lsv:updateCrewMembers', player, Player.CrewMembers)
	TriggerServerEvent('lsv:addCrewMember', player)

	table.insert(Player.CrewMembers, player)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification(Gui.GetPlayerName(player)..' has accepted your Crew Invitation.')
end)

RegisterNetEvent('lsv:crewMembersUpdated')
AddEventHandler('lsv:crewMembersUpdated', function(members)
	table.iforeach(members, function(member)
		table.insert(Player.CrewMembers, member)
	end)
end)

RegisterNetEvent('lsv:addedCrewMember')
AddEventHandler('lsv:addedCrewMember', function(player, member)
	if player ~= Player.ServerId() and member ~= Player.ServerId() and Player.IsCrewMember(player) then
		table.insert(Player.CrewMembers, member)

		FlashMinimapDisplay()
		PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
		Gui.DisplayNotification(GetPlayerName(member)..' has joined to your Crew.')
	end
end)

RegisterNetEvent('lsv:crewInvitationDeclined')
AddEventHandler('lsv:crewInvitationDeclined', function(player)
	PlaySoundFrontend(-1, 'MP_IDLE_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
	Gui.DisplayPersonalNotification(Gui.GetPlayerName(player)..' has declined your Crew Invitation.')
end)

RegisterNetEvent('lsv:alreadyInCrew')
AddEventHandler('lsv:alreadyInCrew', function(player)
	PlaySoundFrontend(-1, 'MP_IDLE_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
	Gui.DisplayNotification(Gui.GetPlayerName(player)..' is already in Crew.')
end)

AddEventHandler('lsv:playerDisconnected', function(_, player)
	table.try_remove(Player.CrewMembers, player)
end)
