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
		components = { },
		RP = 30000,
	},

	["WEAPON_RPG"] = {
		name = "RPG",
		components = { },
	},

	["WEAPON_MINIGUN"] = {
		name = "Minigun",
		components = { },
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
			{ hash = 3978713628, name = "Extended Clip" },
			{ hash = 1709866683, name = "Suppressor" },
		},
		RP = 0,
	},

	["WEAPON_MINISMG"] = {
		name = "Mini SMG",
		components = {
			{ hash = 2474561719, name = "Extended Clip" },
		},
		RP = 89000,
	},

	["WEAPON_MACHINEPISTOL"] = {
		name = "Machine Pistol",
		components = {
			{ hash = 3106695545, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
		},
		RP = 62500,
	},

	["WEAPON_COMPACTRIFLE"] = {
		name = "Compact Rifle",
		components = {
			{ hash = 1509923832, name = "Extended Clip" },
		},
		RP = 146500,
	},

	["WEAPON_COMBATPDW"] = {
		name = "Combat PDW",
		components = {
			{ hash = 860508675, name = "Extended Clip" },
			{ hash = 202788691, name = "Grip" },
			{ hash = 2855028148, name = "Scope" },
		},
		RP = 117500,
	},

	["WEAPON_SNSPISTOL"] = {
		name = "SNS Pistol",
		components = {
			{ hash = 2063610803, name = "Extended Clip" },
		},
		RP = 27500,
	},

	["WEAPON_HEAVYPISTOL"] = {
		name = "Heavy Pistol",
		components = {
			{ hash = 1694090795, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
		},
		RP = 37500,
	},

	["WEAPON_SPECIALCARBINE"] = {
		name = "Special Carbine",
		components = {
			{ hash = 2089537806, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 2698550338, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 147500,
	},

	["WEAPON_BULLPUPRIFLE"] = {
		name = "Bullpup Rifle",
		components = {
			{ hash = 3009973007, name = "Extended Clip" },
			{ hash = 2205435306, name = "Suppressor" },
			{ hash = 2855028148, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 145000,
	},

	["WEAPON_VINTAGEPISTOL"] = {
		name = "Vintage Pistol",
		components = {
			{ hash = 867832552, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
		},
		RP = 34500,
	},

	["WEAPON_HEAVYSHOTGUN"] = {
		name = "Heavy Shotgun",
		components = {
			{ hash = 2535257853, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 135500,
	},

	["WEAPON_MARKSMANRIFLE"] = {
		name = "Marksman Rifle",
		components = {
			{ hash = 3439143621, name = "Extended Clip" },
			{ hash = 2205435306, name = "Suppressor" },
			{ hash = 471997210, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
	},

	["WEAPON_COMBATPISTOL"] = {
		name = "Combat Pistol",
		components = {
			{ hash = 3598405421, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
		},
		RP = 32000,
	},

	["WEAPON_APPISTOL"] = {
		name = "AP Pistol",
		components = {
			{ hash = 614078421, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
		},
		RP = 50000,
	},

	["WEAPON_DOUBLEACTION"] = {
		name = "Double-Action Revolver",
		components = { },
	},

	["WEAPON_PISTOL50"] = {
		name = "Pistol .50",
		components = {
			{ hash = 3654528146, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
		},
		RP = 40000,
	},

	["WEAPON_MICROSMG"] = {
		name = "Micro SMG",
		components = {
			{ hash = 283556395, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 2637152041, name = "Scope" },
		},
		RP = 37500,
	},

	["WEAPON_SMG"] = {
		name = "SMG",
		components = {
			{ hash = 889808635, name = "Extended Clip" },
			{ hash = 3271853210, name = "Suppressor" },
			{ hash = 1019656791, name = "Scope" },
		},
		RP = 75000,
	},

	["WEAPON_ASSAULTSMG"] = {
		name = "Assault SMG",
		components = {
			{ hash = 3141985303, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 2637152041, name = "Scope" },
		},
		RP = 125500,
	},

	["WEAPON_ASSAULTRIFLE"] = {
		name = "Assault Rifle",
		components = {
			{ hash = 2971750299, name = "Extended Clip" },
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 2637152041, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 85500,
	},

	["WEAPON_CARBINERIFLE"] = {
		name = "Carbine Rifle",
		components = {
			{ hash = 2433783441, name = "Extended Clip" },
			{ hash = 2205435306, name = "Suppressor" },
			{ hash = 2698550338, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 130000,
	},

	["WEAPON_ADVANCEDRIFLE"] = {
		name = "Advanced Rifle",
		components = {
			{ hash = 2395064697, name = "Extended Clip" },
			{ hash = 2205435306, name = "Suppressor" },
			{ hash = 2855028148, name = "Scope" },
		},
		RP = 142500,
	},

	["WEAPON_MG"] = {
		name = "MG",
		components = {
			{ hash = 2182449991, name = "Extended Clip" },
			{ hash = 1006677997, name = "Scope" },
		},
		RP = 135000,
	},

	["WEAPON_COMBATMG"] = {
		name = "Combat MG",
		components = {
			{ hash = 3603274966, name = "Extended Clip" },
			{ hash = 2698550338, name = "Scope" },
		},
		RP = 148000,
	},

	["WEAPON_PUMPSHOTGUN"] = {
		name = "Pump Shotgun",
		components = {
			{ hash = 3859329886, name = "Suppressor" },
		},
		RP = 35000,
	},

	["WEAPON_ASSAULTSHOTGUN"] = {
		name = "Assault Shotgun",
		components = {
			{ hash = 2260565874, name = "Extended Clip" },
			{ hash = 2205435306, name = "Suppressor" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 100000,
	},

	["WEAPON_BULLPUPSHOTGUN"] = {
		name = "Bullpup Shotgun",
		components = {
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 202788691, name = "Grip" },
		},
		RP = 80000,
	},

	["WEAPON_SNIPERRIFLE"] = {
		name = "Sniper Rifle",
		components = {
			{ hash = 2805810788, name = "Suppressor" },
			{ hash = 3159677559, name = "Advanced Scope" },
		},
	},

	["WEAPON_HEAVYSNIPER"] = {
		name = "Heavy Sniper",
		components = {
			{ hash = 3159677559, name = "Advanced Scope" },
		},
	},

	["WEAPON_GRENADELAUNCHER"] = {
		name = "Grenade Launcher",
		components = {
			{ hash = 2855028148, name = "Scope" },
			{ hash = 202788691, name = "Grip" },
		},
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