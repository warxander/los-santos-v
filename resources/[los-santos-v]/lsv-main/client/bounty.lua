--TODO Instancing players?

local bountyScaleform = nil
local bountyScaleformDuration = 5500
local bountyScaleformTransitionOutDuration = 500
local bountyText = 'Watch out, someone has put a Bounty on you.'

RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	World.SetBountyPlayerId(bountyServerPlayerId)

	if not bountyServerPlayerId then return end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	if GetPlayerServerId(PlayerId()) == bountyServerPlayerId then
		Gui.DisplayNotification(bountyText, 'CHAR_LESTER_DEATHWISH', 'Unknown')

		bountyScaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		bountyScaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'BOUNTY', bountyText)

		local startDrawingTime = GetGameTimer()
		while GetGameTimer() - startDrawingTime < bountyScaleformDuration do
			Citizen.Wait(0)

			if GetGameTimer() - startDrawingTime > bountyScaleformDuration - bountyScaleformTransitionOutDuration then
				bountyScaleform:Call('SHARD_ANIM_OUT', 1, 0.33)
				startDrawingTime = startDrawingTime + bountyScaleformTransitionOutDuration

				while GetGameTimer() - startDrawingTime < bountyScaleformDuration do
					Citizen.Wait(0)
					bountyScaleform:RenderFullscreen(255, 255, 255, 255)
				end

				bountyScaleform:Delete()
				return
			end

			bountyScaleform:RenderFullscreen(255, 255, 255, 255)
		end
	else Gui.DisplayNotification('A Bounty has been set on '..Gui.GetPlayerName(bountyServerPlayerId, '~p~')..'.') end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killer)
	if GetPlayerServerId(PlayerId()) ~= killer then
		Gui.DisplayNotification('The Bounty on '..Gui.GetPlayerName(World.GetBountyPlayerId(), '~p~')..' has been claimed by '..Gui.GetPlayerName(killer, '~p~'))
	end

	World.SetBountyPlayerId(nil)
end)