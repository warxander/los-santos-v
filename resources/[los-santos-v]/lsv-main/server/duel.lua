local duelingPlayers = { }

local logger = Logger:CreateNamedLogger('Duel')


local function validateDuelingPlayers(player, opponent)
	if not Scoreboard.IsPlayerOnline(opponent) then
		TriggerClientEvent('lsv:duelRejected', player, 'Duel is not available for selected opponent.')
		return false
	end

	if MissionManager.IsPlayerOnMission(player) then
		TriggerClientEvent('lsv:duelRejected', player, 'You are doing mission right now.')
		return false
	end

	if MissionManager.IsPlayerOnMission(opponent) then
		TriggerClientEvent('lsv:duelRejected', player, 'Your opponent is doing mission right now.')
		return false
	end

	if duelingPlayers[player] then
		TriggerClientEvent('lsv:duelRejected', player, 'You are already dueling.')
		return false
	end

	if duelingPlayers[opponent] then
		TriggerClientEvent('lsv:duelRejected', player, 'Your opponent is already dueling.')
		return false
	end

	return true
end


RegisterNetEvent('lsv:requestDuel')
AddEventHandler('lsv:requestDuel', function(opponent)
	local player = source

	if not validateDuelingPlayers(player, opponent) then return end

	logger:Info('Duel requested { '..player..', '..opponent..' }')

	TriggerClientEvent('lsv:duelRequested', opponent, player)
end)


RegisterNetEvent('lsv:duelAccepted')
AddEventHandler('lsv:duelAccepted', function(opponent)
	local player = source

	if not Scoreboard.IsPlayerOnline(opponent) or not validateDuelingPlayers(opponent, player) then return end

	logger:Info('Duel started { '..player..', '..opponent..' }')

	duelingPlayers[player] = { opponent = opponent, score = 0, opponentScore = 0 }
	duelingPlayers[opponent] = { opponent = player, score = 0, opponentScore = 0 }

	TriggerClientEvent('lsv:duelUpdated', player, duelingPlayers[player])
	TriggerClientEvent('lsv:duelUpdated', opponent, duelingPlayers[opponent])
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source

	if killer == -1 or not duelingPlayers[killer] or duelingPlayers[killer].opponent ~= victim then return end

	duelingPlayers[killer].score = duelingPlayers[killer].score + 1
	if duelingPlayers[killer].score == Settings.duel.targetScore then
		logger:Info('Duel ended { '..killer..', '..victim..' }')
		TriggerClientEvent('lsv:duelEnded', -1, killer, victim)
		Db.UpdateCash(victim, -Settings.duel.reward)
		Db.UpdateCash(killer, Settings.duel.reward)
		duelingPlayers[killer] = nil
		duelingPlayers[victim] = nil
		return
	end

	duelingPlayers[victim].opponentScore = duelingPlayers[victim].opponentScore + 1
	TriggerClientEvent('lsv:duelUpdated', killer, duelingPlayers[killer])
	TriggerClientEvent('lsv:duelUpdated', victim, duelingPlayers[victim])
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not duelingPlayers[player] then return end

	local opponent = duelingPlayers[player].opponent
	logger:Info('Duel ended { '..player..', '..opponent..' }')
	duelingPlayers[player] = nil
	duelingPlayers[opponent] = nil
	TriggerClientEvent('lsv:duelEnded', opponent)
end)