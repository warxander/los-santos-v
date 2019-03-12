local storeBlips = { }
local storePickups = { }


AddEventHandler('lsv:startMarketManipulation', function()
	local pickupHash = GetHashKey('PICKUP_MONEY_CASE')
	local placesCount = #Settings.marketManipulation.places

	table.foreach(Settings.marketManipulation.places, function(place)
		table.insert(storePickups, CreatePickupRotate(pickupHash, place.x, place.y, place.z, 0., 0., 0., 512))
	end)

	local eventStartTime = Timer.New()
	local totalRobberies = 0

	Gui.StartMission('Market Manipulation', 'Rob stores and banks within the time limit.')

	table.foreach(Settings.marketManipulation.places, function(place)
		local blip = AddBlipForCoord(place.x, place.y, place.z)
		SetBlipSprite(blip, Blip.Store())
		SetBlipHighDetail(blip, true)
		Map.SetBlipFlashes(blip)
		table.insert(storeBlips, blip)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			if Player.IsActive() then
				Gui.DisplayObjectiveText('Rob stores and banks.')
				Gui.DrawTimerBar('MISSION TIME', Settings.marketManipulation.time - eventStartTime:Elapsed())
				Gui.DrawBar('TOTAL ROBBERIES', totalRobberies, nil, 2)
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:marketManipulationFinished', false)
			return
		end

		if eventStartTime:Elapsed() < Settings.marketManipulation.time then
			if #storePickups == 0 then
				TriggerServerEvent('lsv:marketManipulationFinished')
				return
			end

			for i = placesCount, 1, -1 do
				if HasPickupBeenCollected(storePickups[i]) then
					SetBlipSprite(storeBlips[i], Blip.Completed())
					SetBlipAsShortRange(storeBlips[i], true)

					TriggerServerEvent('lsv:marketManipulationRobbed')
					Gui.DisplayNotification('You grabbed a decent cash.')
					totalRobberies = totalRobberies + 1
					storePickups[i] = nil

					World.SetWantedLevel(2)
				end
			end
		else
			TriggerServerEvent('lsv:marketManipulationFinished')
			return
		end
	end
end)


RegisterNetEvent('lsv:marketManipulationFinished')
AddEventHandler('lsv:marketManipulationFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.SetWantedLevel(0)	

	for i = #Settings.marketManipulation.places, 1, -1 do
		RemoveBlip(storeBlips[i])
		RemovePickup(storePickups[i])
	end

	Gui.FinishMission('Market Manipulation', success, reason)
end)