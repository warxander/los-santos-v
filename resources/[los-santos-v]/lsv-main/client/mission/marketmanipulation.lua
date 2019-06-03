local moneyPlaces = nil


AddEventHandler('lsv:startMarketManipulation', function()
	local pickupHash = GetHashKey('PICKUP_MONEY_CASE')
	local placesCount = #Settings.marketManipulation.places

	local eventStartTime = Timer.New()
	local totalRobberies = 0

	moneyPlaces = { }

	table.foreach(Settings.marketManipulation.places, function(place)
		local moneyPlace = { }
		moneyPlace.blip = Map.CreatePlaceBlip(Blip.CrateDrop(), place.x, place.y, place.z, 'Money Case', Color.BlipGreen())
		moneyPlace.pickup = CreatePickupRotate(pickupHash, place.x, place.y, place.z, 0., 0., 0., 512)
		SetBlipAsShortRange(moneyPlace.blip, false)
		SetBlipScale(moneyPlace.blip, 1.25)
		table.insert(moneyPlaces, moneyPlace)
	end)

	Gui.StartMission('Market Manipulation', 'Rob stores and banks within the time limit.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			if Player.IsActive() then
				Gui.DisplayObjectiveText('Rob stores and banks.')
				Gui.DrawTimerBar('MISSION TIME', Settings.marketManipulation.time - eventStartTime:Elapsed())
				Gui.DrawBar('TOTAL ROBBERIES', totalRobberies..'/'..placesCount)
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
			if #moneyPlaces == 0 then
				TriggerServerEvent('lsv:marketManipulationFinished')
				return
			end

			local place, placeIndex = table.ifind_if(moneyPlaces, function(place) return place.pickup and HasPickupBeenCollected(place.pickup) end)

			if place then
				TriggerServerEvent('lsv:marketManipulationRobbed')
				Gui.DisplayPersonalNotification('You have collected a money case.')
				RemovePickup(place.pickup)
				place.pickup = nil
				RemoveBlip(place.blip)
				totalRobberies = totalRobberies + 1
				World.SetWantedLevel(2)
				table.remove(moneyPlaces, placeIndex)
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

	table.foreach(moneyPlaces, function(place)
		RemoveBlip(place.blip)
		RemovePickup(place.pickup)
	end)
	moneyPlaces = nil

	Gui.FinishMission('Market Manipulation', success, reason)
end)