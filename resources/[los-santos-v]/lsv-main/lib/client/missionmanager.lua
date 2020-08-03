MissionManager = { }
MissionManager.__index = MissionManager

MissionManager.Mission = nil

local _missionNames = {
	['MostWanted'] = 'Most Wanted',
	['Headhunter'] = 'Headhunter',
	['Velocity'] = 'Velocity',
	['AssetRecovery'] = 'Asset Recovery',
	['Heist'] = 'Heist',
	['Sightseer'] = 'Sightseer',
}

local _missionPlaces = Settings.mission.places

local _players = { }

local function finishMission(success)
	if not success and _missionPlaces[MissionManager.Mission] then
		_missionPlaces[MissionManager.Mission].finished = false
		SetBlipColour(_missionPlaces[MissionManager.Mission].blip, Color.BLIP_BLUE)
	end

	MissionManager.Mission = nil
end

function MissionManager.StartMission(id, name)
	if MissionManager.Mission then
		return
	end

	MissionManager.Mission = id
	TriggerServerEvent('lsv:missionStarted', id, name)
end

function MissionManager.AbortMission()
	if not MissionManager.Mission then
		return
	end

	TriggerEvent('lsv:finish'..MissionManager.Mission)
end

function MissionManager.FinishMission(success)
	if not MissionManager.Mission then
		return
	end

	TriggerServerEvent('lsv:missionFinished', success)
	finishMission(success)
end

function MissionManager.IsPlayerOnMission(player)
	return _players[player]
end

RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(player, id, name)
	_players[player] = id

	if player ~= Player.ServerId() then
		FlashMinimapDisplay()
		local missionName = name or _missionNames[id]
		Gui.DisplayNotification(Gui.GetPlayerName(player)..' has started '..missionName..'. Kill him to earn reward.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
	end
end)

RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(player)
	_players[player] = nil
end)

RegisterNetEvent('lsv:updateMissions')
AddEventHandler('lsv:updateMissions', function(missions, players)
	table.iforeach(_missionPlaces, function(mission, i)
		mission.id = missions[i].id
		mission.blip = Map.CreatePlaceBlip(Blip.MISSION, mission.x, mission.y, mission.z, _missionNames[mission.id], Color.BLIP_BLUE)
		mission.finished = false
	end)

	if players then
		table.foreach(players, function(_, player)
			_players[player] = true
		end)
	end
end)

RegisterNetEvent('lsv:resetMissions')
AddEventHandler('lsv:resetMissions', function()
	table.iforeach(_missionPlaces, function(mission)
		if mission.finished then
			mission.finished = false
			SetBlipColour(mission.blip, Color.BLIP_BLUE)
		end
	end)
end)

AddEventHandler('lsv:init', function()
	local closestMissionBlip = nil
	local missionColor = Color.BLUE

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = Player.Position()
		local closestBlip = nil
		local closestBlipDistance = nil

		table.iforeach(_missionPlaces, function(mission)
			SetBlipAlpha(mission.blip, isPlayerInFreeroam and 255 or 0)

			if isPlayerInFreeroam and not mission.finished then
				local missionDistance = World.GetDistance(mission, playerPosition, true)

				if not closestBlipDistance or missionDistance < closestBlipDistance then
					closestBlipDistance = missionDistance
					closestBlip = mission.blip
				end

				Gui.DrawPlaceMarker(mission, missionColor)

				if missionDistance < Settings.placeMarker.radius then
					Gui.DisplayHelpText('Press ~INPUT_TALK~ to start '.._missionNames[mission.id]..'.')

					if IsControlJustReleased(0, 46) then
						mission.finished = true
						SetBlipColour(mission.blip, Color.BLIP_GREY)

						MissionManager.StartMission(mission.id)
						TriggerEvent('lsv:start'..mission.id)
					end
				end
			end
		end)

		if closestBlip then
			if closestMissionBlip ~= closestBlip then
				if closestMissionBlip then
					SetBlipAsShortRange(closestMissionBlip, true)
				end

				SetBlipAsShortRange(closestBlip, false)
				closestMissionBlip = closestBlip
			end
		end
	end
end)

AddEventHandler('lsv:playerDisconnected', function(_, player)
	_players[player] = nil
end)
