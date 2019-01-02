AmmuNation = { }


local ammunations = {
	{ blip = nil, ['x'] = 251.37934875488, ['y'] = -48.90043258667, ['z'] = 69.941062927246 },
	{ blip = nil, ['x'] = 843.44445800781, ['y'] = -1032.1590576172, ['z'] = 28.194854736328 },
	{ blip = nil, ['x'] = 810.82800292969, ['y'] = -2156.3671875, ['z'] = 29.619010925293 },
	{ blip = nil, ['x'] = 20.719049453735, ['y'] = -1108.0506591797, ['z'] = 29.797027587891 },
	{ blip = nil, ['x'] = -662.86431884766, ['y'] = -936.32116699219, ['z'] = 21.829231262207 },
	{ blip = nil, ['x'] = -1306.2987060547, ['y'] = -393.93954467773, ['z'] = 36.695774078369 },
	{ blip = nil, ['x'] = -3171.1555175781, ['y'] = 1086.576171875, ['z'] = 20.838750839233 },
	{ blip = nil, ['x'] = -1117.4243164063, ['y'] = 2697.328125, ['z'] = 18.554145812988 },
	{ blip = nil, ['x'] = -329.94900512695, ['y'] = 6082.3178710938, ['z'] = 31.454774856567 },
	{ blip = nil, ['x'] = 2568.3815917969, ['y'] = 295.02661132813, ['z'] = 108.73487854004 },
	{ blip = nil, ['x'] = 1693.8348388672, ['y'] = 3759.2829589844, ['z'] = 34.705318450928 },
}


local weaponCategories = {
	['Handguns'] = {
		'WEAPON_COMBATPISTOL',
		'WEAPON_APPISTOL',
		'WEAPON_PISTOL50'
	},
	['Shotguns'] = {
		'WEAPON_SAWNOFFSHOTGUN',
		'WEAPON_PUMPSHOTGUN',
		'WEAPON_BULLPUPSHOTGUN',
		'WEAPON_ASSAULTSHOTGUN'
	},
	['Submachine & Lightmachine Guns'] = {
		'WEAPON_MICROSMG',
		'WEAPON_SMG',
		'WEAPON_ASSAULTSMG',
		'WEAPON_MG',
		'WEAPON_COMBATMG'
	},
	['Assault Rifles'] = {
		'WEAPON_ASSAULTRIFLE',
		'WEAPON_CARBINERIFLE',
		'WEAPON_ADVANCEDRIFLE'
	},
	['Thrown Weapons'] = {
		'WEAPON_SMOKEGRENADE',
		'WEAPON_GRENADE',
		'WEAPON_MOLOTOV',
		'WEAPON_STICKYBOMB'
	}
}

local ammoByWeaponTypes = {
	['Pistol Rounds'] = {
		'WEAPON_PISTOL'
	},
	['Shotgun Shells'] = {
		'WEAPON_SAWNOFFSHOTGUN',
		'WEAPON_PUMPSHOTGUN',
		'WEAPON_BULLPUPSHOTGUN',
		'WEAPON_ASSAULTSHOTGUN'
	},
	['SMG Rounds'] = {
		'WEAPON_MICROSMG',
		'WEAPON_SMG',
		'WEAPON_ASSAULTSMG'
	},
	['MG Rounds'] = {
		'WEAPON_MG',
		'WEAPON_COMBATMG'
	},
	['Assault Rifle Rounds'] = {
		'WEAPON_ASSAULTRIFLE',
		'WEAPON_CARBINERIFLE',
		'WEAPON_ADVANCEDRIFLE'
	},
	['Tear Gas Units'] = {
		'WEAPON_SMOKEGRENADE'
	},
	['Grenade Units'] = {
		'WEAPON_GRENADE',
	},
	['Molotov Cocktail Units'] = {
		'WEAPON_MOLOTOV'
	},
	['Sticky Bomb Units'] = {
		'WEAPON_STICKYBOMB'
	}
}


local function weaponTintKills(weaponTintIndex, weaponHash)
	if GetPedWeaponTintIndex(PlayerPedId(), weaponHash) == weaponTintIndex then return 'Used' end
	if Player.kills >= Settings.weaponTints[weaponTintIndex].kills then return '' end
	return Settings.weaponTints[weaponTintIndex].kills..' Kills'
end


