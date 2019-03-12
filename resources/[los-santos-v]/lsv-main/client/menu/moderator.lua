local target = nil

local moderationEventName = nil
local moderationReasons = { 'Inappropriate Player Name', 'Harassment', 'Cheating', 'Spam', 'Abusing Game Mechanics', 'Inappropriate Voice Chat Language' }

local function setSpectatorModeEnabled(enabled)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	local x, y, z = table.unpack(GetEntityCoords(targetPed, false))

	RequestCollisionAtCoord(x, y, z)
	NetworkSetInSpectatorMode(enabled, targetPed)
	Player.SetFreeze(enabled)
end


AddEventHandler('lsv:init', function()
	if not Player.Moderator then return end

	while true do
		Citizen.Wait(0)

		if not WarMenu.IsAnyMenuOpened() and IsControlJustReleased(0, 29) then WarMenu.OpenMenu('moderator') end
	end
end)


AddEventHandler('lsv:init', function()
	if not Player.Moderator then return end

	WarMenu.CreateMenu('moderator', 'Moderator Menu')
	WarMenu.SetSubTitle('moderator', 'Select Player')
	WarMenu.SetTitleColor('moderator', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('moderator', 178, 98, 135)

	WarMenu.CreateSubMenu('playermoderation', 'moderator')
	WarMenu.CreateSubMenu('moderationReason', 'playermoderation')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('moderator') then
			for id = 0, Settings.maxPlayerCount do
				if id ~= PlayerId() and NetworkIsPlayerActive(id) then
					if WarMenu.MenuButton(GetPlayerName(id), 'playermoderation') then
						target = GetPlayerServerId(id)
						WarMenu.SetSubTitle('playermoderation', 'Select Action for '..GetPlayerName(id))
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('playermoderation') then
			if WarMenu.MenuButton('Kick', 'moderationReason') then
				moderationEventName = 'lsv:kickPlayer'
				WarMenu.SetSubTitle('moderationReason', 'Select reason for kicking')
			elseif WarMenu.MenuButton('Ban', 'moderationReason') then
				moderationEventName = 'lsv:tempBanPlayer'
				WarMenu.SetSubTitle('moderationReason', 'Select reason for banning')
			elseif WarMenu.Button('Spectate') then
				setSpectatorModeEnabled(true)
				while not IsControlJustReleased(3, 177) do
					Gui.DisplayHelpText('Press ~INPUT_CELLPHONE_CANCEL~ to stop spectating.')
					Gui.DisplayObjectiveText('Spectating '..Gui.GetPlayerName(target))
					Citizen.Wait(0)
				end
				setSpectatorModeEnabled(false)
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('moderationReason') then
			table.foreach(moderationReasons, function(reason)
				if WarMenu.Button(reason) then
					TriggerServerEvent(moderationEventName, target, reason)
					target = nil
					moderationEventName = nil
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		end
	end
end)


RegisterNetEvent('lsv:playerBanned')
AddEventHandler('lsv:playerBanned', function(name, cheatName)
	Gui.DisplayNotification('<C>'..name..'</C> ~r~was banned for '..cheatName..'.')
end)