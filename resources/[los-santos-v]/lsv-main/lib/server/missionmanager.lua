MissionManager = { }
MissionManager.__index = MissionManager

local logger = Logger.New('MissionManager')

local _players = { }

local _missionNames = { 'Most Wanted', 'Headhunter', 'Velocity', 'Asset Recovery', 'Heist' }
local _missions = Settings.mission.places

function MissionManager.IsPlayerOnMission(player)
	return table.ifind(_players, player)
end

RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(missionName)
	local player = source

	if not _players[player] then
		_players[player] = missionName
		TriggerClientEvent('lsv:missionStarted', -1, player, missionName)
	end
end)

RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(success)
	local player = source
	if not _players[player] then
		return
	end

	local missionName = nil
	if success then
		missionName = _players[player]
		PlayerData.UpdateMissionsDone(player)
	end

	_players[player] = nil
	TriggerClientEvent('lsv:missionFinished', -1, player, missionName)

	if success then
		local playerFaction = PlayerData.GetFaction(player)
		if playerFaction ~= Settings.faction.Neutral then
			PlayerData.ForEach(function(data)
				if data.id ~= player and data.faction == playerFaction then
					PlayerData.UpdateCash(data.id, Settings.mission.factionRewards.cash)
					PlayerData.UpdateExperience(data.id, Settings.mission.factionRewards.exp)
				end
			end)
		end
	elseif success == false then
		PlayerData.UpdateCash(player, Settings.mission.failedRewards.cash)
		PlayerData.UpdateExperience(player, Settings.mission.failedRewards.exp)
	end
end)

Citizen.CreateThread(function()
	while true do
		logger:info('Reset missions')

		local missionNames = { }
		table.iforeach(_missionNames, function(name)
			table.insert(missionNames, name)
		end)

		table.iforeach(_missions, function(mission)
			if #missionNames ~= 0 then
				local name, index = table.random(missionNames)
				table.remove(missionNames, index)
				mission.name = name
			else
				mission.name = table.random(_missionNames)
			end
		end)

		TriggerClientEvent('lsv:updateMissions', -1, _missions)

		Citizen.Wait(Settings.mission.resetTimeInterval)
	end
end)

AddSignalHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:updateMissions', player, _missions, _players)
end)

AddSignalHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
