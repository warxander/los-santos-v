local _challengeName = 'One on One Deathmatch'

local _duelData = nil

RegisterNetEvent('lsv:duelRequested')
AddEventHandler('lsv:duelRequested', function(opponent)
	ChallengeManager.Request(opponent, _challengeName, 'lsv:duelAccepted')
end)

RegisterNetEvent('lsv:duelUpdated')
AddEventHandler('lsv:duelUpdated', function(data)
	if not _duelData then
		World.ChallengingPlayer = data.opponent
		_duelData = data

		Gui.StartChallenge(_challengeName)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)

				if not _duelData then
					return
				end

				if Player.IsActive() then
					Gui.DrawBar('TARGET SCORE', Settings.duel.targetScore, 1)
					Gui.DrawBar(GetPlayerName(GetPlayerFromServerId(_duelData.opponent)), _duelData.opponentScore, 2, Color.RED, true)
					Gui.DrawBar(GetPlayerName(PlayerId()), _duelData.score, 3, Color.BLUE, true)
				end
			end
		end)
	else
		_duelData.score = data.score
		_duelData.opponentScore = data.opponentScore
	end
end)

RegisterNetEvent('lsv:duelEnded')
AddEventHandler('lsv:duelEnded', function(winner, looser)
	if not winner or winner == Player.ServerId() or looser == Player.ServerId() then
		_duelData = nil
		World.ChallengingPlayer = nil
	end

	Gui.FinishChallenge(winner, looser, _challengeName)
end)
