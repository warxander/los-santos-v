AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('vipWork') then
			if WarMenu.Button('Most Wanted') then
				TriggerEvent('lsv:startMostWanted')
				WarMenu.CloseMenu()
			end

			if WarMenu.Button('Asset Recovery') then
				TriggerEvent('lsv:startAssetRecovery')
				WarMenu.CloseMenu()
			end

			if WarMenu.Button('Headhunter') then
				TriggerEvent('lsv:startHeadhunter')
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		end
	end
end)


RegisterNetEvent('lsv:vipWorkStarted')
AddEventHandler('lsv:vipWorkStarted', function(player, vipWork)
	if GetPlayerServerId(PlayerId()) ~= player then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has started '..vipWork..' VIP Work.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)


RegisterNetEvent('lsv:vipWorkFinished')
AddEventHandler('lsv:vipWorkFinished', function(player, vipWork)
	if GetPlayerServerId(PlayerId()) ~= player then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has finished '..vipWork..' VIP Work.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)