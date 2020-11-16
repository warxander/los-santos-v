local logger = Logger.New('GangWars')

local _gangData = nil

local function getCrewIndexById(id)
	for i, v in pairs(_gangData.crews) do
		if v.id == id then
			return i
		end
	end

	return nil
end

local function sortCrewsByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

AddEventHandler('lsv:startGangWars', function()
	_gangData = { }

	_gangData.crews = { }
	_gangData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startGangWars', -1, _gangData)

	while true do
		Citizen.Wait(0)

		if not _gangData then
			return
		end

		if _gangData.eventStartTimer:elapsed() >= Settings.gangWars.duration then
			local winners = nil

			if #_gangData.crews ~= 0 then
				winners = { }
				local pointCash = nil
				local pointExp = nil

				table.iforeach(_gangData.crews, function(crewData, index)
					if index < 4 then
						logger:info('Winner { '..crewData.id..', '..index..' }')

						Crew.ForEachMember(crewData.id, function(member)
							PlayerData.UpdateCash(member, Settings.gangWars.rewards.top[index].cash, true)
							PlayerData.UpdateExperience(member, Settings.gangWars.rewards.top[index].exp, true)
							PlayerData.GiveDrugBusinessSupply(member)
							PlayerData.UpdateEventsWon(member)
						end)

						table.insert(winners, crewData.id)
						pointCash = math.floor(Settings.gangWars.rewards.top[index].cash / crewData.points)
						pointExp = math.floor(Settings.gangWars.rewards.top[index].exp / crewData.points)
					else
						Crew.ForEachMember(crewData.id, function(member)
							PlayerData.UpdateCash(member, crewData.points * pointCash, true)
							PlayerData.UpdateExperience(member, crewData.points * pointExp, true)
						end)
					end
				end)
			else
				logger:info('No winners')
			end

			_gangData = nil
			TriggerClientEvent('lsv:finishGangWars', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerKilled', function(killData)
	local victim = source
	if not _gangData or not PlayerData.IsExists(killData.killer) or not PlayerData.IsExists(victim) or not PlayerData.GetCrewLeader(victim) then
		return
	end

	local leader = PlayerData.GetCrewLeader(killData.killer)
	if not leader then
		return
	end

	local crewIndex = getCrewIndexById(leader)
	if not crewIndex then
		table.insert(_gangData.crews, { id = leader, points = 1 })
	else
		_gangData.crews[crewIndex].points = _gangData.crews[crewIndex].points + 1
	end

	table.sort(_gangData.crews, sortCrewsByPoints)
	TriggerClientEvent('lsv:updateGangWarsCrews', -1, _gangData.crews)
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _gangData then
		return
	end

	TriggerClientEvent('lsv:startGangWars', player, _gangData, _gangData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:crewDisbanded', function(leader)
	if not _gangData then
		return
	end

	local crewIndex = getCrewIndexById(leader)
	if not crewIndex then
		return
	end

	table.remove(_gangData.crews, crewIndex)
	table.sort(_gangData.crews, sortCrewsByPoints)
	TriggerClientEvent('lsv:updateGangWarsCrews', -1, _gangData.crews)
end)
