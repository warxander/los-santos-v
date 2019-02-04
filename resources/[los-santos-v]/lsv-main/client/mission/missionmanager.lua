MissionManager = { }

MissionManager.Mission = nil
MissionManager.MissionFinishedTime = 0


local missionIds = { 'MostWanted', 'Headhunter', 'Velocity', 'AssetRecovery', 'MarketManipulation' }
local missionNames = {
	['MostWanted'] = 'Most Wanted',
	['Headhunter'] = 'Headhunter',
	['Velocity'] = 'Velocity',
	['AssetRecovery'] = 'Asset Recovery',
	['MarketManipulation'] = 'Market Manipulation',
}
local players = { }


local function finishMission()
	MissionManager.Mission = nil
	MissionManager.MissionFinishedTime = GetGameTimer()
end


function MissionManager.StartMission(id)
	if MissionManager.Mission then return end
	MissionManager.Mission = id
	TriggerServerEvent('lsv:missionStarted', missionNames[id])
end


function MissionManager.FinishMission()
	if not MissionManager.Mission then return end
	TriggerServerEvent('lsv:missionFinished', missionNames[MissionManager.Mission])
	finishMission()
end


function MissionManager.CancelMission() -- Fix server memory leak (sic!)
	finishMission()
end


function MissionManager.IsPlayerOnMission(player)
	return players[player]
end


RegisterNetEvent('lsv:missionStarted')
AddEventHandler('lsv:missionStarted', function(player, missionName)
	if Player.ServerId() == player then return end

	players[player] = true

	FlashMinimapDisplay()
	Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has started '..missionName..'. Kill him to earn extra cash.')
	Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(player))))
end)


RegisterNetEvent('lsv:missionFinished')
AddEventHandler('lsv:missionFinished', function(player, missionName)
	if Player.ServerId() == player then return end

	if players[player] then
		Gui.DisplayNotification(Gui.GetPlayerName(player, '~p~')..' has finished '..missionName..'.')
		players[player] = nil
	end
end)


AddEventHandler('lsv:playerDisconnected', function(_, player)
	players[player] = nil
end)
