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

function Db.UpdatePlayerName(player, playerName)
	setValue(player, 'PlayerName', toDbString(playerName))
end

function Db.UpdateDiscordId(player, discordId)
	setValue(player, 'DiscordID', toDbString(discordId))
end

function Db.UpdateTimePlayed(player, timePlayed)
	setValue(player, 'TimePlayed', timePlayed)
end

function Db.UpdateSkinModel(player, skinModel, callback)
	setValue(player, 'SkinModel', toDbString(json.encode(skinModel)), callback)
end

function Db.UpdateWeapons(player, weapons)
	setValue(player, 'Weapons', toDbString(json.encode(weapons)))
end

function Db.UpdateWeaponStats(player, weaponStats)
	setValue(player, 'WeaponStats', toDbString(json.encode(weaponStats)))
end

function Db.UpdateGarages(player, garages)
	setValue(player, 'Garages', toDbString(json.encode(garages)))
end

function Db.UpdateVehicles(player, vehicles)
	setValue(player, 'Vehicles', toDbString(json.encode(vehicles)))
end

function Db.UpdateDrugBusiness(player, drugBusiness)
	setValue(player, 'DrugBusiness', toDbString(json.encode(drugBusiness)))
end

function Db.UpdateRecords(player, records)
	setValue(player, 'Records', toDbString(json.encode(records)))
end

function Db.UpdateSettings(player, settings)
	setValue(player, 'Settings', toDbString(json.encode(settings)))
end

function Db.UpdateCash(player, cash)
	setValue(player, 'Cash', cash)
end

function Db.UpdateExperience(player, experience)
	setValue(player, 'Experience', experience)
end

function Db.UpdatePrestige(player, callback)
	vSql.Async.execute('UPDATE Players SET SkinModel=DEFAULT, Weapons=DEFAULT, Cash=DEFAULT, Experience=DEFAULT, Vehicles=DEFAULT, Garages=DEFAULT, DrugBusiness=DEFAULT, Prestige=Prestige + 1 WHERE PlayerID=@playerId',
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

function Db.UpdateMoneyWasted(player, cash)
	setValue(player, 'MoneyWasted', 'MoneyWasted + '..cash)
end

function Db.UpdateKills(player, kills)
	setValue(player, 'Kills', kills)
end

function Db.UpdateHeadshots(player, headshots)
	setValue(player, 'Headshots', headshots)
end

function Db.UpdateVehicleKills(player, vehicleKills)
	setValue(player, 'VehicleKills', vehicleKills)
end

function Db.UpdateMaxKillstreak(player, maxKillstreak)
	setValue(player, 'MaxKillstreak', maxKillstreak)
end

function Db.UpdateLongestKillDistance(player, killDistance)
	setValue(player, 'LongestKillDistance', killDistance)
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

function Db.GetFields(playerId, fields, callback)
	local fieldString = table.concat(fields, ',')

	vSql.Async.fetchAll('SELECT '..fieldString..' FROM Players WHERE PlayerID=@playerId', { ['@playerId'] = playerId }, function(data)
		callback(data[1])
	end)
end

function Db.RegisterPlayer(player, playerName, callback)
	local playerId = PlayerData.GetIdentifier(player)

	vSql.Async.execute('INSERT INTO Players (PlayerID, PlayerName) VALUES (@playerId, @playerName)', { ['@playerId'] = playerId, ['@playerName'] = playerName }, function()
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
