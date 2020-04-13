AddEventHandler('lsv:init', function()
	if Player.Moderator then
		return
	end

	local timeLeft = nil
	local currentPosition = nil
	local previousPosition = nil
	local previousHeading = nil

	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()

		if playerPed then
			local currentPosition = GetEntityCoords(playerPed, true)
			local currentHeading = GetEntityHeading(playerPed)

			if currentPosition == previousPosition and currentHeading == previousHeading then
				if timeLeft > 0 then
					if timeLeft == math.ceil(Settings.afkTimeout / 4) then
						Gui.DisplayPersonalNotification('You will be kicked in '..timeLeft..' seconds for being AFK.')
					end

					timeLeft = timeLeft - 1
				else
					TriggerServerEvent('lsv:kickAFKPlayer')
				end
			else
				timeLeft = Settings.afkTimeout
			end

			previousPosition = currentPosition
			previousHeading = currentHeading
		end
	end
end)
