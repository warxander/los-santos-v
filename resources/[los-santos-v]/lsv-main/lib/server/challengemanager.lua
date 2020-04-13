ChallengeManager = { }

local logger = Logger.New('ChallengeManager')

local players = { }


function ChallengeManager.Start(player, opponent)
	if players[player] or players[opponent] then
		return
	end

	players[player] = { opponent = opponent }
	players[opponent] = { opponent = player }
end

function ChallengeManager.Finish(player)
	if not players[player] then
		return
	end

	local opponent = players[player]
	players[player] = nil
	players[opponent] = nil
end

function ChallengeManager.GetPlayerOpponent(player)
	return players[player].opponent
end

function ChallengeManager.IsPlayerInChallenge(player)
	return players[player]
end

function ChallengeManager.GetData(player, id)
	if not id then
		return players[player]
	else
		return players[player][id]
	end
end

function ChallengeManager.ModifyData(player, id, valueDiff, defaultValue)
	if not players[player] then
		return
	end

	if not players[player][id] then
		if defaultValue then
			players[player][id] = defaultValue
		end

		return
	end

	players[player][id] = players[player][id] + valueDiff
end


function ChallengeManager.SetData(player, id, value)
	if not players[player] then
		return
	end

	players[player][id] = value
end

function ChallengeManager.IsChallengeUnavailable(player, opponent)
	local message = nil

	if not PlayerData.IsExists(opponent) then message = 'Your opponent is not available.'

	elseif MissionManager.IsPlayerOnMission(player) then message = 'You are doing mission right now.'
	elseif MissionManager.IsPlayerOnMission(opponent) then message = 'Your opponent is doing mission right now.'

	elseif ChallengeManager.IsPlayerInChallenge(player) then message = 'You are challenging right now.'
	elseif ChallengeManager.IsPlayerInChallenge(opponent) then message = 'Your opponent is challenging right now.' end

	if message then
		TriggerClientEvent('lsv:challengeRejected', player, message)
	end

	return message
end
