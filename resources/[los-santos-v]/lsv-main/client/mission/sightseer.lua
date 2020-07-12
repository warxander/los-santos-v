local _sightseer = nil

local function finishMission(success, reason)
	local packagesLeft = #_sightseer

	if success or packagesLeft < Settings.sightseer.count then
		TriggerServerEvent('lsv:sightseerFinished', Settings.sightseer.count - packagesLeft)
	else
		TriggerEvent('lsv:sightseerFinished', false, reason or '')
	end
end

local function removePackage(index)
	local data = _sightseer[index]

	RemovePickup(data.pickup.id)
	RemoveBlip(data.blip.id)
	RemoveBlip(data.areaBlip)
end

RegisterNetEvent('lsv:sightseerFinished')
AddEventHandler('lsv:sightseerFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	for i = 1, #_sightseer do
		removePackage(i)
	end
	_sightseer = nil

	Gui.FinishMission('Sightseer', success, reason)
end)

AddEventHandler('lsv:startSightseer', function()
	local missionTimer = Timer.New()

	Gui.StartMission('Sightseer', 'Find and collect all packages in the given time.')

	_sightseer = table.irandom_n(Settings.sightseer.locations, Settings.sightseer.count)
	table.iforeach(_sightseer, function(data)
		data.areaBlip = Map.CreateRadiusBlip(data.blip.x, data.blip.y, data.blip.z, Settings.sightseer.radius, Color.BLIP_GREEN)
		data.blip.id = Map.CreatePlaceBlip(Blip.SIGHTSEER, data.blip.x, data.blip.y, data.blip.z, 'Package', Color.BLIP_GREEN)
		SetBlipAsShortRange(data.blip.id, false)
		Map.SetBlipFlashes(data.blip.id)
	end)

	World.EnableWanted(true)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				Gui.DrawTimerBar('MISSION TIME', Settings.sightseer.time - missionTimer:elapsed(), 1)
				Gui.DrawBar('PACKAGES REMAINING', #_sightseer, 2)
				Gui.DisplayObjectiveText('Find and collect all ~g~packages~w~.')
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			finishMission(false)
			return
		end

		if IsPlayerDead(PlayerId()) then
			finishMission(false)
			return
		end

		if missionTimer:elapsed() >= Settings.heist.time then
			finishMission(false, 'Time is over.')
			return
		end

		if Player.IsActive() then
			local playerPosition = Player.Position()

			for i = #_sightseer, 1, -1 do
				local data = _sightseer[i]
				local distance = World.GetDistance(playerPosition, data.blip, true)

				if distance < Settings.sightseer.radius then
					if not data.pickup.id then
						data.pickup.id = CreatePickupRotate(`PICKUP_MONEY_CASE`, data.pickup.x, data.pickup.y, data.pickup.z, 0.0, 0.0, 0.0, 8, 1)
					elseif not DoesPickupExist(data.pickup.id) or HasPickupBeenCollected(data.pickup.id) then
						Gui.DisplayPersonalNotification('You have collected the package.')
						removePackage(i)
						table.remove(_sightseer, i)
					else
						Gui.DrawProgressBar('DISTANCE TO PACKAGE', 1.0 - World.GetDistance(playerPosition, data.pickup) / Settings.sightseer.radius, 3, Color.GREEN)
						DrawMarker(20, data.pickup.x, data.pickup.y, data.pickup.z + 0.25, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.85, 0.85, 0.85, 114, 204, 114, 96, true, true)
					end
				end
			end

			if #_sightseer == 0 then
				finishMission(true)
				return
			end
		end
	end
end)
