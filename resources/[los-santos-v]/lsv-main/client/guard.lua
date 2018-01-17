local banned = false
local blacklistWeapons = {
	"WEAPON_RAILGUN",
	"WEAPON_GARBAGEBAG",
}


RegisterNetEvent('lsv:playerBanned')
AddEventHandler('lsv:playerBanned', function(name, cheatName)
	Gui.DisplayNotification('<C>'..tostring(name)..'</C> was banned ('..tostring(cheatName)..').')
end)


AddEventHandler('lsv:init', function()
	local weaponHash = nil

	while true do
		Citizen.Wait(0)

		if banned then return end

		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		ResetEntityAlpha(PlayerPedId())
		SetEntityVisible(PlayerPedId(), true)

		if GetPlayerInvincible(PlayerId()) and not IsEntityDead(PlayerPedId()) then
			TriggerServerEvent('lsv:banPlayer', 'God Mode')
			banned = true
			return
		end

		for _, weapon in ipairs(blacklistWeapons) do
			weaponHash = GetHashKey(weapon)
			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) then RemoveWeaponFromPed(PlayerPedId(), weaponHash) end
		end
	end
end)