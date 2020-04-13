function string.from_ms(ms)
	local seconds = ms / 1000
	return string.format('%02.f', math.floor(seconds / 60))..':'..string.format('%02.f', math.floor(seconds % 60))
end
