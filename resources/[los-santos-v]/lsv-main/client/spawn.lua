-- TODO Make me module?
DeathTimer = nil
TimeToRespawn = Settings.spawn.deathTime

local _isSpawnInProcess = false

function spawnPlayer(spawnPoint)
	if _isSpawnInProcess then
		return
	end

	local isFirstSpawn = spawnPoint ~= nil

	_isSpawnInProcess = true

	if not GetIsLoadingScreenActive() then
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end
	end

	if spawnPoint then
		spawnPoint.z = spawnPoint.z - 1.0
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
			if xDiff >= 0 then
				xDiff = math.max(radius, xDiff)
			else
				xDiff = math.min(-radius, xDiff)
			end

			local yDiff = diff.r * math.sin(diff.theta)
			if yDiff >= 0 then
				yDiff = math.max(radius, yDiff)
			else
				yDiff = math.min(-radius, yDiff)
			end

			local x = playerPosition.x + xDiff
			local y = playerPosition.y + yDiff

			local _, groundZ = GetGroundZFor_3dCoord(x, y, z)
			local validCoords, coords = GetSafeCoordForPed(x, y, groundZ + 1., false, 16)

			if validCoords then
				for _, i in ipairs(GetActivePlayers()) do
					if i ~= PlayerId() then
						local ped = GetPlayerPed(i)

						if DoesEntityExist(ped) then
							local pedCoords = GetEntityCoords(ped)
							if Vdist(coords.x, coords.y, coords.z, pedCoords.x, pedCoords.y, pedCoords.z) < Settings.spawn.radius.minDistanceToPlayer then
								validCoords = false
								break
							end
						end
					end
				end
			end

			if validCoords then
				spawnPoint = { }
				spawnPoint.x, spawnPoint.y, spawnPoint.z = coords.x, coords.y, coords.z
			else
				if tryCount ~= Settings.spawn.tryCount then
					tryCount = tryCount + 1
				else
					radius = radius + Settings.spawn.radius.increment
					tryCount = 0
				end
			end

			if spawnPoint then
				break
			end

			if startSpawnTimer:elapsed() >= Settings.spawn.timeout then
				spawnPoint = table.random(Settings.spawn.points)
				Gui.DisplayPersonalNotification('Unable to find suitable place for spawning.')
			end
		end
	end

	Player.SetPassiveMode(true, not isFirstSpawn)
	local ped = PlayerPedId()

	RequestCollisionAtCoord(spawnPoint.x, spawnPoint.y, spawnPoint.z)
	SetEntityCoordsNoOffset(ped, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false, true)
	NetworkResurrectLocalPlayer(spawnPoint.x, spawnPoint.y, spawnPoint.z, GetRandomFloatInRange(0.0, 360.0), true, true, false)

	ClearPedTasksImmediately(ped)
	StopEntityFire(ped)
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)

	if GetIsLoadingScreenActive() then
		ShutdownLoadingScreen()
	end

	if IsScreenFadedOut() then
		DoScreenFadeIn(500)
		while not IsScreenFadedIn() do
			Citizen.Wait(0)
		end
	end

	TriggerEvent('playerSpawned')

	_isSpawnInProcess = false
end

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if DoesEntityExist(PlayerPedId()) then
			if NetworkIsPlayerActive(PlayerId()) then
				if not _isSpawnInProcess then
					if DeathTimer and GetTimeDifference(GetGameTimer(), DeathTimer) > TimeToRespawn then
						spawnPlayer()
					end
				end
			end

			if IsPlayerDead(PlayerId()) then
				if not DeathTimer then
					DeathTimer = GetGameTimer()
					TimeToRespawn = Settings.spawn.deathTime
				end
			else
				DeathTimer = nil
			end
		end
	end
end)
