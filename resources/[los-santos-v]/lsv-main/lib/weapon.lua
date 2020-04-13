-- Components: https://wiki.fivem.net/wiki/Weapon_Components
-- Tints: https://wiki.fivem.net/wiki/Weapon_Tints
Weapon = { }
Weapon.__index = Weapon

Weapon.WEAPON_KNIFE = {
	name = 'Knife',
	components = { },
}

Weapon.WEAPON_STUNGUN = {
	name = 'Stun Gun',
	components = { },
	cash = 99999,
}

Weapon.WEAPON_FLASHLIGHT = {
	name = 'Flashlight',
	components = { },
	cash = 100,
}

Weapon.WEAPON_NIGHTSTICK = {
	name = 'Nightstick',
	components = { },
	cash = 500,
}

Weapon.WEAPON_HAMMER = {
	name = 'Hammer',
	components = { },
	cash = 500,
}

Weapon.WEAPON_BAT = {
	name = 'Bat',
	components = { },
	cash = 500,
}

Weapon.WEAPON_GOLFCLUB = {
	name = 'Golf Club',
	components = { },
	cash = 600,
}

Weapon.WEAPON_CROWBAR = {
	name = 'Crowbar',
	components = { },
	cash = 700,
}

Weapon.WEAPON_SAWNOFFSHOTGUN = {
	name = 'Sawed-Off Shotgun',
	components = {
		{ hash = 2242268665, name = 'Gilded Gun Metal Finish', cash = 34250, rank = 95 },
	},
	cash = 3000,
	rank = 2,
}

Weapon.WEAPON_RPG = {
	name = 'RPG',
	components = { },
	unique = true,
}

Weapon.WEAPON_MINIGUN = {
	name = 'Minigun',
	components = { },
	unique = true,
}

Weapon.WEAPON_GRENADE = {
	name = 'Grenade',
	components = { },
	cash = 31,
	rank = 5,
}

Weapon.WEAPON_STICKYBOMB = {
	name = 'Sticky Bomb',
	components = { },
	cash = 94,
	rank = 19,
}

Weapon.WEAPON_SMOKEGRENADE = {
	name = 'Tear Gas',
	components = { },
	cash = 14,
	rank = 13,
}

Weapon.WEAPON_MOLOTOV = {
	name = 'Molotov Cocktail',
	components = { },
	cash = 67,
	rank = 17,
}

Weapon.WEAPON_BOTTLE = {
	name = 'Broken Bottle',
	components = { },
	cash = 300,
}

Weapon.WEAPON_GUSENBERG = {
	name = 'Gusenberg Sweeper',
	components = { },
	cash = 14600,
}

Weapon.WEAPON_DAGGER = {
	name = 'Antique Cavalry Dagger',
	components = { },
	cash = 2000,
}

Weapon.WEAPON_MUSKET = {
	name = 'Musket',
	components = { },
}

Weapon.WEAPON_HOMINGLAUNCHER = {
	name = 'Homing Launcher',
	components = { },
	unique = true,
}

Weapon.WEAPON_PROXMINE = {
	name = 'Proximity Mine',
	components = { },
	cash = 119,
	rank = 21,
}

Weapon.WEAPON_FLAREGUN = {
	name = 'Flare Gun',
	components = { },
	cash = 3750,
	rank = 1,
}

Weapon.WEAPON_MARKSMANPISTOL = {
	name = 'Marksman Pistol',
	components = { },
	cash = 4350,
}

Weapon.WEAPON_KNUCKLE = {
	name = 'Knuckle Dusters',
	components = { },
	cash = 7500,
}

Weapon.WEAPON_HATCHET = {
	name = 'Hatchet',
	components = { },
	cash = 7500,
}

Weapon.WEAPON_MACHETE = {
	name = 'Machete',
	components = { },
	cash = 890,
}

Weapon.WEAPON_SWITCHBLADE = {
	name = 'Switchblade',
	components = { },
	cash = 1950,
}

Weapon.WEAPON_REVOLVER = {
	name = 'Heavy Revolver',
	components = { },
	cash = 5400,
}

Weapon.WEAPON_DBSHOTGUN = {
	name = 'Double Barrel Shotgun',
	components = { },
	cash = 15450,
}

