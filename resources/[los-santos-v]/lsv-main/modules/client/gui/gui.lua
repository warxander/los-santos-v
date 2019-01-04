Gui = { }

local cashGained = 0
local cashGainedTime = nil


function Gui.GetPlayerName(serverId, color, lowercase)
	if Player.ServerId() == serverId then
		if lowercase then
			return "you"
		else
			return "You"
		end
	else
		if not color then
			if Player.isCrewMember(serverId) then
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
	AddTextComponentScaleform(tostring(text))
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function Gui.DisplayHelpTextThisFrame(text)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(tostring(text))
	EndTextCommandDisplayHelp(0, 0, 0, -1)
end


function Gui.DisplayNotification(text, pic, title, subtitle, icon)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(tostring(text))

	if pic then
		SetNotificationMessage(pic, pic, false, icon or 4, title or "", subtitle or "")
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
	AddTextComponentSubstringPlayerName(tostring(text))

	if center then
		SetTextCentre(true)
	elseif rightJustify then
		SetTextRightJustify(true)
		if width then SetTextWrap(position.x - width, position.x)
		else SetTextWrap(SafeZone.Left(), position.x) end
	end

	EndTextCommandDisplayText(position.x, position.y)
end


function Gui.DisplayObjectiveText(text)
	BeginTextCommandPrint("STRING")
	AddTextComponentString(tostring(text))
	EndTextCommandPrint(1, true)
end


function Gui.DrawPlaceMarker(x, y, z, radius, r, g, b, a)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, radius, radius, radius, r, g, b, a, false, nil, nil, false)
end


function Gui.StartJob(jobId, message, tip)
	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
	Gui.DisplayNotification(message)

	if not tip then return end
	SetTimeout(3000, function()
		if JobWatcher.IsJobInProgress(jobId) then Gui.DisplayHelpText(tip) end
	end)
end


function Gui.FinishJob(name, success, reason)
	StartScreenEffect('SuccessMichael', 0, false)

	if success then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	elseif not IsPlayerDead(PlayerId()) then PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	local status = success and 'COMPLETED' or 'FAILED'
	local message = reason or ''

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', string.upper(name)..' '..status, message)
	scaleform:RenderFullscreenTimed(7000)

	scaleform:Delete()
end


AddEventHandler('lsv:cashUpdated', function(cash)
	cashGained = cashGained + cash
	cashGainedTime = GetGameTimer()
end)


AddEventHandler('lsv:init', function()
	cashGainedTime = GetGameTimer()

	Streaming.RequestStreamedTextureDict('MPHud')

	local screenWidth, screenHeight = GetScreenResolution()
	local spriteScale = 18.0
	local textScale = 0.5

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), cashGainedTime) < Settings.cashGainedNotificationTime then
			if cashGained ~=0 and not IsPlayerDead(PlayerId()) then
				local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
				local z = playerZ + 1.0
				local sign = cashGained > 0 and '+' or '-'
				local color = cashGained > 0 and Color.GetHudFromBlipColor(Color.BlipWhite()) or Color.GetHudFromBlipColor(Color.BlipRed())

				SetDrawOrigin(playerX, playerY, z, 0)
				DrawSprite('MPHud', 'mp_anim_cash', 0.0, 0.0, spriteScale / screenWidth, spriteScale / screenHeight, 0.0, 255, 255, 255, 255)
				Gui.DrawText(sign..'$'..math.abs(cashGained), { x = spriteScale / 2 / screenWidth, y = -spriteScale / 2 / screenHeight - 0.004 }, 4,
					color, textScale, true, true)
				ClearDrawOrigin()
			end
		else cashGained = 0 end
	end
end)