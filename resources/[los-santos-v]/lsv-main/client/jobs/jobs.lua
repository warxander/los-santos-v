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