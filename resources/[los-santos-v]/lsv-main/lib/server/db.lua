Db = { }
Db.__index = Db

local function setValueById(playerId, field, value, callback)
	vSql.Async.execute('UPDATE Players SET '..field..' = '..tostring(value)..' WHERE PlayerId=@playerId', { ['@playerId'] = playerId }, function()
		if callback then
			callback()
		end
	end)
end

local function setValue(player, field, value, callback)
	setValueById(PlayerData.GetIdentifier(player), field, value, callback)
end

local function toDbString(value)
	return '\''..tostring(value)..'\''
end

function Db.UpdateTimePlayed(player, timePlayed)
	setValue(player, 'TimePlayed', timePlayed)
end

function Db.UpdateSkinModel(player, skin, callback)
	setValue(player, 'SkinModel', toDbString(skin), callback)
end

function Db.UpdateWeapons(player, weapons)
	setValue(player, 'Weapons', toDbString(json.encode(weapons)))
end

function Db.UpdateCash(player, cash)
	setValue(player, 'Cash', cash)
end

function Db.UpdateExperience(player, experience)
	setValue(player, 'Experience', experience)
end

function Db.UpdatePrestige(player, callback)
	vSql.Async.execute('UPDATE Players SET SkinModel=DEFAULT, Weapons=DEFAULT, Cash=DEFAULT, Experience=DEFAULT, Prestige=Prestige + 1 WHERE PlayerID=@playerId',
			{ ['@playerId'] = PlayerData.GetIdentifier(player) }, function()
				if callback then
					callback()
				end
	end)
end

function Db.UpdatePatreonTierById(playerId, patreonTier)
	setValueById(playerId, 'PatreonTier', patreonTier or 'DEFAULT')
end

function Db.UpdateModeratorById(playerId, moderatorLevel)
	setValueById(playerId, 'Moderator', moderatorLevel or 'DEFAULT')
end

function Db.UpdateLoginTime(player, time)
	setValue(player, 'LoginTime', time)
end

function Db.UpdateKills(player, kills)
	setValue(player, 'Kills', kills)
end

function Db.UpdateHeadshots(player, headshots)
	setValue(player, 'Headshots', headshots)
end

function Db.UpdateMaxKillstreak(player, maxKillstreak)
	setValue(player, 'MaxKillstreak', maxKillstreak)
end

function Db.UpdateDeaths(player, deaths)
	setValue(player, 'Deaths', deaths)
end

function Db.UpdateMissionsDone(player, missionsDone)
	setValue(player, 'MissionsDone', missionsDone)
end

function Db.UpdateEventsWon(player, eventsWon)
	setValue(player, 'EventsWon', eventsWon)
end

function Db.FindPlayer(player, callback)
	vSql.Async.fetchAll('SELECT * FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = PlayerData.GetIdentifier(player) }, function(data)
		callback(data[1])
	end)
end

function Db.GetFields(player, fields, callback)
	local fieldString = table.concat(fields, ',')

	vSql.Async.fetchAll('SELECT '..fieldString..' FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = PlayerData.GetIdentifier(player) }, function(data)
		callback(data[1])
	end)
end

function Db.RegisterPlayer(player, callback)
	local playerId = PlayerData.GetIdentifier(player)

	vSql.Async.execute('INSERT INTO Players (PlayerID) VALUES (@playerId)', { ['@playerId'] = playerId }, function()
		Db.FindPlayer(player, callback)
	end)
end

function Db.BanPlayer(player, callback)
	vSql.Async.execute('UPDATE Players SET Banned=1 WHERE PlayerID=@playerId', { ['@playerId'] = PlayerData.GetIdentifier(player) }, function()
		if callback then
			callback()
		end
	end)
end

function Db.UnbanPlayerById(playerId, callback)
	vSql.Async.execute('UPDATE Players SET Banned=0, BanExpiresDate=NULL WHERE PlayerID=@playerId', { ['@playerId'] = playerId }, function()
		if callback then
			callback()
		end
	end)
end

function Db.UnbanPlayer(player, callback)
	Db.UnbanPlayerById(PlayerData.GetIdentifier(player), callback)
end

function Db.TempBanPlayer(player, expiresDate, callback)
	vSql.Async.execute('UPDATE Players SET Banned=1, BanExpiresDate=@banExpiresDate WHERE PlayerID=@playerId', { ['@playerId'] = PlayerData.GetIdentifier(player), ['@banExpiresDate'] = expiresDate }, function()
		if callback then
			callback()
		end
	end)
end
