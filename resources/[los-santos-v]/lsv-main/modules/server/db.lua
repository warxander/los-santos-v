Db = { }


function Db.SetValue(player, field, value, callback)
	vSql.Async.execute('UPDATE Players SET '..field..' = '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.UpdateNumericValue(player, field, value, callback)
	vSql.Async.execute('UPDATE Players SET '..field..' = '..field..' + '..value..' WHERE PlayerId=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.UpdateCash(player, cash, callback, victim)
	if not Scoreboard.IsPlayerOnline(player) then return end

	if cash == 0 then
		if callback then callback() end
		return
	end

	if cash > 0 then
		local basicCash = cash
		if Scoreboard.GetPatreonTier(player) ~= 0 then cash = math.floor(basicCash * Settings.patreonBonus) end
		local prestige = Scoreboard.GetPlayerPrestige(player)
		if prestige ~= 0 then cash = cash + math.floor(basicCash * prestige * Settings.prestigeBonus) end
	end

	Db.UpdateNumericValue(player, 'Cash', cash, function()
		if Scoreboard.IsPlayerOnline(player) then Scoreboard.UpdateCash(player, cash) end
		if callback then callback() end
		TriggerClientEvent('lsv:cashUpdated', player, cash, victim)
	end)
end


function Db.UpdateExperience(player, experience, callback)
	if not Scoreboard.IsPlayerOnline(player) then return end

	if experience == 0 then
		if callback then callback() end
		return
	end

	if experience > 0 then
		local basicExperience = experience
		if Scoreboard.GetPatreonTier(player) ~= 0 then experience = math.floor(basicExperience * Settings.patreonBonus) end
		local prestige = Scoreboard.GetPlayerPrestige(player)
		if prestige ~= 0 then experience = experience + math.floor(basicExperience * prestige * Settings.prestigeBonus) end
	end

	Db.UpdateNumericValue(player, 'Experience', experience, function()
		if Scoreboard.IsPlayerOnline(player) then Scoreboard.UpdateExperience(player, experience) end
		if callback then callback() end
		TriggerClientEvent('lsv:experienceUpdated', player, experience)
	end)
end


function Db.UpdatePrestige(player, callback)
	vSql.Async.execute('UPDATE Players SET SkinModel=DEFAULT, Weapons=DEFAULT, Cash=DEFAULT, Experience=DEFAULT, Prestige=Prestige + 1 WHERE PlayerID=@playerId',
			{ ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
				if callback then callback() end
	end)
end

function Db.UpdateLoginTime(player, time, callback)
	Db.SetValue(player, 'LoginTime', time, function()
		if callback then callback() end
	end)
end


function Db.UpdateKills(player, callback)
	Db.UpdateNumericValue(player, 'Kills', 1, function()
		if Scoreboard.IsPlayerOnline(player) then Scoreboard.UpdateKills(player) end
		if callback then callback() end
	end)
end


function Db.UpdateDeaths(player, callback)
	Db.UpdateNumericValue(player, 'Deaths', 1, function()
		if Scoreboard.IsPlayerOnline(player) then Scoreboard.UpdateDeaths(player) end
		if callback then callback() end
	end)
end


function Db.FindPlayer(player, callback)
	vSql.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function(data)
		if callback then callback(data) end
	end)
end


function Db.GetBanStatus(player, callback)
	vSql.Async.fetchAll('SELECT Banned, BanExpiresDate FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function(data)
		if callback then callback(data) end
	end)
end


function Db.RegisterPlayer(player, callback)
	local playerId = Scoreboard.GetPlayerIdentifier(player)

	vSql.Async.transaction({ 'INSERT INTO Players (PlayerID) VALUES (@playerId)', 'INSERT INTO Reports (PlayerID) VALUES (@playerId)' }, { ['@playerId'] = playerId }, function()
		Db.FindPlayer(player, callback)
	end)
end


function Db.BanPlayer(player, callback)
	vSql.Async.execute('UPDATE Players SET Banned=1 WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.UnbanPlayerById(playerId, callback)
	vSql.Async.execute('UPDATE Players SET Banned=0, BanExpiresDate=NULL WHERE PlayerID=@playerId', { ['@playerId'] = playerId }, function()
		if callback then callback() end
	end)
end


function Db.UnbanPlayer(player, callback)
	Db.UnbanPlayerById(Scoreboard.GetPlayerIdentifier(player), callback)
end


function Db.TempBanPlayer(player, expiresDate, callback)
	vSql.Async.execute('UPDATE Players SET Banned=1, BanExpiresDate=@banExpiresDate WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player), ['@banExpiresDate'] = expiresDate }, function()
		if callback then callback() end
	end)
end


function Db.UpdateReports(player, callback)
	vSql.Async.execute('UPDATE Reports SET Total=Total+1 WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.ToString(value)
	return '\''..tostring(value)..'\''
end
