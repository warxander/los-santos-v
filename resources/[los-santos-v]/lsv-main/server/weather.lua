local logger = Logger.New('Weather')

local weatherIndex = nil
local timer = Timer.New()


Citizen.CreateThread(function()
	local weatherCount = #Settings.weatherTypes
	weatherIndex = math.random(weatherCount)

	if weatherCount == 1 then
		return
	end

	timer:Restart()

	while true do
		Citizen.Wait(1000)

		if timer:Elapsed() >= Settings.weatherOverTime then
			weatherIndex = math.random(weatherCount)
			timer:Restart()

			TriggerClientEvent('lsv:weatherUpdated', -1, Settings.weatherTypes[weatherIndex])
			logger:Info('Setting weather to '..Settings.weatherTypes[weatherIndex])
		end
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:weatherUpdated', player, Settings.weatherTypes[weatherIndex])
end)
