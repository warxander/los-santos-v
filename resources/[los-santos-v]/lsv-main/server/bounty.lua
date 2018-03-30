local logger = Logger:CreateNamedLogger('Bounty')

local bountyPlayerId = nil
local eventFinishedTime = nil


Citizen.CreateThread(function()
	eventFinishedTime = GetGameTimer()

	while true do
		Citizen.Wait(Settings.bountyEventTimeout)

		local timePassedSinceLastEvent = GetGameTimer() - eventFinishedTime
		if timePassedSinceLastEvent < Settings.bountyEventTimeout then Citizen.Wait(Settings.bountyEventTimeout - timePassedSinceLastEvent) end

		if not bountyPlayerId and Scoreboard.GetPlayersCount() > 1 then
			bountyPlayerId = Scoreboard.GetRandomPlayer()

			logger:Info('Set { '..GetPlayerName(bountyPlayerId)..', '..bountyPlayerId..' }')

			TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
		end
	end
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source

	if not bountyPlayerId or victim ~= bountyPlayerId or killer == -1 then return end

	logger:Info('Killed { '..GetPlayerName(bountyPlayerId)..', '..bountyPlayerId..' }')

	bountyPlayerId = nil
	eventFinishedTime = GetGameTimer()

	Db.UpdateRP(killer, Settings.bountyEventReward, function()
		TriggerClientEvent('lsv:bountyKilled', -1, killer)
	end)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if bountyPlayerId ~= nil then TriggerClientEvent('lsv:setBounty', player, bountyPlayerId) end
end)


AddEventHandler('lsv:playerDropped', function(player)
	if player ~= bountyPlayerId then return end

	bountyPlayerId = nil

	TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
end)