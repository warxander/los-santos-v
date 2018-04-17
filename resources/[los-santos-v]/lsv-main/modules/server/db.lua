Db = { }


function Db.SetValue(player, field, value, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET '..field..' = '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.UpdateNumericValue(player, field, value, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET '..field..' = '..field..' + '..value..' WHERE PlayerId=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.UpdateCash(player, cash, callback)
	if cash == 0 then
		if callback then callback() end
		return
	end

	Db.UpdateNumericValue(player, 'Cash', cash, function()
		if callback then callback() end
		Scoreboard.UpdateCash(player, cash)
		TriggerClientEvent('lsv:cashUpdated', player, cash)
	end)
end


function Db.UpdateKills(player, callback)
	Db.UpdateNumericValue(player, 'Kills', 1, function()
		if callback then callback() end
		Scoreboard.UpdateKills(player)
		TriggerClientEvent('lsv:killsUpdated', player)
	end)
end


function Db.UpdateDeaths(player, callback)
	Db.UpdateNumericValue(player, 'Deaths', 1, function()
		if callback then callback() end
		Scoreboard.UpdateDeaths(player)
		TriggerClientEvent('lsv:deathsUpdated', player)
	end)
end


function Db.FindPlayer(player, callback)
	MySQL.ready(function()
		MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function(data)
			if callback then callback(data) end
		end)
	end)
end


function Db.RegisterPlayer(player, callback)
	local playerId = GetPlayerIdentifiers(player)[1]

	MySQL.ready(function()
		MySQL.Async.transaction({ 'INSERT INTO Players (PlayerID) VALUES (@playerId)', 'INSERT INTO Reports (PlayerID) VALUES (@playerId)' }, { ['@playerId'] = playerId }, function()
			Db.FindPlayer(player, callback)
		end)
	end)
end


function Db.BanPlayer(player, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET Banned=1 WHERE PlayerID=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.UpdateReports(player, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Reports SET Total=Total+1 WHERE PlayerID=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.ToString(value)
	return '\''..tostring(value)..'\''
end