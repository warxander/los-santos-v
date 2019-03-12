DeathTimer = nil
TimeToRespawn = Settings.spawn.deathTime

local isSpawnInProcess = false
local isFirstSpawn = true


local function spawnPlayer()
	if isSpawnInProcess then return end
	isSpawnInProcess = true

	if not GetIsLoadingScreenActive() then
		DoScreenFadeOut(500)
		while IsScreenFadingOut() do Citizen.Wait(0) end
	end

	local spawnPoint = nil
	if isFirstSpawn then
		spawnPoint = table.random(Settings.spawn.points)
	else
		local playerPosition = Player.Position()
		local radius = Settings.spawn.radius.min
		local z = 1500.
		local tryCount = 0
		local startSpawnTimer = Timer.New()

		while true do
			Citizen.Wait(0)

			local diff = { r = radius * math.sqrt(GetRandomFloatInRange(0.0, 1.0)), theta = GetRandomFloatInRange(0.0, 1.0) * 2 * math.pi }
			local xDiff = diff.r * math.cos(diff.theta)
			if xDiff >= 0 then xDiff = math.max(radius, xDiff) else xDiff = math.min(-radius, xDiff) end

			local yDiff = diff.r * math.sin(diff.theta)
			if yDiff >= 0 then yDiff = math.max(radius, yDiff) else yDiff = math.min(-radius, yDiff) end

			local x = playerPosition.x + xDiff
			local y = playerPosition.y + yDiff

			local _, groundZ = GetGroundZFor_3dCoord(x, y, z)
			local validCoords, coords = GetSafeCoordForPed(x, y, groundZ + 1., false, 16)

			if validCoords then
				spawnPoint = { }
				spawnPoint.x, spawnPoint.y, spawnPoint.z = coords.x, coords.y, coords.z
			else
				if tryCount ~= Settings.spawn.tryCount then tryCount = tryCount + 1
				else
					radius = radius + Settings.spawn.radius.increment
					tryCount = 0
				end
			end

			if startSpawnTimer:Elapsed() >= Settings.spawn.timeout then spawnPoint = table.random(Settings.spawn.points) end
			if spawnPoint then break end
		end
	end

	Player.SetFreeze(true)

	local ped = PlayerPedId()

	RequestCollisionAtCoord(spawnPoint.x, spawnPoint.y, spawnPoint.z)
	SetEntityCoordsNoOffset(ped, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false, true)
	NetworkResurrectLocalPlayer(spawnPoint.x, spawnPoint.y, spawnPoint.z, GetRandomFloatInRange(0.0, 360.0), true, true, false)

	ClearPedTasksImmediately(ped)
	StopEntityFire(ped)
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)

	while not HasCollisionLoadedAroundEntity(ped) do Citizen.Wait(0) end
	if GetIsLoadingScreenActive() then ShutdownLoadingScreen() end

	DoScreenFadeIn(500)
	while IsScreenFadingIn() do Citizen.Wait(0) end

	TriggerEvent('playerSpawned')
	Player.SetFreeze(false)
	isSpawnInProcess = false
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if DoesEntityExist(PlayerPedId()) then
			if NetworkIsPlayerActive(PlayerId()) then
				if isFirstSpawn then
					spawnPlayer()
					isFirstSpawn = false
				elseif not isSpawnInProcess then
					if DeathTimer and GetTimeDifference(GetGameTimer(), DeathTimer) > TimeToRespawn or isFirstSpawn then
						spawnPlayer()
					end
				end
			end

			if IsPlayerDead(PlayerId()) then
				if not DeathTimer then
					DeathTimer = GetGameTimer()
					TimeToRespawn = Settings.spawn.deathTime
				end
			else DeathTimer = nil end
		end
	end
end)