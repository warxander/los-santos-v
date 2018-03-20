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

local ammunationColor = Color.GetHudFromBlipColor(Color.Red)


function AmmuNation.GetPlaces()
	return ammunations
end


local function updateLoadout(weapon, playerWeapon, slotEvent)
	if weapon.id == playerWeapon then return end
	TriggerServerEvent(slotEvent, weapon.id)
end


local function updateMeleeWeapon(weapon)
	updateLoadout(weapon, Player.meleeWeapon, 'lsv:updateMeleeWeapon')
end


local function updatePrimaryWeapon(weapon)
	updateLoadout(weapon, Player.primaryWeapon, 'lsv:updatePrimaryWeapon')
end


local function updateSecondaryWeapon(weapon)
	updateLoadout(weapon, Player.secondaryWeapon, 'lsv:updateSecondaryWeapon')
end


local function updateGadget1(gadget)
	updateLoadout(gadget, Player.gadget1, 'lsv:updateGadget1')
end

local function updateGadget2(gadget)
	updateLoadout(gadget, Player.gadget2, 'lsv:updateGadget2')
end


AddEventHandler('lsv:init', function()
	for _, ammunation in pairs(ammunations) do
		ammunation.blip = Map.CreatePlaceBlip(Blip.AmmuNation(), ammunation.x, ammunation.y, ammunation.z)
	end

	WarMenu.CreateMenu('ammunation', 'Ammu-Nation')
	WarMenu.SetSubTitle('ammunation', 'SLOTS')
	WarMenu.SetTitleBackgroundColor('ammunation', ammunationColor.r, ammunationColor.g, ammunationColor.b)

	WarMenu.CreateSubMenu('ammunation_melee', 'ammunation', 'MELEE WEAPONS')
	WarMenu.SetMenuButtonPressedSound('ammunation_melee', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_primary', 'ammunation', 'PRIMARY WEAPONS')
	WarMenu.SetMenuButtonPressedSound('ammunation_primary', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_secondary', 'ammunation', 'SECONDARY WEAPONS')
	WarMenu.SetMenuButtonPressedSound('ammunation_secondary', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_gadget1', 'ammunation', 'GADGET 1')
	WarMenu.SetMenuButtonPressedSound('ammunation_gadget1', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_gadget2', 'ammunation', 'GADGET 2')
	WarMenu.SetMenuButtonPressedSound('ammunation_gadget2', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		if WarMenu.IsMenuOpened('ammunation') then
			if WarMenu.MenuButton('Melee Weapon', 'ammunation_melee') then
			elseif WarMenu.MenuButton('Primary Weapon', 'ammunation_primary') then
			elseif WarMenu.MenuButton('Secondary Weapon', 'ammunation_secondary') then
			elseif WarMenu.MenuButton('Gadget 1', 'ammunation_gadget1') then
			elseif WarMenu.MenuButton('Gadget 2', 'ammunation_gadget2') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_melee') then
			for _, weapon in pairs(Weapon.GetMeleeWeapons()) do
				if WarMenu.Button(weapon.name) then
					updateMeleeWeapon(weapon)
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_primary') then
			for _, weapon in pairs(Weapon.GetPrimaryWeapons()) do
				if WarMenu.Button(weapon.name) then
					updatePrimaryWeapon(weapon)
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_secondary') then
			for _, weapon in pairs(Weapon.GetSecondaryWeapons()) do
				if WarMenu.Button(weapon.name) then
					updateSecondaryWeapon(weapon)
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_gadget1') then
			for _, gadget in pairs(Weapon.GetGadgets()) do
				if gadget.id ~= Player.gadget2 and WarMenu.Button(gadget.name) then
					updateGadget1(gadget)
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_gadget2') then
			for _, gadget in pairs(Weapon.GetGadgets()) do
				if gadget.id ~= Player.gadget1 and WarMenu.Button(gadget.name) then
					updateGadget2(gadget)
				end
			end
			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	local ammunationOpenedMenuIndex = nil

	while true do
		Citizen.Wait(0)

		for ammunationIndex, ammunation in pairs(ammunations) do
			Gui.DrawPlaceMarker(ammunation.x, ammunation.y, ammunation.z - 1, Settings.placeMarkerRadius, ammunationColor.r, ammunationColor.g, ammunationColor.b, Settings.placeMarkerOpacity)

			if Vdist(ammunation.x, ammunation.y, ammunation.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < Settings.placeMarkerRadius then
				if not WarMenu.IsAnyMenuOpened() then
					Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to customize Loadout.')

					if IsControlJustReleased(0, 38) then
						ammunationOpenedMenuIndex = ammunationIndex
						WarMenu.OpenMenu('ammunation')
					end
				end
			elseif WarMenu.IsMenuOpened('ammunation') and ammunationIndex == ammunationOpenedMenuIndex then
				WarMenu.CloseMenu()
			end
		end
	end
end)


RegisterNetEvent('lsv:meleeWeaponUpdated')
AddEventHandler('lsv:meleeWeaponUpdated', function(meleeWeapon)
	Player.UpdateMeleeWeapon(meleeWeapon)
end)


RegisterNetEvent('lsv:primaryWeaponUpdated')
AddEventHandler('lsv:primaryWeaponUpdated', function(primaryWeapon)
	Player.UpdatePrimaryWeapon(primaryWeapon)
end)


RegisterNetEvent('lsv:secondaryWeaponUpdated')
AddEventHandler('lsv:secondaryWeaponUpdated', function(secondaryWeapon)
	Player.UpdateSecondaryWeapon(secondaryWeapon)
end)


RegisterNetEvent('lsv:gadget1Updated')
AddEventHandler('lsv:gadget1Updated', function(gadget1)
	Player.UpdateGadget1(gadget1)
end)


RegisterNetEvent('lsv:gadget2Updated')
AddEventHandler('lsv:gadget2Updated', function(gadget2)
	Player.UpdateGadget2(gadget2)
end)