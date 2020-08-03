Map = { }
Map.__index = Map

local function setBlipProperties(blip, blipSprite, customName, color)
	SetBlipHighDetail(blip, true)

	if blipSprite then
		SetBlipSprite(blip, blipSprite)
	end

	if customName then
		Map.SetBlipText(blip, customName)
	end

	if color then
		SetBlipColour(blip, color)
	end

	SetBlipRouteColour(blip, color or GetBlipColour(blip))
end

function Map.SetBlipText(blip, text)
	BeginTextCommandSetBlipName('STRING')
	Gui.AddText(text)
	EndTextCommandSetBlipName(blip)
end

function Map.CreateEntityBlip(entity, blipSprite, customName, color)
	local blip = AddBlipForEntity(entity)

	setBlipProperties(blip, blipSprite, customName, color)

	return blip
end

function Map.CreatePlaceBlip(blipSprite, x, y, z, customName, color)
	local blip = AddBlipForCoord(x, y, z)

	setBlipProperties(blip, blipSprite, customName, color)
	SetBlipAsShortRange(blip, true)

	return blip
end

function Map.CreateRadiusBlip(x, y, z, radius, color)
	local blip = AddBlipForRadius(x, y, z, radius)

	setBlipProperties(blip, Blip.BIG_CIRCLE, nil, color)
	SetBlipAlpha(blip, 96)

	return blip
end

function Map.CreateEventBlip(blipSprite, x, y, z, customName, color)
	local blip = AddBlipForCoord(x, y, z)

	setBlipProperties(blip, blipSprite, customName, color)
	SetBlipScale(blip, 1.1)

	return blip
end

function Map.CreatePickupBlip(pickup, blipSprite, customName, color)
	local blip = AddBlipForPickup(pickup)

	setBlipProperties(blip, blipSprite, customName, color)
	SetBlipAsShortRange(blip, true)

	return blip
end

function Map.SetBlipFlashes(blip, time)
	SetBlipFlashes(blip, true)
	SetBlipFlashTimer(blip, time or 5000)
end
