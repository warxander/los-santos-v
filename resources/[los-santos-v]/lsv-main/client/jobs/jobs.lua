local missionPlaces = { }
local missionNames = { 'MostWanted', 'Headhunter', 'Velocity', 'AssetRecovery', 'MarketManipulation' }


AddEventHandler('lsv:init', function()
	for _, place in ipairs(Settings.mission.places) do
		table.insert(missionPlaces, {
			startTime = nil,
			blip = Map.CreatePlaceBlip(Blip.Mission(), place.x, place.y, place.z, 'Mission', Color.BlipBlue()),
		})
	end

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			for _, place in ipairs(missionPlaces) do
				local alpha = 255
				if JobWatcher.IsAnyJobInProgress() or place.startTime then alpha = 0 end
				SetBlipAlpha(place.blip, alpha)

				if place.startTime and GetTimeDifference(GetGameTimer(), place.startTime) >= Settings.mission.timeout then
					Map.SetBlipFlashes(place.blip, 5000)
					place.startTime = nil
				end

				if not JobWatcher.IsAnyJobInProgress() then
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
					local placeX, placeY, placeZ = table.unpack(GetBlipCoords(place.blip))
					if not place.startTime and GetDistanceBetweenCoords(playerX, playerY, playerZ, placeX, placeY, placeZ, true) < Settings.placeMarkerRadius then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to start Mission.')
						if IsControlJustReleased(0, 38) then
							place.startTime = GetGameTimer()
							SetBlipAlpha(place.blip, 0)
							SetTimeout(1000, function() TriggerEvent('lsv:start'..Utils.GetRandom(missionNames)) end)
						end
					end
				end
			end
		end
	end
end)