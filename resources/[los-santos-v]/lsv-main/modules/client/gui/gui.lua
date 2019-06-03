Gui = { }


function Gui.GetPlayerName(serverId, color, lowercase)
	if Player.ServerId() == serverId then
		if lowercase then
			return 'you'
		else
			return 'You'
		end
	else
		if not color then
			if Player.IsCrewMember(serverId) then color = '~b~'
			elseif serverId == World.ChallengingPlayer or serverId == World.ExecutiveSearchPlayer or serverId == World.HotPropertyPlayer or MissionManager.IsPlayerOnMission(serverId) then color = '~r~'
			else color = '~w~' end
		end

		return color..'<C>'..GetPlayerName(GetPlayerFromServerId(serverId))..'</C>~w~'
	end
end


function Gui.OpenMenu(id)
	if not WarMenu.IsAnyMenuOpened() and Player.IsActive() then WarMenu.OpenMenu(id) end
end


function Gui.DisplayHelpText(text)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentScaleform(tostring(text))
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function Gui.DisplayNotification(text, pic, title, subtitle, icon)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(tostring(text))

	if pic then
		SetNotificationMessage(pic, pic, false, icon or 4, title or '', subtitle or '')
	end

	DrawNotification(false, true)
end


function Gui.DisplayPersonalNotification(text, pic, title, subtitle, icon)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(tostring(text))
	SetNotificationBackgroundColor(200)

	if pic then
		SetNotificationMessage(pic, pic, false, icon or 4, title or '', subtitle or '')
	end

	DrawNotification(false, true)
end


function Gui.DrawRect(position, width, height, color)
	DrawRect(position.x, position.y, width, height, color.r, color.g, color.b, color.a or 255)
end


function Gui.SetTextParams(font, color, scale, shadow, outline, center)
	SetTextFont(font)
	SetTextColour(color.r, color.g, color.b, color.a or 255)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropshadow(8, 0, 0, 0, 255)
		SetTextDropShadow()
	end

	if outline then
		SetTextEdge(4, 0, 0, 0, 255)
		SetTextOutline()
	end

	if center then
		SetTextCentre(true)
	end
end


function Gui.DrawText(text, position, width)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(tostring(text))
	if width then
		SetTextRightJustify(true)
		SetTextWrap(position.x - width, position.x)
	end
	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawNumeric(number, position)
	BeginTextCommandDisplayText('NUMBER')
	if type(number) == 'number' and not string.find(number, '%.') then
		AddTextComponentInteger(number)
	else
		AddTextComponentFloat(number, 2)
	end
	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawNumericTextEntry(entry, position, ...) -- Generalize it more?
	local params = { ... }
	BeginTextCommandDisplayText(entry)
	table.foreach(params, function(v)
		if type(v) == 'number' and not string.find(v, '%.') then -- Move it to Utils?
			AddTextComponentInteger(v)
		else
			AddTextComponentFloat(v, 2) -- Configure it?
		end
	end)
	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DisplayObjectiveText(text)
	BeginTextCommandPrint('STRING')
	AddTextComponentString(tostring(text))
	EndTextCommandPrint(1, true)
end


function Gui.DrawPlaceMarker(x, y, z, radius, r, g, b, a)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, radius, radius, radius, r, g, b, a, false, nil, nil, false)
end


function Gui.StartEvent(name, message)
	PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name..' has started', message)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	end)

	FlashMinimapDisplay()
end


function Gui.StartChallenge(name)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name, '')
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	end)
end


function Gui.StartMission(name, message)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', name, message or '')
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()

		Gui.DisplayHelpText('Other players have been alerted to your activity. They can come after you to earn reward.')
	end)

	FlashMinimapDisplay()
end


function Gui.FinishMission(name, success, reason)
	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	elseif Player.IsActive() then PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	if not reason then return end

	local status = success and 'COMPLETED' or 'FAILED'
	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', string.upper(name)..' '..status, reason)
	scaleform:RenderFullscreenTimed(7000)
	scaleform:Delete()
end