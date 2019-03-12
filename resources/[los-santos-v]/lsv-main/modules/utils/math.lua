function math.average(t)
	local sum = 0

	table.foreach(t, function(v) sum = sum + v end)

	return sum / table.length(t)
end