-- in-memory spawnpoint array for this script execution instance
local spawnPoints = {}

-- auto-spawn enabled flag
local autoSpawnEnabled = false
local autoSpawnCallback

local spawnModel = nil

-- support for mapmanager maps
AddEventHandler('getMapDirectives', function(add)
	-- call the remote callback
	add('spawnpoint', function(state, model)
		-- return another callback to pass coordinates and so on (as such syntax would be [spawnpoint 'model' { options/coords }])
		return function(opts)
			local x, y, z, heading

			local s, e = pcall(function()
				-- is this a map or an array?
				if opts.x then
					x = opts.x
					y = opts.y
					z = opts.z
				else
					x = opts[1]
					y = opts[2]
					z = opts[3]
				end

				x = x + 0.0001
				y = y + 0.0001
				z = z + 0.0001

				-- get a heading and force it to a float, or just default to null
				heading = opts.heading and (opts.heading + 0.01) or 0

				-- add the spawnpoint
				addSpawnPoint({
					x = x, y = y, z = z,
					heading = heading,
					model = model
				})

				-- recalculate the model for storage
				if not tonumber(model) then
					model = GetHashKey(model, _r)
				end

				-- store the spawn data in the state so we can erase it later on
				state.add('xyz', { x, y, z })
				state.add('model', model)
			end)

			if not s then
				Citizen.Trace(e .. "\n")
			end
		end
		-- delete callback follows on the next line
	end, function(state, arg)
		-- loop through all spawn points to find one with our state
		for i, sp in ipairs(spawnPoints) do
			-- if it matches...
			if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
				-- remove it.
				table.remove(spawnPoints, i)
				return
			end
		end
	end)
end)


-- loads a set of spawn points from a JSON string
function loadSpawns(spawnString)
	-- decode the JSON string
	local data = json.decode(spawnString)

	-- do we have a 'spawns' field?
	if not data.spawns then
		error("no 'spawns' in JSON data")
	end

	-- loop through the spawns
	for i, spawn in ipairs(data.spawns) do
		-- and add it to the list (validating as we go)
		addSpawnPoint(spawn)
	end
end

local spawnNum = 1

function addSpawnPoint(spawn)
	-- validate the spawn (position)
	if not tonumber(spawn.x) or not tonumber(spawn.y) or not tonumber(spawn.z) then
		error("invalid spawn position")
	end

	-- heading
	if not tonumber(spawn.heading) then
		error("invalid spawn heading")
	end

	-- model (try integer first, if not, hash it)
	local model = spawn.model

	if not tonumber(spawn.model) then
		model = GetHashKey(spawn.model)
	end

	-- is the model actually a model?
	if not IsModelInCdimage(model) then
		error("invalid spawn model")
	end

	-- is is even a ped?
	-- not in V?
	--[[if not IsThisModelAPed(model) then
		error("this model ain't a ped!")
	end]]

	-- overwrite the model in case we hashed it
	spawn.model = model

	-- add an index
	spawn.idx = spawnNum
	spawnNum = spawnNum + 1

	-- all OK, add the spawn entry to the list
	table.insert(spawnPoints, spawn)

	return spawn.idx
end

-- removes a spawn point
function removeSpawnPoint(spawn)
	for i = 1, #spawnPoints do
		if spawnPoints[i].idx == spawn then
			table.remove(spawnPoints, i)
			return
		end
	end
end

-- changes the auto-spawn flag
function setAutoSpawn(enabled)
	autoSpawnEnabled = enabled
end

-- sets a callback to execute instead of 'native' spawning when trying to auto-spawn
function setAutoSpawnCallback(cb)
	autoSpawnCallback = cb
	autoSpawnEnabled = true
end

-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
	local player = id
	SetPlayerControl(player, not freeze, false)

	local ped = GetPlayerPed(player)

	if not freeze then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		--SetCharNeverTargetted(ped, false)
		SetPlayerInvincible(player, false)
	else
		if IsEntityVisible(ped) then
			SetEntityVisible(ped, false)
		end

		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		--SetCharNeverTargetted(ped, true)
		SetPlayerInvincible(player, true)
		--RemovePtfxFromPed(ped)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end

function loadScene(x, y, z)
	NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)

	while IsNewLoadSceneActive() do
		networkTimer = GetNetworkTimer()

		NetworkUpdateLoadScene()
	end
end

-- to prevent trying to spawn multiple times
local spawnLock = false


local minSpawnRadius = 75.
local maxSpawnRadius = 125.

