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
			elseif serverId == World.ChallengingPlayer or serverId == World.BeastPlayer or serverId == World.HotPropertyPlayer or MissionManager.IsPlayerOnMission(serverId) then color = '~r~'
			else color = '~w~' end
		end

		return color..'<C>'..GetPlayerName(GetPlayerFromServerId(serverId))..'</C>~w~'
	end
end


function Gui.OpenMenu(id)
	if not WarMenu.IsAnyMenuOpened() and Player.IsActive() then WarMenu.OpenMenu(id) end
end


function Gui.AddText(text)
	local str = tostring(text)
	local strLen = string.len(str)
	local maxStrLength = 99

	for i = 1, strLen, maxStrLength + 1 do
		if i > strLen then
			return
		end

		AddTextComponentString(string.sub(str, i, i + maxStrLength))
	end
end


function Gui.DisplayHelpText(text)
	BeginTextCommandDisplayHelp('STRING')
	Gui.AddText(text)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function Gui.DisplayNotification(text, pic, title, subtitle, icon)
	BeginTextCommandThefeedPost('STRING')
	Gui.AddText(text)

	if pic then
		EndTextCommandThefeedPostMessagetext(pic, pic, false, icon or 4, title or '', subtitle or '')
	else
		EndTextCommandThefeedPostTicker(true, true)
	end
end


function Gui.DisplayPersonalNotification(text, pic, title, subtitle, icon)
	BeginTextCommandThefeedPost('STRING')
	Gui.AddText(text)
	ThefeedNextPostBackgroundColor(200)

	if pic then
		EndTextCommandThefeedPostMessagetext(pic, pic, false, icon or 4, title or '', subtitle or '')
	else
		EndTextCommandThefeedPostTicker(true, true)
	end
end


function Gui.DrawRect(position, width, height, color)
	DrawRect(position.x, position.y, width, height, color.r, color.g, color.b, color.a or 255)
end


function Gui.SetTextParams(font, color, scale, shadow, outline, center)
	SetTextFont(font)
	SetTextColour(color.r, color.g, color.b, color.a or 255)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow()
	end

	if outline then
		SetTextOutline()
	end

	if center then
		SetTextCentre(true)
	end
end


function Gui.DrawText(text, position, width)
	BeginTextCommandDisplayText('STRING')
	Gui.AddText(text)

	if width then
		SetTextRightJustify(true)
		SetTextWrap(position.x - width, position.x)
	end

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawTextEntry(entry, position, ...)
	BeginTextCommandDisplayText(entry)

	local params = { ... }
	table.iforeach(params, function(param)
		local paramType = type(param)
		if paramType == 'string' then
			AddTextComponentString(param)
		elseif paramType == 'number' then
			if math.is_integer(param) then
				AddTextComponentInteger(param)
			else
				AddTextComponentFloat(param, 2)
			end
		end
	end)

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DrawNumeric(number, position)
	Gui.DrawTextEntry('NUMBER', position, number)
end


function Gui.DisplayObjectiveText(text)
	BeginTextCommandPrint('STRING')
	Gui.AddText(text)
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