Weapon.WEAPON_AUTOSHOTGUN = {
	name = 'Sweeper Shotgun',
	components = { },
	cash = 6900,
	rank = 24,
}

Weapon.WEAPON_BATTLEAXE = {
	name = 'Battle Axe',
	components = { },
	cash = 950,
}

Weapon.WEAPON_COMPACTLAUNCHER = {
	name = 'Compact Grenade Launcher',
	components = { },
	unique = true,
}

Weapon.WEAPON_PIPEBOMB = {
	name = 'Pipe Bomb',
	components = { },
	cash = 5000,
}

Weapon.WEAPON_POOLCUE = {
	name = 'Pool Cue',
	components = { },
	cash = 625,
}

Weapon.WEAPON_WRENCH = {
	name = 'Pipe Wrench',
	components = { },
	cash = 715,
}

Weapon.WEAPON_PISTOL = {
	name = 'Pistol',
	components = {
		{ hash = 4275109233, name = 'Default clip', cash = 0 },
		{ hash = 3978713628, name = 'Extended clip', cash = 9175, rank = 2 },
		{ hash = 899381934,  name = 'Flashlight', cash = 1675, rank = 4 },
		{ hash = 1709866683, name = 'Suppressor', cash = 12050, rank = 5 },
		{ hash = 3610841222, name = 'Yusuf Amir Luxury Finish', cash = 46500, rank = 95 },
	},
	cash = 0,
	rank = 1,
}

Weapon.WEAPON_MINISMG = {
	name = 'Mini SMG',
	components = {
		{ hash = 2227745491, name = 'Default clip', cash = 0 },
		{ hash = 2474561719, name = 'Extended clip', cash = 6670 },
	},
	cash = 8900,
}

Weapon.WEAPON_MACHINEPISTOL = {
	name = 'Machine Pistol',
	components = {
		{ hash = 1198425599, name = 'Default clip', cash = 0 },
		{ hash = 3106695545, name = 'Extended clip', cash = 4690 },
		{ hash = 3271853210, name = 'Suppressor', cash = 9370 },
		{ hash = 2850671348, name = 'Drum Magazine', cash = 12500 },
	},
	cash = 6250,
}

Weapon.WEAPON_COMPACTRIFLE = {
	name = 'Compact Rifle',
	components = {
		{ hash = 1363085923, name = 'Default clip', cash = 0 },
		{ hash = 1509923832, name = 'Extended clip', cash = 9950, rank = 97 },
		{ hash = 3322377230, name = 'Drum Magazine', cash = 26850, rank = 98 },
	},
	cash = 14650,
	rank = 96,
}

Weapon.WEAPON_COMBATPDW = {
	name = 'Combat PDW',
	components = {
		{ hash = 1125642654, name = 'Default clip', cash = 0 },
		{ hash = 860508675,  name = 'Extended clip', cash = 8810 },
		{ hash = 1857603803, name = 'Drum Magazine', cash = 23500 },
		{ hash = 2855028148, name = 'Scope', cash = 20560 },
		{ hash = 202788691,  name = 'Grip', cash = 14680 },
	},
	cash = 11750,
}

Weapon.WEAPON_SNSPISTOL = {
	name = 'SNS Pistol',
	components = {
		{ hash = 4169150169, name = 'Default clip', cash = 0 },
		{ hash = 2063610803, name = 'Extended clip', cash = 2060 },
		{ hash = 2150886575, name = 'Etched Wood Grip Finish', cash = 6180 },
	},
	cash = 2750,
}

Weapon.WEAPON_HEAVYPISTOL = {
	name = 'Heavy Pistol',
	components = {
		{ hash = 222992026,  name = 'Default clip', cash = 0 },
		{ hash = 1694090795, name = 'Extended clip', cash = 2810 },
		{ hash = 899381934,  name = 'Flashlight', cash = 1870 },
		{ hash = 3271853210, name = 'Suppressor', cash = 5620 },
		{ hash = 2053798779, name = 'Etched Wood Grip Finish', cash = 8430 },
	},
	cash = 3750,
}

