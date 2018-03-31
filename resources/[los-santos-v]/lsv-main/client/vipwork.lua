AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('vipWork') then
			if WarMenu.Button('Distract Cops') then
				TriggerEvent('lsv:distractCops')
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		end
	end
end)