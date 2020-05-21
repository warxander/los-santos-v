AddEventHandler('lsv:init', function()
	local scaleform = Scaleform.NewAsync('MP_BIG_MESSAGE_FREEMODE')

	local instructionalButtonsScaleform = Scaleform.NewAsync('INSTRUCTIONAL_BUTTONS')

	RequestScriptAudioBank('MP_WASTED', 0)

	while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) then
				local deathSource, weaponHash = NetworkGetEntityKillerOfPlayer(PlayerId())

				local killer = nil
				if deathSource == -1 or deathSource == playerPed then
					killer = PlayerId()
				elseif IsEntityAPed(deathSource) and IsPedAPlayer(deathSource) then
					killer = NetworkGetPlayerIndexFromPed(deathSource)
				end

				local deathDetails = ''
				local playerPos = Player.Position()

				if not killer then
					TriggerServerEvent('lsv:onPlayerDied', false, playerPos)
				elseif killer == PlayerId() then
					TriggerServerEvent('lsv:onPlayerDied', true, playerPos)
				else
					local killData = { }

					killData.killer = GetPlayerServerId(killer)
					killData.position = playerPos
					killData.killerPosition = GetEntityCoords(deathSource)
					killData.isKillerInVehicle = IsPedInAnyVehicle(deathSource, false)

					killData.killDistance = math.floor(World.GetDistance(playerPos, killData.killerPosition, true))
					deathDetails = string.format('Distance: %dm', killData.killDistance)

					local hasDamagedBone, damagedBone = GetPedLastDamageBone(playerPed)
					if hasDamagedBone and damagedBone == 31086 then
						killData.headshot = true
					end

					if IsWeaponValid(weaponHash) then
						killData.weaponHash = weaponHash
						killData.weaponGroup = GetWeapontypeGroup(weaponHash)

						local weaponName = WeaponUtility.GetNameByHash(weaponHash)
						if weaponName then
							local tint = GetPedWeaponTintIndex(killer, weaponHash)
							local tintName = Settings.weaponTintNames[tint]
							if tintName then
								weaponName = weaponName..' ('..tintName..')'
							end
							deathDetails = 'Killed with '..weaponName..'\n'..deathDetails
						end
					end

					TriggerServerEvent('lsv:onPlayerKilled', killData)
				end

				StartScreenEffect('DeathFailOut', 0, true)
				ShakeGameplayCam('DEATH_FAIL_IN_EFFECT_SHAKE', 1.0)
				PlaySoundFrontend(-1, 'MP_Flash', 'WastedSounds', 1)

				instructionalButtonsScaleform:call('CLEAR_ALL')
				instructionalButtonsScaleform:call('SET_DATA_SLOT', 0, '~INPUT_ATTACK~', 'Respawn Faster')
				instructionalButtonsScaleform:call('DRAW_INSTRUCTIONAL_BUTTONS')

				scaleform:call('SHOW_SHARD_WASTED_MP_MESSAGE', '~r~WASTED', deathDetails)

				repeat
					scaleform:renderFullscreen()
					instructionalButtonsScaleform:renderFullscreen()
					Citizen.Wait(0)
				until not IsPedFatallyInjured(PlayerPedId())

				StopScreenEffect('DeathFailOut')
				StopGameplayCamShaking(true)
			end
		end
	end
end)
