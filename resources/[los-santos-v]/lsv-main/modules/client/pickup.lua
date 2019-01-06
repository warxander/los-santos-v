-- https://pastebin.com/8EuSv2r1


Pickup = { }


local pickups = {
	-- Handguns
	{ id = "PICKUP_WEAPON_PISTOL", name = "Pistol" },
	{ id = "PICKUP_WEAPON_APPISTOL", name = "AP Pistol" },
	{ id = "PICKUP_WEAPON_COMBATPISTOL", name = "Combat Pistol" },
	{ id = "PICKUP_WEAPON_FLAREGUN", name = "Flare Gun" },
	{ id = "PICKUP_WEAPON_HEAVYPISTOL", name = "Heavy Pistol" },
	{ id = "PICKUP_WEAPON_REVOLVER", name = "Heavy Revolver" },
	{ id = "PICKUP_WEAPON_MARKSMANPISTOL", name = "Marksman Pistol" },
	{ id = "PICKUP_WEAPON_PISTOL50", name = "Pistol .50" },
	{ id = "PICKUP_WEAPON_SNSPISTOL", name = "SNS Pistol" },
	{ id = "PICKUP_WEAPON_VINTAGEPISTOL", name = "Vintage Pistol" },

	--Shotguns
	{ id = "PICKUP_WEAPON_ASSAULTSHOTGUN", name = "Assault Shotgun" },
	{ id = "PICKUP_WEAPON_BULLPUPSHOTGUN", name = "Bullpup Shotgun" },
	{ id = "PICKUP_WEAPON_DBSHOTGUN", name = "Double Barrel Shotgun" },
	{ id = "PICKUP_WEAPON_HEAVYSHOTGUN", name = "Heavy Shotgun" },
	{ id = "PICKUP_WEAPON_MUSKET", name = "Musket" },
	{ id = "PICKUP_WEAPON_PUMPSHOTGUN", name = "Pump Shotgun" },
	{ id = "PICKUP_WEAPON_SAWNOFFSHOTGUN", name = "Sawed-Off Shotgun" },
	{ id = "PICKUP_WEAPON_AUTOSHOTGUN", name = "Sweeper Shotgun" },

	--Submachine Guns & Light Machine Guns
	{ id = "PICKUP_WEAPON_ASSAULTSMG", name = "Assault SMG" },
	{ id = "PICKUP_WEAPON_COMBATMG", name = "Combat MG" },
	{ id = "PICKUP_WEAPON_COMBATPDW", name = "Combat PDW" },
	{ id = "PICKUP_WEAPON_GUSENBERG", name = "Gusenberg Sweeper" },
	{ id = "PICKUP_WEAPON_MACHINEPISTOL", name = "Machine Pistol" },
	{ id = "PICKUP_WEAPON_MG", name = "MG" },
	{ id = "PICKUP_WEAPON_MICROSMG", name = "Micro SMG" },
	{ id = "PICKUP_WEAPON_MINISMG", name = "Mini SMG" },
	{ id = "PICKUP_WEAPON_SMG", name = "SMG" },

	--Assault Rifles
	{ id = "PICKUP_WEAPON_ADVANCEDRIFLE", name = "Advanced Rifle" },
	{ id = "PICKUP_WEAPON_ASSAULTRIFLE", name = "Assault Rifle" },
	{ id = "PICKUP_WEAPON_BULLPUPRIFLE", name = "Bullpup Rifle" },
	{ id = "PICKUP_WEAPON_CARBINERIFLE", name = "Carbine Rifle" },
	{ id = "PICKUP_WEAPON_COMPACTRIFLE", name = "Compact Rifle" },
	{ id = "PICKUP_WEAPON_SPECIALCARBINE", name = "Special Carbine" },

	--Thrown Weapons
	{ id = "PICKUP_WEAPON_SMOKEGRENADE", name = "Tear Gas" },
	{ id = "PICKUP_WEAPON_GRENADE", name = "Grenade" },
	{ id = "PICKUP_WEAPON_MOLOTOV", name = "Molotov Cocktail" },
	{ id = "PICKUP_WEAPON_PROXMINE", name = "Proximity Mines" },
	{ id = "PICKUP_WEAPON_PIPEBOMB", name = "Pipe Bomb" },
	{ id = "PICKUP_WEAPON_STICKYBOMB", name = "Sticky Bomb" },

	 --Ammunition
	{ id = "PICKUP_HEALTH_STANDARD", color = Color.BlipGreen(), name = "First Aid Kit" },
	{ id = "PICKUP_ARMOUR_STANDARD", color = Color.BlipBlue(), armor = true, name = "Body Armor" },

	--Heavy Weapons
	-- { id = "PICKUP_WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher" },
	-- { id = "PICKUP_WEAPON_GRENADELAUNCHER", name = "Grenade Launcher" },
	-- { id = "PICKUP_WEAPON_RPG", name = "Rocket Laucher" },
	-- { id = "PICKUP_WEAPON_HOMINGLAUNCHER", name = "Homing Laucher" },
	-- { id = "PICKUP_WEAPON_MINIGUN", name = "Minigun" },

	--Sniper Rifles
	-- { id = "PICKUP_WEAPON_HEAVYSNIPER", name = "Heavy Sniper" },
	-- { id = "PICKUP_WEAPON_SNIPERRIFLE", name = "Sniper Rifle" },
	-- { id = "PICKUP_WEAPON_MARKSMANRIFLE", name = "Marksman Rifle" },

	--Ammo
	{ id = "PICKUP_AMMO_PISTOL", name = "Pistol", ammo = true },
	{ id = "PICKUP_AMMO_FLAREGUN", name = "Flare Gun", ammo = true },
	{ id = "PICKUP_AMMO_RIFLE", name = "Rifle", ammo = true },
	{ id = "PICKUP_AMMO_SHOTGUN", name = "Shotgun", ammo = true },
	{ id = "PICKUP_AMMO_SMG", name = "SMG", ammo = true },
	{ id = "PICKUP_AMMO_MG", name = "MG", ammo = true },
	-- { id = "PICKUP_AMMO_MINIGUN", name = "Minigun", ammo = true },
	-- { id = "PICKUP_AMMO_GRENADELAUNCHER", name = "Grenade Launcher", ammo = true },
	-- { id = "PICKUP_AMMO_HOMINGLAUNCHER", name = "Homing Launcher", ammo = true },
	-- { id = "PICKUP_AMMO_RPG", name = "RPG", ammo = true },
	-- { id = "PICKUP_AMMO_SNIPER", name = "Sniper", ammo = true },
}


function Pickup.GetRandomPickup()
	return Utils.GetRandom(pickups)
end


function Pickup.GetName(id)
	local pickupHash = GetPickupHash(id)
	for _, pickup in ipairs(pickups) do
		if GetHashKey(pickup.id) == pickupHash then
			local name = pickup.name
			if pickup.ammo then name = name.." Ammo" end
			return name
		end
	end

	return nil
end