Weapon.WEAPON_SPECIALCARBINE = {
	name = 'Special Carbine',
	components = {
		{ hash = 3334989185, name = 'Default clip', cash = 0 },
		{ hash = 2089537806, name = 'Extended clip', cash = 9975, rank = 65 },
		-- { hash = 1801039530, name = 'Drum Magazine', cash = 29500 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2525, rank = 66 },
		{ hash = 2805810788, name = 'Suppressor', cash = 12500, rank = 67 },
		{ hash = 2698550338, name = 'Scope', cash = 11500, rank = 68 },
		{ hash = 202788691,  name = 'Grip', cash = 4350, rank = 69 },
		{ hash = 1929467122, name = 'Etched Gun Metal Finish', cash = 45000, rank = 75 },
	},
	cash = 14750,
	rank = 60,
}

Weapon.WEAPON_BULLPUPRIFLE = {
	name = 'Bullpup Rifle',
	components = {
		{ hash = 3315675008, name = 'Default clip', cash = 0 },
		{ hash = 3009973007, name = 'Extended clip', cash = 10870 },
		{ hash = 2076495324, name = 'Flashlight', cash = 7250 },
		{ hash = 2205435306, name = 'Suppressor', cash = 21750 },
		{ hash = 2855028148, name = 'Scope', cash = 25370 },
		{ hash = 202788691,  name = 'Grip', cash = 18120 },
		{ hash = 2824322168, name = 'Gilded Gun Metal Finish', cash = 32620 },
	},
	cash = 14500,
}

Weapon.WEAPON_VINTAGEPISTOL = {
	name = 'Vintage Pistol',
	components = {
		{ hash = 1168357051, name = 'Default clip', cash = 0 },
		{ hash = 867832552,  name = 'Extended clip', cash = 2580 },
		{ hash = 3271853210, name = 'Suppressor', cash = 5170 },
	},
	cash = 3450,
}

Weapon.WEAPON_HEAVYSHOTGUN = {
	name = 'Heavy Shotgun',
	components = {
		{ hash = 844049759,  name = 'Default clip', cash = 0 },
		{ hash = 2535257853, name = 'Extended clip', cash = 10160 },
		{ hash = 2294798931, name = 'Drum Magazine', cash = 27100 },
		{ hash = 2076495324, name = 'Flashlight', cash = 6770 },
		{ hash = 2805810788, name = 'Suppressor', cash = 20320 },
		{ hash = 202788691,  name = 'Grip', cash = 16930 },
	},
	cash = 13550,
}

Weapon.WEAPON_MARKSMANRIFLE = {
	name = 'Marksman Rifle',
	components = {
		{ hash = 3627761985, name = 'Default clip', cash = 0 },
		{ hash = 3439143621, name = 'Extended clip', cash = 11250 },
		{ hash = 2076495324, name = 'Flashlight', cash = 7500 },
		{ hash = 2205435306, name = 'Suppressor', cash = 22500 },
		{ hash = 202788691,  name = 'Grip', cash = 18750 },
		{ hash = 371102273,  name = 'Yusuf Amir Luxury Finish', cash = 33750 },
	},
	unique = true,
}

Weapon.WEAPON_COMBATPISTOL = {
	name = 'Combat Pistol',
	components = {
		{ hash = 119648377,  name = 'Default clip', cash = 0 },
		{ hash = 3598405421, name = 'Extended clip', cash = 9200, rank = 10 },
		{ hash = 899381934,  name = 'Flashlight', cash = 1825, rank = 11 },
		{ hash = 3271853210, name = 'Suppressor', cash = 12100, rank = 12 },
		{ hash = 3328527730, name = 'Yusuf Amir Luxury Finish', cash = 36250, rank = 95 },
	},
	cash = 3200,
	rank = 9,
}

Weapon.WEAPON_APPISTOL = {
	name = 'AP Pistol',
	components = {
		{ hash = 834974250,  name = 'Default clip', cash = 0 },
		{ hash = 614078421,  name = 'Extended clip', cash = 9400, rank = 34 },
		{ hash = 899381934,  name = 'Flashlight', cash = 1975, rank = 35 },
		{ hash = 3271853210, name = 'Suppressor', cash = 12200, rank = 36 },
		{ hash = 2608252716, name = 'Gilded Gun Metal Finish', cash = 39500, rank = 95 },
	},
	cash = 5000,
	rank = 33,
}

Weapon.WEAPON_DOUBLEACTION = {
	name = 'Double-Action Revolver',
	components = { },
	unique = true,
}

