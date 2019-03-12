local reportedPlayers = { }
local reportingPlayer = nil
local reportingReasons = { 'Inappropriate Player Name', 'Harassment', 'Cheating', 'Spam', 'Abusing Game Mechanics', 'Inappropriate Voice Chat Language' }

local weaponCategories = {
	['Handguns'] = {
		'WEAPON_COMBATPISTOL',
		'WEAPON_APPISTOL',
		'WEAPON_PISTOL50',
		'WEAPON_FLAREGUN',
		'WEAPON_STUNGUN'
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
		'WEAPON_GUSENBERG',
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
		'WEAPON_STICKYBOMB',
		'WEAPON_PROXMINE'
	}
}


local function weaponTintKills(weaponTintIndex, weaponHash)
	if GetPedWeaponTintIndex(PlayerPedId(), weaponHash) == weaponTintIndex then return 'Used' end
	if Player.Kills >= Settings.weaponTints[weaponTintIndex].kills then return '' end
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


AddEventHandler('lsv:init', function()
	local selectedWeapon = nil
	local selectedWeaponCategory = nil

	local selectedVehicleCategory = nil

	WarMenu.CreateMenu('interaction', GetPlayerName(PlayerId()))
	WarMenu.SetTitleColor('interaction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('interaction', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('interaction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('requestVehicle', 'interaction', 'Select Vehicle Category')
	WarMenu.SetTitleBackgroundSprite('requestVehicle', 'shopui_title_carmod', 'shopui_title_carmod')
	WarMenu.CreateSubMenu('requestVehicle_vehicles', 'requestVehicle')
	WarMenu.SetMenuButtonPressedSound('requestVehicle_vehicles', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('reportPlayer', 'interaction', 'Report Player')
	WarMenu.CreateSubMenu('reportReason', 'reportPlayer', 'Select a reason for reporting')

	WarMenu.CreateSubMenu('ammunation', 'interaction', 'Ammu-Nation')
	WarMenu.SetTitleColor('ammunation', 0, 0, 0, 0)
	WarMenu.SetTitleBackgroundSprite('ammunation', 'shopui_title_gr_gunmod', 'shopui_title_gr_gunmod')

	WarMenu.CreateSubMenu('ammunation_weaponCategories', 'ammunation', 'Weapons')

	WarMenu.CreateSubMenu('ammunation_weapons', 'ammunation_weaponCategories', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weapons', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_ammunition', 'ammunation', 'Ammunition')
	WarMenu.SetMenuWidth('ammunation_ammunition', 0.25)
	WarMenu.SetMenuButtonPressedSound('ammunation_ammunition', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_upgradeWeapons', 'ammunation', 'Weapon Upgrades')

	WarMenu.CreateSubMenu('ammunation_weaponUpgrades', 'ammunation_upgradeWeapons', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weaponUpgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('duel', 'interaction', 'Select player to duel')

	while true do
		if WarMenu.IsMenuOpened('interaction') then
			if IsPlayerDead(PlayerId()) then
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Ammu-Nation', 'ammunation') then
			elseif not Player.Vehicle and WarMenu.MenuButton('Request Personal Vehicle', 'requestVehicle') then
			elseif Player.Vehicle and WarMenu.Button('Explode Personal Vehicle') then
				WarMenu.CloseMenu()
				if not NetworkRequestControlOfEntity(Player.Vehicle) then
					Gui.DisplayNotification('~r~Unable to get control of Personal Vehicle.')
				else
					NetworkExplodeVehicle(Player.Vehicle, true, true)
				end
			elseif Player.IsInFreeroam() and WarMenu.MenuButton('Start Duel', 'duel') then
			elseif WarMenu.Button('Kill Yourself') then
				SetEntityHealth(PlayerPedId(), 0)

				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Report Player', 'reportPlayer') then
			elseif MissionManager.Mission and WarMenu.Button('~r~Cancel Mission') then
				MissionManager.FinishMission()
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation') then
			if WarMenu.MenuButton('Weapons', 'ammunation_weaponCategories') then
			elseif WarMenu.MenuButton('Ammunition', 'ammunation_ammunition') then
			elseif WarMenu.MenuButton('Weapon Upgrades', 'ammunation_upgradeWeapons') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponCategories') then
			table.foreach(weaponCategories, function(_, weaponCategory)
				if WarMenu.MenuButton(weaponCategory, 'ammunation_weapons') then
					WarMenu.SetSubTitle('ammunation_weapons', weaponCategory)
					selectedWeaponCategory = weaponCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weapons') then
			table.foreach(weaponCategories[selectedWeaponCategory], function(weapon)
				if WarMenu.Button(Weapon.GetWeapon(weapon).name, weaponPrice(weapon)) then
					if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
						Gui.DisplayNotification('You already have this weapon.')
					else
						TriggerServerEvent('lsv:purchaseWeapon', weapon)
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_ammunition') then
			table.foreach(Settings.ammuNationRefillAmmo, function(data, ammoType)
				local playerWeaponByAmmoType = table.find_if(data.weapons, function(weapon) return HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) end)

				if playerWeaponByAmmoType then
					local weaponHash = GetHashKey(playerWeaponByAmmoType)
					local weaponAmmoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
					local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
					local playerAmmo = GetPedAmmoByType(PlayerPedId(), weaponAmmoType)

					if WarMenu.Button(ammoType..' '..playerAmmo..' | '..maxAmmo..' (+'..data.ammo..')',
						weaponAmmoPrice(ammoType, playerAmmo, maxAmmo)) then
						if playerAmmo == maxAmmo then
							Gui.DisplayNotification('You already have max ammo.')
						else
							TriggerServerEvent('lsv:refillAmmo', ammoType, playerWeaponByAmmoType)
						end
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_upgradeWeapons') then
			local playerWeapons = Player.GetPlayerWeapons()

			table.foreach(playerWeapons, function(weapon)
				local weaponName = Weapon.GetWeapon(weapon.id).name
				if WarMenu.MenuButton(weaponName, 'ammunation_weaponUpgrades') then
					WarMenu.SetSubTitle('ammunation_weaponUpgrades', weaponName..' UPGRADES')
					SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon.id), true)
					selectedWeapon = weapon.id
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponUpgrades') then
			local selectedWeaponHash = GetHashKey(selectedWeapon)

			table.foreach(Weapon.GetWeapon(selectedWeapon).components, function(component, componentIndex)
				if WarMenu.Button(component.name, weaponComponentPrice(componentIndex, selectedWeapon, component.hash)) and
					not HasPedGotWeaponComponent(PlayerPedId(), selectedWeaponHash, component.hash) then
						TriggerServerEvent('lsv:updateWeaponComponent', selectedWeapon, componentIndex)
				end
			end)

			if GetWeaponTintCount(selectedWeaponHash) == table.length(Settings.weaponTints) then
				table.foreach(Settings.weaponTints, function(weaponTint, weaponTintIndex)
					if WarMenu.Button(weaponTint.name, weaponTintKills(weaponTintIndex, selectedWeaponHash)) and GetPedWeaponTintIndex(PlayerPedId(), selectedWeaponHash) ~= weaponTintIndex then
						TriggerServerEvent('lsv:updateWeaponTint', selectedWeaponHash, weaponTintIndex)
					end
				end)
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('requestVehicle') then
			table.foreach(Settings.requestVehicle.vehicles, function(_, vehicleCategory)
				if WarMenu.MenuButton(vehicleCategory, 'requestVehicle_vehicles') then
					WarMenu.SetSubTitle('requestVehicle_vehicles', vehicleCategory)
					selectedVehicleCategory = vehicleCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('requestVehicle_vehicles') then
			table.foreach(Settings.requestVehicle.vehicles[selectedVehicleCategory], function(vehicle, model)
				if WarMenu.Button(vehicle.name, '$'..vehicle.cash) then
					TriggerEvent('lsv:requestVehicle', model, selectedVehicleCategory)
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('duel') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local target = GetPlayerServerId(i)
					if WarMenu.Button(GetPlayerName(i)) then
						TriggerServerEvent('lsv:requestDuel', target)
						WarMenu.CloseMenu()
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportPlayer') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local target = GetPlayerServerId(i)
					if not table.find(reportedPlayers, target) and WarMenu.MenuButton(GetPlayerName(i), 'reportReason') then
						reportingPlayer = target
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportReason') then
			table.foreach(reportingReasons, function(reason)
				if WarMenu.Button(reason) then
					TriggerServerEvent('lsv:reportPlayer', reportingPlayer, reason)
					table.insert(reportedPlayers, reportingPlayer)
					reportingPlayer = nil
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if not WarMenu.IsAnyMenuOpened() and IsControlJustReleased(1, 244) then
			WarMenu.OpenMenu('interaction')
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
