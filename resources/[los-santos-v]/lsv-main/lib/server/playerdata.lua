PlayerData = { }
PlayerData.__index = PlayerData

local _playerSharedData = { }
local _playerLocalData = { }

local function calculateKdRatio(kills, deaths)
	if kills + deaths < Settings.kdRatioMinStat then
		return nil
	else
		return kills / deaths
	end
end

function PlayerData.Add(player, playerStats)
	if _playerSharedData[player] then
		return
	end

	local sharedData = {
		id = player,
		patreonTier = playerStats.PatreonTier,
		moderator = playerStats.Moderator,
		name = playerStats.PlayerName,
		cash = playerStats.Cash,
		faction = Settings.faction.Neutral,
		kdRatio = calculateKdRatio(playerStats.Kills, playerStats.Deaths),
		kills = playerStats.Kills,
		killstreak = 0,
		rank = playerStats.Rank,
		prestige = playerStats.Prestige,
	}

	local localData = {
		loginTime = playerStats.LoginTime,
		loginTimer = Timer.New(),
		timePlayed = playerStats.TimePlayed,
		headshots = playerStats.Headshots,
		deaths = playerStats.Deaths,
		maxKillstreak = playerStats.MaxKillstreak,
		experience = playerStats.Experience,
		missionsDone = playerStats.MissionsDone,
		eventsWon = playerStats.EventsWon,
	}

	_playerSharedData[player] = sharedData
	_playerLocalData[player] = localData

	TriggerClientEvent('lsv:initPlayerData', player, _playerSharedData)
	TriggerClientEvent('lsv:addPlayerData', -1, sharedData)
end

function PlayerData.Remove(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]

	playerData.timePlayed = playerData.timePlayed + playerData.loginTimer:elapsed()
	Db.UpdateTimePlayed(player, playerData.timePlayed)

	_playerSharedData[player] = nil
	_playerLocalData[player] = nil
	TriggerClientEvent('lsv:removePlayerData', -1, player)
end

-- TODO: Iterate over local data as well
function PlayerData.ForEach(func)
	table.foreach(_playerSharedData, func)
end

function PlayerData.GetCount()
	return table.length(_playerSharedData)
end

function PlayerData.IsExists(player)
	return _playerSharedData[player]
end

function PlayerData.GetIdentifier(player)
	return table.ifind_if(GetPlayerIdentifiers(player), function(id)
		return string.find(id, 'license')
	end)
end

function PlayerData.GetRandom()
	return table.random(_playerSharedData).id
end

function PlayerData.GetLoginTime(player)
	return _playerLocalData[player].loginTime
end

function PlayerData.IsModerator(player)
	return _playerSharedData[player].moderator
end

function PlayerData.GetModeratorLevel(player)
	return _playerSharedData[player].moderator
end

function PlayerData.GetPatreonTier(player)
	return _playerSharedData[player].patreonTier
end

function PlayerData.GetCash(player)
	return _playerSharedData[player].cash
end

function PlayerData.GetRank(player)
	return _playerSharedData[player].rank
end

function PlayerData.GetPrestige(player)
	return _playerSharedData[player].prestige
end

function PlayerData.GetKillstreak(player)
	return _playerSharedData[player].killstreak
end

function PlayerData.GetFaction(player)
	return _playerSharedData[player].faction
end

function PlayerData.GetKills(player)
	return _playerSharedData[player].kills
end

function PlayerData.UpdateFaction(player, faction)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerSharedData[player]
	playerData.faction = faction
	TriggerClientEvent('lsv:updatePlayerData', -1, player, { faction = playerData.faction })
end

function PlayerData.UpdateCash(player, cash, killDetails)
	if not PlayerData.IsExists(player) then
		return
	end

	if cash > 0 then
		local basicCash = cash

		local patreonTier = PlayerData.GetPatreonTier(player)
		if patreonTier ~= 0 then
			cash = math.floor(basicCash * Settings.patreon.reward[patreonTier])
		end

		local prestige = PlayerData.GetPrestige(player)
		if prestige ~= 0 then
			cash = cash + math.floor(basicCash * prestige * Settings.prestigeBonus)
		end
	elseif cash < 0 then
		cash = -math.min(PlayerData.GetCash(player), math.abs(cash))
	end

	if cash ~= 0 then
		local playerData = _playerSharedData[player]
		playerData.cash = playerData.cash + cash
		TriggerClientEvent('lsv:updatePlayerData', -1, player, { cash = playerData.cash })
		Db.UpdateCash(player, playerData.cash)
		TriggerClientEvent('lsv:cashUpdated', player, cash, killDetails)
	end
