AddEventHandler('lsv:init', function()
	local bodyArmorTime = nil
	local bodyArmorTimeout = nil

	local refillAmmoTime = nil
	local refillAmmoTimeout = nil

	local repairVehicleTime = nil
	local repairVehicleTimeout = nil

	local buttonScaleform = Scaleform:Request('INSTRUCTIONAL_BUTTONS')

	while true do
		Citizen.Wait(0)

		local buttons = { }

		if bodyArmorTime then
			bodyArmorTimeout = (Settings.equipBodyArmorTimeout * 1000) - GetTimeDifference(GetGameTimer(), bodyArmorTime)

			if bodyArmorTimeout < 0 then
				bodyArmorTimeout = nil
				bodyArmorTime = nil
			end
		end

		if refillAmmoTime then
			refillAmmoTimeout = (Settings.refillAmmoTimeout * 1000) - GetTimeDifference(GetGameTimer(), refillAmmoTime)

			if refillAmmoTimeout < 0 then
				refillAmmoTimeout = nil
				refillAmmoTime = nil
			end
		end

		if repairVehicleTime then
			repairVehicleTimeout = (Settings.repairVehicleTimeout * 1000) - GetTimeDifference(GetGameTimer(), repairVehicleTime)

			if repairVehicleTimeout < 0 then
				repairVehicleTimeout = nil
				repairVehicleTime = nil
			end
		end


		if not IsEntityDead(PlayerPedId()) and not WarMenu.IsAnyMenuOpened() then
			local playerVehicle = IsPedSittingInAnyVehicle(PlayerPedId()) and GetVehiclePedIsIn(PlayerPedId(), false)

			if playerVehicle and IsVehicleDamaged(playerVehicle) then
				local repairVehicleLabel = "Repair Vehicle"
				if repairVehicleTimeout then repairVehicleLabel = repairVehicleLabel.." ("..math.floor(repairVehicleTimeout / 1000)..")" end

				table.insert(buttons, { input = "~INPUT_SAVE_REPLAY_CLIP~", label = repairVehicleLabel })

				if IsControlJustPressed(0, 170) then -- F3
					if not repairVehicleTime then
						StartScreenEffect("SuccessFranklin", 0, false)
						PlaySoundFrontend(1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
						SetVehicleFixed(playerVehicle)
						repairVehicleTime = GetGameTimer()
					else
						PlaySoundFrontend(1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						Gui.DisplayNotification("~r~You cannot Repair Vehicle right now.")
					end
				end
			end


			for id, weapon in pairs(Weapon.GetWeapons()) do
				local weaponHash = GetHashKey(id)

				if weaponHash == GetSelectedPedWeapon(PlayerPedId()) then
					local hasAmmo, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)

					if hasAmmo and GetAmmoInPedWeapon(PlayerPedId(), weaponHash) ~= maxAmmo and not weapon.unique then
						local refillAmmoLabel = "Refill Ammo"
						if refillAmmoTimeout then refillAmmoLabel = refillAmmoLabel.." ("..math.floor(refillAmmoTimeout / 1000)..")" end

						table.insert(buttons, { input = "~INPUT_REPLAY_START_STOP_RECORDING_SECONDARY~", label = refillAmmoLabel })

						if IsControlJustPressed(0, 289) then -- F2
							if not refillAmmoTime then
								StartScreenEffect("SuccessTrevor", 0, false)
								PlaySoundFrontend(1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
								AddAmmoToPed(PlayerPedId(), weaponHash, GetWeaponClipSize(weaponHash) * Settings.refillAmmoClipCount)
								refillAmmoTime = GetGameTimer()
							else
								PlaySoundFrontend(1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
								Gui.DisplayNotification("~r~You cannot Refill Ammo right now.")
							end
						end
					end

					break
				end
			end


			if GetPedArmour(PlayerPedId()) ~= GetPlayerMaxArmour(PlayerId()) then
				local equipBodyArmorLabel = "Equip Body Armor"
				if bodyArmorTimeout then equipBodyArmorLabel = equipBodyArmorLabel.." ("..math.floor(bodyArmorTimeout / 1000)..")" end

				table.insert(buttons, { input = "~INPUT_REPLAY_START_STOP_RECORDING~", label = equipBodyArmorLabel })

				if IsControlJustPressed(0, 288) then -- F1
					if not bodyArmorTime then
						StartScreenEffect("SuccessMichael", 0, false)
						PlaySoundFrontend(1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
						AddArmourToPed(PlayerPedId(), math.floor(GetPlayerMaxArmour(PlayerId()) * Settings.equipBodyArmorPercentage))
						bodyArmorTime = GetGameTimer()
					else
						PlaySoundFrontend(1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						Gui.DisplayNotification("~r~You cannot Equip Body Armor right now.")
					end
				end
			end


			buttonScaleform:Call('CLEAR_ALL')

			for buttonIndex = 1, Utils.GetTableLength(buttons) do
				buttonScaleform:Call('SET_DATA_SLOT', buttonIndex - 1, buttons[buttonIndex].input, buttons[buttonIndex].label)
			end

			buttonScaleform:Call('DRAW_INSTRUCTIONAL_BUTTONS')
			buttonScaleform:RenderFullscreen()
		end
	end
end)