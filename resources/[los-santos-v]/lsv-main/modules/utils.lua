function table.length(t)
	local length = 0
	for _ in pairs(t) do length = length + 1 end
	return length
end


function table.foreach(t, func)
	for k, v in pairs(t) do func(v ,k) end
end


function table.random(t)
	local keys = { }
	table.foreach(t, function(_, k) table.insert(keys, k) end)
	local i = keys[math.random(#keys)]
	return t[i], i
end


function table.find(t, value)
	for k, v in pairs(t) do
		if v == value then return k, v end
	end
	return nil
end


function table.try_remove(t, value)
	local k = table.find(t, value)
	if k then
		table.remove(t, k)
		return true
	end

	return false
end


function table.find_if(t, func)
	for k, v in pairs(t) do
		if func(v, k) then return v, k end
	end
	return nil
end


function table.filter(t, func)
	local result = { }
	table.foreach(t, function(v, k)
		if func(v, k) then result[k] = v end
	end)
	return result
end


function table.map(t, func)
	table.foreach(t, function(v, k)
		t[k] = func(v, k)
	end)
	return t
end


function table.every(t, func)
	for k, v in pairs(t) do
		if not func(v, k) then return false end
	end
	return true
end


function table.some(t, func)
	for k, v in pairs(t) do
		if func(v, k) then return true end
	end
	return false
end


function table.reduce(t, func, initialValue)
	local result = initialValue or t[1]
	local index = initialValue and 1 or 2
	for i = index, #t do result = result + func(result, t[i], i) end
	return result
end


function table.slice(t, i, j)
	local result = { }
	for k = i, j do table.insert(result, t[k]) end
	return result
end


function math.average(t)
	local sum = 0
	table.foreach(t, function(v) sum = sum + v end)
	return sum / table.length(t)
end


function ms_to_string(ms)
	local seconds = ms / 1000
	return string.format('%02.f', math.floor(seconds / 60))..':'..string.format('%02.f', math.floor(seconds % 60))
end