Weapon.WEAPON_PISTOL50 = {
	name = 'Pistol .50',
	components = {
		{ hash = 580369945,  name = 'Default clip', cash = 0 },
		{ hash = 3654528146, name = 'Extended clip', cash = 9500, rank = 92 },
		{ hash = 899381934,  name = 'Flashlight', cash = 2000, rank = 93 },
		{ hash = 2805810788, name = 'Suppressor', cash = 12500, rank = 94 },
		{ hash = 2008591151, name = 'Platinum Pearl Deluxe Finish', cash = 50000, rank = 95 },
	},
	unique = true,
}

Weapon.WEAPON_MICROSMG = {
	name = 'Micro SMG',
	components = {
		{ hash = 3410538224, name = 'Default clip', cash = 0 },
		{ hash = 283556395,  name = 'Extended clip', cash = 9325, rank = 6 },
		{ hash = 899381934,  name = 'Flashlight', cash = 1900, rank = 7 },
		{ hash = 2805810788, name = 'Suppressor', cash = 12150, rank = 9 },
		{ hash = 2637152041, name = 'Scope', cash = 10800, rank = 8 },
		{ hash = 1215999497, name = 'Yusuf Amir Luxury Finish', cash = 37750, rank = 95 },
	},
	cash = 3750,
	rank = 3,
}

Weapon.WEAPON_SMG = {
	name = 'SMG',
	components = {
		{ hash = 643254679,  name = 'Default clip', cash = 0 },
		{ hash = 889808635,  name = 'Extended clip', cash = 9475, rank = 12 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2050, rank = 13 },
		{ hash = 3271853210, name = 'Suppressor', cash = 12250, rank = 15 },
		{ hash = 1019656791, name = 'Scope', cash = 10825, rank = 14 },
		{ hash = 663170192,  name = 'Yusuf Amir Luxury Finish', cash = 48250, rank = 95 },
	},
	cash = 7500,
	rank = 11,
}

Weapon.WEAPON_ASSAULTSMG = {
	name = 'Assault SMG',
	components = {
		{ hash = 2366834608, name = 'Default clip', cash = 0 },
		{ hash = 3141985303, name = 'Extended clip', cash = 9410 },
		{ hash = 2076495324, name = 'Flashlight', cash = 6270 },
		{ hash = 2805810788, name = 'Suppressor', cash = 18820 },
		{ hash = 2637152041, name = 'Scope', cash = 21960 },
		{ hash = 663517359,  name = 'Yusuf Amir Luxury Finish', cash = 28230 },
	},
	cash = 12550,
}

Weapon.WEAPON_ASSAULTRIFLE = {
	name = 'Assault Rifle',
	components = {
		{ hash = 3193891350, name = 'Default clip', cash = 0 },
		{ hash = 2971750299, name = 'Extended clip', cash = 9550, rank = 25 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2125, rank = 27 },
		{ hash = 2805810788, name = 'Suppressor', cash = 12300, rank = 29 },
		{ hash = 2637152041, name = 'Scope', cash = 10850, rank = 28 },
		{ hash = 202788691,  name = 'Grip', cash = 4200, rank = 26 },
		{ hash = 1319990579, name = 'Yusuf Amir Luxury Finish', cash = 36000, rank = 95 },
	},
	cash = 8550,
	rank = 4,
}

Weapon.WEAPON_CARBINERIFLE = {
	name = 'Carbine Rifle',
	components = {
		{ hash = 2680042476, name = 'Default clip', cash = 0 },
		{ hash = 2433783441, name = 'Extended clip', cash = 9775, rank = 43 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2350, rank = 45 },
		{ hash = 2205435306, name = 'Suppressor', cash = 12450, rank = 47 },
		{ hash = 2698550338, name = 'Scope', cash = 10900, rank = 46 },
		{ hash = 202788691,  name = 'Grip', cash = 4350, rank = 44 },
		{ hash = 202788691,  name = 'Yusuf Amir Luxury Finish', cash = 44750, rank = 95 },
	},
	cash = 13000,
	rank = 42,
}

