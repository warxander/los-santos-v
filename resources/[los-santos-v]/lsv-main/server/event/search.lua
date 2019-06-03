local logger = Logger:CreateNamedLogger('ExecutiveSearch')

local searchData = nil


AddEventHandler('lsv:startExecutiveSearch', function()
	searchData = { }
	searchData.target = nil
	searchData.placeIndex = math.random(#Settings.executiveSearch.places)
	searchData.eventStartTime = Timer.New()

	logger:Info('Start { '..searchData.placeIndex..' }')

	TriggerClientEvent('lsv:startExecutiveSearch', -1, searchData)

	while true do
		Citizen.Wait(0)

		if not searchData then return end

		local winner = nil
		if searchData.eventStartTime:Elapsed() >= Settings.executiveSearch.duration then
			if searchData.target then
				logger:Info('Target won')
				Db.UpdateCash(searchData.target, Settings.executiveSearch.reward.cash)
				Db.UpdateExperience(searchData.target, Settings.executiveSearch.reward.exp)
				TriggerClientEvent('lsv:finishExecutiveSearch', -1, searchData.target, searchData.target)
				winner = searchData.target
			else
				logger:Info('No target')
				TriggerClientEvent('lsv:finishExecutiveSearch', -1)
			end

			searchData = nil
			EventManager.StopEvent(winner)
			return
		end
	end
end)


RegisterNetEvent('lsv:onExecutiveSearchAreaEntered')
AddEventHandler('lsv:onExecutiveSearchAreaEntered', function()
	if not searchData or searchData.target then return end
	local player = source
	logger:Info('Target { '..player..' }')
	searchData.target = player
	TriggerClientEvent('lsv:onExecutiveSearchAreaEntered', -1, searchData.target)
end)


RegisterNetEvent('lsv:onExecutiveSearchAreaLeft')
AddEventHandler('lsv:onExecutiveSearchAreaLeft', function()
	if not searchData then return end
	local player = source
	if not searchData.target or searchData.target ~= player then
		logger:Error('Unexpected behavior')
		searchData = nil
		TriggerClientEvent('lsv:finishExecutiveSearch', -1)
		EventManager.StopEvent()
	end
	logger:Info('Target left area')
	searchData = nil
	TriggerClientEvent('lsv:finishExecutiveSearch', -1)
	EventManager.StopEvent()
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not searchData then return end
	TriggerClientEvent('lsv:startExecutiveSearch', player, searchData, searchData.eventStartTime:Elapsed())
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not searchData or not searchData.target or searchData.target ~= player then return end
	logger:Info('Target left')
	searchData = nil
	TriggerClientEvent('lsv:finishExecutiveSearch', -1)
	EventManager.StopEvent()
end)


AddEventHandler('baseevents:onPlayerDied', function()
	local player = source
	if not searchData or not searchData.target or searchData.target ~= player then return end
	logger:Info('Died { '..player..' }')
	searchData = nil
	TriggerClientEvent('lsv:finishExecutiveSearch', -1, player)
	EventManager.StopEvent()
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source
	if not searchData or not searchData.target or searchData.target ~= victim then return end
	logger:Info('Killed { '..killer..' }')
	Db.UpdateCash(killer, Settings.executiveSearch.reward.cash)
	Db.UpdateExperience(killer, Settings.executiveSearch.reward.exp)
	searchData = nil
	TriggerClientEvent('lsv:finishExecutiveSearch', -1, victim, killer)
	EventManager.StopEvent(killer)
end)