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
		kdRatio = calculateKdRatio(playerStats.Kills, playerStats.Deaths),
		kills = playerStats.Kills,
		killstreak = 0,
		deathstreak = 0,
		rank = playerStats.Rank,
		prestige = playerStats.Prestige,
		crewLeader = nil,
	}

	local localData = {
		identifier = PlayerData.GetIdentifier(player),
		loginTime = playerStats.LoginTime,
		loginTimer = Timer.New(),
		timePlayed = playerStats.TimePlayed,
		headshots = playerStats.Headshots,
		vehicleKills = playerStats.VehicleKills,
		deaths = playerStats.Deaths,
		weaponStats = playerStats.WeaponStats,
		maxKillstreak = playerStats.MaxKillstreak,
		experience = playerStats.Experience,
		missionsDone = playerStats.MissionsDone,
		eventsWon = playerStats.EventsWon,
		longestKillDistance = playerStats.LongestKillDistance,
		garages = playerStats.Garages,
		vehicles = playerStats.Vehicles,
		drugBusiness = playerStats.DrugBusiness,
		records = playerStats.Records,
		settings = playerStats.Settings,
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

function PlayerData.GetCount()
	return table.length(_playerSharedData)
end

function PlayerData.IsExists(player)
	return _playerSharedData[player]
end

function PlayerData.IsExistsById(playerId)
	return table.find_if(_playerLocalData, function(_, player)
		return PlayerData.GetIdentifier(player) == playerId
	end)
end

function PlayerData.GetIdentifier(player)
	local playerData = _playerLocalData[player]

	if playerData and playerData.identifier then
		return playerData.identifier
	end

	local identifier = table.ifind_if(GetPlayerIdentifiers(player), function(id)
		return string.find(id, 'license')
	end)

	if playerData then
		playerData.identifier = identifier
	end

	return identifier
end

function PlayerData.GetRandom()
	return table.random(_playerSharedData).id
end

function PlayerData.GetName(player)
	return _playerSharedData[player].name
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

function PlayerData.GetKills(player)
	return _playerSharedData[player].kills
end

function PlayerData.UpdateWeaponStats(player, weaponHash)
	if not PlayerData.IsExists(player) then
		return
	end

	weaponHash = tostring(weaponHash)

	local weaponStats = _playerLocalData[player].weaponStats
	local newCount = nil

	if not weaponStats[weaponHash] then
		newCount = 1
	else
		newCount = weaponStats[weaponHash] + 1
	end

	weaponStats[weaponHash] = newCount
	Db.UpdateWeaponStats(player, weaponStats)
	TriggerClientEvent('lsv:weaponStatsUpdated', player, weaponHash, newCount)
end

function PlayerData.GetCrewLeader(player)
	return _playerSharedData[player].crewLeader
end

function PlayerData.UpdateCrewLeader(player, crewLeader)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerSharedData[player]
	if playerData.crewLeader ~= crewLeader then
		playerData.crewLeader = crewLeader
		TriggerClientEvent('lsv:updatePlayerData', -1, player, { crewLeader = crewLeader or false })
	end
end

function PlayerData.GetRecord(player, id)
	return _playerLocalData[player].records[id]
end

function PlayerData.UpdateRecord(player, id, record)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]

	local currentRecord = playerData.records[id] or 0
	if record ~= currentRecord then
		playerData.records[id] = record
		Db.UpdateRecords(player, playerData.records)
		TriggerClientEvent('lsv:recordUpdated', player, id, record)
	end
end

function PlayerData.HasGarage(player, garage)
	return _playerLocalData[player].garages[garage] ~= nil
end

function PlayerData.GetGaragesCapacity(player)
	local capacity = 0

	table.foreach(_playerLocalData[player].garages, function(_, garage)
		capacity = capacity + Settings.garages[garage].capacity
	end)

	return capacity
end

function PlayerData.GetVehicles(player)
	return _playerLocalData[player].vehicles
end

function PlayerData.GetVehicle(player, vehicleIndex)
	return _playerLocalData[player].vehicles[vehicleIndex]
end

function PlayerData.UpdateGarage(player, garage)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	if not playerData.garages[garage] then
		playerData.garages[garage] = true
		Db.UpdateGarages(player, playerData.garages)
		TriggerClientEvent('lsv:garageUpdated', player, garage)
	end
end

function PlayerData.HasVehicle(player, vehicleIndex)
	return _playerLocalData[player].vehicles[vehicleIndex] ~= nil
end

function PlayerData.AddVehicle(player, vehicle)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	table.insert(playerData.vehicles, vehicle)
	Db.UpdateVehicles(player, playerData.vehicles)
	TriggerClientEvent('lsv:vehicleAdded', player, vehicle)
end

function PlayerData.ReplaceVehicle(player, vehicleIndex, vehicle)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.vehicles[vehicleIndex] = vehicle
	Db.UpdateVehicles(player, playerData.vehicles)
	TriggerClientEvent('lsv:vehicleReplaced', player, vehicleIndex, vehicle)
end

function PlayerData.RemoveVehicle(player, vehicleIndex)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	table.remove(playerData.vehicles, vehicleIndex)
	Db.UpdateVehicles(player, playerData.vehicles)
	TriggerClientEvent('lsv:vehicleRemoved', player, vehicleIndex)
end

function PlayerData.HasDrugBusiness(player, type)
	return _playerLocalData[player].drugBusiness[type] ~= nil
end

function PlayerData.GetDrugBusiness(player, type)
	return _playerLocalData[player].drugBusiness[type]
end

