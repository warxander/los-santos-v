local vehiclePosition = { }
local vehicleHeading = nil


AddEventHandler('lsv:requestVehicle', function(model, vehicleCategory)
	local playerPosition = Player.Position()
	local success, position, heading = GetNthClosestVehicleNodeWithHeading(playerPosition.x, playerPosition.y, playerPosition.z)

	if not success then
		Gui.DisplayNotification('~r~Failed to deliver your Personal Vehicle. Try again from another location.')
		return
	end

	vehiclePosition = position
	vehicleHeading = heading

	TriggerServerEvent('lsv:requestVehicle', model, vehicleCategory)
end)


RegisterNetEvent('lsv:vehicleRequested')
AddEventHandler('lsv:vehicleRequested', function(model)
	if Player.Vehicle then return end

	if not model then
		Gui.DisplayNotification('~r~You don\'t have enough cash.')
		return
	end

	Streaming.RequestModel(model)
	Player.Vehicle = CreateVehicle(GetHashKey(model), vehiclePosition.x, vehiclePosition.y, vehiclePosition.z, vehicleHeading, true, true)
	SetVehicleMod(Player.Vehicle, 16, 4) -- Armour
	SetVehicleNumberPlateText(Player.Vehicle, GetPlayerName(PlayerId()))
	SetVehicleOnGroundProperly(Player.Vehicle)

	local vehicleBlip = AddBlipForEntity(Player.Vehicle)
	SetBlipSprite(vehicleBlip, Blip.PersonalVehicleCar())
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipColour(vehicleBlip, Color.BlipGreen())
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not DoesEntityExist(Player.Vehicle) or not IsVehicleDriveable(Player.Vehicle) then
				Gui.DisplayNotification('Your Personal Vehicle has been destroyed.')
				RemoveBlip(vehicleBlip)
				Player.Vehicle = nil
				return
			else
				local isPlayerInVehicle = IsPedInVehicle(PlayerPedId(), Player.Vehicle)
				SetBlipAlpha(vehicleBlip, isPlayerInVehicle and 0 or 255)
				if not isPlayerInVehicle then
					local vehiclePosition = GetEntityCoords(Player.Vehicle)
					DrawMarker(20, vehiclePosition.x, vehiclePosition.y, vehiclePosition.z + 1.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.85, 0.85, 0.85, 114, 204, 114, 96, true, true)
				end
			end
		end
	end)

	Streaming.RequestModel('a_f_y_business_04')
	local driver = CreatePedInsideVehicle(Player.Vehicle, 4, GetHashKey('a_f_y_business_04'), -1)
	SetBlockingOfNonTemporaryEvents(driver, true)
	SetPedFleeAttributes(driver, 0, 0)

	local _, taskSequence = OpenSequenceTask()
	local playerPosition = Player.Position()
	TaskVehicleDriveToCoordLongrange(0, Player.Vehicle, playerPosition.x, playerPosition.y, playerPosition.z, 40.0, 8388614, 10.)
	TaskLeaveVehicle(0, Player.Vehicle, 256)
	TaskWanderStandard(0, 10.0, 10)
	CloseSequenceTask(taskSequence)
	TaskPerformSequence(driver, taskSequence)
	ClearSequenceTask(taskSequence)

	Gui.DisplayHelpText('Your Personal Vehicle is nearby.')
end)