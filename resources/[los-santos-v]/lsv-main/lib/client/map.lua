Map = { }
Map.__index = Map

function Map.SetBlipText(blip, text)
	BeginTextCommandSetBlipName('STRING')
	Gui.AddText(text)
	EndTextCommandSetBlipName(blip)
end

function Map.CreatePlaceBlip(blipSprite, x, y, z, customName, color)
	local blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, blipSprite)
	SetBlipHighDetail(blip, true)
	SetBlipAsShortRange(blip, true)

	if customName then
		Map.SetBlipText(blip, customName)
	end

	if color then
		SetBlipColour(blip, color)
	end

	return blip
end

function Map.CreateRadiusBlip(x, y, z, radius, color)
	local blip = AddBlipForRadius(x, y, z, radius)

	SetBlipHighDetail(blip, true)
	SetBlipSprite(blip, Blip.BIG_CIRCLE)
	SetBlipColour(blip, color)
	SetBlipAlpha(blip, 128)

	return blip
end

function Map.CreateEventBlip(blipSprite, x, y, z, customName, color)
	local blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, blipSprite)
	SetBlipHighDetail(blip, true)
	SetBlipScale(blip, 1.1)

	if customName then
		Map.SetBlipText(blip, customName)
	end

	if color then
		SetBlipColour(blip, color)
	end

	return blip
end

function Map.CreatePickupBlip(pickup, itemId, color, name)
	local blipSprite = Blip[itemId]
	local blip = nil

	if blipSprite then
		blip = AddBlipForPickup(pickup)

		SetBlipSprite(blip, blipSprite)
		SetBlipHighDetail(blip, true)
		SetBlipAsShortRange(blip, true)

		if color then
			SetBlipColour(blip, color)
		end
	end

	if name then
		Map.SetBlipText(blip, name)
	end

	return blip
end

function Map.SetBlipFlashes(blip, time)
	if not blip or blip == 0 then
		return
	end

	SetBlipFlashes(blip, true)
	SetTimeout(time or 3000, function()
		SetBlipFlashes(blip, false)
	end)
end
