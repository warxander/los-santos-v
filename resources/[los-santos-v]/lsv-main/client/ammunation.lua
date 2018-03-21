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


AddEventHandler('lsv:init', function()
	for _, ammunation in ipairs(ammunations) do
		ammunation.blip = Map.CreatePlaceBlip(Blip.AmmuNation(), ammunation.x, ammunation.y, ammunation.z)
	end

	WarMenu.CreateMenu('ammunation', 'Ammu-Nation')
	WarMenu.SetSubTitle('ammunation', 'WEAPONS')
	WarMenu.SetTitleBackgroundColor('ammunation', ammunationColor.r, ammunationColor.g, ammunationColor.b)

	while true do
		if WarMenu.IsMenuOpened('ammunation') then
			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	local ammunationOpenedMenuIndex = nil

	while true do
		Citizen.Wait(0)

		for ammunationIndex, ammunation in ipairs(ammunations) do
			Gui.DrawPlaceMarker(ammunation.x, ammunation.y, ammunation.z - 1, Settings.placeMarkerRadius, ammunationColor.r, ammunationColor.g, ammunationColor.b, Settings.placeMarkerOpacity)

			if Vdist(ammunation.x, ammunation.y, ammunation.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < Settings.placeMarkerRadius then
				if not WarMenu.IsAnyMenuOpened() then
					Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to browse weapons.')

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