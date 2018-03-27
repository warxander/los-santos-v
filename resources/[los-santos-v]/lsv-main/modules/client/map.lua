Map = { }


function Map.CreatePlaceBlip(blipSprite, x, y, z, customName)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, blipSprite)
	SetBlipHighDetail(blip, true)
	SetBlipAsShortRange(blip, true)

	if customName then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(customName)
		EndTextCommandSetBlipName(blip)
	end

	return blip
end


function Map.CreateRadiusBlip(x, y, z, radius, color)
	local blip = AddBlipForRadius(x, y, z, radius)

	SetBlipHighDetail(blip, true)
	SetBlipSprite(blip, Blip.BigCircle())
	SetBlipColour(blip, color)
	SetBlipAlpha(blip, 128)

	return blip
end


function Map.CreatePickupBlip(pickup, itemId, color)
	local blipSprite = Blip.GetPickupBlipSpriteId(itemId)
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

	return blip
end