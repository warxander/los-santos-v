local _ammunations = {
	{ x = 251.37934875488, y = -48.90043258667, z = 69.941062927246 },
	{ x = 843.44445800781, y = -1032.1590576172, z = 28.194854736328 },
	{ x = 810.82800292969, y = -2156.3671875, z = 29.619010925293 },
	{ x = 20.719049453735, y = -1108.0506591797, z = 29.797027587891 },
	{ x = -662.86431884766, y = -936.32116699219, z = 21.829231262207 },
	{ x = -1306.2987060547, y = -393.93954467773, z = 36.695774078369 },
	{ x = -3171.1555175781, y = 1086.576171875, z = 20.838750839233 },
	{ x = -1117.4243164063, y = 2697.328125, z = 18.554145812988 },
	{ x = -329.94900512695, y = 6082.3178710938, z = 31.454774856567 },
	{ x = 2568.3815917969, y = 295.02661132813, z = 108.73487854004 },
	{ x = 1693.8348388672, y = 3759.2829589844, z = 34.705318450928 },
}

local _selectedWeapon = nil
local _selectedAmmoType = nil

local _crateData = nil

local function specialWeaponAmmoPrice(weapon, ammo, maxAmmo)
	if ammo == maxAmmo then
		return 'Maxed'
	end

	return '$'..Settings.ammuNationSpecialAmmo[weapon].price
end

local function fullSpecialWeaponAmmoPrice(weapon, ammoClipCount)
	if ammoClipCount == 0 then
		return 'Maxed'
	end

	return '$'..tostring(ammoClipCount * Settings.ammuNationSpecialAmmo[weapon].price)
end

RegisterNetEvent('lsv:specialAmmoRefilled')
AddEventHandler('lsv:specialAmmoRefilled', function(weapon, amount, fullAmmo)
	if amount then
		if not fullAmmo then
			AddAmmoToPed(PlayerPedId(), GetHashKey(weapon), amount)
		else
			local weaponHash = GetHashKey(weapon)
			local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
			SetPedAmmo(PlayerPedId(), weaponHash, maxAmmo)
		end
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:specialCratePurchased')
AddEventHandler('lsv:specialCratePurchased', function(purchased)
	if purchased then
		WarMenu.CloseMenu()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:spawnSpecialCrate')
AddEventHandler('lsv:spawnSpecialCrate', function(crate)
	if _crateData then
		return
	end

	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('We have been dropped a Special Crate for you.', 'CHAR_AMMUNATION', 'Ammu-Nation', '', 2)

	_crateData = { }
	_crateData.pickup = CreatePickupRotate(`PICKUP_PORTABLE_CRATE_UNFIXED`, crate.position.x, crate.position.y, crate.position.z, 0.0, 0.0, 0.0, 512)
	_crateData.position = crate.position
	_crateData.location = crate.location
	_crateData.areaBlip = Map.CreateRadiusBlip(crate.location.x, crate.location.y, crate.location.z, Settings.crate.radius, Color.BLIP_YELLOW)

	_crateData.blip = Map.CreatePlaceBlip(Blip.CRATE_DROP, crate.location.x, crate.location.y, crate.location.z, nil, Color.BLIP_YELLOW)
	SetBlipAsShortRange(_crateData.blip, false)
	SetBlipScale(_crateData.blip, 1.5)
	Map.SetBlipFlashes(_crateData.blip)

	FlashMinimapDisplay()

	while true do
		Citizen.Wait(0)

		if HasPickupBeenCollected(_crateData.pickup) then
			TriggerServerEvent('lsv:specialCratePickedUp')
			return
		end

		if Player.IsInFreeroam() then
			if Player.DistanceTo(_crateData.location) < Settings.crate.radius then
				Gui.DrawProgressBar('CRATE DISTANCE', 1.0 - Player.DistanceTo(_crateData.position) / Settings.crate.radius, 7, Color.YELLOW)
			end
		end
	end
end)

RegisterNetEvent('lsv:specialCratePickedUp')
AddEventHandler('lsv:specialCratePickedUp', function(crate)
	local playerPed = PlayerPedId()

	SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))
	GiveWeaponToPed(playerPed, GetHashKey(crate.weapon.id), crate.weapon.ammo, false, true)

	Gui.DisplayPersonalNotification('Crate Contents:~w~\n+ $'..Settings.crate.reward.cash..'\n+ '..crate.weapon.name..'\n+ Body Armor')
	Player.SaveWeapons()

	RemoveBlip(_crateData.areaBlip)
	RemoveBlip(_crateData.blip)

	_crateData = nil
end)

