Weapon = { }


local weapons = {
	{ id = "WEAPON_KNIFE", name = "Knife",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_STUNGUN", name = "Stun Gun",
		components = { 
		},
		price = 1000,
	},
	{ id = "WEAPON_FLASHLIGHT", name = "Flashlight",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_NIGHTSTICK", name = "Nightstick",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_HAMMER", name = "Hammer",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_BAT", name = "Bat",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_GOLFCLUB", name = "Golf Club",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_CROWBAR", name = "Crowbar",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_SAWNOFFSHOTGUN", name = "Sawed-Off Shotgun",
		components = { 
		},
		price = 3000,
	},
	{ id = "WEAPON_REMOTESNIPER", name = "Remote Sniper",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_RPG", name = "RPG",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_MINIGUN", name = "Minigun",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_GRENADE", name = "Grenade",
		components = { 
		},
		price = 2500,
	},
	{ id = "WEAPON_STICKYBOMB", name = "Sticky Bomb",
		components = { 
		},
		price = 6000,
	},
	{ id = "WEAPON_SMOKEGRENADE", name = "Tear Gas",
		components = { 
		},
		price = 1500,
	},
	{ id = "WEAPON_MOLOTOV", name = "Molotov Cocktail",
		components = { 
		},
		price = 3500,
	},
	{ id = "WEAPON_BOTTLE", name = "Broken Bottle",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_GUSENBERG", name = "Gusenberg Sweeper",
		components = { 
		},
		price = 146000,
	},
	{ id = "WEAPON_DAGGER", name = "Antique Cavalry Dagger",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_MUSKET", name = "Musket",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_HOMINGLAUNCHER", name = "Homing Launcher",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_PROXMINE", name = "Proximity Mine",
		components = { 
		},
		price = 10000,
	},
	{ id = "WEAPON_FLAREGUN", name = "Flare Gun",
		components = { 
		},
		price = 37500,
	},
	{ id = "WEAPON_MARKSMANPISTOL", name = "Marksman Pistol",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_KNUCKLE", name = "Knuckledusters",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_HATCHET", name = "Hatchet",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_MACHETE", name = "Machete",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_SWITCHBLADE", name = "Switchblade",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_REVOLVER", name = "Heavy Revolver",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_DBSHOTGUN", name = "Double Barrel Shotgun",
		components = { 
		},
		price = 154500,
	},
	{ id = "WEAPON_AUTOSHOTGUN", name = "Sweeper Shotgun",
		components = { 
		},
		price = 149000,
	},
	{ id = "WEAPON_BATTLEAXE", name = "Battle Axe",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher",
		components = { 
		},
		unique = true,
	},
	{ id = "WEAPON_PIPEBOMB", name = "Pipe Bomb",
		components = { 
		},
		price = 5000,
	},
	{ id = "WEAPON_POOLCUE", name = "Pool Cue",
		components = { 
		},
		melee = true,
	},
	{ id = "WEAPON_WRENCH", name = "Pipe Wrench",
		components = { 
		},
		melee = true,
	},

	{ id = "WEAPON_PISTOL", name = "Pistol",
		components = {
			{ owned = nil, hash = 3978713628, name = "Extended Clip" },
			{ owned = nil, hash = 1709866683, name = "Suppressor" },
		},
		price = 0,
	},


	{ id = "WEAPON_MINISMG", name = "Mini SMG",
		components = {
			{ owned = nil, hash = 2474561719, name = "Extended Clip" },
		},
		price = 89000,
	},

	{ id = "WEAPON_MACHINEPISTOL", name = "Machine Pistol",
		components = {
			{ owned = nil, hash = 3106695545, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
		},
		price = 62500,
	},

	{ id = "WEAPON_COMPACTRIFLE", name = "Compact Rifle",
		components = {
			{ owned = nil, hash = 1509923832, name = "Extended Clip" },
		},
		price = 146500,
	},

	{ id = "WEAPON_COMBATPDW", name = "Combat PDW",
		components = {
			{ owned = nil, hash = 860508675, name = "Extended Clip" },
			{ owned = nil, hash = 202788691, name = "Grip" },
			{ owned = nil, hash = 2855028148, name = "Scope" },
		},
		price = 117500,
	},

	{ id = "WEAPON_SNSPISTOL", name = "SNS Pistol",
		components = {
			{ owned = nil, hash = 2063610803, name = "Extended Clip" },
		},
		price = 27500,
	},

	{ id = "WEAPON_HEAVYPISTOL", name = "Heavy Pistol",
		components = {
			{ owned = nil, hash = 1694090795, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
		},
		price = 37500,
	},

	{ id = "WEAPON_SPECIALCARBINE", name = "Special Carbine",
		components = {
			{ owned = nil, hash = 2089537806, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 2698550338, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 147500,
	},

	{ id = "WEAPON_BULLPUPRIFLE", name = "Bullpup Rifle",
		components = {
			{ owned = nil, hash = 3009973007, name = "Extended Clip" },
			{ owned = nil, hash = 2205435306, name = "Suppressor" },
			{ owned = nil, hash = 2855028148, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 145000,
	},

	{ id = "WEAPON_VINTAGEPISTOL", name = "Vintage Pistol",
		components = {
			{ owned = nil, hash = 867832552, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
		},
		price = 34500,
	},

	{ id = "WEAPON_HEAVYSHOTGUN", name = "Heavy Shotgun",
		components = {
			{ owned = nil, hash = 2535257853, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 135500,
	},

	{ id = "WEAPON_MARKSMANRIFLE", name = "Marksman Rifle",
		components = {
			{ owned = nil, hash = 3439143621, name = "Extended Clip" },
			{ owned = nil, hash = 2205435306, name = "Suppressor" },
			{ owned = nil, hash = 471997210, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		unique = true,
	},

	{ id = "WEAPON_COMBATPISTOL", name = "Combat Pistol",
		components = {
			{ owned = nil, hash = 3598405421, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
		},
		price = 32000,
	},

	{ id = "WEAPON_APPISTOL", name = "AP Pistol",
		components = {
			{ owned = nil, hash = 614078421, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
		},
		price = 50000,
	},

	{ id = "WEAPON_PISTOL50", name = "Pistol .50",
		components = {
			{ owned = nil, hash = 3654528146, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
		},
		price = 40000, --TODO unique?
	},

	{ id = "WEAPON_MICROSMG", name = "Micro SMG",
		components = {
			{ owned = nil, hash = 283556395, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 2637152041, name = "Scope" },
		},
		price = 37500,
	},

	{ id = "WEAPON_SMG", name = "SMG",
		components = {
			{ owned = nil, hash = 889808635, name = "Extended Clip" },
			{ owned = nil, hash = 3271853210, name = "Suppressor" },
			{ owned = nil, hash = 1019656791, name = "Scope" },
		},
		price = 75000,
	},

	{ id = "WEAPON_ASSAULTSMG", name = "Assault SMG",
		components = {
			{ owned = nil, hash = 3141985303, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 2637152041, name = "Scope" },
		},
		price = 125500,
	},

	{ id = "WEAPON_ASSAULTRIFLE", name = "Assault Rifle",
		components = {
			{ owned = nil, hash = 2971750299, name = "Extended Clip" },
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 2637152041, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 85500,
	},

	{ id = "WEAPON_CARBINERIFLE", name = "Carbine Rifle",
		components = {
			{ owned = nil, hash = 2433783441, name = "Extended Clip" },
			{ owned = nil, hash = 2205435306, name = "Suppressor" },
			{ owned = nil, hash = 2698550338, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 130000,
	},

	{ id = "WEAPON_ADVANCEDRIFLE", name = "Advanced Rifle",
		components = {
			{ owned = nil, hash = 2395064697, name = "Extended Clip" },
			{ owned = nil, hash = 2205435306, name = "Suppressor" },
			{ owned = nil, hash = 2855028148, name = "Scope" },
		},
		price = 142500,
	},

	{ id = "WEAPON_MG", name = "MG",
		components = {
			{ owned = nil, hash = 2182449991, name = "Extended Clip" },
			{ owned = nil, hash = 1006677997, name = "Scope" },
		},
		price = 135000,
	},

	{ id = "WEAPON_COMBATMG", name = "Combat MG",
		components = {
			{ owned = nil, hash = 3603274966, name = "Extended Clip" },
			{ owned = nil, hash = 2698550338, name = "Scope" },
		},
		price = 148000,
	},

	{ id = "WEAPON_PUMPSHOTGUN", name = "Pump Shotgun",
		components = {
			{ owned = nil, hash = 3859329886, name = "Suppressor" },
		},
		price = 35000,
	},

	{ id = "WEAPON_ASSAULTSHOTGUN", name = "Assault Shotgun",
		components = {
			{ owned = nil, hash = 2260565874, name = "Extended Clip" },
			{ owned = nil, hash = 2205435306, name = "Suppressor" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 100000,
	},

	{ id = "WEAPON_BULLPUPSHOTGUN", name = "Bullpup Shotgun",
		components = {
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		price = 80000,
	},

	{ id = "WEAPON_SNIPERRIFLE", name = "Sniper Rifle",
		components = {
			{ owned = nil, hash = 2805810788, name = "Suppressor" },
			{ owned = nil, hash = 3159677559, name = "Advanced Scope" },
		},
		unique = true,
	},

	{ id = "WEAPON_HEAVYSNIPER", name = "Heavy Sniper",
		components = {
			{ owned = nil, hash = 3159677559, name = "Advanced Scope" },
		},
		unique = true,
	},

	{ id = "WEAPON_GRENADELAUNCHER", name = "Grenade Launcher",
		components = {
			{ owned = nil, hash = 2855028148, name = "Scope" },
			{ owned = nil, hash = 202788691, name = "Grip" },
		},
		unique = true,
	}
}


function Weapon.GetWeapons()
	return weapons
end


function Weapon.GetMeleeWeapons()
	local meleeWeapons = { }

	for _, weapon in pairs(weapons) do
		if weapon.melee then
			table.insert(meleeWeapons, weapon)
		end
	end

	return meleeWeapons
end


function Weapon.GetSpawningAmmo(weaponHash)
	local clipSize = GetWeaponClipSize(weaponHash)
	if clipSize <= 0 then
		clipSize = 1
	end

	return clipSize * Settings.weaponClipCount
end