function PlayerData.UpdateDrugBusiness(player, type, data)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerLocalData = _playerLocalData[player]
	playerLocalData.drugBusiness[type] = data
	Db.UpdateDrugBusiness(player, playerLocalData.drugBusiness)
	TriggerClientEvent('lsv:drugBusinessUpdated', player, type, data)
end

function PlayerData.GiveDrugBusinessSupply(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerLocalData = _playerLocalData[player]

	local data, type = table.find_if(playerLocalData.drugBusiness, function(data)
		return data.supplies ~= Settings.drugBusiness.limits.supplies
	end)
	if not data then
		return
	end

	data.supplies = data.supplies + 1
	Db.UpdateDrugBusiness(player, playerLocalData.drugBusiness)
	TriggerClientEvent('lsv:drugBusinessUpdated', player, type, data)
	TriggerClientEvent('lsv:drugBusinessSupplyRewarded', player, type)
end

function PlayerData.UpdateCash(player, cash, notPayToLeader)
	if not PlayerData.IsExists(player) then
		return
	end

	if cash > 0 then
		local basicCash = math.floor(cash * Settings.cashMultiplier)

		local patreonTier = PlayerData.GetPatreonTier(player)
		if patreonTier ~= 0 then
			cash = math.floor(basicCash * Settings.patreon.reward[patreonTier])
		end

		local prestige = PlayerData.GetPrestige(player)
		if prestige ~= 0 then
			cash = cash + math.floor(basicCash * prestige * Settings.prestige.rewardMultiplier)
		end

		if not notPayToLeader then
			local crewLeader = PlayerData.GetCrewLeader(player)
			if crewLeader and crewLeader ~= player then
				PlayerData.UpdateCash(crewLeader, math.floor(basicCash * Settings.crew.rewardBonus.cash))
			end
		end
	elseif cash < 0 then
		cash = -math.min(PlayerData.GetCash(player), math.abs(cash))
		Db.UpdateMoneyWasted(player, math.abs(cash))
	end

	if cash ~= 0 then
		local playerData = _playerSharedData[player]
		playerData.cash = math.floor(playerData.cash + cash)
		TriggerClientEvent('lsv:updatePlayerData', -1, player, { cash = playerData.cash })
		Db.UpdateCash(player, playerData.cash)
		TriggerClientEvent('lsv:cashUpdated', player, cash)
	end
end

function PlayerData.UpdateExperience(player, experience, notPayToLeader)
	if not PlayerData.IsExists(player) then
		return
	end

	local basicExperience = math.floor(experience * Settings.expMultiplier)

	local patreonTier = PlayerData.GetPatreonTier(player)
	if patreonTier ~= 0 then
		experience = math.floor(basicExperience * Settings.patreon.reward[patreonTier])
	end

	local prestige = PlayerData.GetPrestige(player)
	if prestige ~= 0 then
		experience = experience + math.floor(basicExperience * prestige * Settings.prestige.rewardMultiplier)
	end

	if experience ~= 0 then
		if not notPayToLeader then
			local crewLeader = PlayerData.GetCrewLeader(player)
			if crewLeader and crewLeader ~= player then
				PlayerData.UpdateExperience(crewLeader, math.floor(basicExperience * Settings.crew.rewardBonus.exp))
			end
		end

		local playerData = _playerSharedData[player]
		local playerLocalData = _playerLocalData[player]
		playerLocalData.experience = math.floor(playerLocalData.experience + experience)
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

	if playerData.deathstreak ~= 0 then
		playerData.deathstreak = 0
		data.deathstreak = playerData.deathstreak
	end

	TriggerClientEvent('lsv:updatePlayerData', -1, player, data)
	Db.UpdateKills(player, playerData.kills)
end

function PlayerData.UpdateLongestKillDistance(player, killDistance)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	if killDistance > playerData.longestKillDistance then
		playerData.longestKillDistance = killDistance
		Db.UpdateLongestKillDistance(player, playerData.longestKillDistance)
		TriggerClientEvent('lsv:longestKillDistanceUpdated', player, playerData.longestKillDistance)
	end
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

function PlayerData.UpdateVehicleKills(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.vehicleKills = playerData.vehicleKills + 1

	TriggerClientEvent('lsv:vehicleKillsUpdated', player, playerData.vehicleKills)
	Db.UpdateVehicleKills(player, playerData.vehicleKills)
end

function PlayerData.UpdateDeaths(player, isSuicide)
	if not PlayerData.IsExists(player) then
		return
	end

	local playerData = _playerSharedData[player]
	local playerLocalData = _playerLocalData[player]

	local data = { }

	playerData.killstreak = 0
	data.killstreak = playerData.killstreak

	if not isSuicide then
		playerLocalData.deaths = playerLocalData.deaths + 1

		local kdRatio = calculateKdRatio(playerData.kills, playerLocalData.deaths)
		if playerData.kdRatio ~= kdRatio then
			playerData.kdRatio = kdRatio
			data.kdRatio = kdRatio
		end

		playerData.deathstreak = playerData.deathstreak + 1
		data.deathstreak = playerData.deathstreak
	end

	TriggerClientEvent('lsv:updatePlayerData', -1, player, data)

	if not isSuicide then
		Db.UpdateDeaths(player, playerLocalData.deaths)
	end
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

RegisterNetEvent('lsv:updatePlayerSetting')
AddEventHandler('lsv:updatePlayerSetting', function(setting, value)
	local player = source
	if not PlayerData.IsExists(player) or not Settings.player[setting] or type(value) ~= 'boolean' then
		return
	end

	local playerData = _playerLocalData[player]
	playerData.settings[setting] = value or nil

	Db.UpdateSettings(player, playerData.settings)
	TriggerClientEvent('lsv:settingUpdated', player, setting, value)
end)
