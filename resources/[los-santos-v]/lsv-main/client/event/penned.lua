local _instructionsText = 'Achieve the highest number of driveby kills on players.'
local _titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local _playerColors = { Color.YELLOW, Color.GREY, Color.BROWN }
local _playerPositions = { '1st: ', '2nd: ', '3rd: ' }

local _pennedData = nil

local function getPlayerPoints()
	local player = table.ifind_if(_pennedData.players, function(player)
		return player.id == Player.ServerId()
	end)

	return player and player.points or nil
end

RegisterNetEvent('lsv:startPennedIn')
AddEventHandler('lsv:startPennedIn', function(data, passedTime)
	if _pennedData then
		return
	end

	-- Preparations
	_pennedData = { }

	_pennedData.startTime = GetGameTimer()
	if passedTime then
		_pennedData.startTime = _pennedData.startTime - passedTime
	end

	_pennedData.players = data.players

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then
			Gui.StartEvent('Penned In', _instructionsText)
		end

		while true do
			Citizen.Wait(0)

			if not _pennedData then
				return
			end

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText(_instructionsText)

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.penned.duration - GetGameTimer() + _pennedData.startTime), 1)
				Gui.DrawBar('YOUR SCORE', getPlayerPoints() or 0, 2)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					local data = _pennedData.players[i]
					if data then
						Gui.DrawBar(_playerPositions[i]..GetPlayerName(GetPlayerFromServerId(data.id)), data.points, barPosition, _playerColors[i], true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)
end)

RegisterNetEvent('lsv:updatePennedInPlayers')
AddEventHandler('lsv:updatePennedInPlayers', function(players)
	if _pennedData then
		_pennedData.players = players
	end
end)

RegisterNetEvent('lsv:finishPennedIn')
AddEventHandler('lsv:finishPennedIn', function(winners)
	if not _pennedData then
		return
	end

	if not winners then
		_pennedData = nil
		return
	end

	local playerPoints = getPlayerPoints()
	_pennedData = nil

	local playerPosition = nil
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			playerPosition = i
			break
		end
	end

	local messageText = playerPosition and 'You have won Penned In with a score of '..playerPoints or Gui.GetPlayerName(winners[1], '~p~')..' has won Penned In.'

	if Player.IsInFreeroam() and playerPoints then
		if playerPosition then
			PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else
			PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
		end

		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', playerPosition and _titles[playerPosition] or 'YOU LOSE', messageText, 21)
		scaleform:renderFullscreenTimed(10000)
	else
		Gui.DisplayNotification(messageText)
	end
end)
