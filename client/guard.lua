local banned = false
local blacklistWeapons = {
	"WEAPON_RAILGUN",
	"WEAPON_GARBAGEBAG",
}


RegisterNetEvent('lsv:playerBanned')
AddEventHandler('lsv:playerBanned', function(name, cheatName)
	Gui.DisplayNotification('<C>'..tostring(name)..'</C> was banned ('..tostring(cheatName)..').')
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if Player.initialized then
			if banned then return end

			SetPedInfiniteAmmoClip(PlayerPedId(), false)
			ResetEntityAlpha(PlayerPedId())
			SetEntityVisible(PlayerPedId(), true)

			if GetPlayerInvincible(PlayerId()) and not IsEntityDead(PlayerPedId()) then
				TriggerServerEvent('lsv:banPlayer', 'God Mode')
				banned = true
				return
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if Player.initialized then
			if banned then return end

			for _, weapon in ipairs(blacklistWeapons) do
				if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
					RemoveAllPedWeapons(PlayerPedId(), false)
					TriggerServerEvent('lsv:banPlayer', 'Blacklist Weapon: '..tostring(weapon))
					banned = true
					return
				end
			end
		end
	end
end)