end

function PlayerData.UpdateExperience(player, experience)
	if not PlayerData.IsExists(player) then
		return
	end

	local basicExperience = experience

	local patreonTier = PlayerData.GetPatreonTier(player)
	if patreonTier ~= 0 then
		experience = math.floor(basicExperience * Settings.patreon.reward[patreonTier])
	end

	local prestige = PlayerData.GetPrestige(player)
	if prestige ~= 0 then
		experience = experience + math.floor(basicExperience * prestige * Settings.prestigeBonus)
	end

	if experience ~= 0 then
		local playerData = _playerSharedData[player]
		local playerLocalData = _playerLocalData[player]
		playerLocalData.experience = playerLocalData.experience + experience
		local rank = Rank.CalculateRank(playerLocalData.experience)
		if rank ~= playerData.rank then
			if rank % Settings.crate.nthRank == 0 then
				SpecialCrate.Drop(player)
			end

			playerData.rank = rank
			TriggerClientEvent('lsv:playerRankChanged', player, rank, Stat.CalculateStats(rank))
			TriggerClientEvent('lsv:updatePlayerData', -1, player, { rank = rank })
		end
		Db.UpdateExperience(player, playerLocalData.experience)
		TriggerClientEvent('lsv:experienceUpdated', player, experience)
	end
end

function PlayerData.UpdateKills(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerSharedData[player]
	local playerLocalData = _playerLocalData[player]

	local data = { }

	playerData.kills = playerData.kills + 1
	data.kills = playerData.kills

	local kdRatio = calculateKdRatio(playerData.kills, playerLocalData.deaths)
	if playerData.kdRatio ~= kdRatio then
		playerData.kdRatio = kdRatio
		data.kdRatio = kdRatio
	end

	playerData.killstreak = playerData.killstreak + 1
	data.killstreak = playerData.killstreak
	if playerData.killstreak > playerLocalData.maxKillstreak then
		playerLocalData.maxKillstreak = playerData.killstreak
		Db.UpdateMaxKillstreak(player, playerLocalData.maxKillstreak)
		TriggerClientEvent('lsv:maxKillstreakUpdated', player, playerLocalData.maxKillstreak)
	end

	TriggerClientEvent('lsv:updatePlayerData', -1, player, data)
	Db.UpdateKills(player, playerData.kills)
end

function PlayerData.UpdateHeadshots(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.headshots = playerData.headshots + 1

	TriggerClientEvent('lsv:headshotsUpdated', player, playerData.headshots)
	Db.UpdateHeadshots(player, playerData.headshots)
end

function PlayerData.UpdateDeaths(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerSharedData[player]
	local playerLocalData = _playerLocalData[player]

	playerLocalData.deaths = playerLocalData.deaths + 1

	local data = { }

	local kdRatio = calculateKdRatio(playerData.kills, playerLocalData.deaths)
	if playerData.kdRatio ~= kdRatio then
		playerData.kdRatio = kdRatio
		data.kdRatio = kdRatio
	end

	playerData.killstreak = 0
	data.killstreak = playerData.killstreak

	TriggerClientEvent('lsv:updatePlayerData', -1, player, data)
	Db.UpdateDeaths(player, playerLocalData.deaths)
end

function PlayerData.UpdateMissionsDone(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.missionsDone = playerData.missionsDone + 1

	TriggerClientEvent('lsv:missionsDoneUpdated', player, playerData.missionsDone)
	Db.UpdateMissionsDone(player, playerData.missionsDone)
end

function PlayerData.UpdateEventsWon(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.eventsWon = playerData.eventsWon + 1

	TriggerClientEvent('lsv:eventsWonUpdated', player, playerData.eventsWon)
	Db.UpdateEventsWon(player, playerData.eventsWon)
end
