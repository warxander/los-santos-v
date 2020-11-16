EventScheduler = { }
EventScheduler.__index = EventScheduler

local logger = Logger.New('EventScheduler')

local _events = {
	{ id = 'GunGame', name = 'Gun Game' },
	-- { id = 'HuntTheBeast', name = 'Hunt the Beast' },
	{ id = 'Castle', name = 'King of the Castle' },
	{ id = 'StockPiling', name = 'Stockpiling' },
	{ id = 'SharpShooter', name = 'Sharpshooter' },
	{ id = 'HotProperty', name = 'Hot Property' },
	{ id = 'PennedIn', name = 'Penned In' },
	{ id = 'Highway', name = 'Highway' },
	{ id = 'SimeonExport', name = 'Simeon Export' },
	{ id = 'GangWars', name = 'Gang Wars' },
}

table.ishuffle(_events)

local _lastEventTimer = nil
local _isEventInProgress = false
local _currentEventIndex = 0

function EventScheduler.StopEvent()
	logger:info('Stopping '.._events[_currentEventIndex].name..' event')

	_lastEventTimer = Timer.New()
	TriggerClientEvent('lsv:updateLastEventTime', -1, _lastEventTimer:elapsed())

	_isEventInProgress = false
end

Citizen.CreateThread(function()
	while true do
		if not _lastEventTimer and not _isEventInProgress then
			_lastEventTimer = Timer.New()
		else
			Citizen.Wait(0)

			if not _isEventInProgress and _lastEventTimer:elapsed() >= Settings.event.interval and PlayerData.GetCount() >= Settings.event.minPlayers then
				_currentEventIndex = math.max(1, (_currentEventIndex + 1) % (#_events + 1))
				_isEventInProgress = true

				logger:info('Starting '.._events[_currentEventIndex].name..' event')
				TriggerEvent('lsv:start'.._events[_currentEventIndex].id)

				_lastEventTimer = nil
				TriggerClientEvent('lsv:updateLastEventTime', -1, _lastEventTimer)
			end
		end
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	if _lastEventTimer then
		TriggerClientEvent('lsv:updateLastEventTime', player, _lastEventTimer:elapsed())
	end
end)
