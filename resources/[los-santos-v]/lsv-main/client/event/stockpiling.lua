local instructionsText = 'Compete to collect the most checkpoints in the given time.'
local titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local playerColors = { Color.BlipYellow(), Color.BlipGrey(), Color.BlipBrown() }
local playerPositions = { '1st: ', '2nd: ', '3rd: ' }
local markerColor = Color.GetHudFromBlipColor(Color.BlipYellow())

local stockData = nil

local function getPlayerPoints()
	local player = table.find_if(stockData.players, function(player)
		return player.id == Player.ServerId()
	end)
	if not player then return nil end
	return player.points
end


RegisterNetEvent('lsv:startStockPiling')
AddEventHandler('lsv:startStockPiling', function(data, passedTime)
	if stockData then return end

	-- Preparations
	stockData = { }

	stockData.startTime = GetGameTimer()
	if passedTime then stockData.startTime = stockData.startTime - passedTime end
	stockData.players = data.players

	stockData.checkPoints = data.checkPoints
	table.iforeach(stockData.checkPoints, function(checkPoint)
		if checkPoint.picked then return end
		checkPoint.blip = Map.CreateEventBlip(Blip.Checkpoint(), checkPoint.position.x, checkPoint.position.y, checkPoint.position.z, 'Checkpoint', Color.BlipYellow())
		Map.SetBlipFlashes(checkPoint.blip)
	end)
	stockData.totalCheckPoints = data.totalCheckPoints
	stockData.checkPointsCollected = data.checkPointsCollected

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then Gui.StartEvent('Stockpiling', instructionsText) end

		while true do
			Citizen.Wait(0)

			if not stockData then return end

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText('Collect the most ~y~checkpoints~w~.')

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.stockPiling.duration - GetGameTimer() + stockData.startTime))
				Gui.DrawBar('YOUR SCORE', getPlayerPoints() or 0)
				Gui.DrawBar('REMAINING', (stockData.totalCheckPoints - stockData.checkPointsCollected)..'/'..stockData.totalCheckPoints)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					if stockData.players[i] then
						Gui.DrawBar(playerPositions[i]..GetPlayerName(GetPlayerFromServerId(stockData.players[i].id)), stockData.players[i].points,
							Color.GetHudFromBlipColor(playerColors[i]), true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)

	-- Logic
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not stockData then return end

			local playerPosition = Player.Position(true)
			local checkPoint, index = table.ifind_if(stockData.checkPoints, function(checkPoint) return not checkPoint.picked and Vdist(playerPosition.x, playerPosition.y, playerPosition.z, checkPoint.position.x, checkPoint.position.y, checkPoint.position.z) <= Settings.stockPiling.radius end)
			if checkPoint then
				checkPoint.picked = true
				TriggerServerEvent('lsv:stockPilingCheckPointCollected', index)
			else
				table.iforeach(stockData.checkPoints, function(checkPoint)
					if checkPoint.picked then return end

					if IsSphereVisible(checkPoint.position.x, checkPoint.position.y, checkPoint.position.z, Settings.stockPiling.radius) then
						Gui.DrawPlaceMarker(checkPoint.position.x, checkPoint.position.y, checkPoint.position.z - 1, Settings.stockPiling.radius, markerColor.r, markerColor.g, markerColor.b, Settings.placeMarkerOpacity)
						DrawMarker(29, checkPoint.position.x, checkPoint.position.y, checkPoint.position.z + 1, 0., 0., 0., 0., 0.,0., 2.5, 2.5, 2.5, markerColor.r, markerColor.g, markerColor.b, Settings.placeMarkerOpacity, false, true)
					end
				end)
			end
		end
	end)
end)


RegisterNetEvent('lsv:updateStockPilingPlayers')
AddEventHandler('lsv:updateStockPilingPlayers', function(players, index, player)
	if not stockData then return end

	stockData.players = players

	if index then
		stockData.checkPoints[index].picked = true

		RemoveBlip(stockData.checkPoints[index].blip)
		stockData.checkPoints[index].blip = nil

		stockData.checkPointsCollected = stockData.checkPointsCollected + 1

		if player == Player.ServerId() then
			PlaySoundFrontend(-1, 'CHECKPOINT_AHEAD', 'HUD_MINI_GAME_SOUNDSET', false)
			Gui.DisplayPersonalNotification('You have collected a checkpoint.')
		end
	end
end)


RegisterNetEvent('lsv:finishStockPiling')
AddEventHandler('lsv:finishStockPiling', function(winners)
	if stockData then
		table.iforeach(stockData.checkPoints, function(checkPoint)
			if checkPoint.blip then RemoveBlip(checkPoint.blip) end
		end)
	end

	if not winners then
		stockData = nil
		return
	end

	local playerPoints = getPlayerPoints()
	stockData = nil

	local isPlayerWinner = false
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = isPlayerWinner and 'You have won Stockpiling with a score of '..playerPoints or Gui.GetPlayerName(winners[1], '~p~')..' has won Stockpiling.'

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