Citizen.CreateThread(function()
	local bodyArmorTime = nil
	local bodyArmorTimeout = nil

	local requestVehicleTime = nil
	local requestVehicleTimeout = nil

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

		if requestVehicleTime then
			requestVehicleTimeout = (Settings.requestVehicleTimeout * 1000) - GetTimeDifference(GetGameTimer(), requestVehicleTime)

			if requestVehicleTimeout < 0 then
				requestVehicleTimeout = nil
				requestVehicleTime = nil
			end
		end

		if repairVehicleTime then
			repairVehicleTimeout = (Settings.repairVehicleTimeout * 1000) - GetTimeDifference(GetGameTimer(), repairVehicleTime)

			if repairVehicleTimeout < 0 then
				repairVehicleTimeout = nil
				repairVehicleTime = nil
			end
		end


		if not IsEntityDead(PlayerPedId()) and Player.initialized then

			-- Equip Body Armor
			if GetPedArmour(PlayerPedId()) ~= GetPlayerMaxArmour(PlayerId()) then
				local equipBodyArmorLabel = "Equip Body Armor"

				if bodyArmorTimeout then
					equipBodyArmorLabel = equipBodyArmorLabel.." ("..tostring(math.floor(bodyArmorTimeout / 1000))..")"
				else
					equipBodyArmorLabel = equipBodyArmorLabel.." ($"..tostring(Settings.equipBodyArmorPrice)..")"
				end

				table.insert(buttons, { input = "~INPUT_CELLPHONE_LEFT~", label = equipBodyArmorLabel })

				if IsControlJustPressed(0, 174) and not WarMenu.IsAnyMenuOpened() then --ARROWLEFT
					if not bodyArmorTime then
						if Player.IsEnoughMoney(Settings.equipBodyArmorPrice) then
							StartScreenEffect("SuccessMichael", 0, false)
							PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
							SetPedArmour(PlayerPedId(), GetPlayerMaxArmour(PlayerId()))
							Player.ChangeMoney(-Settings.equipBodyArmorPrice)

							bodyArmorTime = GetGameTimer()
						else
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
							Gui.DisplayNotification("You don't have enough money to Equip Body Armor.")
						end
					else
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						Gui.DisplayNotification("You cannot Equip Body Armor right now.")
					end
				end
			end


			for _, weapon in ipairs(Weapon.GetWeapons()) do
				local weaponHash = GetHashKey(weapon.id)

				if weaponHash == GetSelectedPedWeapon(PlayerPedId()) then

					-- Set All Attachments
					if Utils.GetTableLength(weapon.components) ~= 0 then
						local hasAllComponents = true
						for _, component in ipairs(weapon.components) do
							if not component.owned then
								hasAllComponents = false
								break
							end
						end

						if not hasAllComponents then
							table.insert(buttons, { input = "~INPUT_CELLPHONE_DOWN~",
								label = "Set All Attachments ($"..tostring(Settings.setAllAttachmentsPrice)..")" })

							if IsControlJustPressed(0, 173) and not WarMenu.IsAnyMenuOpened() then --ARROWDOWN
								if Player.IsEnoughMoney(Settings.setAllAttachmentsPrice) then
									StartScreenEffect("SuccessMichael", 0, false)
									PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)

									for _, component in ipairs(weapon.components) do
										GiveWeaponComponentToPed(PlayerPedId(), weaponHash, component.hash)
										component.owned = true
									end

									Player.ChangeMoney(-Settings.setAllAttachmentsPrice)
								else
									PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
									Gui.DisplayNotification("You don't have enough money to Set All Attachments.")
								end
							end
						end
					end

					-- Refill Ammo
					local hasAmmo, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
					if hasAmmo and GetAmmoInPedWeapon(PlayerPedId(), weaponHash) ~= maxAmmo and not weapon.unique then
						table.insert(buttons, { input = "~INPUT_CELLPHONE_UP~",
							label = "Refill Ammo ($"..tostring(Settings.refillAmmoPrice)..")" })

						if IsControlJustPressed(0, 172) and not WarMenu.IsAnyMenuOpened() then --ARROWUP
							if Player.IsEnoughMoney(Settings.refillAmmoPrice) then
								StartScreenEffect("SuccessTrevor", 0, false)
								PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
								AddAmmoToPed(PlayerPedId(), weaponHash, maxAmmo)

								Player.ChangeMoney(-Settings.refillAmmoPrice)
							else
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
								Gui.DisplayNotification("You don't have enough money to Refill Ammo.")
							end
						end
					end

					break
				end
			end

			-- Request Vehicle / Repair Vehicle
			if Player.vehicleModel then
				local vehicleLabel = nil

				if not Player.vehicle then
					vehicleLabel = 'Request Vehicle'

					if requestVehicleTimeout then
						vehicleLabel = vehicleLabel.." ("..tostring(math.floor(requestVehicleTimeout / 1000))..")"
					else
						vehicleLabel = vehicleLabel.." ($"..tostring(Settings.requestVehiclePrice)..")"
					end

					if IsControlJustPressed(0, 175) and not WarMenu.IsAnyMenuOpened() then --ARROWRIGHT
						if not requestVehicleTime then
							if Player.IsEnoughMoney(Settings.requestVehiclePrice) then
								local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
								local x = playerX + GetRandomIntInRange(-Settings.requestRadius, Settings.requestRadius)
								local y = playerY + GetRandomIntInRange(-Settings.requestRadius, Settings.requestRadius)
								local isValidCoords, coords = GetSafeCoordForPed(x, y, playerZ, false, 16)

								if isValidCoords then
									StartScreenEffect("SuccessFranklin", 0, false)
									PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
									local vehicleX, vehicleY, vehicleZ = table.unpack(coords)
									Player.SpawnVehicle({x = vehicleX, y = vehicleY, z = vehicleZ, heading = GetEntityHeading(PlayerPedId())})
									Player.ChangeMoney(-Settings.requestVehiclePrice)
									requestVehicleTime = GetGameTimer()
								else
									PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
									Gui.DisplayNotification("You should stay near the road to Request Vehicle.")
								end
							else
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
								Gui.DisplayNotification("You don't have enough money to Request Vehicle.")
							end
						else
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
							Gui.DisplayNotification("You cannot Request Vehicle right now.")
						end
					end
				elseif IsPedInVehicle(PlayerPedId(), Player.vehicle, false) and IsVehicleDamaged(Player.vehicle) then
					vehicleLabel = 'Repair Vehicle'
					if repairVehicleTimeout then
						vehicleLabel = vehicleLabel.." ("..tostring(math.floor(repairVehicleTimeout / 1000))..")"
					else
						vehicleLabel = vehicleLabel.." ($"..tostring(Settings.repairVehiclePrice)..")"
					end

					if IsControlJustPressed(0, 175) and not WarMenu.IsAnyMenuOpened() then --ARROWRIGHT
						if not repairVehicleTime then
							if Player.IsEnoughMoney(Settings.repairVehiclePrice) then
								StartScreenEffect("SuccessFranklin", 0, false)
								PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)

								SetVehicleFixed(Player.vehicle)

								Player.ChangeMoney(-Settings.repairVehiclePrice)
								repairVehicleTime = GetGameTimer()
							else
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
								Gui.DisplayNotification("You don't have enough money to Repair Vehicle.")
							end
						else
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
							Gui.DisplayNotification("You cannot Repair Vehicle right now.")
						end
					end
				end

				if vehicleLabel then
					table.insert(buttons, { input = "~INPUT_CELLPHONE_RIGHT~", label = vehicleLabel })
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