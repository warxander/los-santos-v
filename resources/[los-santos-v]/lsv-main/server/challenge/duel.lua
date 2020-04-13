local logger = Logger.New('Duel')

RegisterNetEvent('lsv:requestDuel')
AddEventHandler('lsv:requestDuel', function(opponent)
	local player = source

	if ChallengeManager.IsChallengeUnavailable(player, opponent) then
		return
	end

	logger:info('Requested { '..player..', '..opponent..' }')
	TriggerClientEvent('lsv:duelRequested', opponent, player)
end)

RegisterNetEvent('lsv:duelAccepted')
AddEventHandler('lsv:duelAccepted', function(opponent)
	local player = source

	if ChallengeManager.IsChallengeUnavailable(opponent, player) then
		return
	end

	ChallengeManager.Start(player, opponent)

	ChallengeManager.SetData(player, 'score', 0)
	ChallengeManager.SetData(player, 'opponentScore', 0)

	ChallengeManager.SetData(opponent, 'score', 0)
	ChallengeManager.SetData(opponent, 'opponentScore', 0)

	logger:info('Started { '..player..', '..opponent..' }')

	TriggerClientEvent('lsv:duelUpdated', player, ChallengeManager.GetData(player))
	TriggerClientEvent('lsv:duelUpdated', opponent, ChallengeManager.GetData(opponent))
end)

AddEventHandler('lsv:onPlayerKilled', function(killer)
	local victim = source

	if killer == -1 or not ChallengeManager.IsPlayerInChallenge(killer) or ChallengeManager.GetPlayerOpponent(killer) ~= victim then
		return
	end

	ChallengeManager.ModifyData(killer, 'score', 1)

	if ChallengeManager.GetData(killer, 'score') == Settings.duel.targetScore then
		local cash = -Settings.duel.reward.cash

		local victimCash = PlayerData.GetCash(victim)
		if victimCash - Settings.duel.reward.cash < 0 then
			cash = -victimCash
		end

		PlayerData.UpdateCash(victim, cash)
		PlayerData.UpdateCash(killer, Settings.duel.reward.cash)
		PlayerData.UpdateExperience(killer, Settings.duel.reward.exp)

		ChallengeManager.Finish(killer)

		logger:info('Ended { '..killer..', '..victim..' }')
		TriggerClientEvent('lsv:duelEnded', -1, killer, victim)

		return
	end

	ChallengeManager.ModifyData(victim, 'opponentScore', 1)

	TriggerClientEvent('lsv:duelUpdated', killer, ChallengeManager.GetData(killer))
	TriggerClientEvent('lsv:duelUpdated', victim, ChallengeManager.GetData(victim))
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not ChallengeManager.IsPlayerInChallenge(player) then
		return
	end

	local opponent = ChallengeManager.GetPlayerOpponent(player)
	ChallengeManager.Finish(player)

	logger:info('Ended { '..player..', '..opponent..' }')
	TriggerClientEvent('lsv:duelEnded', opponent)
end)
