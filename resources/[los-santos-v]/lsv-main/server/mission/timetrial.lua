local logger = Logger.New('TimeTrial')

local _trialRecords = { } -- For server use, contains all player records
local _trialRecordsTop = { } -- Contains top (default 3) records for all tracks

-- Given a race top, returns top topCount records
function getTopPlayers(trackRecords, topCount)
  local playerNames = {}
  local topThreeRecords = {}

  -- Create player-only list
  for playerName in pairs(trackRecords) do
    playerNames[#playerNames + 1] = playerName
  end

  -- Sort players by comparing their scores from record table
  table.sort(playerNames, function(a, b)
    return trackRecords[a] < trackRecords[b]
  end)

  -- Get top three
  for i = 1, #playerNames, 1 do
    topThreeRecords[i] = { name = playerNames[i], time = trackRecords[playerNames[i]] }

    if i >= topCount then break end
  end

  return topThreeRecords
end

RegisterNetEvent('lsv:finishTimeTrial')
AddEventHandler('lsv:finishTimeTrial', function(trialId, vehicleClassName, trialTime)
	local player = source
	local playerName = PlayerData.GetName(player)

	-- Sanity check, player and track exists
	if not PlayerData.IsExists(player) or not Settings.timeTrial.tracks[trialId] then
		return
	end

	local isServerRecord = false
	local isPersonalBest = false

  -- Check for server record
  if _trialRecords[trialId].serverrecords[vehicleClassName] == nil or _trialRecords[trialId].serverrecords[vehicleClassName] > trialTime then
    isServerRecord = true

    -- Save server best
    _trialRecords[trialId].serverrecords[vehicleClassName] = trialTime

    -- Save new personal best
		_trialRecords[trialId].records[vehicleClassName][playerName] = trialTime

    logger:info('New server best for '..playerName..' on '..trialId..' in a '..vehicleClassName..' class vehicle, time '..string.from_ms(_trialRecords[trialId].records[vehicleClassName][playerName], true))

	-- Check for personal best
  elseif _trialRecords[trialId].records[vehicleClassName][playerName] == nil or _trialRecords[trialId].records[vehicleClassName][playerName] > trialTime then
		isPersonalBest = true

		-- Save new personal best
		_trialRecords[trialId].records[vehicleClassName][playerName] = trialTime

		logger:info('New personal best for '..playerName..' on '..trialId..' in a '..vehicleClassName..' class vehicle, time '..string.from_ms(_trialRecords[trialId].records[vehicleClassName][playerName], true))
	end

  if isServerRecord or isPersonalBest then
    -- Save to DB
    vSql.Async.execute("INSERT INTO TrackRecords (tid, pid, vcid, `Time`, RecordDTM) SELECT t.tid, p.pid, vc.vcid, @time, NOW() FROM Players AS p JOIN TrialTracks AS t JOIN VehicleClasses AS vc WHERE p.PlayerID = @playerId AND t.TrackID = @trackId AND vc.VehicleClass = @vehicleClassName ON DUPLICATE KEY UPDATE `Time` = @time, RecordDTM = NOW()",
      { ['@vehicleClassName'] = vehicleClassName, ['@time'] = trialTime, ['@playerId'] = PlayerData.GetIdentifier(player), ['@trackId'] = trialId }, nil)

    -- Inform Discord, if its a server record
    if isServerRecord then
      Discord.ReportNewTimeTrialRecord(player, _trialRecords[trialId].name, vehicleClassName, string.from_ms(trialTime, true))
    end

    -- Update players local records
    _trialRecordsTop[trialId][vehicleClassName].records = getTopPlayers(_trialRecords[trialId].records[vehicleClassName], Settings.timeTrial.showTopRecordCount)

    TriggerClientEvent('lsv:updateTimeTrialRecord', -1, trialId, vehicleClassName, _trialRecordsTop[trialId][vehicleClassName].records)
  end

  -- Awards and announcements
  local cash = Settings.timeTrial.reward.cash
  local exp = Settings.timeTrial.reward.exp
  local message = 'Trial time: '..string.from_ms(trialTime, true)

  if isServerRecord then
    cash = Settings.timeTrial.serverRecordReward.cash
    exp = Settings.timeTrial.serverRecordReward.exp

    message = 'NEW SERVER RECORD: '..string.from_ms(trialTime, true)
  elseif isPersonalBest then
    cash = Settings.timeTrial.personalRecordReward.cash
    exp = Settings.timeTrial.personalRecordReward.exp

    message = 'NEW PERSONAL BEST: '..string.from_ms(trialTime, true)
  end

  PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)

  -- If its a personal record, send along so local data can be updated
  if not isServerRecord and not isPersonalBest then
    trialTime = nil
  end

  TriggerClientEvent('lsv:timeTrialFinished', player, true, message, trialId, vehicleClassName, trialTime)
end)

