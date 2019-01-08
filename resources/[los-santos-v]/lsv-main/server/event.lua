local logger = Logger:CreateNamedLogger('Event')

local events = { 'HotProperty', 'Castle' }
local eventIndex = 0
local isEventInProgress = false

local eventFinishedTime = nil


Citizen.CreateThread(function()
	eventFinishedTime = GetGameTimer()

	while true do
		Citizen.Wait(Settings.event.timeout)

		local timePassedSinceLastEvent = GetGameTimer() - eventFinishedTime
		if timePassedSinceLastEvent < Settings.event.timeout then Citizen.Wait(Settings.event.timeout - timePassedSinceLastEvent) end

		if not isEventInProgress and Scoreboard.GetPlayersCount() >= Settings.event.minPlayers then
			eventIndex = eventIndex + 1
			if eventIndex > #events then eventIndex = 1 end
			isEventInProgress = true
			logger:Info('Starting '..events[eventIndex]..' event')
			TriggerEvent('lsv:start'..events[eventIndex])
		end
	end
end)


AddEventHandler('lsv:onEventStopped', function()
	logger:Info('Stopping '..events[eventIndex]..' event')
	eventFinishedTime = GetGameTimer()
	isEventInProgress = false
end)