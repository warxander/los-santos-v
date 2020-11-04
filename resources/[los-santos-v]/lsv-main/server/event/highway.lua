local logger = Logger.New('Highway')

local _highwayData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(_highwayData.players) do
		if v.id == id then
			return i
		end
	end

	return nil
end

local function sortPlayersBySpeed(l, r)
	if not l then return false end
	if not r then return true end

	return l.speed > r.speed
end

RegisterNetEvent('lsv:highwayNewSpeedRecord')
AddEventHandler('lsv:highwayNewSpeedRecord', function(speed)
	if not _highwayData then
		return
	end

	local player = source
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_highwayData.players, { id = player, speed = speed })
	elseif _highwayData.players[playerIndex].speed < speed then
		_highwayData.players[playerIndex].speed = speed
	end

	table.sort(_highwayData.players, sortPlayersBySpeed)
	TriggerClientEvent('lsv:updateHighwayPlayers', -1, _highwayData.players)
end)

AddEventHandler('lsv:startHighway', function()
	_highwayData = { }

	_highwayData.players = { }
	_highwayData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startHighway', -1, _highwayData)

	while true do
		Citizen.Wait(0)

		if not _highwayData then
			return
		end

		if _highwayData.eventStartTimer:elapsed() >= Settings.highway.duration then
			local winners = nil

			if #_highwayData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.highway.rewards do
					if _highwayData.players[i] then
						logger:info('Winner { '.._highwayData.players[i].id..', '.._highwayData.players[i].speed..' }')

						PlayerData.UpdateCash(_highwayData.players[i].id, Settings.highway.rewards[i].cash)
						PlayerData.UpdateExperience(_highwayData.players[i].id, Settings.highway.rewards[i].exp)
						PlayerData.GiveDrugBusinessSupply(_highwayData.players[i].id)
						PlayerData.UpdateEventsWon(_highwayData.players[i].id)

						table.insert(winners, _highwayData.players[i].id)
					else
						break
					end
				end
			else
				logger:info('No winners')
			end

			_highwayData = nil
			TriggerClientEvent('lsv:finishHighway', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _highwayData then
		return
	end

	TriggerClientEvent('lsv:startHighway', player, _highwayData, _highwayData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _highwayData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_highwayData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_highwayData.players, playerIndex)
	table.sort(_highwayData.players, sortPlayersBySpeed)
	TriggerClientEvent('lsv:updateHighwayPlayers', -1, _highwayData.players)
end)