local function GetValidRandomPickupRadius(radiusIncrement)
	local randomSpawnRadius = maxSpawnRadius - minSpawnRadius + radiusIncrement
	local result = GetRandomFloatInRange(-randomSpawnRadius, randomSpawnRadius)

	if result < 0 then result = result - minSpawnRadius
	else result = result + minSpawnRadius end

	return result
end


-- spawns the current player at a certain spawn point index (or a random one, for that matter)
function spawnPlayer(spawnIdx, cb)
	if spawnLock then
		return
	end

	spawnLock = true

	Citizen.CreateThread(function()
		DoScreenFadeOut(3000)

		while IsScreenFadingOut() do
			Citizen.Wait(0)
		end

		-- if the spawn isn't set, select a random one
		if not spawnIdx then
			spawnIdx = GetRandomIntInRange(1, #spawnPoints + 1)
		end

		-- get the spawn from the array
		local spawn = nil

		if spawnModel then
			-- I know that it's a piece of shit
			-- Need to rewrite it completely to make it better, because game mode use its own spawn rules
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			local radiusIncrement = 0
			local tryCount = 0

			while true do
				Citizen.Wait(0)

				local x = playerX + GetValidRandomPickupRadius(radiusIncrement)
				local y = playerY + GetValidRandomPickupRadius(radiusIncrement)
				local unk, groundZ = GetGroundZFor_3dCoord(x, y, playerZ)
				local validCoords, coords = GetSafeCoordForPed(x, y, groundZ, false, 16)

				if validCoords and groundZ > 0. then
					spawn = { }
					spawn.x, spawn.y, spawn.z = table.unpack(coords)
				else
					if tryCount ~= 100 then tryCount = tryCount + 1
					else
						radiusIncrement = radiusIncrement + 5
						tryCount = 0
					end
				end

				if spawn then break end
			end
		else
			spawn = spawnPoints[spawnIdx]
		end

		-- validate the index
		if not spawn then
			spawnLock = false

			return
		end

		-- freeze the local player
		freezePlayer(PlayerId(), true)

		if not spawnModel then
			spawnModel = GetHashKey('a_m_m_beach_01')

			RequestModel(spawnModel)

			-- load the model for this spawn
			while not HasModelLoaded(spawnModel) do
				RequestModel(spawnModel)

				Wait(0)
			end

			-- change the player model
			SetPlayerModel(PlayerId(), spawnModel)

			-- release the player model
			SetModelAsNoLongerNeeded(spawnModel)
		end

		-- preload collisions for the spawnpoint
		RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

		-- spawn the player
		--ResurrectNetworkPlayer(GetPlayerId(), spawn.x, spawn.y, spawn.z, spawn.heading)
		local ped = PlayerPedId()

		-- V requires setting coords as well
		SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

		NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

		-- gamelogic-style cleanup stuff
		ClearPedTasksImmediately(ped)
		StopEntityFire(ped)
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		--SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
		--RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
		ClearPlayerWantedLevel(PlayerId())

		-- why is this even a flag?
		--SetCharWillFlyThroughWindscreen(ped, false)

		-- set primary camera heading
		--SetGameCamHeading(spawn.heading)
		--CamRestoreJumpcut(GetGameCam())

		-- load the scene; streaming expects us to do it
		--ForceLoadingScreen(true)
		--loadScene(spawn.x, spawn.y, spawn.z)
		--ForceLoadingScreen(false)

		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(0)
		end

		ShutdownLoadingScreen()

		DoScreenFadeIn(500)

		while IsScreenFadingIn() do
			Citizen.Wait(0)
		end

		-- and unfreeze the player
		freezePlayer(PlayerId(), false)

		TriggerEvent('playerSpawned', spawn)

		if cb then
			cb(spawn)
		end

		spawnLock = false
	end)
end

-- automatic spawning monitor thread, too
local respawnForced
local diedAt

AddEventHandler('onClientMapStart', function()
  setAutoSpawn(true)
  forceRespawn()
end)

Citizen.CreateThread(function()
	-- main loop thing
	while true do
		Citizen.Wait(50)

		local playerPed = PlayerPedId()

		if playerPed and playerPed ~= -1 then
			-- check if we want to autospawn
			if autoSpawnEnabled then
				if NetworkIsPlayerActive(PlayerId()) then
					if (diedAt and (GetTimeDifference(GetGameTimer(), diedAt) > 2000)) or respawnForced then
						if autoSpawnCallback then
							autoSpawnCallback()
						else
							spawnPlayer()
						end

						respawnForced = false
					end
				end
			end

			if IsEntityDead(playerPed) then
				if not diedAt then
					diedAt = GetGameTimer()
				end
			else
				diedAt = nil
			end
		end
	end
end)

function forceRespawn()
	spawnLock = false
	respawnForced = true
end