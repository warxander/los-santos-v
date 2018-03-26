local reportedPlayers = { }
local reportingPlayer = nil
local reportingReasons = { "Bad Player Name", "Harassment", "Cheating", "Spam" }


AddEventHandler('lsv:init', function()
	while true do
		if WarMenu.IsMenuOpened('reportPlayer') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local target = GetPlayerServerId(i)
					if not Utils.Index(reportedPlayers, target) and WarMenu.MenuButton(GetPlayerName(i), 'reportReason') then
						reportingPlayer = target
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportReason') then
			for _, reason in ipairs(reportingReasons) do
				if WarMenu.Button(reason) then
					TriggerServerEvent('lsv:reportPlayer', reportingPlayer, reason)
					table.insert(reportedPlayers, reportingPlayer)
					reportingPlayer = nil
					WarMenu.CloseMenu()
				end
			end

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


RegisterNetEvent('lsv:reportSuccess')
AddEventHandler('lsv:reportSuccess', function(targetName)
	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('<C>'..targetName..'</C> ~r~has been reported.')
end)


RegisterNetEvent('lsv:playerKicked')
AddEventHandler('lsv:playerKicked', function(playerName)
	Gui.DisplayNotification('<C>'..playerName..'</C> has been kicked from the session by players.')
end)