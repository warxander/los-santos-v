EventManager = { }

local logger = Logger.New('Event')

local events = { 'HuntTheBeast', 'Castle', 'StockPiling', 'SharpShooter',  'HotProperty' }
local eventNames = { 'Hunt the Beast', 'King of the Castle', 'Stockpiling', 'Sharpshooter',  'Hot Property' }
local eventIndex = 0
local eventVotes = { }
local votedPlayers = { }

local isEventInProgress = false

local eventFinishedTime = nil


local function getNextEventIndex()
	local nextEvent = nil
	local maxVotes = 0
	for i, votes in pairs(eventVotes) do
		if votes > maxVotes then
			nextEvent = i
			maxVotes = votes
		end
	end

	return nextEvent or math.max(1, (eventIndex + 1) % (#events + 1))
end


function EventManager.StopEvent(winners)
	logger:Info('Stopping '..events[eventIndex]..' event')

	eventFinishedTime = Timer.New()
	TriggerClientEvent('lsv:eventFinishedTimeUpdated', -1, eventFinishedTime:Elapsed())

	isEventInProgress = false
	if not winners then return end
	if type(winners) == 'table' then
		table.foreach(winners, function(winner)
			Crate.TrySpawn(winner)
		end)
	else Crate.TrySpawn(winners) end
end


Citizen.CreateThread(function()
	while true do
		if not eventFinishedTime and not isEventInProgress then
			eventFinishedTime = Timer.New()
		else
			Citizen.Wait(0)

			if not isEventInProgress and eventFinishedTime:Elapsed() >= Settings.event.timeout and Scoreboard.GetPlayersCount() >= Settings.event.minPlayers then
				eventIndex = getNextEventIndex()
				isEventInProgress = true
				eventVotes = { }
				votedPlayers = { }
				logger:Info('Starting '..events[eventIndex]..' event')
				TriggerEvent('lsv:start'..events[eventIndex])

				eventFinishedTime = nil
				TriggerClientEvent('lsv:eventFinishedTimeUpdated', -1, eventFinishedTime)
			end
		end
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	if eventFinishedTime then
		TriggerClientEvent('lsv:eventFinishedTimeUpdated', player, eventFinishedTime:Elapsed())
	end
end)


RegisterCommand('eventvote', function(source, args)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local text = nil
	if not args[1] then
		text = 'Event list:'
		for i, eventName in ipairs(eventNames) do
			text = text..'\n'..i
			if i == eventIndex then text = text..'*' end
			text = text..' - '..eventName
			if eventVotes[i] then text = text..' ['..eventVotes[i]..']' end
		end
	else
		if votedPlayers[source] then
			text = 'You have already voted for ['..eventNames[votedPlayers[source]].. '].'
		else
			local vote = tonumber(args[1])
			if not vote or vote < 1 or vote > #events then
				text = 'Invalid Event ID. Please use /eventvote without arguments to see list of Events.'
			else
				if not eventVotes[vote] then eventVotes[vote] = 1 else eventVotes[vote] = eventVotes[vote] + 1 end
				votedPlayers[source] = vote
				text = 'You have voted for ['..eventNames[vote]..'].'
			end
		end
	end

	local message = {
		color = { 114, 204, 114 }, --TODO Copy-paste
		args = { text },
	}
	TriggerClientEvent('chat:addMessage', source, message)
end)
