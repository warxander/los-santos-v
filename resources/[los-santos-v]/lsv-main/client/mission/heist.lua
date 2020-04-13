local _placeBlip = nil
local _placeAreaBlip = nil

RegisterNetEvent('lsv:heistFinished')
AddEventHandler('lsv:heistFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	RemoveBlip(_placeBlip)
	RemoveBlip(_placeAreaBlip)

	Gui.FinishMission('Heist', success, reason)
end)

AddEventHandler('lsv:startHeist', function()
	local missionTimer = Timer.New()

	local location = table.random(Settings.heist.places)
	local stealTimer = nil
	local take = 0
	local loseTheCopsStage = false

	_placeBlip = Map.CreatePlaceBlip(Blip.STORE, location.x, location.y, location.z, 'Store', Color.BLIP_YELLOW)
	SetBlipAsShortRange(_placeBlip, false)
	SetBlipRouteColour(_placeBlip, Color.BLIP_YELLOW)
	SetBlipRoute(_placeBlip, true)
	Map.SetBlipFlashes(_placeBlip)

	_placeAreaBlip = Map.CreateRadiusBlip(location.x, location.y, location.z, Settings.heist.radius, Color.BLIP_YELLOW)
	SetBlipAlpha(_placeAreaBlip, 0)

	Gui.StartMission('Heist', 'Go to the store and steal as much as possible.')

	World.EnableWanted(true)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				if not loseTheCopsStage then
					if Player.DistanceTo(location) < Settings.heist.radius then
						Gui.DisplayObjectiveText('Stay in the ~y~store~w~ to steal as much as possible.')

						if not IsPlayerDead(PlayerId()) then
							if not stealTimer then
								stealTimer = Timer.New()
								SetBlipAlpha(_placeBlip, 0)
								SetBlipAlpha(_placeAreaBlip, 128)
								World.SetWantedLevel(2, 3, true)
							elseif stealTimer:elapsed() >= Settings.heist.take.interval then
								take = math.min(Settings.heist.take.rate.cash.limit, take + GetRandomIntInRange(Settings.heist.take.rate.cash.min, Settings.heist.take.rate.cash.max))
								PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)
								stealTimer:restart()

								if take == Settings.heist.take.rate.cash.limit then
									loseTheCopsStage = true
								end
							end
						else
							loseTheCopsStage = true
						end
					else
						if stealTimer then
							loseTheCopsStage = true
						else
							Gui.DisplayObjectiveText('Go to the ~y~store~w~.')
						end
					end
				else
					Gui.DisplayObjectiveText('Lose the cops.')
				end
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:heistFinished', false)
			return
		end

		if missionTimer:elapsed() < Settings.heist.time then
			Gui.DrawTimerBar('MISSION TIME', Settings.heist.time - missionTimer:elapsed(), 1)
			if stealTimer then
				Gui.DrawBar('TAKE', '$'..take, 2)
			end

			if stealTimer or loseTheCopsStage then
				if IsPlayerDead(PlayerId()) then
					TriggerEvent('lsv:heistFinished', false)
					return
				end
			end

			if loseTheCopsStage then
				SetBlipAlpha(_placeBlip, 0)
				SetBlipRoute(_placeBlip, false)
				SetBlipAlpha(_placeAreaBlip, 0)

				if GetPlayerWantedLevel(PlayerId()) == 0 then
					TriggerServerEvent('lsv:heistFinished', take)
					return
				end
			end
		else
			TriggerEvent('lsv:heistFinished', false, 'Time is over.')
			return
		end
	end
end)