Weapon.WEAPON_ADVANCEDRIFLE = {
	name = 'Advanced Rifle',
	components = {
		{ hash = 4203716879, name = 'Default clip', cash = 0 },
		{ hash = 2395064697, name = 'Extended clip', cash = 9925, rank = 71 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2425, rank = 72 },
		{ hash = 2205435306, name = 'Suppressor', cash = 12500, rank = 74 },
		{ hash = 2855028148, name = 'Scope', cash = 10950, rank = 73 },
		{ hash = 930927479,  name = 'Gilded Gun Metal Finish', cash = 41250, rank = 95 },
	},
	cash = 14250,
	rank = 70,
}

Weapon.WEAPON_MG = {
	name = 'MG',
	components = {
		{ hash = 4097109892, name = 'Default clip', cash = 0 },
		{ hash = 2182449991, name = 'Extended clip', cash = 9850, rank = 51 },
		{ hash = 1006677997, name = 'Scope', cash = 10925, rank = 52 },
		{ hash = 3604658878, name = 'Yusuf Amir Luxury Finish', cash = 39000, rank = 95 },
	},
	cash = 13500,
	rank = 50,
}

Weapon.WEAPON_COMBATMG = {
	name = 'Combat MG',
	components = {
		{ hash = 3791631178, name = 'Default clip', cash = 0 },
		{ hash = 3603274966, name = 'Extended clip', cash = 10000, rank = 81 },
		{ hash = 202788691,  name = 'Grip', cash = 4425, rank = 82 },
		{ hash = 2698550338, name = 'Scope', cash = 10975, rank = 83 },
		{ hash = 2466172125, name = 'Etched Gun Metal Finish', cash = 35000, rank = 85 },
	},
	cash = 14800,
	rank = 80,
}

Weapon.WEAPON_PUMPSHOTGUN = {
	name = 'Pump Shotgun',
	components = {
		{ hash = 2076495324, name = 'Flashlight', cash = 1750, rank = 18 },
		{ hash = 3859329886, name = 'Suppressor', cash = 12350, rank = 19 },
		{ hash = 2732039643, name = 'Yusuf Amir Luxury Finish', cash = 42250, rank = 25 },
	},
	cash = 3500,
	rank = 17,
}

Weapon.WEAPON_ASSAULTSHOTGUN = {
	name = 'Assault Shotgun',
	components = {
		{ hash = 2498239431, name = 'Default clip', cash = 0 },
		{ hash = 2260565874, name = 'Extended clip', cash = 9625, rank = 38 },
		{ hash = 2076495324, name = 'Flashlight', cash = 2200, rank = 40 },
		{ hash = 2205435306, name = 'Suppressor', cash = 12350, rank = 41 },
		{ hash = 202788691,  name = 'Grip', cash = 4275, rank = 39 },
	},
	cash = 10000,
	rank = 37,
}

Weapon.WEAPON_BULLPUPSHOTGUN = {
	name = 'Bullpup Shotgun',
	components = {
		{ hash = 2076495324, name = 'Flashlight', cash = 4000 },
		{ hash = 2805810788, name = 'Suppressor', cash = 12000 },
		{ hash = 202788691,  name = 'Grip', cash = 10000 },
	},
	cash = 8000,
}

Weapon.WEAPON_SNIPERRIFLE = {
	name = 'Sniper Rifle',
	components = {
		{ hash = 2805810788, name = 'Suppressor', cash = 12050, rank = 22 },
		{ hash = 3159677559, name = 'Advanced Scope', cash = 12500, rank = 23 },
		{ hash = 1077065191, name = 'Etched Wood Grip Finish', cash = 32500, rank = 95 },
	},
	cash = 20000,
	rank = 21,
}

Weapon.WEAPON_GRENADELAUNCHER = {
	name = 'Grenade Launcher',
	components = {
		{ hash = 2076495324, name = 'Flashlight', cash = 2500, rank = 62 },
		{ hash = 2855028148, name = 'Scope', cash = 11000, rank = 63 },
		{ hash = 202788691,  name = 'Grip', cash = 4500, rank = 61 },
	},
	unique = true,
}

Weapon.WEAPON_RAILGUN = {
	name = 'Railgun',
	components = { },
	unique = true,
}

Weapon.WEAPON_RAYPISTOL = {
	name = 'Up-n-Atomizer',
	components = { },
	cash = 39900,
	prestige = 1,
}

