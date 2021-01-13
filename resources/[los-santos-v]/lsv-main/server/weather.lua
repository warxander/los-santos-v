local logger = Logger.New('Weather')

local _weather = nil

Citizen.CreateThread(function()
	local weatherCount = #Settings.weather.types

	_weather = Settings.weather.types[math.random(weatherCount)]

	if weatherCount == 1 then
		return
	end

	while true do
		Citizen.Wait(math.random(Settings.weather.interval.min, Settings.weather.interval.max) * 60000)

		local weather = nil

		if _weather == 'THUNDER' then
			weather = 'RAIN'
		elseif _weather == 'RAIN' then
			weather = 'CLEARING'
		else
			weather = Settings.weather.types[math.random(weatherCount)]
		end

		if _weather ~= weather then
			logger:info('Setting weather to '.._weather)

			_weather = weather
			TriggerClientEvent('lsv:updateWeather', -1, _weather)
		end
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:updateWeather', player, _weather)
end)
