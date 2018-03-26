Gui = { }


function Gui.GetPlayerName(serverId, color, lowercase)
	local player = GetPlayerServerId(PlayerId())

	if player == serverId then
		if lowercase then
			return "you"
		else
			return "You"
		end
	else
		if not color then
			if Utils.Index(Player.crewMembers, serverId) then
				color = '~b~'
			else
				color = '~w~'
			end
		end


		return color..'<C>'..GetPlayerName(GetPlayerFromServerId(serverId))..'</C>~w~'
	end
end


function Gui.DisplayHelpText(text)
	if IsHelpMessageBeingDisplayed() then return end
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function Gui.DisplayHelpTextThisFrame(text)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandDisplayHelp(0, 0, 0, -1)
end


function Gui.DisplayNotification(text, icon, title, subtitle)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)

	if icon then
		SetNotificationMessage(icon, icon, false, 4, title or "", subtitle or "")
	end

	DrawNotification(false, true)
end


function Gui.DrawRect(position, width, height, color)
	DrawRect(position.x, position.y, width, height, color.r, color.g, color.b, color.a)
end


function Gui.DrawText(text, position, font, color, scale, shadow, outline, center, rightJustify, width)
	SetTextFont(font)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropshadow(8, 0, 0, 0, 255)
		SetTextDropShadow()
	end

	if outline then
		SetTextEdge(4, 0, 0, 0, 255)
		SetTextOutline()
	end

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)

	if center then
		SetTextCentre(true)
	elseif rightJustify then
		SetTextWrap(position.x - width, position.x)
		SetTextRightJustify(true)
	end

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DisplayObjectiveText(text)
	BeginTextCommandPrint("STRING")
	AddTextComponentString(text)
	EndTextCommandPrint(1, true)
end


function Gui.DrawTimerBar(width, text, subText)
	local rectHeight = 0.038
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = GetSafeZoneSize() - rectHeight + rectHeight / 2
	local hTextMargin = 0.003
	local textFont = 0
	local textColor = { r = 255, g = 255, b = 255, a = 255 }
	local textScale = 0.32
	local subTextScale = 0.5

	if not HasStreamedTextureDictLoaded("timerbars") then
		RequestStreamedTextureDict("timerbars", true)
		while not HasStreamedTextureDictLoaded("timerbars") do Citizen.Wait(0) end
	end

	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, rectHeight, 0, 0, 0, 0, 128)
	Gui.DrawText(text, { x = GetSafeZoneSize() - width + hTextMargin, y = rectY - 0.008 }, textFont, textColor, textScale)
	Gui.DrawText(subText, { x = GetSafeZoneSize() - hTextMargin, y = rectY - 0.0175 }, textFont, textColor, subTextScale, false, false, false, true, width / 2)
end


function Gui.DrawPlaceMarker(x, y, z, radius, r, g, b, a)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, radius, radius, radius, r, g, b, a, false, nil, nil, false)
end