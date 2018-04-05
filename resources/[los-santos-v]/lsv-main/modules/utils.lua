Utils = { }


function Utils.GetTableLength(t)
	local length = 0
	for _ in pairs(t) do length = length + 1 end
	return length
end


function Utils.GetRandom(t)
	local keys = { }

	for key, _ in pairs(t) do
		keys[Utils.GetTableLength(keys) + 1] = key
	end

	local index = keys[math.random(Utils.GetTableLength(keys))]

	return t[index]
end


function Utils.IndexOf(t, value)
	for index, v in pairs(t) do
		if v == value then
			return index
		end
	end

	return nil
end


function Utils.SafeRemove(t, value)
	local index = Utils.IndexOf(t, value)

	if not index then return end

	table.remove(t, index)
end


function Utils.IsTableEmpty(t)
	return type(t) == 'table' and Utils.GetTableLength(t) == 0
end


function Utils.Clear(t)
	for i = Utils.GetTableLength(t), 1, -1 do
		table.remove(t, i)
	end
end


function Utils.Copy(t) -- Avoid Stack Overflow for huge tables
	if type(t) == 'table' then
		local result = { }
		for key, value in next, t, nil do result[Utils.Copy(key)] = Utils.Copy(value) end
		setmetatable(result, Utils.Copy(getmetatable(t)))
		return result
	else
		return t
	end
end