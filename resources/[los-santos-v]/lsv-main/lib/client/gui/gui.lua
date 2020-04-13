Gui = { }
Gui.__index = Gui

function Gui.GetPlayerName(serverId, color, lowercase)
	if Player.ServerId() == serverId then
		if lowercase then
			return 'you'
		else
			return 'You'
		end
	else
		if not color then
			local isPlayerEnforcer = false
			local isPlayerCriminal = false
			if Player.Faction ~= Settings.faction.Neutral and PlayerData.IsExists(serverId) then
				local faction = PlayerData.GetFaction(serverId)
				isPlayerEnforcer = faction == Settings.faction.Enforcer
				isPlayerCriminal = faction == Settings.faction.Criminal
			end

			if Player.IsCrewMember(serverId) then
				color = '~b~'
			elseif isPlayerEnforcer then
				color = '~d~'
			elseif serverId == World.ChallengingPlayer or serverId == World.BeastPlayer or serverId == World.HotPropertyPlayer or isPlayerCriminal then
				color = '~r~'
			elseif MissionManager.IsPlayerOnMission(serverId) then
				color = '~p~'
			else
				color = '~w~'
			end
		end

		return color..'<C>'..GetPlayerName(GetPlayerFromServerId(serverId))..'</C>~w~'
	end
end

function Gui.OpenMenu(id)
	if not WarMenu.IsAnyMenuOpened() and Player.IsActive() then
		WarMenu.OpenMenu(id)
	end
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


function Gui.DrawPlaceMarker(position, color, radius)
	if not radius then
		radius = Settings.placeMarker.radius
	end

	if IsSphereVisible(position.x, position.y, position.z, radius) then
		DrawMarker(1, position.x, position.y, position.z - 1, 0, 0, 0, 0, 0, 0, radius * 2, radius * 2, radius * 2, color.r, color.g, color.b, color.a or Settings.placeMarker.opacity, false, nil, nil, false)
	end
end

function Gui.StartEvent(name, message)
	PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', name..' has started', message)
		scaleform:renderFullscreenTimed(10000)
	end)

	FlashMinimapDisplay()
end

function Gui.StartChallenge(name)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', name, '')
		scaleform:renderFullscreenTimed(10000)
	end)
end

function Gui.StartMission(name, message)
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)

	Citizen.CreateThread(function()
		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', name, message or '')
		scaleform:renderFullscreenTimed(10000)

		Gui.DisplayHelpText('Other players have been alerted to your activity. They can come after you to earn reward.')
	end)

	FlashMinimapDisplay()
end

function Gui.FinishMission(name, success, reason)
	if success then
		PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	else
		PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
	end

	if not reason then
		return
	end

	if Player.IsActive() then
		local status = success and 'COMPLETED' or 'FAILED'
		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', string.upper(name)..' '..status, reason)
		scaleform:renderFullscreenTimed(7000)
	else
		Gui.DisplayPersonalNotification(success and 'You have completed '..name..'.' or 'You have failed '..name..'.')
	end
end

function Gui.FinishChallenge(winner, looser, challengeName)
	if not winner then
		return
	end

	if winner ~= Player.ServerId() and looser ~= Player.ServerId() then
		Gui.DisplayNotification(Gui.GetPlayerName(winner)..' has defeated '..Gui.GetPlayerName(looser)..' in '..challengeName..'.')
		return
	end

	local isWinner = winner == Player.ServerId()

	if isWinner then
		PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	else
		PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
	end

	if Player.IsActive() then
		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', isWinner and 'WINNER' or 'LOOSER', '')
		scaleform:renderFullscreenTimed(7000)
	else
		Gui.DisplayPersonalNotification(isWinner and 'You have won '..challengeName..'.' or 'You have lost '..challengeName..'.')
	end
end
