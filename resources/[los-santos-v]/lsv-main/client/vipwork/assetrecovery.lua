local vehicle = nil
local vehicleBlip = nil
local dropOffBlip = nil
local dropOffLocationBlip = nil

AddEventHandler('lsv:startAssetRecovery', function()
	local variant = Settings.assetRecovery.variants[GetRandomIntInRange(1, Utils.GetTableLength(Settings.assetRecovery.variants) + 1)]

	Streaming.RequestModel(variant.vehicle)

	vehicle = CreateVehicle(GetHashKey(variant.vehicle), variant.vehicleLocation.x, variant.vehicleLocation.y, variant.vehicleLocation.z, variant.vehicleLocation.heading, true, true)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 16, 4)

	vehicleBlip = AddBlipForEntity(vehicle)
	SetBlipColour(vehicleBlip, Color.BlipYellow())
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipRouteColour(vehicleBlip, Color.BlipYellow())
	SetBlipAlpha(vehicleBlip, 0)

	dropOffBlip = AddBlipForCoord(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z)
	SetBlipColour(dropOffBlip, Color.BlipYellow())
	SetBlipHighDetail(dropOffBlip, true)
	SetBlipRouteColour(dropOffBlip, Color.BlipYellow())
	SetBlipAlpha(dropOffBlip, 0)

	dropOffLocationBlip = Map.CreateRadiusBlip(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, Settings.assetRecovery.dropRadius, Color.BlipYellow())
	SetBlipAlpha(dropOffLocationBlip, 0)

	Player.StartVipWork('Asset Recovery')

	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayNotification('You have started Asset Recovery. Steal the vehicle and deliver it to the drop-off to earn RP.')

	local eventStartTime = GetGameTimer()

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if Player.isEventInProgress then Gui.DrawTimerBar(0.13, 'VIP WORK END', math.floor((Settings.assetRecovery.time - GetGameTimer() + eventStartTime) / 1000))
			else return end
		end
	end)

	local routeBlip = nil

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.assetRecovery.time then
			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle, false) then
				TriggerEvent('lsv:assetRecoveryFinished', false, 'A vehicle has been destroyed.')
				return
			end

			local isInVehicle = IsPedInVehicle(PlayerPedId(), vehicle, false)

			Gui.DisplayObjectiveText(isInVehicle and 'Deliver the vehicle to the ~y~drop off~w~.' or 'Steal the ~y~vehicle~w~.')

			SetBlipAlpha(vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(dropOffBlip, isInVehicle and 255 or 0)
			SetBlipAlpha(dropOffLocationBlip, isInVehicle and 128 or 0)

			if isInVehicle then
				if routeBlip ~= dropOffBlip then
					SetBlipRoute(dropOffBlip, true)
					routeBlip = dropOffBlip
				end
			elseif routeBlip ~= vehicleBlip then
				SetBlipRoute(vehicleBlip, true)
				routeBlip = vehicleBlip
			end

			if isInVehicle then
				World.SetWantedLevel(3)

				local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

				if GetDistanceBetweenCoords(playerX, playerY, playerZ, variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, false) < Settings.assetRecovery.dropRadius then
					TriggerServerEvent('lsv:assetRecoveryFinished')
					return
				end
			end
		else
			TriggerEvent('lsv:assetRecoveryFinished', false, 'Time is over.')
			return
		end
	end
end)


RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(success, reason)
	Player.FinishVipWork('Asset Recovery')

	RemoveBlip(vehicleBlip)
	RemoveBlip(dropOffBlip)
	RemoveBlip(dropOffLocationBlip)

	vehicleBlip = nil
	dropOffBlip = nil
	dropOffLocationBlip = nil

	World.SetWantedLevel(0)

	StartScreenEffect("SuccessMichael", 0, false)

	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true) end

	local status = success and 'COMPLETED' or 'FAILED'
	local message = success and '+'..Settings.assetRecovery.reward..' RP' or reason or ''

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'ASSET RECOVERY '..status, message)
	scaleform:RenderFullscreenTimed(5000)

	scaleform:Delete()
end)