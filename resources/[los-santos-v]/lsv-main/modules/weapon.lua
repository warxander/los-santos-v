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
		cash = 100,
	},

	["WEAPON_FLASHLIGHT"] = {
		name = "Flashlight",
		components = { },
		cash = 100,
	},

	["WEAPON_NIGHTSTICK"] = {
		name = "Nightstick",
		components = { },
		cash = 500,
	},

	["WEAPON_HAMMER"] = {
		name = "Hammer",
		components = { },
		cash = 500,
	},

	["WEAPON_BAT"] = {
		name = "Bat",
		components = { },
		cash = 500,
	},

	["WEAPON_GOLFCLUB"] = {
		name = "Golf Club",
		components = { },
		cash = 600,
	},

	["WEAPON_CROWBAR"] = {
		name = "Crowbar",
		components = { },
		cash = 700,
	},

	["WEAPON_SAWNOFFSHOTGUN"] = {
		name = "Sawed-Off Shotgun",
		components = {
			{ hash = 2242268665, name = "Gilded Gun Metal Finish", cash = 6750 },
		},
		cash = 3000,
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
		cash = 2500,
	},

	["WEAPON_STICKYBOMB"] = {
		name = "Sticky Bomb",
		components = { },
		cash = 6000,
	},

	["WEAPON_SMOKEGRENADE"] = {
		name = "Tear Gas",
		components = { },
		cash = 1500,
	},

	["WEAPON_MOLOTOV"] = {
		name = "Molotov Cocktail",
		components = { },
		cash = 3500,
	},

	["WEAPON_BOTTLE"] = {
		name = "Broken Bottle",
		components = { },
		cash = 300,
	},

	["WEAPON_GUSENBERG"] = {
		name = "Gusenberg Sweeper",
		components = { },
		cash = 14600,
	},

	["WEAPON_DAGGER"] = {
		name = "Antique Cavalry Dagger",
		components = { },
		cash = 2000,
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
		cash = 10000,
	},

	["WEAPON_FLAREGUN"] = {
		name = "Flare Gun",
		components = { },
		cash = 3750,
	},

	["WEAPON_MARKSMANPISTOL"] = {
		name = "Marksman Pistol",
		components = { },
		cash = 4350,
	},

	["WEAPON_KNUCKLE"] = {
		name = "Knuckle Dusters",
		components = { },
		cash = 7500,
	},

	["WEAPON_HATCHET"] = {
		name = "Hatchet",
		components = { },
		cash = 7500,
	},

	["WEAPON_MACHETE"] = {
		name = "Machete",
		components = { },
		cash = 890,
	},

	["WEAPON_SWITCHBLADE"] = {
		name = "Switchblade",
		components = { },
		cash = 1950,
	},

	["WEAPON_REVOLVER"] = {
		name = "Heavy Revolver",
		components = { },
		cash = 5400,
	},

	["WEAPON_DBSHOTGUN"] = {
		name = "Double Barrel Shotgun",
		components = { },
		cash = 15450,
	},

	["WEAPON_AUTOSHOTGUN"] = {
		name = "Sweeper Shotgun",
		components = { },
		cash = 14900,
	},

	["WEAPON_BATTLEAXE"] = {
		name = "Battle Axe",
		components = { },
		cash = 950,
	},

	["WEAPON_COMPACTLAUNCHER"] = {
		name = "Compact Grenade Launcher",
		components = { },
		unique = true,
	},

	["WEAPON_PIPEBOMB"] = {
		name = "Pipe Bomb",
		components = { },
		cash = 5000,
	},

	["WEAPON_POOLCUE"] = {
		name = "Pool Cue",
		components = { },
		cash = 625,
	},

	["WEAPON_WRENCH"] = {
		name = "Pipe Wrench",
		components = { },
		cash = 715,
	},

	["WEAPON_PISTOL"] = {
		name = "Pistol",
		components = {
			{ hash = 4275109233, name = "Default clip", cash = 0 },
			{ hash = 3978713628, name = "Extended clip", cash = 3750 },
			{ hash = 899381934,  name = "Flashlight", cash = 2500 },
			{ hash = 1709866683, name = "Suppressor", cash = 7500 },
			{ hash = 3610841222, name = "Yusuf Amir Luxury Finish", cash = 11250 },
		},
		cash = 0,
	},

	["WEAPON_MINISMG"] = {
		name = "Mini SMG",
		components = {
			{ hash = 2227745491, name = "Default clip", cash = 0 },
			{ hash = 2474561719, name = "Extended clip", cash = 6670 },
		},
		cash = 8900,
	},

	["WEAPON_MACHINEPISTOL"] = {
		name = "Machine Pistol",
		components = {
			{ hash = 1198425599, name = "Default clip", cash = 0 },
			{ hash = 3106695545, name = "Extended clip", cash = 4690 },
			{ hash = 3271853210, name = "Suppressor", cash = 9370 },
			{ hash = 2850671348, name = "Drum Magazine", cash = 12500 },
		},
		cash = 6250,
	},

	["WEAPON_COMPACTRIFLE"] = {
		name = "Compact Rifle",
		components = {
			{ hash = 1363085923, name = "Default clip", cash = 0 },
			{ hash = 1509923832, name = "Extended clip", cash = 10980 },
			{ hash = 3322377230, name = "Drum Magazine", cash = 29300 },
		},
		cash = 14650,
	},

	["WEAPON_COMBATPDW"] = {
		name = "Combat PDW",
		components = {
			{ hash = 1125642654, name = "Default clip", cash = 0 },
			{ hash = 860508675,  name = "Extended clip", cash = 8810 },
			{ hash = 1857603803, name = "Drum Magazine", cash = 23500 },
			{ hash = 2855028148, name = "Scope", cash = 20560 },
			{ hash = 202788691,  name = "Grip", cash = 14680 },
		},
		cash = 11750,
	},

	["WEAPON_SNSPISTOL"] = {
		name = "SNS Pistol",
		components = {
			{ hash = 4169150169, name = "Default clip", cash = 0 },
			{ hash = 2063610803, name = "Extended clip", cash = 2060 },
			{ hash = 2150886575, name = "Etched Wood Grip Finish", cash = 6180 },
		},
		cash = 2750,
	},

	["WEAPON_HEAVYPISTOL"] = {
		name = "Heavy Pistol",
		components = {
			{ hash = 222992026,  name = "Default clip", cash = 0 },
			{ hash = 1694090795, name = "Extended clip", cash = 2810 },
			{ hash = 899381934,  name = "Flashlight", cash = 1870 },
			{ hash = 3271853210, name = "Suppressor", cash = 5620 },
			{ hash = 2053798779, name = "Etched Wood Grip Finish", cash = 8430 },
		},
		cash = 3750,
	},

	["WEAPON_SPECIALCARBINE"] = {
		name = "Special Carbine",
		components = {
			{ hash = 3334989185, name = "Default clip", cash = 0 },
			{ hash = 2089537806, name = "Extended clip", cash = 11060 },
			{ hash = 1801039530, name = "Drum Magazine", cash = 29500 },
			{ hash = 2076495324, name = "Flashlight", cash = 7370 },
			{ hash = 2805810788, name = "Suppressor", cash = 22120 },
			{ hash = 2698550338, name = "Scope", cash = 25810 },
			{ hash = 202788691,  name = "Grip", cash = 18430 },
			{ hash = 1929467122, name = "Etched Gun Metal Finish", cash = 33180 },
		},
		cash = 14750,
	},

	["WEAPON_BULLPUPRIFLE"] = {
		name = "Bullpup Rifle",
		components = {
			{ hash = 3315675008, name = "Default clip", cash = 0 },
			{ hash = 3009973007, name = "Extended clip", cash = 10870 },
			{ hash = 2076495324, name = "Flashlight", cash = 7250 },
			{ hash = 2205435306, name = "Suppressor", cash = 21750 },
			{ hash = 2855028148, name = "Scope", cash = 25370 },
			{ hash = 202788691,  name = "Grip", cash = 18120 },
			{ hash = 2824322168, name = "Gilded Gun Metal Finish", cash = 32620 },
		},
		cash = 14500,
	},

	["WEAPON_VINTAGEPISTOL"] = {
		name = "Vintage Pistol",
		components = {
			{ hash = 1168357051, name = "Default clip", cash = 0 },
			{ hash = 867832552,  name = "Extended clip", cash = 2580 },
			{ hash = 3271853210, name = "Suppressor", cash = 5170 },
		},
		cash = 3450,
	},

	["WEAPON_HEAVYSHOTGUN"] = {
		name = "Heavy Shotgun",
		components = {
			{ hash = 844049759,  name = "Default clip", cash = 0 },
			{ hash = 2535257853, name = "Extended clip", cash = 10160 },
			{ hash = 2294798931, name = "Drum Magazine", cash = 27100 },
			{ hash = 2076495324, name = "Flashlight", cash = 6770 },
			{ hash = 2805810788, name = "Suppressor", cash = 20320 },
			{ hash = 202788691,  name = "Grip", cash = 16930 },
		},
		cash = 13550,
	},

	["WEAPON_MARKSMANRIFLE"] = {
		name = "Marksman Rifle",
		components = {
			{ hash = 3627761985, name = "Default clip", cash = 0 },
			{ hash = 3439143621, name = "Extended clip", cash = 11250 },
			{ hash = 2076495324, name = "Flashlight", cash = 7500 },
			{ hash = 2205435306, name = "Suppressor", cash = 22500 },
			{ hash = 202788691,  name = "Grip", cash = 18750 },
			{ hash = 371102273,  name = "Yusuf Amir Luxury Finish", cash = 33750 },
		},
		unique = true,
	},

	["WEAPON_COMBATPISTOL"] = {
		name = "Combat Pistol",
		components = {
			{ hash = 119648377,  name = "Default clip", cash = 0 },
			{ hash = 3598405421, name = "Extended clip", cash = 2400 },
			{ hash = 899381934,  name = "Flashlight", cash = 1600 },
			{ hash = 3271853210, name = "Suppressor", cash = 4800 },
			{ hash = 3328527730, name = "Yusuf Amir Luxury Finish", cash = 7200 },
		},
		cash = 3200,
	},

	["WEAPON_APPISTOL"] = {
		name = "AP Pistol",
		components = {
			{ hash = 834974250,  name = "Default clip", cash = 0 },
			{ hash = 614078421,  name = "Extended clip", cash = 3750 },
			{ hash = 899381934,  name = "Flashlight", cash = 2500 },
			{ hash = 3271853210, name = "Suppressor", cash = 7500 },
			{ hash = 2608252716, name = "Gilded Gun Metal Finish", cash = 11250 },
		},
		cash = 5000,
	},

	["WEAPON_DOUBLEACTION"] = {
		name = "Double-Action Revolver",
		components = { },
		unique = true,
	},

	["WEAPON_PISTOL50"] = {
		name = "Pistol .50",
		components = {
			{ hash = 580369945,  name = "Default clip", cash = 0 },
			{ hash = 3654528146, name = "Extended clip", cash = 3000 },
			{ hash = 899381934,  name = "Flashlight", cash = 2000 },
			{ hash = 2805810788, name = "Suppressor", cash = 6000 },
			{ hash = 2008591151, name = "Platinum Pearl Deluxe Finish", cash = 9000 },
		},
		cash = 4000,
	},

	["WEAPON_MICROSMG"] = {
		name = "Micro SMG",
		components = {
			{ hash = 3410538224, name = "Default clip", cash = 0 },
			{ hash = 283556395,  name = "Extended clip", cash = 2810 },
			{ hash = 899381934,  name = "Flashlight", cash = 1870 },
			{ hash = 2805810788, name = "Suppressor", cash = 5620 },
			{ hash = 2637152041, name = "Scope", cash = 6560 },
			{ hash = 1215999497, name = "Yusuf Amir Luxury Finish", cash = 8430 },
		},
		cash = 3750,
	},

	["WEAPON_SMG"] = {
		name = "SMG",
		components = {
			{ hash = 643254679,  name = "Default clip", cash = 0 },
			{ hash = 889808635,  name = "Extended clip", cash = 5620 },
			{ hash = 2043113590, name = "Drum Magazine", cash = 15000 },
			{ hash = 2076495324, name = "Flashlight", cash = 3750 },
			{ hash = 3271853210, name = "Suppressor", cash = 11250 },
			{ hash = 1019656791, name = "Scope", cash = 13120 },
			{ hash = 663170192,  name = "Yusuf Amir Luxury Finish", cash = 16870 },
		},
		cash = 7500,
	},

	["WEAPON_ASSAULTSMG"] = {
		name = "Assault SMG",
		components = {
			{ hash = 2366834608, name = "Default clip", cash = 0 },
			{ hash = 3141985303, name = "Extended clip", cash = 9410 },
			{ hash = 2076495324, name = "Flashlight", cash = 6270 },
			{ hash = 2805810788, name = "Suppressor", cash = 18820 },
			{ hash = 2637152041, name = "Scope", cash = 21960 },
			{ hash = 663517359,  name = "Yusuf Amir Luxury Finish", cash = 28230 },
		},
		cash = 12550,
	},

	["WEAPON_ASSAULTRIFLE"] = {
		name = "Assault Rifle",
		components = {
			{ hash = 3193891350, name = "Default clip", cash = 0 },
			{ hash = 2971750299, name = "Extended clip", cash = 6410 },
			{ hash = 2076495324, name = "Flashlight", cash = 4270 },
			{ hash = 2805810788, name = "Suppressor", cash = 12820 },
			{ hash = 2637152041, name = "Scope", cash = 14960 },
			{ hash = 202788691,  name = "Grip", cash = 10680 },
			{ hash = 1319990579, name = "Yusuf Amir Luxury Finish", cash = 19230 },
		},
		cash = 8550,
	},

	["WEAPON_CARBINERIFLE"] = {
		name = "Carbine Rifle",
		components = {
			{ hash = 2680042476, name = "Default clip", cash = 0 },
			{ hash = 2433783441, name = "Extended clip", cash = 9750 },
			{ hash = 3127044405, name = "Box Magazine", cash = 26000 },
			{ hash = 2076495324, name = "Flashlight", cash = 6500 },
			{ hash = 2205435306, name = "Suppressor", cash = 19500 },
			{ hash = 2698550338, name = "Scope", cash = 22750 },
			{ hash = 202788691,  name = "Grip", cash = 16250 },
			{ hash = 202788691,  name = "Yusuf Amir Luxury Finish", cash = 29250 },
		},
		cash = 13000,
	},

	["WEAPON_ADVANCEDRIFLE"] = {
		name = "Advanced Rifle",
		components = {
			{ hash = 4203716879, name = "Default clip", cash = 0 },
			{ hash = 2395064697, name = "Extended clip", cash = 10680 },
			{ hash = 2076495324, name = "Flashlight", cash = 7120 },
			{ hash = 2205435306, name = "Suppressor", cash = 21370 },
			{ hash = 2855028148, name = "Scope", cash = 24930 },
			{ hash = 930927479,  name = "Gilded Gun Metal Finish", cash = 32060 },
		},
		cash = 14250,
	},

	["WEAPON_MG"] = {
		name = "MG",
		components = {
			{ hash = 4097109892, name = "Default clip", cash = 0 },
			{ hash = 2182449991, name = "Extended clip", cash = 10120 },
			{ hash = 1006677997, name = "Scope", cash = 23620 },
			{ hash = 3604658878, name = "Yusuf Amir Luxury Finish", cash = 30370 },
		},
		cash = 13500,
	},

	["WEAPON_COMBATMG"] = {
		name = "Combat MG",
		components = {
			{ hash = 3791631178, name = "Default clip", cash = 0 },
			{ hash = 3603274966, name = "Extended clip", cash = 11100 },
			{ hash = 202788691,  name = "Grip", cash = 18500 },
			{ hash = 2698550338, name = "Scope", cash = 25900 },
			{ hash = 2466172125, name = "Etched Gun Metal Finish", cash = 33300 },
		},
		cash = 14800,
	},

	["WEAPON_PUMPSHOTGUN"] = {
		name = "Pump Shotgun",
		components = {
			{ hash = 2076495324, name = "Flashlight", cash = 1750 },
			{ hash = 3859329886, name = "Suppressor", cash = 5250 },
			{ hash = 2732039643, name = "Yusuf Amir Luxury Finish", cash = 7870 },
		},
		cash = 3500,
	},

	["WEAPON_ASSAULTSHOTGUN"] = {
		name = "Assault Shotgun",
		components = {
			{ hash = 2498239431, name = "Default clip", cash = 0 },
			{ hash = 2260565874, name = "Extended clip", cash = 7500 },
			{ hash = 2076495324, name = "Flashlight", cash = 5000 },
			{ hash = 2205435306, name = "Suppressor", cash = 15000 },
			{ hash = 202788691,  name = "Grip", cash = 12500 },
		},
		cash = 10000,
	},

	["WEAPON_BULLPUPSHOTGUN"] = {
		name = "Bullpup Shotgun",
		components = {
			{ hash = 2076495324, name = "Flashlight", cash = 4000 },
			{ hash = 2805810788, name = "Suppressor", cash = 12000 },
			{ hash = 202788691,  name = "Grip", cash = 10000 },
		},
		cash = 8000,
	},

	["WEAPON_SNIPERRIFLE"] = {
		name = "Sniper Rifle",
		components = {
			{ hash = 2805810788, name = "Suppressor", cash = 30000 },
			{ hash = 3527687644, name = "Scope", cash = 0 },
			{ hash = 3159677559, name = "Advanced Scope", cash = 35000 },
			{ hash = 1077065191, name = "Etched Wood Grip Finish", cash = 45000 },
		},
		unique = true,
	},

	["WEAPON_HEAVYSNIPER"] = {
		name = "Heavy Sniper",
		components = {
			{ hash = 3527687644, name = "Scope", cash = 0 },
			{ hash = 3159677559, name = "Advanced Scope", cash = 66760 },
		},
		unique = true,
	},

	["WEAPON_GRENADELAUNCHER"] = {
		name = "Grenade Launcher",
		components = {
			{ hash = 2076495324, name = "Flashlight", cash = 16200 },
			{ hash = 2855028148, name = "Scope", cash = 56700 },
			{ hash = 202788691,  name = "Grip", cash = 40500 },
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