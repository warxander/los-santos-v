local _titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local _instructionsText = 'Hold the Castle area by yourself to become the King and earn reward.'
local _playerColors = { Color.YELLOW, Color.GREY, Color.BROWN }
local _playerPositions = { '1st: ', '2nd: ', '3rd: ' }

local _castleData = nil

local function getPlayerPoints()
	local player = table.find_if(_castleData.players, function(player)
		return player.id == Player.ServerId()
	end)

	if not player then
		return nil
	end

	return player.points
end

RegisterNetEvent('lsv:startCastle')
AddEventHandler('lsv:startCastle', function(data, passedTime)
	if _castleData then
		return
	end

	-- Preparations
	local place = Settings.castle.places[data.placeIndex]

	_castleData = { }

	_castleData.place = place

	_castleData.startTime = GetGameTimer()
	if passedTime then
		_castleData.startTime = _castleData.startTime - passedTime
	end

	_castleData.players = data.players

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then
			Gui.StartEvent('King of the Castle', _instructionsText)
		end

		_castleData.zoneBlip = Map.CreateRadiusBlip(place.x, place.y, place.z, Settings.castle.radius, Color.BLIP_PURPLE)
		_castleData.blip = Map.CreateEventBlip(Blip.CASTLE, place.x, place.y, place.z, nil, Color.BLIP_PURPLE)
		Map.SetBlipFlashes(_castleData.blip)

		while true do
			Citizen.Wait(0)

			if not _castleData then
				return
			end

			SetBlipAlpha(_castleData.blip, MissionManager.Mission and 0 or 255)
			SetBlipAlpha(_castleData.zoneBlip, MissionManager.Mission and 0 or 128)

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText(Player.DistanceTo(_castleData.place, true) <= Settings.castle.radius and
					'Defend the ~p~Castle area~w~.' or 'Enter the ~p~Castle area~w~ to become the King.')

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.castle.duration - GetGameTimer() + _castleData.startTime), 1)
				Gui.DrawBar('YOUR SCORE', getPlayerPoints() or 0, 2)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					if _castleData.players[i] then
						Gui.DrawBar(_playerPositions[i]..GetPlayerName(GetPlayerFromServerId(_castleData.players[i].id)), _castleData.players[i].points,
							barPosition, _playerColors[i], true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)

	-- Logic
	Citizen.CreateThread(function()
		local pointTimer = nil

		while true do
			Citizen.Wait(0)

			if not _castleData then
				return
			end

			if Player.IsActive() then
				if Player.DistanceTo(_castleData.place, true) <= Settings.castle.radius then
					if not pointTimer then
						pointTimer = Timer.New()
					elseif pointTimer:elapsed() >= 1000 then
						TriggerServerEvent('lsv:castleAddPoint')
						pointTimer:restart()
					end
				end
			end
		end
	end)
end)

RegisterNetEvent('lsv:updateCastlePlayers')
AddEventHandler('lsv:updateCastlePlayers', function(players)
	if _castleData then
		_castleData.players = players
	end
end)

RegisterNetEvent('lsv:finishCastle')
AddEventHandler('lsv:finishCastle', function(winners)
	if not _castleData then
		return
	end

	RemoveBlip(_castleData.blip)
	RemoveBlip(_castleData.zoneBlip)

	if not winners then
		_castleData = nil
		return
	end

	local playerPoints = getPlayerPoints()
	_castleData = nil

	local isPlayerWinner = false
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = isPlayerWinner and 'You have won King of the Castle with a score of '..playerPoints or Gui.GetPlayerName(winners[1], '~p~')..' has become the King of the Castle.'

	if Player.IsInFreeroam() and playerPoints then
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
