local _target = nil

local _moderationEventName = nil
local _moderationReasons = { 'Inappropriate Player Name', 'Harassment', 'Cheating', 'Spam', 'Abusing Game Mechanics' }
local _banDurations = { 1, 3, 7, 30 }
local _banReason = nil

local function setSpectatorModeEnabled(enabled)
	local targetPed = enabled and GetPlayerPed(GetPlayerFromServerId(_target)) or PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(targetPed, false))

	RequestCollisionAtCoord(x, y, z)
	NetworkSetInSpectatorMode(enabled, targetPed)
	Player.SetPassiveMode(enabled)
end

RegisterNetEvent('lsv:playerBanned')
AddEventHandler('lsv:playerBanned', function(name, cheatName)
	Gui.DisplayNotification('<C>'..name..'</C> ~r~was banned for '..cheatName..'.')
end)

AddEventHandler('lsv:init', function()
	if not Player.Moderator then
		return
	end

	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 29) then
			Gui.OpenMenu('moderator')
		end
	end
end)

AddEventHandler('lsv:init', function()
	if not Player.Moderator then
		return
	end

	WarMenu.CreateMenu('moderator', 'Moderator Menu')
	WarMenu.SetMenuMaxOptionCountOnScreen('moderator', Settings.maxMenuOptionCount)
	WarMenu.SetSubTitle('moderator', 'Select Player')
	WarMenu.SetTitleColor('moderator', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('moderator', 178, 98, 135)

	WarMenu.CreateSubMenu('playermoderation', 'moderator')
	WarMenu.CreateSubMenu('moderationReason', 'playermoderation')
	WarMenu.CreateSubMenu('banDuration', 'moderationReason', 'Select ban duration')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('moderator') then
			for _, id in ipairs(GetActivePlayers()) do
				if id ~= PlayerId() then
					if WarMenu.MenuButton(GetPlayerName(id), 'playermoderation') then
						_target = GetPlayerServerId(id)
						WarMenu.SetSubTitle('playermoderation', 'Select Action for '..GetPlayerName(id))
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('playermoderation') then
			if WarMenu.MenuButton('Kick', 'moderationReason') then
				_moderationEventName = 'lsv:kickPlayer'
				WarMenu.SetSubTitle('moderationReason', 'Select reason for kicking')
			elseif WarMenu.MenuButton('Temp Ban', 'moderationReason') then
				_moderationEventName = 'lsv:tempBanPlayer'
				WarMenu.SetSubTitle('moderationReason', 'Select reason for banning')
			elseif WarMenu.Button('Spectate') then
				setSpectatorModeEnabled(true)
				while not IsControlJustReleased(3, 177) do
					Gui.DisplayHelpText('Press ~INPUT_CELLPHONE_CANCEL~ to stop spectating.')
					Gui.DisplayObjectiveText('Spectating '..Gui.GetPlayerName(_target, '~w~'))
					Citizen.Wait(0)
				end
				setSpectatorModeEnabled(false)
			elseif Player.Moderator == Settings.moderator.levels.Administrator and WarMenu.MenuButton('~r~Ban', 'moderationReason') then
				_moderationEventName = 'lsv:banPlayer'
				WarMenu.SetSubTitle('moderationReason', 'Select reason for banning')
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('moderationReason') then
			table.iforeach(_moderationReasons, function(reason)
				if _moderationEventName ~= 'lsv:tempBanPlayer' then
					if WarMenu.Button(reason) then
						TriggerServerEvent(_moderationEventName, _target, reason)
						_target = nil
						_moderationEventName = nil
						WarMenu.CloseMenu()
					end
				else
					if WarMenu.MenuButton(reason, 'banDuration') then
						_banReason = reason
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('banDuration') then
			table.iforeach(_banDurations, function(days)
				if WarMenu.Button(days..' Day(s)') then
					TriggerServerEvent(_moderationEventName, _target, _banReason, days)
					_target = nil
					_moderationEventName = nil
					_banReason = nil
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		end
	end
end)
