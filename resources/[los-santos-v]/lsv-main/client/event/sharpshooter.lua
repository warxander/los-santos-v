local instructionsText = 'Compete to the most headshots in the given time.'
local titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local playerColors = { Color.BlipYellow(), Color.BlipGrey(), Color.BlipBrown() }
local playerPositions = { '1st: ', '2nd: ', '3rd: ' }

local sharpShooterData = nil

local function getPlayerPoints()
	local player = table.find_if(sharpShooterData.players, function(player)
		return player.id == Player.ServerId()
	end)
	if not player then return nil end
	return player.points
end


RegisterNetEvent('lsv:startSharpShooter')
AddEventHandler('lsv:startSharpShooter', function(data, passedTime)
	if sharpShooterData then return end

	-- Preparations
	sharpShooterData = { }

	sharpShooterData.startTime = GetGameTimer()
	if passedTime then sharpShooterData.startTime = sharpShooterData.startTime - passedTime end
	sharpShooterData.players = data.players

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then Gui.StartEvent('Sharpshooter', instructionsText) end

		while true do
			Citizen.Wait(0)

			if not sharpShooterData then return end

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText('Compete to the most headshots.')

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.sharpShooter.duration - GetGameTimer() + sharpShooterData.startTime))
				Gui.DrawBar('YOUR SCORE', getPlayerPoints() or 0)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					if sharpShooterData.players[i] then
						Gui.DrawBar(playerPositions[i]..GetPlayerName(GetPlayerFromServerId(sharpShooterData.players[i].id)), sharpShooterData.players[i].points,
							Color.GetHudFromBlipColor(playerColors[i]), true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)
end)


RegisterNetEvent('lsv:updateSharpShooterPlayers')
AddEventHandler('lsv:updateSharpShooterPlayers', function(players)
	if sharpShooterData then sharpShooterData.players = players end
end)


RegisterNetEvent('lsv:finishSharpShooter')
AddEventHandler('lsv:finishSharpShooter', function(winners)
	if not winners then
		sharpShooterData = nil
		return
	end

	local playerPoints = getPlayerPoints()
	sharpShooterData = nil

	local isPlayerWinner = false
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = isPlayerWinner and 'You have won Sharpshooter with a score of '..playerPoints or Gui.GetPlayerName(winners[1], '~p~')..' has won Sharpshooter.'

	if Player.IsInFreeroam() and playerPoints then
		if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and titles[isPlayerWinner] or 'YOU LOSE', messageText, 21)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	else
		Gui.DisplayNotification(messageText)
	end
end)