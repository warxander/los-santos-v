local logger = Logger:CreateNamedLogger('Bounty')

local bountyPlayerId = nil


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Settings.bountyEventTimeout)

		if not bountyPlayerId and Scoreboard.GetPlayersCount() > 1 then
			bountyPlayerId = Scoreboard.GetRandomPlayer()

			logger:Info('Set { '..GetPlayerName(bountyPlayerId)..', '..bountyPlayerId..' }')

			TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
		end
	end
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source

	if not bountyPlayerId or victim ~= bountyPlayerId then return end

	logger:Info('Killed { '..GetPlayerName(bountyPlayerId)..', '..bountyPlayerId..' }')

	bountyPlayerId = nil

	Db.UpdateMoney(killer, Settings.bountyEventReward, function()
		TriggerClientEvent('lsv:bountyKilled', -1, killer)
	end)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if player ~= bountyPlayerId then return end

	bountyPlayerId = nil

	TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
end)