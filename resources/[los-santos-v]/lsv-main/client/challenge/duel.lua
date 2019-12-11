local challengeName = 'One on One Deathmatch'

local duelData = nil


RegisterNetEvent('lsv:duelRequested')
AddEventHandler('lsv:duelRequested', function(opponent)
	ChallengeManager.Request(opponent, challengeName, 'lsv:duelAccepted')
end)


RegisterNetEvent('lsv:duelUpdated')
AddEventHandler('lsv:duelUpdated', function(data)
	if not duelData then
		World.ChallengingPlayer = data.opponent
		duelData = data

		Gui.StartChallenge(challengeName)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)

				if not duelData then return end

				if Player.IsActive() then
					Gui.DrawBar('TARGET SCORE', Settings.duel.targetScore, 1)
					Gui.DrawBar(GetPlayerName(GetPlayerFromServerId(duelData.opponent)), duelData.opponentScore, 2, Color.GetHudFromBlipColor(Color.BLIP_RED), true)
					Gui.DrawBar(GetPlayerName(PlayerId()), duelData.score, 3, Color.GetHudFromBlipColor(Color.BLIP_BLUE), true)
				end
			end
		end)
	else
		duelData.score = data.score
		duelData.opponentScore = data.opponentScore
	end
end)


RegisterNetEvent('lsv:duelEnded')
AddEventHandler('lsv:duelEnded', function(winner, looser)
	if not ChallengeManager.Finish(winner, looser, challengeName) then return end

	duelData = nil
end)
