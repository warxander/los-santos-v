MissionManager = { }

MissionManager.Mission = nil


local missionPlaces = Settings.mission.places

local players = { }


local function finishMission(success)
	if not success then
		missionPlaces[MissionManager.Mission].finished = false
		SetBlipColour(missionPlaces[MissionManager.Mission].blip, Color.BlipBlue())
	end

	MissionManager.Mission = nil
end


function MissionManager.StartMission(id)
	if MissionManager.Mission then return end
	MissionManager.Mission = id
	TriggerServerEvent('lsv:missionStarted', missionPlaces[id].name)
end


function MissionManager.FinishMission(success)
	if not MissionManager.Mission then return end
	TriggerServerEvent('lsv:missionFinished', success)
	finishMission(success)
end


function MissionManager.IsPlayerOnMission(player)
	return players[player]
end


AddEventHandler('lsv:init', function()
	local closestMissionBlip = nil

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = GetEntityCoords(PlayerPedId())
		local closestBlip = nil
		local closestBlipDistance = nil

		table.iforeach(missionPlaces, function(mission, id)
			if mission.name and isPlayerInFreeroam and not mission.finished then
				local missionDistance = GetDistanceBetweenCoords(mission.x, mission.y, mission.z, playerPosition.x, playerPosition.y, playerPosition.z, true)

				if not closestBlipDistance or missionDistance < closestBlipDistance then
					closestBlipDistance = missionDistance
					closestBlip = mission.blip
				end

				if missionDistance < Settings.placeMarkerRadius then
					Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to start '..mission.name..'.')
					if IsControlJustReleased(0, 38) then
						mission.finished = true
						SetBlipColour(mission.blip, Color.BlipGrey())
						MissionManager.StartMission(id)
						TriggerEvent('lsv:start'..string.gsub(mission.name, '%s+', ''))
					end
				end
			end
		end)

		if closestBlip then
			if closestMissionBlip ~= closestBlip then
				if closestMissionBlip then SetBlipAsShortRange(closestMissionBlip, true) end
				SetBlipAsShortRange(closestBlip, false)
				closestMissionBlip = closestBlip
			end
		end
	end
end)


RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(player, missionName)
	if Player.ServerId() == player then return end

	players[player] = true

	FlashMinimapDisplay()
	Gui.DisplayNotification(Gui.GetPlayerName(player)..' has started '..missionName..'. Kill him to earn reward.')
	Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
end)


RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(player, missionName)
	if Player.ServerId() == player then return end

	players[player] = nil
end)


RegisterNetEvent('lsv:resetMissions')
AddEventHandler('lsv:resetMissions', function(missions)
	table.iforeach(missionPlaces, function(mission, i)
		mission.name = missions[i].name
		mission.finished = false

		if not mission.blip then
			mission.blip = Map.CreatePlaceBlip(Blip.Mission(), mission.x, mission.y, mission.z, mission.name, Color.BlipBlue())
		else
			Map.SetBlipText(mission.blip, mission.name)
			SetBlipColour(Color.BlipBlue())
		end
	end)
end)


AddEventHandler('lsv:playerDisconnected', function(_, player)
	players[player] = nil
end)