local missionPlaces = { }
local missionIds = { 'MostWanted', 'Headhunter', 'Velocity', 'AssetRecovery', 'MarketManipulation' }
local missionNames = {
	['MostWanted'] = 'Most Wanted',
	['Headhunter'] = 'Headhunter',
	['Velocity'] = 'Velocity',
	['AssetRecovery'] = 'Asset Recovery',
	['MarketManipulation'] = 'Market Manipulation',
}


AddEventHandler('lsv:init', function()
	for _, place in ipairs(Settings.mission.places) do
		local mission = { }
		mission.startTime = nil
		mission.mission = Utils.GetRandom(missionIds)
		mission.blip = Map.CreatePlaceBlip(Blip.Mission(), place.x, place.y, place.z, missionNames[mission.mission], Color.BlipPurple())
		table.insert(missionPlaces, mission)
	end

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			for _, place in ipairs(missionPlaces) do
				local alpha = 255
				if JobWatcher.IsAnyJobInProgress() or place.startTime then alpha = 0 end
				SetBlipAlpha(place.blip, alpha)

				if place.startTime and GetTimeDifference(GetGameTimer(), place.startTime) >= Settings.mission.timeout then
					place.startTime = nil
					place.mission = Utils.GetRandom(missionIds)
					Map.SetBlipText(place.blip, missionNames[place.mission])
					Map.SetBlipFlashes(place.blip, 5000)
				end

				if not JobWatcher.IsAnyJobInProgress() then
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
					local placeX, placeY, placeZ = table.unpack(GetBlipCoords(place.blip))
					if not place.startTime and GetDistanceBetweenCoords(playerX, playerY, playerZ, placeX, placeY, placeZ, true) < Settings.placeMarkerRadius then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to start '..missionNames[place.mission]..'.')
						if IsControlJustReleased(0, 38) then
							place.startTime = GetGameTimer()
							SetBlipAlpha(place.blip, 0)
							SetTimeout(1000, function() TriggerEvent('lsv:start'..place.mission) end)
						end
					end
				end
			end
		end
	end
end)