AddEventHandler('lsv:init', function()
	table.iforeach(_ammunations, function(ammunation)
		Map.CreatePlaceBlip(Blip.AMMU_NATION, ammunation.x, ammunation.y, ammunation.z)
	end)

	Gui.CreateMenu('ammunation_special', '')
	WarMenu.SetSubTitle('ammunation_special', 'Special Weapons')
	WarMenu.SetTitleBackgroundColor('ammunation_special', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('ammunation_special', 'shopui_title_gunclub', 'shopui_title_gunclub')

	WarMenu.CreateSubMenu('ammunation_special_ammunition', 'ammunation_special', 'Ammunition')

	WarMenu.CreateSubMenu('ammunation_special_ammo', 'ammunation_special', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_special_ammo', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('ammunation_special') then
			if WarMenu.MenuButton('Ammunition', 'ammunation_special_ammunition') then
			elseif WarMenu.Button('Drop Special Crate', '$'..Settings.crate.cash) then
				if _crateData then
					Gui.DisplayPersonalNotification('Your Special Crate was already delivered.')
				else
					TriggerServerEvent('lsv:purchaseSpecialCrate')
					Prompt.ShowAsync()
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_special_ammunition') then
			table.foreach(Settings.ammuNationSpecialAmmo, function(data, weapon)
				local weaponHash = GetHashKey(weapon)
				if HasPedGotWeapon(PlayerPedId(), weaponHash, false) then
					if WarMenu.MenuButton(Weapon[weapon].name..' '..data.type, 'ammunation_special_ammo') then
						_selectedWeapon = weapon
						_selectedAmmoType = data.type
						WarMenu.SetSubTitle('ammunation_special_ammo', Weapon[weapon].name..' '..data.type)
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_special_ammo') then
			local weaponHash = GetHashKey(_selectedWeapon)
			local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
			local weaponAmmoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
			local playerAmmo = GetPedAmmoByType(PlayerPedId(), weaponAmmoType)

			local ammoClipCount = 0
			if playerAmmo ~= maxAmmo then
				ammoClipCount = math.max(1, math.floor((maxAmmo - playerAmmo) / Settings.ammuNationSpecialAmmo[_selectedWeapon].ammo))
			end

			if WarMenu.Button('Full Ammo', fullSpecialWeaponAmmoPrice(_selectedWeapon, ammoClipCount)) then
				if playerAmmo == maxAmmo then
					Gui.DisplayPersonalNotification('You already have max ammo.')
				else
					TriggerServerEvent('lsv:refillSpecialAmmo', _selectedWeapon, ammoClipCount)
					Prompt.ShowAsync()
				end
			elseif WarMenu.Button(_selectedAmmoType..' x'..Settings.ammuNationSpecialAmmo[_selectedWeapon].ammo, specialWeaponAmmoPrice(_selectedWeapon, playerAmmo, maxAmmo)) then
				if playerAmmo == maxAmmo then
					Gui.DisplayPersonalNotification('You already have max ammo.')
				else
					TriggerServerEvent('lsv:refillSpecialAmmo', _selectedWeapon)
					Prompt.ShowAsync()
				end
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local ammunationOpenedMenuIndex = nil
	local ammunationColor = Color.RED

	while true do
		Citizen.Wait(0)

		if Player.IsActive() then
			table.iforeach(_ammunations, function(ammunation, ammunationIndex)
				Gui.DrawPlaceMarker(ammunation, ammunationColor)

				if Player.DistanceTo(ammunation, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to browse Special Weapons ammunition.')

						if IsControlJustReleased(0, 46) then
							ammunationOpenedMenuIndex = ammunationIndex
							openedFromInteractionMenu = false
							Gui.OpenMenu('ammunation_special')
						end
					end
				elseif (WarMenu.IsMenuOpened('ammunation_special') or WarMenu.IsMenuOpened('ammunation_special_ammunition') or WarMenu.IsMenuOpened('ammunation_special_ammo')) and ammunationIndex == ammunationOpenedMenuIndex then
					WarMenu.CloseMenu()
					Player.SaveWeapons()
					Prompt.Hide()
				end
			end)
		end
	end
end)