Weapon.WEAPON_RAYCARBINE = {
	name = 'Unholy Hellbringer',
	components = { },
	cash = 44900,
	prestige = 2,
}

Weapon.WEAPON_RAYMINIGUN = {
	name = 'Widowmaker',
	components = { },
	cash = 49900,
	prestige = 3,
}

Weapon.WEAPON_HEAVYSNIPER = {
	name = 'Heavy Sniper',
	components = {
		{ hash = 3527687644, name = 'Scope', cash = 0 },
		{ hash = 3159677559, name = 'Advanced Scope', cash = 12500, rank = 91 },
	},
	cash = 69900,
	prestige = 5,
}

Weapon.WEAPON_FIREWORK = {
	name = 'Firework Launcher',
	components = { },
	cash = 0,
	rank = 1,
}

Weapon.WEAPON_SMG_MK2 = {
	name = 'SMG Mk II',
	components = {
		{ hash = 0x4C24806E, name = 'Default Clip', cash = 0 },
		{ hash = 0xB9835B2E, name = 'Extended Clip', cash = 18300 },
		{ hash = 0x7BC4CDDC, name = 'Flashlight', cash = 7500 },
		{ hash = 0x3DECC7DA, name = 'Medium Scope', cash = 24100 },
		{ hash = 0x4DB62ABE, name = 'Split-End Muzzle Brake', cash = 33025 },
	},
	cash = 85500,
	prestige = 3,
}

Weapon.WEAPON_ASSAULTRIFLE_MK2 = {
	name = 'Assault Rifle Mk II',
	components = {
		{ hash = 0x8610343F, name = 'Default Clip', cash = 0 },
		{ hash = 0xD12ACA6F, name = 'Extended Clip', cash = 21350 },
		{ hash = 0x9D65907A, name = 'Grip', cash = 14080 },
		{ hash = 0x7BC4CDDC, name = 'Flashlight', cash = 10500 },
		{ hash = 0xC66B6542, name = 'Large Scope', cash = 34020 },
		{ hash = 0xA73D4664, name = 'Suppressor', cash = 40250 },
		{ hash = 0x4DB62ABE, name = 'Split-End Muzzle Brake', cash = 38530 },
	},
	cash = 98750,
	prestige = 5,
}

Weapon.WEAPON_COMBATMG_MK2 = {
	name = 'Combat MG Mk II',
	components = {
		{ hash = 0x492B257C, name = 'Default Clip', cash = 0 },
		{ hash = 0x17DF42E9, name = 'Extended Clip', cash = 28925 },
		{ hash = 0x9D65907A, name = 'Grip', cash = 20180 },
		{ hash = 0xC66B6542, name = 'Large Scope', cash = 46170 },
		{ hash = 0x4DB62ABE, name = 'Split-End Muzzle Brake', cash = 52290 },
		{ hash = 0xB5E2575B, name = 'Heavy Barrel', cash = 66500 },
	},
	cash = 119000,
	prestige = 7,
}

Weapon.WEAPON_SPECIALCARBINE_MK2 = {
	name = 'Special Carbine Mk II',
	components = {
		{ hash = 0x16C69281, name = 'Default Clip', cash = 0 },
		{ hash = 0xDE1FA12C, name = 'Extended Clip', cash = 26450 },
		{ hash = 0x9D65907A, name = 'Grip', cash = 14080 },
		{ hash = 0x7BC4CDDC, name = 'Flashlight', cash = 10500 },
		{ hash = 0xC66B6542, name = 'Large Scope', cash = 34020 },
		{ hash = 0xA73D4664, name = 'Suppressor', cash = 40250 },
		{ hash = 0x4DB62ABE, name = 'Split-End Muzzle Brake', cash = 38530 },
	},
	cash = 135000,
	prestige = 10,
}

WeaponUtility = { }
WeaponUtility.__index = WeaponUtility

function WeaponUtility.GetNameByHash(hash)
	local weapon = table.find_if(Weapon, function(_, id)
		return GetHashKey(id) == hash
	end)

	if weapon then
		return weapon.name
	end

	return nil
end

function WeaponUtility.GetSpawningAmmo(weaponHash)
	return math.max(1, GetWeaponClipSize(weaponHash)) * Settings.weaponClipCount
end
