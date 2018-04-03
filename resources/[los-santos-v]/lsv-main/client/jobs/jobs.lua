AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('jobs') then
			if WarMenu.Button('Velocity') then
				TriggerEvent('lsv:startVelocity')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Most Wanted') then
				TriggerEvent('lsv:startMostWanted')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Asset Recovery') then
				TriggerEvent('lsv:startAssetRecovery')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Headhunter') then
				TriggerEvent('lsv:startHeadhunter')
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		end
	end
end)


RegisterNetEvent('lsv:jobStarted')
AddEventHandler('lsv:jobStarted', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has started '..job..' Job.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)


RegisterNetEvent('lsv:jobFinished')
AddEventHandler('lsv:jobFinished', function(player, job)
	if GetPlayerServerId(PlayerId()) ~= player then Gui.DisplayNotification(Gui.GetPlayerName(player, '~g~')..' has finished '..job..' Job.') end
end)