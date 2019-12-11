MissionManager = { }


local logger = Logger.New('MissionManager')

local players = { }

local missionNames = { 'Most Wanted', 'Headhunter', 'Velocity', 'Asset Recovery', 'Market Manipulation' }
local missions = Settings.mission.places


function MissionManager.IsPlayerOnMission(player)
	return table.find(players, player)
end


Citizen.CreateThread(function()
	while true do
		logger:Info('Reset missions')

		table.iforeach(missions, function(mission)
			mission.name = table.random(missionNames)
		end)

		TriggerClientEvent('lsv:resetMissions', -1, missions)

		Citizen.Wait(Settings.mission.resetTimeInterval)
	end
end)


RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(missionName)
	local player = source
	if players[player] then return end
	players[player] = missionName
	TriggerClientEvent('lsv:missionStarted', -1, player, missionName)
end)


RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(success)
	local player = source
	if not players[player] then return end
	TriggerClientEvent('lsv:missionFinished', -1, player, players[player])
	players[player] = nil
	if success then Crate.TrySpawn(player)
	elseif success ~= nil then
		Db.UpdateCash(player, Settings.mission.failedRewards.cash)
		Db.UpdateExperience(player, Settings.mission.failedRewards.exp)
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:resetMissions', player, missions)
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)