local function weaponComponentPrice(componentIndex, weapon, componentHash)
	local weaponHash = GetHashKey(weapon)
	if HasPedGotWeaponComponent(PlayerPedId(), weaponHash, componentHash) then return 'Owned' end
	return '$'..Weapon.GetWeapon(weapon).components[componentIndex].cash
end


local function weaponPrice(weapon)
	if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then return 'Owned' end
	return '$'..Weapon.GetWeapon(weapon).cash
end


local function weaponAmmoPrice(ammoType, ammo, maxAmmo)
	if ammo == maxAmmo then return 'Maxed' end
	return '$'..Settings.ammuNationRefillAmmo[ammoType].price
end


function AmmuNation.GetPlaces()
	return ammunations
end


AddEventHandler('lsv:init', function()
	local selectedWeapon = nil
	local selectedWeaponCategory = nil

	for _, ammunation in ipairs(ammunations) do
		ammunation.blip = Map.CreatePlaceBlip(Blip.AmmuNation(), ammunation.x, ammunation.y, ammunation.z)
	end

	WarMenu.CreateMenu('ammunation', '')
	WarMenu.SetSubTitle('ammunation', '')
	WarMenu.SetTitleBackgroundColor('ammunation', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('ammunation', 'shopui_title_gunclub', 'shopui_title_gunclub')

	WarMenu.CreateSubMenu('ammunation_weaponCategories', 'ammunation', 'Weapons')

	WarMenu.CreateSubMenu('ammunation_weapons', 'ammunation_weaponCategories', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weapons', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_ammunition', 'ammunation', 'Ammunition')
	WarMenu.SetMenuButtonPressedSound('ammunation_ammunition', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_upgradeWeapons', 'ammunation', 'Weapon Upgrades')

	WarMenu.CreateSubMenu('ammunation_weaponUpgrades', 'ammunation_upgradeWeapons', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weaponUpgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		if WarMenu.IsMenuOpened('ammunation') then
			if WarMenu.MenuButton('Weapons', 'ammunation_weaponCategories') then
			elseif WarMenu.MenuButton('Ammunition', 'ammunation_ammunition') then
			elseif WarMenu.MenuButton('Weapon Upgrades', 'ammunation_upgradeWeapons') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponCategories') then
			for weaponCategory, _ in pairs(weaponCategories) do
				if WarMenu.MenuButton(weaponCategory, 'ammunation_weapons') then
					WarMenu.SetSubTitle('ammunation_weapons', weaponCategory)
					selectedWeaponCategory = weaponCategory
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weapons') then
			for _, weapon in ipairs(weaponCategories[selectedWeaponCategory]) do
				if WarMenu.Button(Weapon.GetWeapon(weapon).name, weaponPrice(weapon)) then
					if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
						Gui.DisplayNotification('You already have this weapon.')
					else
						TriggerServerEvent('lsv:purchaseWeapon', weapon)
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_ammunition') then
			for ammoType, weapons in pairs(ammoByWeaponTypes) do
				local playerWeaponByAmmoType = nil

				for _, weapon in pairs(weapons) do
					if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
						playerWeaponByAmmoType = weapon
						break
					end
				end

				if playerWeaponByAmmoType then
					local weaponHash = GetHashKey(playerWeaponByAmmoType)
					local weaponAmmoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
					local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
					local playerAmmo = GetPedAmmoByType(PlayerPedId(), weaponAmmoType)

					if WarMenu.Button(ammoType..' '..playerAmmo..' | '..maxAmmo..' (+'..Settings.ammuNationRefillAmmo[ammoType].ammo..')',
						weaponAmmoPrice(ammoType, playerAmmo, maxAmmo)) then
						if playerAmmo == maxAmmo then
							Gui.DisplayNotification('You already have max ammo.')
						else
							TriggerServerEvent('lsv:refillAmmo', ammoType, playerWeaponByAmmoType)
						end
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_upgradeWeapons') then
			local playerWeapons = Player.GetPlayerWeapons()

			for _, weapon in ipairs(playerWeapons) do
				local weaponName = Weapon.GetWeapon(weapon.id).name
				if WarMenu.MenuButton(weaponName, 'ammunation_weaponUpgrades') then
					WarMenu.SetSubTitle('ammunation_weaponUpgrades', weaponName..' UPGRADES')
					SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon.id), true)
					selectedWeapon = weapon.id
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponUpgrades') then
			local selectedWeaponHash = GetHashKey(selectedWeapon)

			for componentIndex, component in ipairs(Weapon.GetWeapon(selectedWeapon).components) do
				if WarMenu.Button(component.name, weaponComponentPrice(componentIndex, selectedWeapon, component.hash)) and
					not HasPedGotWeaponComponent(PlayerPedId(), selectedWeaponHash, component.hash) then
						TriggerServerEvent('lsv:updateWeaponComponent', selectedWeapon, componentIndex)
				end
			end

			if GetWeaponTintCount(selectedWeaponHash) == Utils.GetTableLength(Settings.weaponTints) then
				for weaponTintIndex, weaponTint in ipairs(Settings.weaponTints) do
					if WarMenu.Button(weaponTint.name, weaponTintKills(weaponTintIndex, selectedWeaponHash)) and GetPedWeaponTintIndex(PlayerPedId(), selectedWeaponHash) ~= weaponTintIndex then
						TriggerServerEvent('lsv:updateWeaponTint', selectedWeaponHash, weaponTintIndex)
					end
				end
			end

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	local ammunationOpenedMenuIndex = nil
	local ammunationColor = Color.GetHudFromBlipColor(Color.BlipRed())
	local openedFromInteractionMenu = true -- It's hacky but seems to work

	while true do
		Citizen.Wait(0)

		for ammunationIndex, ammunation in ipairs(ammunations) do
			Gui.DrawPlaceMarker(ammunation.x, ammunation.y, ammunation.z - 1, Settings.placeMarkerRadius, ammunationColor.r, ammunationColor.g, ammunationColor.b, Settings.placeMarkerOpacity)

			if Vdist(ammunation.x, ammunation.y, ammunation.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < Settings.placeMarkerRadius then
				if not WarMenu.IsAnyMenuOpened() then
					Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to browse weapons.')

					if IsControlJustReleased(0, 38) then
						ammunationOpenedMenuIndex = ammunationIndex
						openedFromInteractionMenu = false
						WarMenu.OpenMenu('ammunation')
					end
				end
			else
				local isAmmunationMenuOpened = not openedFromInteractionMenu and
					(WarMenu.IsMenuOpened('ammunation') or
					WarMenu.IsMenuOpened('ammunation_weapons') or
					WarMenu.IsMenuOpened('ammunation_weaponCategories') or
					WarMenu.IsMenuOpened('ammunation_ammunition') or
					WarMenu.IsMenuOpened('ammunation_weaponUpgrades') or
					WarMenu.IsMenuOpened('ammunation_upgradeWeapons'))

				if isAmmunationMenuOpened and ammunationIndex == ammunationOpenedMenuIndex then
					openedFromInteractionMenu = true
					WarMenu.CloseMenu()
				end
			end
		end
	end
end)


RegisterNetEvent('lsv:weaponTintUpdated')
AddEventHandler('lsv:weaponTintUpdated', function(weaponHash, weaponTintIndex)
	if weaponHash then
		SetPedWeaponTintIndex(PlayerPedId(), weaponHash, weaponTintIndex)
		Player.SaveWeapons()
	else Gui.DisplayNotification('~r~You don\'t have enough kills.') end
end)


RegisterNetEvent('lsv:weaponComponentUpdated')
AddEventHandler('lsv:weaponComponentUpdated', function(weapon, componentIndex)
	if weapon then
		GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), Weapon.GetWeapon(weapon).components[componentIndex].hash)
		Player.SaveWeapons()
	else Gui.DisplayNotification('~r~You don\'t have enough cash.') end
end)


RegisterNetEvent('lsv:weaponPurchased')
AddEventHandler('lsv:weaponPurchased', function(weapon)
	if weapon then
		local weaponHash = GetHashKey(weapon)
		GiveWeaponToPed(PlayerPedId(), weaponHash, Weapon.GetSpawningAmmo(weaponHash), false, true)
		Player.SaveWeapons()
	else Gui.DisplayNotification('~r~You don\'t have enough cash.') end
end)

RegisterNetEvent('lsv:ammoRefilled')
AddEventHandler('lsv:ammoRefilled', function(weapon, amount)
	if amount then AddAmmoToPed(PlayerPedId(), GetHashKey(weapon), amount)
	else Gui.DisplayNotification('~r~You don\'t have enough cash.') end
end)