Citizen.CreateThread(function()
	-- Prep _trialRecords with tracks and vehicleclasses
	for trialId, v in pairs (Settings.timeTrial.tracks) do
	  _trialRecords[trialId] = {}
		_trialRecords[trialId].name = Settings.timeTrial.tracks[trialId].name
    _trialRecords[trialId].serverrecords = {}  -- Keep track of server best here, so we don't have to sort player records to check if its beaten
	  _trialRecords[trialId].records = {} -- Individual player records

    -- All records are kept per vehicleclass
	  for vehicleClass, v in ipairs(Settings.timeTrial.vehicleClassNames) do
	    _trialRecords[trialId].serverrecords[v] = nil
      _trialRecords[trialId].records[v] = {}
	  end
	end

	logger:info('Prepped records structure for '..table.length(_trialRecords)..' track(s)')

  -- Update DB with available time trials
  local sql = 'INSERT INTO TrialTracks (TrackId, TrackName) VALUES '

  for trialId, v in pairs (Settings.timeTrial.tracks) do
    -- Real cheap SQL injection protection, beware trial names
    sql = sql.." ('"..string.gsub(trialId, "'", "\'").."','"..string.gsub(Settings.timeTrial.tracks[trialId].name, "'", "\'").."'),"
  end

  -- Strip last , and handle PK violations
  sql = string.sub(sql, 1, -2)..' ON DUPLICATE KEY UPDATE TrackName = VALUES(TrackName)'

  vSql.Async.execute(sql, nil, nil)

  -- Update DB with vehicle classes
  local sql = 'INSERT INTO VehicleClasses (vcid, VehicleClass) VALUES '

  for vehicleClassId, vehicleClass in ipairs(Settings.timeTrial.vehicleClassNames) do
    -- Real cheap SQL injection protection, beware
    sql = sql.." ("..vehicleClassId..", '"..string.gsub(vehicleClass, "'", "\'").."'),"
  end

  -- Strip last , and handle PK violations
  sql = string.sub(sql, 1, -2)..' ON DUPLICATE KEY UPDATE VehicleClass = VALUES(VehicleClass)'

  vSql.Async.execute(sql, nil, nil)

  -- Read existing records
	vSql.Async.fetchAll('SELECT tt.TrackID, p.PlayerName, vc.VehicleClass, tr.`Time` FROM TrackRecords AS tr JOIN Players AS p ON p.pid = tr.pid JOIN TrialTracks AS tt ON tt.tid = tr.tid JOIN VehicleClasses AS vc ON vc.vcid = tr.vcid ORDER BY tt.TrackID, tr.vcid, tr.`Time`, tr.RecordDTM DESC', nil, function(data)
		table.iforeach(data, function(record)
      -- Check for server best
      if _trialRecords[record.TrackID].serverrecords[record.VehicleClass] == nil or _trialRecords[record.TrackID].serverrecords[record.VehicleClass] > record.Time then
        -- Save server best
        _trialRecords[record.TrackID].serverrecords[record.VehicleClass] = record.Time
      end

			_trialRecords[record.TrackID].records[record.VehicleClass][record.PlayerName] = record.Time
		end)

    -- Initialize client side records (top three), loop tracks
    for trialId in pairs (Settings.timeTrial.tracks) do
      _trialRecordsTop[trialId] = {}

      -- And loop vehicle classes
      for vehicleClassId, vehicleClass in ipairs(Settings.timeTrial.vehicleClassNames) do
        _trialRecordsTop[trialId][vehicleClass] = {}
        _trialRecordsTop[trialId][vehicleClass].records = getTopPlayers(_trialRecords[trialId].records[vehicleClass], Settings.timeTrial.showTopRecordCount)
  	  end
    end

		logger:info('Loaded '..table.length(data)..' time trial records')
	end)
end)

AddSignalHandler('lsv:playerConnected', function(player)
  local _trialRecordsPlayer = _trialRecordsTop
  local playerName = PlayerData.GetName(player)

  -- Enrich response with players own personal best, if available
  for trialId in pairs (Settings.timeTrial.tracks) do
    for vehicleClassId, vehicleClass in ipairs(Settings.timeTrial.vehicleClassNames) do
      if _trialRecords[trialId].records[vehicleClass][playerName] ~= nil then
        _trialRecordsPlayer[trialId][vehicleClass].personalBest = _trialRecords[trialId].records[vehicleClass][playerName]
      end
    end
  end

	TriggerClientEvent('lsv:initTimeTrialRecords', player, _trialRecordsPlayer)
end)
