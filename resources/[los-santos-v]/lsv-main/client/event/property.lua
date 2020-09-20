local _titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local _playerColors = { Color.YELLOW, Color.GREY, Color.BROWN }
local _playerPositions = { '1st: ', '2nd: ', '3rd: ' }
local _instructionsText = 'Collect the briefcase and hold it for as long as possible for reward.'

local _propertyData = nil

local function createBriefcase(position)
	_propertyData.pickup = CreatePickupRotate(`PICKUP_MONEY_CASE`, position.x, position.y, position.z, 0.0, 0.0, 0.0, 8, 1)
	_propertyData.blip = Map.CreatePickupBlip(_propertyData.pickup, Blip.PICKUP_MONEY_CASE, nil, Color.BLIP_GREEN)
	SetBlipAsShortRange(_propertyData.blip, false)
	SetBlipScale(_propertyData.blip, 1.1)
end

local function removeBriefcase()
	if _propertyData.pickup then
		RemovePickup(_propertyData.pickup)
		_propertyData.pickup = nil

		RemoveBlip(_propertyData.blip)
		_propertyData.blip = nil
	end
end

local function getPlayerPoints()
	local player = table.ifind_if(_propertyData.players, function(player)
		return player.id == Player.ServerId()
	end)

	return player and player.points or nil
end

RegisterNetEvent('lsv:startHotProperty')
AddEventHandler('lsv:startHotProperty', function(data, passedTime)
	if _propertyData then
		return
	end

	-- Preparations
	_propertyData = { }

	_propertyData.startTime = GetGameTimer()
	if passedTime then
		_propertyData.startTime = _propertyData.startTime - passedTime
	end

	_propertyData.players = data.players

	World.HotPropertyPlayer = data.currentPlayer

	if not data.currentPlayer then
		createBriefcase(data.position)
		SetBlipAlpha(_propertyData.blip, 0)
	end

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then
			Gui.StartEvent('Hot Property', _instructionsText)
		end

		if _propertyData.blip then
			SetBlipAlpha(_propertyData.blip, 255)
			Map.SetBlipFlashes(_propertyData.blip)
		end

		while true do
			Citizen.Wait(0)

			if not _propertyData then
				return
			end

			if Player.IsInFreeroam() then
				local eventObjectiveText = 'Collect the ~g~briefcase~w~ and hold on to it.'
				if World.HotPropertyPlayer then
					if World.HotPropertyPlayer == Player.ServerId() then
						eventObjectiveText = 'Hold on to the briefcase for as long as possible.'
					else
						eventObjectiveText = Gui.GetPlayerName(World.HotPropertyPlayer, '~w~')..'<C> has the ~r~briefcase~w~. Take it from him.</C>'
					end
				end
				Gui.DisplayObjectiveText(eventObjectiveText)

				if _propertyData.pickup then
					local pickupPosition = GetPickupCoords(_propertyData.pickup)
					DrawMarker(20, pickupPosition.x, pickupPosition.y, pickupPosition.z + 0.25, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.85, 0.85, 0.85, 114, 204, 114, 96, true, true)
				end

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.property.duration - GetGameTimer() + _propertyData.startTime), 1)
				Gui.DrawBar('YOUR SCORE', getPlayerPoints() or 0, 2)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					local data = _propertyData.players[i]
					if data then
						Gui.DrawBar(_playerPositions[i]..GetPlayerName(GetPlayerFromServerId(data.id)), data.points, barPosition, _playerColors[i], true)
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

			if not _propertyData then
				return
			end

			if _propertyData.pickup and HasPickupBeenCollected(_propertyData.pickup) then
				TriggerServerEvent('lsv:hotPropertyCollected')
				removeBriefcase()
			end

			if World.HotPropertyPlayer == Player.ServerId() then
				local playerPed = PlayerPedId()

				if IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed) or (IsPedInAnyVehicle(playerPed) and GetEntityModel(GetVehiclePedIsIn(playerPed)) == `oppressor`) then
					TriggerServerEvent('lsv:hotPropertyDropped', Player.Position())
					World.HotPropertyPlayer = nil
				else
					if not pointTimer then
						pointTimer = Timer.New()
					elseif pointTimer:elapsed() >= 1000 then
						TriggerServerEvent('lsv:hotPropertyTimeUpdated')
						pointTimer:restart()
					end
				end
			else
				pointTimer = nil
			end
		end
	end)
end)

RegisterNetEvent('lsv:updateHotPropertyPlayers')
AddEventHandler('lsv:updateHotPropertyPlayers', function(players)
	if _propertyData then
		_propertyData.players = players
	end
end)

RegisterNetEvent('lsv:hotPropertyCollected')
AddEventHandler('lsv:hotPropertyCollected', function(player)
	if not _propertyData then
		return
	end

	removeBriefcase()

	World.HotPropertyPlayer = player
end)

RegisterNetEvent('lsv:hotPropertyDropped')
AddEventHandler('lsv:hotPropertyDropped', function(player, position)
	if not _propertyData then
		return
	end

	if not position then
		position = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
	end

	removeBriefcase()
	createBriefcase(position)

	World.HotPropertyPlayer = nil
end)

RegisterNetEvent('lsv:finishHotProperty')
AddEventHandler('lsv:finishHotProperty', function(winners)
	if not _propertyData then
		return
	end

	World.HotPropertyPlayer = nil

	removeBriefcase()

	if not winners then
		_propertyData = nil
		return
	end

	local playerTime = getPlayerPoints()
	_propertyData = nil

	local playerPosition = nil
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			playerPosition = i
			break
		end
	end

	local messageText = Gui.GetPlayerName(winners[1], '~p~')..' has won Hot Property.'
	if playerPosition then
		messageText = 'You have won Hot Property with a score of '..playerTime
	end

	if Player.IsInFreeroam() and playerTime then
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
