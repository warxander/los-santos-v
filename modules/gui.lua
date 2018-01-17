Gui = { }


function Gui.GetPlayerName(serverId, color, lowercase)
	local player = GetPlayerServerId(PlayerId())

	if tonumber(player) == tonumber(serverId) then
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
	ClearAllHelpMessages()
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


function Gui.Draw()
	if not HasStreamedTextureDictLoaded("timerbars") then
		RequestStreamedTextureDict("timerbars", true)
		while not HasStreamedTextureDictLoaded("timerbars") do
			Citizen.Wait(0)
		end
	end

	local x = 0.9225
	local y = 0.88
	local spacing = 0.0025
	local width = 0.12
	local height = 0.04
	local textXOffset = 0.0035
	local textYOffset = 0.0015
	local textScale = 0.635
	local color = { r = 255, g = 255, b = 255, a = 185 }
	local moneyColor = Color.GetHudFromBlipColor(Color.Green)
	moneyColor.a = 255

	DrawSprite("timerbars", "all_black_bg", x, y, width, height, 0, color.r, color.b, color.g, color.a)
	Gui.DrawText('$'..tostring(Player.money), { ['x'] = 0.9825 - textXOffset, ['y'] = y - height / 2 + textYOffset }, 7, moneyColor, textScale, false, true, false, true, width - textXOffset)
end