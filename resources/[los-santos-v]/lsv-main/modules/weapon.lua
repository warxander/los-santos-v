-- Components: https://wiki.fivem.net/wiki/Weapon_Components
-- Tints: https://wiki.fivem.net/wiki/Weapon_Tints

Weapon = { }


local weapons = {
	["WEAPON_KNIFE"] = {
		name = "Knife",
		components = { },
	},

	["WEAPON_STUNGUN"] = {
		name = "Stun Gun",
		components = { },
		RP = 1000,
	},

	["WEAPON_FLASHLIGHT"] = {
		name = "Flashlight",
		components = { },
		RP = 1000,
	},

	["WEAPON_NIGHTSTICK"] = {
		name = "Nightstick",
		components = { },
		RP = 5000,
	},

	["WEAPON_HAMMER"] = {
		name = "Hammer",
		components = { },
		RP = 5000,
	},

	["WEAPON_BAT"] = {
		name = "Bat",
		components = { },
		RP = 5000,
	},

	["WEAPON_GOLFCLUB"] = {
		name = "Golf Club",
		components = { },
		RP = 6000,
	},

	["WEAPON_CROWBAR"] = {
		name = "Crowbar",
		components = { },
		RP = 7000,
	},

	["WEAPON_SAWNOFFSHOTGUN"] = {
		name = "Sawed-Off Shotgun",
		components = {
			{ hash = 2242268665, name = "Gilded Gun Metal Finish", RP = 67500 },
		},
		RP = 30000,
	},

	["WEAPON_RPG"] = {
		name = "RPG",
		components = { },
		unique = true,
	},

	["WEAPON_MINIGUN"] = {
		name = "Minigun",
		components = { },
		unique = true,
	},

	["WEAPON_GRENADE"] = {
		name = "Grenade",
		components = { },
		RP = 25000,
	},

	["WEAPON_STICKYBOMB"] = {
		name = "Sticky Bomb",
		components = { },
		RP = 60000,
	},

	["WEAPON_SMOKEGRENADE"] = {
		name = "Tear Gas",
		components = { },
		RP = 15000,
	},

	["WEAPON_MOLOTOV"] = {
		name = "Molotov Cocktail",
		components = { },
		RP = 35000,
	},

	["WEAPON_BOTTLE"] = {
		name = "Broken Bottle",
		components = { },
		RP = 3000,
	},

	["WEAPON_GUSENBERG"] = {
		name = "Gusenberg Sweeper",
		components = { },
		RP = 146000,
	},

	["WEAPON_DAGGER"] = {
		name = "Antique Cavalry Dagger",
		components = { },
		RP = 20000,
	},

	["WEAPON_MUSKET"] = {
		name = "Musket",
		components = { },
	},

	["WEAPON_HOMINGLAUNCHER"] = {
		name = "Homing Launcher",
		components = { },
		unique = true,
	},

	["WEAPON_PROXMINE"] = {
		name = "Proximity Mine",
		components = { },
		RP = 100000,
	},

	["WEAPON_FLAREGUN"] = {
		name = "Flare Gun",
		components = { },
		RP = 37500,
	},

	["WEAPON_MARKSMANPISTOL"] = {
		name = "Marksman Pistol",
		components = { },
		RP = 43500,
	},

	["WEAPON_KNUCKLE"] = {
		name = "Knuckle Dusters",
		components = { },
		RP = 75000,
	},

	["WEAPON_HATCHET"] = {
		name = "Hatchet",
		components = { },
		RP = 75000,
	},

	["WEAPON_MACHETE"] = {
		name = "Machete",
		components = { },
		RP = 89000,
	},

	["WEAPON_SWITCHBLADE"] = {
		name = "Switchblade",
		components = { },
		RP = 19500,
	},

	["WEAPON_REVOLVER"] = {
		name = "Heavy Revolver",
		components = { },
		RP = 54000,
	},

	["WEAPON_DBSHOTGUN"] = {
		name = "Double Barrel Shotgun",
		components = { },
		RP = 154500,
	},

	["WEAPON_AUTOSHOTGUN"] = {
		name = "Sweeper Shotgun",
		components = { },
		RP = 149000,
	},

	["WEAPON_BATTLEAXE"] = {
		name = "Battle Axe",
		components = { },
		RP = 95000,
	},

	["WEAPON_COMPACTLAUNCHER"] = {
		name = "Compact Grenade Launcher",
		components = { },
		unique = true,
	},

	["WEAPON_PIPEBOMB"] = {
		name = "Pipe Bomb",
		components = { },
		RP = 50000,
	},

	["WEAPON_POOLCUE"] = {
		name = "Pool Cue",
		components = { },
		RP = 62500,
	},

	["WEAPON_WRENCH"] = {
		name = "Pipe Wrench",
		components = { },
		RP = 71500,
	},

	["WEAPON_PISTOL"] = {
		name = "Pistol",
		components = {
			{ hash = 4275109233, name = "Default clip", RP = 0 },
			{ hash = 3978713628, name = "Extended clip", RP = 3750 },
			{ hash = 899381934,  name = "Flashlight", RP = 2500 },
			{ hash = 1709866683, name = "Suppressor", RP = 7500 },
			{ hash = 3610841222, name = "Yusuf Amir Luxury Finish", RP = 11250 },
		},
		RP = 0,
	},

	["WEAPON_MINISMG"] = {
		name = "Mini SMG",
		components = {
			{ hash = 2227745491, name = "Default clip", RP = 0 },
			{ hash = 2474561719, name = "Extended clip", RP = 66750 },
		},
		RP = 89000,
	},

	["WEAPON_MACHINEPISTOL"] = {
		name = "Machine Pistol",
		components = {
			{ hash = 1198425599, name = "Default clip", RP = 0 },
			{ hash = 3106695545, name = "Extended clip", RP = 46875 },
			{ hash = 3271853210, name = "Suppressor", RP = 93750 },
			{ hash = 2850671348, name = "Drum Magazine", RP = 125000 },
		},
		RP = 62500,
	},

	["WEAPON_COMPACTRIFLE"] = {
		name = "Compact Rifle",
		components = {
			{ hash = 1363085923, name = "Default clip", RP = 0 },
			{ hash = 1509923832, name = "Extended clip", RP = 109875 },
			{ hash = 3322377230, name = "Drum Magazine", RP = 293000 },
		},
		RP = 146500,
	},

	["WEAPON_COMBATPDW"] = {
		name = "Combat PDW",
		components = {
			{ hash = 1125642654, name = "Default clip", RP = 0 },
			{ hash = 860508675,  name = "Extended clip", RP = 88125 },
			{ hash = 1857603803, name = "Drum Magazine", RP = 235000 },
			{ hash = 2855028148, name = "Scope", RP = 205625 },
			{ hash = 202788691,  name = "Grip", RP = 146875 },
		},
		RP = 117500,
	},

	["WEAPON_SNSPISTOL"] = {
		name = "SNS Pistol",
		components = {
			{ hash = 4169150169, name = "Default clip", RP = 0 },
			{ hash = 2063610803, name = "Extended clip", RP = 20625 },
			{ hash = 2150886575, name = "Etched Wood Grip Finish", RP = 61875 },
		},
		RP = 27500,
	},

	["WEAPON_HEAVYPISTOL"] = {
		name = "Heavy Pistol",
		components = {
			{ hash = 222992026,  name = "Default clip", RP = 0 },
			{ hash = 1694090795, name = "Extended clip", RP = 28125 },
			{ hash = 899381934,  name = "Flashlight", RP = 18750 },
			{ hash = 3271853210, name = "Suppressor", RP = 56250 },
			{ hash = 2053798779, name = "Etched Wood Grip Finish", RP = 84375 },
		},
		RP = 37500,
	},

	["WEAPON_SPECIALCARBINE"] = {
		name = "Special Carbine",
		components = {
			{ hash = 3334989185, name = "Default clip", RP = 0 },
			{ hash = 2089537806, name = "Extended clip", RP = 110625 },
			{ hash = 1801039530, name = "Drum Magazine", RP = 295000 },
			{ hash = 2076495324, name = "Flashlight", RP = 73750 },
			{ hash = 2805810788, name = "Suppressor", RP = 221250 },
			{ hash = 2698550338, name = "Scope", RP = 258125 },
			{ hash = 202788691,  name = "Grip", RP = 184375 },
			{ hash = 1929467122, name = "Etched Gun Metal Finish", RP = 331875 },
		},
		RP = 147500,
	},

	["WEAPON_BULLPUPRIFLE"] = {
		name = "Bullpup Rifle",
		components = {
			{ hash = 3315675008, name = "Default clip", RP = 0 },
			{ hash = 3009973007, name = "Extended clip", RP = 108750 },
			{ hash = 2076495324, name = "Flashlight", RP = 72500 },
			{ hash = 2205435306, name = "Suppressor", RP = 217500 },
			{ hash = 2855028148, name = "Scope", RP = 253750 },
			{ hash = 202788691,  name = "Grip", RP = 181250 },
			{ hash = 2824322168, name = "Gilded Gun Metal Finish", RP = 326250 },
		},
		RP = 145000,
	},

	["WEAPON_VINTAGEPISTOL"] = {
		name = "Vintage Pistol",
		components = {
			{ hash = 1168357051, name = "Default clip", RP = 0 },
			{ hash = 867832552,  name = "Extended clip", RP = 25875 },
			{ hash = 3271853210, name = "Suppressor", RP = 51750 },
		},
		RP = 34500,
	},

	["WEAPON_HEAVYSHOTGUN"] = {
		name = "Heavy Shotgun",
		components = {
			{ hash = 844049759,  name = "Default clip", RP = 0 },
			{ hash = 2535257853, name = "Extended clip", RP = 101625 },
			{ hash = 2294798931, name = "Drum Magazine", RP = 271000 },
			{ hash = 2076495324, name = "Flashlight", RP = 67750 },
			{ hash = 2805810788, name = "Suppressor", RP = 203250 },
			{ hash = 202788691,  name = "Grip", RP = 169375 },
		},
		RP = 135500,
	},

	["WEAPON_MARKSMANRIFLE"] = {
		name = "Marksman Rifle",
		components = {
			{ hash = 3627761985, name = "Default clip", RP = 0 },
			{ hash = 3439143621, name = "Extended clip", RP = 112500 },
			{ hash = 2076495324, name = "Flashlight", RP = 75000 },
			{ hash = 2205435306, name = "Suppressor", RP = 225000 },
			{ hash = 202788691,  name = "Grip", RP = 187500 },
			{ hash = 371102273,  name = "Yusuf Amir Luxury Finish", RP = 337500 },
		},
		unique = true,
	},

	["WEAPON_COMBATPISTOL"] = {
		name = "Combat Pistol",
		components = {
			{ hash = 119648377,  name = "Default clip", RP = 0 },
			{ hash = 3598405421, name = "Extended clip", RP = 24000 },
			{ hash = 899381934,  name = "Flashlight", RP = 16000 },
			{ hash = 3271853210, name = "Suppressor", RP = 48000 },
			{ hash = 3328527730, name = "Yusuf Amir Luxury Finish", RP = 72000 },
		},
		RP = 32000,
	},

	["WEAPON_APPISTOL"] = {
		name = "AP Pistol",
		components = {
			{ hash = 834974250,  name = "Default clip", RP = 0 },
			{ hash = 614078421,  name = "Extended clip", RP = 37500 },
			{ hash = 899381934,  name = "Flashlight", RP = 25000 },
			{ hash = 3271853210, name = "Suppressor", RP = 75000 },
			{ hash = 2608252716, name = "Gilded Gun Metal Finish", RP = 112500 },
		},
		RP = 50000,
	},

	["WEAPON_DOUBLEACTION"] = {
		name = "Double-Action Revolver",
		components = { },
		unique = true,
	},

	["WEAPON_PISTOL50"] = {
		name = "Pistol .50",
		components = {
			{ hash = 580369945,  name = "Default clip", RP = 0 },
			{ hash = 3654528146, name = "Extended clip", RP = 30000 },
			{ hash = 899381934,  name = "Flashlight", RP = 20000 },
			{ hash = 2805810788, name = "Suppressor", RP = 60000 },
			{ hash = 2008591151, name = "Platinum Pearl Deluxe Finish", RP = 90000 },
		},
		RP = 40000,
	},

	["WEAPON_MICROSMG"] = {
		name = "Micro SMG",
		components = {
			{ hash = 3410538224, name = "Default clip", RP = 0 },
			{ hash = 283556395,  name = "Extended clip", RP = 28125 },
			{ hash = 899381934,  name = "Flashlight", RP = 18750 },
			{ hash = 2805810788, name = "Suppressor", RP = 56250 },
			{ hash = 2637152041, name = "Scope", RP = 65625 },
			{ hash = 1215999497, name = "Yusuf Amir Luxury Finish", RP = 84375 },
		},
		RP = 37500,
	},

	["WEAPON_SMG"] = {
		name = "SMG",
		components = {
			{ hash = 643254679,  name = "Default clip", RP = 0 },
			{ hash = 889808635,  name = "Extended clip", RP = 56250 },
			{ hash = 2043113590, name = "Drum Magazine", RP = 150000 },
			{ hash = 2076495324, name = "Flashlight", RP = 37500 },
			{ hash = 3271853210, name = "Suppressor", RP = 112500 },
			{ hash = 1019656791, name = "Scope", RP = 131250 },
			{ hash = 663170192,  name = "Yusuf Amir Luxury Finish", RP = 168750 },
		},
		RP = 75000,
	},

	["WEAPON_ASSAULTSMG"] = {
		name = "Assault SMG",
		components = {
			{ hash = 2366834608, name = "Default clip", RP = 0 },
			{ hash = 3141985303, name = "Extended clip", RP = 94125 },
			{ hash = 2076495324, name = "Flashlight", RP = 62750 },
			{ hash = 2805810788, name = "Suppressor", RP = 188250 },
			{ hash = 2637152041, name = "Scope", RP = 219625 },
			{ hash = 663517359,  name = "Yusuf Amir Luxury Finish", RP = 282375 },
		},
		RP = 125500,
	},

	["WEAPON_ASSAULTRIFLE"] = {
		name = "Assault Rifle",
		components = {
			{ hash = 3193891350, name = "Default clip", RP = 0 },
			{ hash = 2971750299, name = "Extended clip", RP = 64125 },
			{ hash = 2076495324, name = "Flashlight", RP = 42750 },
			{ hash = 2805810788, name = "Suppressor", RP = 128250 },
			{ hash = 2637152041, name = "Scope", RP = 149625 },
			{ hash = 202788691,  name = "Grip", RP = 106875 },
			{ hash = 1319990579, name = "Yusuf Amir Luxury Finish", RP = 192375 },
		},
		RP = 85500,
	},

	["WEAPON_CARBINERIFLE"] = {
		name = "Carbine Rifle",
		components = {
			{ hash = 2680042476, name = "Default clip", RP = 0 },
			{ hash = 2433783441, name = "Extended clip", RP = 97500 },
			{ hash = 3127044405, name = "Box Magazine", RP = 260000 },
			{ hash = 2076495324, name = "Flashlight", RP = 65000 },
			{ hash = 2205435306, name = "Suppressor", RP = 195000 },
			{ hash = 2698550338, name = "Scope", RP = 227500 },
			{ hash = 202788691,  name = "Grip", RP = 162500 },
			{ hash = 202788691,  name = "Yusuf Amir Luxury Finish", RP = 292500 },
		},
		RP = 130000,
	},

	["WEAPON_ADVANCEDRIFLE"] = {
		name = "Advanced Rifle",
		components = {
			{ hash = 4203716879, name = "Default clip", RP = 0 },
			{ hash = 2395064697, name = "Extended clip", RP = 106875 },
			{ hash = 2076495324, name = "Flashlight", RP = 71250 },
			{ hash = 2205435306, name = "Suppressor", RP = 213750 },
			{ hash = 2855028148, name = "Scope", RP = 249375 },
			{ hash = 930927479,  name = "Gilded Gun Metal Finish", RP = 320625 },
		},
		RP = 142500,
	},

	["WEAPON_MG"] = {
		name = "MG",
		components = {
			{ hash = 4097109892, name = "Default clip", RP = 0 },
			{ hash = 2182449991, name = "Extended clip", RP = 101250 },
			{ hash = 1006677997, name = "Scope", RP = 236250 },
			{ hash = 3604658878, name = "Yusuf Amir Luxury Finish", RP = 303750 },
		},
		RP = 135000,
	},

	["WEAPON_COMBATMG"] = {
		name = "Combat MG",
		components = {
			{ hash = 3791631178, name = "Default clip", RP = 0 },
			{ hash = 3603274966, name = "Extended clip", RP = 111000 },
			{ hash = 202788691,  name = "Grip", RP = 185000 },
			{ hash = 2698550338, name = "Scope", RP = 259000 },
			{ hash = 2466172125, name = "Etched Gun Metal Finish", RP = 333000 },
		},
		RP = 148000,
	},

	["WEAPON_PUMPSHOTGUN"] = {
		name = "Pump Shotgun",
		components = {
			{ hash = 2076495324, name = "Flashlight", RP = 17500 },
			{ hash = 3859329886, name = "Suppressor", RP = 52500 },
			{ hash = 2732039643, name = "Yusuf Amir Luxury Finish", RP = 78750 },
		},
		RP = 35000,
	},

	["WEAPON_ASSAULTSHOTGUN"] = {
		name = "Assault Shotgun",
		components = {
			{ hash = 2498239431, name = "Default clip", RP = 0 },
			{ hash = 2260565874, name = "Extended clip", RP = 75000 },
			{ hash = 2076495324, name = "Flashlight", RP = 50000 },
			{ hash = 2205435306, name = "Suppressor", RP = 150000 },
			{ hash = 202788691,  name = "Grip", RP = 125000 },
		},
		RP = 100000,
	},

	["WEAPON_BULLPUPSHOTGUN"] = {
		name = "Bullpup Shotgun",
		components = {
			{ hash = 2076495324, name = "Flashlight", RP = 40000 },
			{ hash = 2805810788, name = "Suppressor", RP = 120000 },
			{ hash = 202788691,  name = "Grip", RP = 100000 },
		},
		RP = 80000,
	},

	["WEAPON_SNIPERRIFLE"] = {
		name = "Sniper Rifle",
		components = {
			{ hash = 2805810788, name = "Suppressor", RP = 300000 },
			{ hash = 3527687644, name = "Scope", RP = 0 },
			{ hash = 3159677559, name = "Advanced Scope", RP = 350000 },
			{ hash = 1077065191, name = "Etched Wood Grip Finish", RP = 450000 },
		},
		unique = true,
	},

	["WEAPON_HEAVYSNIPER"] = {
		name = "Heavy Sniper",
		components = {
			{ hash = 3527687644, name = "Scope", RP = 0 },
			{ hash = 3159677559, name = "Advanced Scope", RP = 667625 },
		},
		unique = true,
	},

	["WEAPON_GRENADELAUNCHER"] = {
		name = "Grenade Launcher",
		components = {
			{ hash = 2076495324, name = "Flashlight", RP = 162000 },
			{ hash = 2855028148, name = "Scope", RP = 567000 },
			{ hash = 202788691,  name = "Grip", RP = 405000 },
		},
		unique = true,
	},
}


function Weapon.GetWeapons()
	return weapons
end


function Weapon.GetWeapon(id)
	return weapons[id]
end


function Weapon.GetSpawningAmmo(weaponHash)
	local clipSize = GetWeaponClipSize(weaponHash)
	if clipSize <= 0 then clipSize = 1 end
	return clipSize * Settings.weaponClipCount
end