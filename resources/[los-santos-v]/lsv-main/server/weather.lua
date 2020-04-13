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

		if _weather == 'THUNDER' then
			_weather = 'RAIN'
		elseif _weather == 'RAIN' then
			_weather = 'CLEARING'
		else
			_weather = Settings.weather.types[math.random(weatherCount)]
		end

		TriggerClientEvent('lsv:updateWeather', -1, _weather)
		logger:info('Setting weather to '.._weather)
	end
end)

AddSignalHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:updateWeather', player, _weather)
end)
