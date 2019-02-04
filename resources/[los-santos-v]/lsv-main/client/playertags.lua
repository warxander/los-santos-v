AddEventHandler('lsv:init', function()
	while true do
		for id = 0, Settings.maxPlayerCount do
			if id ~= PlayerId() and NetworkIsPlayerActive(id) then
				local playerPed = GetPlayerPed(id)
				
				local healthBarVisible = IsPlayerFreeAimingAtEntity(PlayerId(), playerPed)
				local isPlayerTalking = NetworkIsPlayerTalking(id)
				local visible = healthBarVisible or isPlayerTalking

				local patreonTier = Scoreboard.GetPlayerPatreonTier(id) or 0

				local gamerTag = CreateMpGamerTag(playerPed, GetPlayerName(id), false, false, '', 0)

				local color = patreonTier == 0 and 0 or 31

				-- https://runtime.fivem.net/doc/reference.html#_0x63BB75ABEDC1F6A0
				SetMpGamerTagName(gamerTag, GetPlayerName(id))

				SetMpGamerTagColour(gamerTag, 0, color)
				SetMpGamerTagColour(gamerTag, 2, color)
				SetMpGamerTagColour(gamerTag, 4, color)
				SetMpGamerTagColour(gamerTag, 7, color)
				SetMpGamerTagHealthBarColour(gamerTag, color)

				SetMpGamerTagAlpha(gamerTag, 0, 255)
				SetMpGamerTagAlpha(gamerTag, 2, 255)
				SetMpGamerTagAlpha(gamerTag, 4, 255)
				SetMpGamerTagAlpha(gamerTag, 7, 255)

				SetMpGamerTagVisibility(gamerTag, 0, visible) -- GAMER_NAME
				SetMpGamerTagVisibility(gamerTag, 2, healthBarVisible) -- HEALTH/ARMOR
				SetMpGamerTagVisibility(gamerTag, 4, isPlayerTalking) -- AUDIO_ICON
				SetMpGamerTagVisibility(gamerTag, 7, healthBarVisible and patreonTier ~= 0) -- WANTED_STARS
			end
		end

		Citizen.Wait(0)
	end
end)