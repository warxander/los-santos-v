function ms_to_string(ms)
	local seconds = ms / 1000
	return string.format('%02.f', math.floor(seconds / 60))..':'..string.format('%02.f', math.floor(seconds % 60))
end