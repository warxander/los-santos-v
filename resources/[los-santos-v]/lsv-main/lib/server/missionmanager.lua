MissionManager = { }
MissionManager.__index = MissionManager

local logger = Logger.New('MissionManager')

local _players = { }

local _missionIds = { 'MostWanted', 'Headhunter', 'Velocity', 'AssetRecovery', 'Heist', 'Sightseer' }

local _missions = Settings.mission.places

function MissionManager.IsPlayerOnMission(player)
	return _players[player]
end

RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(id, name)
	local player = source
	if _players[player] then
		return
	end

	_players[player] = id
	logger:info('Start { '..player..', '..id..' }')
	TriggerClientEvent('lsv:missionStarted', -1, player, id, name)
end)

RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(success)
	local player = source
	if not _players[player] then
		return
	end

	if success then
		PlayerData.UpdateMissionsDone(player)
	end

	logger:info('Finish { '..player..', '.._players[player]..', '..tostring(success)..' }')
	_players[player] = nil
	TriggerClientEvent('lsv:missionFinished', -1, player)
end)

Citizen.CreateThread(function()
	local missions = { }
	table.iforeach(_missionIds, function(mission)
		table.insert(missions, mission)
	end)

	table.iforeach(_missions, function(mission)
		if #missions ~= 0 then
			local id, index = table.random(missions)
			table.remove(missions, index)
			mission.id = id
		else
			mission.id = table.random(_missionIds)
		end
	end)

	while true do
		Citizen.Wait(Settings.mission.resetTimeInterval)
		logger:info('Reset')
		TriggerClientEvent('lsv:resetMissions', -1)
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:updateMissions', player, _missions, _players)
end)

AddEventHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
