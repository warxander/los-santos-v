Db = { }


function Db.SetValue(player, field, value, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET '..field..' = '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.UpdateValue(player, field, value, callback)
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET '..field..' = '..field..' + '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
			if callback then callback() end
		end)
	end)
end


function Db.UpdateMoney(player, money, callback)
	Db.UpdateValue(player, 'Money', money, function()
		if callback then callback() end
		Scoreboard.UpdateMoney(player, money)
		TriggerClientEvent('lsv:moneyUpdated', player, money)
	end)
end


function Db.UpdateKills(player, callback)
	Db.UpdateValue(player, 'Kills', 1, function()
		if callback then callback() end
		Scoreboard.UpdateKills(player)
		TriggerClientEvent('lsv:killsUpdated', player)
	end)
end


function Db.UpdateDeaths(player, callback)
	Db.UpdateValue(player, 'Deaths', 1, function()
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
	MySQL.ready(function()
		MySQL.Async.execute('INSERT INTO Players (PlayerID) VALUES (@playerId)', { ['@playerId'] = GetPlayerIdentifiers(player)[1] }, function()
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


function Db.ToString(value)
	return '\"'..tostring(value)..'\"'
end