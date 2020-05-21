function string.from_ms(ms, highAccuracy)
	local roundMs = ms / 1000

	local minutes = math.floor(roundMs / 60)
	local seconds = math.floor(roundMs % 60)

	local result = string.format('%02.f', minutes)..':'..string.format('%02.f', math.floor(seconds))
	if highAccuracy then
		result = result..'.'..string.format('%02.f', math.floor((ms - (minutes * 60000) - (seconds * 1000)) / 10))
	end

	return result
end
