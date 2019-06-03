EventManager = { }

local logger = Logger:CreateNamedLogger('Event')

local events = { 'SharpShooter', 'StockPiling', 'ExecutiveSearch', 'HotProperty', 'Castle' }
local eventIndex = 0
local isEventInProgress = false

local eventFinishedTime = nil


function EventManager.StopEvent(winners)
	logger:Info('Stopping '..events[eventIndex]..' event')
	eventFinishedTime:Restart()
	isEventInProgress = false
	if not winners then return end
	if type(winners) == 'table' then
		table.foreach(winners, function(winner)
			Crate.TrySpawn(winner)
		end)
	else Crate.TrySpawn(winners) end
end


Citizen.CreateThread(function()
	eventFinishedTime = Timer.New()

	while true do
		Citizen.Wait(Settings.event.timeout)

		if eventFinishedTime:Elapsed() < Settings.event.timeout then Citizen.Wait(Settings.event.timeout - eventFinishedTime:Elapsed()) end

		if not isEventInProgress and Scoreboard.GetPlayersCount() >= Settings.event.minPlayers then
			eventIndex = eventIndex + 1
			if eventIndex > #events then eventIndex = 1 end
			isEventInProgress = true
			logger:Info('Starting '..events[eventIndex]..' event')
			TriggerEvent('lsv:start'..events[eventIndex])
		end
	end
end)