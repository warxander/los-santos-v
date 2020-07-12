local _instructionsText = 'Achieve the highest speed in a land vehicle.'
local _titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local _playerColors = { Color.YELLOW, Color.GREY, Color.BROWN }
local _playerPositions = { '1st: ', '2nd: ', '3rd: ' }

local _highwayData = nil

local function getPlayerSpeed()
	local player = table.find_if(_highwayData.players, function(player)
		return player.id == Player.ServerId()
	end)

	if not player then
		return nil
	end

	return player.speed
end

RegisterNetEvent('lsv:startHighway')
AddEventHandler('lsv:startHighway', function(data, passedTime)
	if _highwayData then
		return
	end

	-- Preparations
	_highwayData = { }

	_highwayData.startTime = GetGameTimer()
	if passedTime then
		_highwayData.startTime = _highwayData.startTime - passedTime
	end

	_highwayData.players = data.players
	_highwayData.currentAttempt = 0

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then
			Gui.StartEvent('Highway', _instructionsText)
		end

		while true do
			Citizen.Wait(0)

			if not _highwayData then
				return
			end

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText(_instructionsText)

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.highway.duration - GetGameTimer() + _highwayData.startTime), 1)
				Gui.DrawBar('YOUR BEST', string.to_speed(getPlayerSpeed() or 0), 2)
				Gui.DrawBar('CURRENT ATTEMPT', string.to_speed(_highwayData.currentAttempt), 3)

				local barPosition = 4
				for i = barPosition - 1, 1, -1 do
					if _highwayData.players[i] then
						Gui.DrawBar(_playerPositions[i]..GetPlayerName(GetPlayerFromServerId(_highwayData.players[i].id)), string.to_speed(_highwayData.players[i].speed),
							barPosition, _playerColors[i], true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)

	while true do
		Citizen.Wait(1000)

		if not _highwayData then
			return
		end

		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed) and not IsPedInAnyHeli(playerPed) and not IsPedInAnyPlane(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed)
			if not IsEntityInAir(vehicle) then
				local speed = GetEntitySpeed(vehicle)
				if speed ~= 0 and speed > _highwayData.currentAttempt then
					TriggerServerEvent('lsv:highwayNewSpeedRecord', speed)
				end

				_highwayData.currentAttempt = speed
			end
		end
	end
end)

RegisterNetEvent('lsv:updateHighwayPlayers')
AddEventHandler('lsv:updateHighwayPlayers', function(players)
	if _highwayData then
		_highwayData.players = players
	end
end)

RegisterNetEvent('lsv:finishHighway')
AddEventHandler('lsv:finishHighway', function(winners)
	if not _highwayData then
		return
	end

	if not winners then
		_highwayData = nil
		return
	end

	local playerSpeed = getPlayerSpeed()
	_highwayData = nil

	local isPlayerWinner = false
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = isPlayerWinner and 'You have won Highway with a score of '..string.to_speed(playerSpeed) or Gui.GetPlayerName(winners[1], '~p~')..' has won Highway.'

	if Player.IsInFreeroam() and playerSpeed then
		if isPlayerWinner then
			PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else
			PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
		end

		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and _titles[isPlayerWinner] or 'YOU LOSE', messageText, 21)
		scaleform:renderFullscreenTimed(10000)
	else
		Gui.DisplayNotification(messageText)
	end
end)
