Db = { }


function Db.SetValue(player, field, value, callback)
	MySQL.Async.execute('UPDATE Players SET '..field..' = '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.UpdateNumericValue(player, field, value, callback)
	MySQL.Async.execute('UPDATE Players SET '..field..' = '..field..' + '..value..' WHERE PlayerId=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.UpdateCash(player, cash, callback, victim)
	if cash == 0 then
		if callback then callback() end
		return
	end

	if not Scoreboard.IsPlayerOnline(player) then return end
	if cash > 0 and Scoreboard.GetPatreonTier(player) ~= 0 then cash = math.floor(cash * Settings.patreonBonus) end

	Scoreboard.UpdateCash(player, cash)
	Db.UpdateNumericValue(player, 'Cash', cash, function()
		if callback then callback() end
		TriggerClientEvent('lsv:cashUpdated', player, cash, victim)
	end)
end


function Db.UpdateExperience(player, experience, callback)
	if experience == 0 then
		if callback then callback() end
		return
	end

	if not Scoreboard.IsPlayerOnline(player) then return end
	if Scoreboard.GetPatreonTier(player) ~= 0 then experience = math.floor(experience * Settings.patreonBonus) end

	Scoreboard.UpdateExperience(player, experience)
	Db.UpdateNumericValue(player, 'Experience', experience, function()
		if callback then callback() end
		TriggerClientEvent('lsv:experienceUpdated', player, experience)
	end)
end


function Db.UpdateKills(player, callback)
	Scoreboard.UpdateKills(player)
	Db.UpdateNumericValue(player, 'Kills', 1, function()
		if callback then callback() end
	end)
end


function Db.UpdateDeaths(player, callback)
	Scoreboard.UpdateDeaths(player)
	Db.UpdateNumericValue(player, 'Deaths', 1, function()
		if callback then callback() end
	end)
end


function Db.FindPlayer(player, callback)
	local oldSteamIdentifier = GetPlayerIdentifiers(player)[1]
	local licenseIdentifier = Scoreboard.GetPlayerIdentifier(player)
	if oldSteamIdentifier ~= licenseIdentifier then
		-- Probably need to migrate
		MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = oldSteamIdentifier }, function(oldData)
			if #oldData == 0 then -- Nothing to migrate, but we can be already registered
				MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = licenseIdentifier }, function(data)
					if callback then callback(data) end
				end)
			else
				MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = licenseIdentifier }, function(data)
					if #data ~= 0 then -- Migrate
						MySQL.Async.transaction({ 'DELETE FROM Players WHERE PlayerID=@newPlayerId', 'UPDATE Players SET PlayerID=@newPlayerId WHERE PlayerID=@oldPlayerId' },
							{ ['@oldPlayerId'] = oldSteamIdentifier, ['@newPlayerId'] = licenseIdentifier }, function()
								if callback then callback(oldData) end
						end)
					else
						if callback then callback(data) end
					end
				end)
			end
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = licenseIdentifier }, function(data)
			if callback then callback(data) end
		end)
	end
end


function Db.RegisterPlayer(player, callback)
	local playerId = Scoreboard.GetPlayerIdentifier(player)

	MySQL.Async.transaction({ 'INSERT INTO Players (PlayerID) VALUES (@playerId)', 'INSERT INTO Reports (PlayerID) VALUES (@playerId)' }, { ['@playerId'] = playerId }, function()
		Db.FindPlayer(player, callback)
	end)
end


function Db.BanPlayer(player, callback)
	MySQL.Async.execute('UPDATE Players SET Banned=1 WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end

function Db.UnbanPlayer(player, callback)
	MySQL.Async.execute('UPDATE Players SET Banned=0, BanExpiresDate=NULL WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.TempBanPlayer(player, expiresDate, callback)
	MySQL.Async.execute('UPDATE Players SET Banned=1, BanExpiresDate=@banExpiresDate WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player), ['@banExpiresDate'] = expiresDate }, function()
		if callback then callback() end
	end)
end


function Db.UpdateReports(player, callback)
	MySQL.Async.execute('UPDATE Reports SET Total=Total+1 WHERE PlayerID=@playerId', { ['@playerId'] = Scoreboard.GetPlayerIdentifier(player) }, function()
		if callback then callback() end
	end)
end


function Db.ToString(value)
	return '\''..tostring(value)..'\''
end