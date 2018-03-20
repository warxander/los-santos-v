Settings = { }


-- General
Settings.maxPlayerCount = 31 -- For internal usage only, do not touch it!
Settings.afkTimeout = 300 --in seconds


-- Place markers
Settings.placeMarkerRadius = 1.25
Settings.placeMarkerOpacity = 196


-- Scoreboard
Settings.scoreboardMaxPlayers = 16
Settings.kdRatioMinStat = 100


-- Player
Settings.disableHealthRegen = true
Settings.giveArmorAtSpawn = true
Settings.autoParachutingHeight = 80
Settings.giveParachuteAtSpawn = true
Settings.infinitePlayerStamina = true
Settings.weaponClipCount = 10


-- Crew
Settings.crewInvitationTimeout = 10000


-- Pickups
Settings.pickupMaxCount = 5
Settings.pickupMinSpawnRadius = 25
Settings.pickupMaxSpawnRadius = 100
Settings.pickupMinDistance = 25


-- RP
Settings.RPPerKill = 2
Settings.RPPerKillstreak = 1


-- Crate Drops
Settings.crateDropSettings = {
	RP = 50,
	weaponClipCount = 5,
	weapons = {
		{ id = "WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher" },
		{ id = "WEAPON_GRENADELAUNCHER", name = "Grenade Launcher" },
		{ id = "WEAPON_RPG", name = "Rocket Laucher" },
		{ id = "WEAPON_HOMINGLAUNCHER", name = "Homing Laucher" },
		{ id = "WEAPON_MINIGUN", name = "Minigun" },
		{ id = "WEAPON_HEAVYSNIPER", name = "Heavy Sniper" },
		{ id = "WEAPON_SNIPERRIFLE", name = "Sniper Rifle" },
		{ id = "WEAPON_MARKSMANRIFLE", name = "Marksman Rifle" },
		{ id = "WEAPON_DOUBLEACTION", name = "Double-Action Revolver" },
	},
	timeout = 300000,
	positions = {
		{ ['x'] = 699.15850830078, ['y'] = -1594.9453125, ['z'] = 9.6801643371582 },
		{ ['x'] = 1436.9431152344, ['y'] = -2148.8503417969, ['z'] = 60.606800079346 },
		{ ['x'] = 977.98474121094, ['y'] = -3007.1948242188, ['z'] = 5.9007620811462 },
		{ ['x'] = 519.29821777344, ['y'] = -2980.8610839844, ['z'] = 6.0444560050964 },
		{ ['x'] = -1594.0063476563, ['y'] = -1025.740234375, ['z'] = 13.018488883972 },
		{ ['x'] = -3205.9792480469, ['y'] = 824.37823486328, ['z'] = 3.6351618766785 },
		{ ['x'] = -987.26776123047, ['y'] = 925.21795654297, ['z'] = 188.12802124023 },
		{ ['x'] = -323.3994140625, ['y'] = 1372.9141845703, ['z'] = 347.55932617188 },
		{ ['x'] = 738.34020996094, ['y'] = 1289.2221679688, ['z'] = 360.29647827148 },
		{ ['x'] = 1136.3858642578, ['y'] = 57.870365142822, ['z'] = 80.756072998047 },
		{ ['x'] = 1376.275390625, ['y'] = -740.32513427734, ['z'] = 67.232810974121 },
		{ ['x'] = 1975.4736328125, ['y'] = 501.99038696289, ['z'] = 161.87936401367 },
		{ ['x'] = 1461.1328125, ['y'] = 1111.3707275391, ['z'] = 114.33401489258 },
		{ ['x'] = 2282.044921875, ['y'] = 1530.5583496094, ['z'] = 65.374633789063 },
		{ ['x'] = 972.55712890625, ['y'] = 2366.0798339844, ['z'] = 52.216976165771 },
		{ ['x'] = 1456.7526855469, ['y'] = 2916.7160644531, ['z'] = 46.06986618042 },
		{ ['x'] = 1313.4600830078, ['y'] = 4332.83984375, ['z'] = 38.35871887207 },
		{ ['x'] = -1719.1187744141, ['y'] = 5044.27734375, ['z'] = 28.715219497681 },
		{ ['x'] = -2458.7272949219, ['y'] = 4203.5561523438, ['z'] = 3.6592676639557 },
		{ ['x'] = -2095.2294921875, ['y'] = 2519.5354003906, ['z'] = 0.95100903511047 },
	},
	guards = {
		hash = "s_m_y_marine_03",
		radius = 13,
		armor = 200,
		weapons = {
			"WEAPON_SNIPERRIFLE",
			"WEAPON_SPECIALCARBINE",
			"WEAPON_ADVANCEDRIFLE",
			"WEAPON_BULLPUPSHOTGUN",
			"WEAPON_RPG",
			"WEAPON_CARBINERIFLE",
			"WEAPON_ADVANCEDRIFLE",
			"WEAPON_MINIGUN",

		},
		count = 15,
	},
}


-- Skins
Settings.skins = {
	["s_m_y_blackops_01"] = {
		name = "Default",
		RP = 0,
	},



	["csb_anita"] = {
		name = "Anita Mendoza",
		RP = 50000,
	},

	["csb_anton"] = {
		name = "Anton Beaudelaire",
		RP = 50000,
	},

	["ig_ashley"] = {
		name = "Ashley Butler",
		RP = 50000,
	},

	["ig_casey"] = {
		name = "Casey",
		RP = 50000,
	},

	["ig_clay"] = {
		name = "Clay Simons",
		RP = 50000,
	},

	["ig_clay"] = {
		name = "Clay Simons",
		RP = 50000,
	},

	["cs_debra"] = {
		name = "Debra",
		RP = 50000,
	},

	["csb_hugh"] = {
		name = "Hugh Harrison",
		RP = 50000,
	},

	["ig_jay_norris"] = {
		name = "Jay Norris",
		RP = 50000,
	},

	["cs_johnnyklebitz"] = {
		name = "Johnny Klebitz",
		RP = 50000,
	},

	["ig_karen_daniels"] = {
		name = "Karen Daniels",
		RP = 50000,
	},

	["ig_natalia"] = {
		name = "Natalia Zverovna",
		RP = 50000,
	},

	["ig_ortega"] = {
		name = "Ortega",
		RP = 50000,
	},

	["csb_oscar"] = {
		name = "Oscar Guzman",
		RP = 50000,
	},

	["ig_dreyfuss"] = {
		name = "Peter Dreyfuss",
		RP = 50000,
	},

	["ig_tanisha"] = {
		name = "Tanisha Jackson",
		RP = 50000,
	},

	["ig_terry"] = {
		name = "Terry Thorpe",
		RP = 50000,
	},

	["ig_terry"] = {
		name = "Terry Thorpe",
		RP = 50000,
	},



	["ig_andreas"] = {
		name = "Andreas Sanchez",
		RP = 125000,
	},

	["ig_taostranslator"] = {
		name = "Cheng's translator",
		RP = 125000,
	},

	["ig_denise"] = {
		name = "Denise Clinton",
		RP = 125000,
	},

	["ig_oneil"] = {
		name = "Elwood O'Neil",
		RP = 125000,
	},

	["ig_fabien"] = {
		name = "Fabien LaRouche",
		RP = 125000,
	},

	["ig_floyd"] = {
		name = "Floyd Hebert",
		RP = 125000,
	},

	["ig_drfriedlander"] = {
		name = "Isiah Friedlander",
		RP = 125000,
	},

	["ig_lazlow"] = {
		name = "Lazlow Jones",
		RP = 125000,
	},

	["ig_patricia"] = {
		name = "Patricia Madrazo",
		RP = 125000,
	},

	["ig_roccopelosi"] = {
		name = "Rocco Pelosi",
		RP = 125000,
	},

	["ig_siemonyetarian"] = {
		name = "Simeon Yetarian",
		RP = 125000,
	},

	["ig_taocheng"] = {
		name = "Tao Cheng",
		RP = 125000,
	},



	["ig_amandatownley"] = {
		name = "Amanda De Santa",
		RP = 250000,
	},

	["ig_jimmydisanto"] = {
		name = "Jimmy De Santa",
		RP = 250000,
	},

	["ig_tracydisanto"] = {
		name = "Tracey De Santa",
		RP = 250000,
	},

	["ig_brad"] = {
		name = "Brad Snider",
		RP = 250000,
	},

	["ig_stretch"] = {
		name = "Stretch",
		RP = 250000,
	},

	["ig_chengsr"] = {
		name = "Wei Cheng",
		RP = 250000,
	},

	["cs_martinmadrazo"] = {
		name = "Martin Madrazo",
		RP = 250000,
	},

	["ig_solomon"] = {
		name = "Solomon Richards",
		RP = 250000,
	},

	["ig_nervousron"] = {
		name = "Ron Jakowski",
		RP = 250000,
	},

	["ig_wade"] = {
		name = "Wade Hebert",
		RP = 250000,
	},

	["ig_molly"] = {
		name = "Molly Schultz",
		RP = 250000,
	},



	["ig_lestercrest"] = {
		name = "Lester Crest",
		RP = 500000,
	},

	["ig_davenorton"] = {
		name = "Dave Norton",
		RP = 500000,
	},

	["ig_lamardavis"] = {
		name = "Lamar Devis",
		RP = 500000,
	},

	["ig_lestercrest"] = {
		name = "Lester Crest",
		RP = 500000,
	},

	["ig_davenorton"] = {
		name = "Dave Norton",
		RP = 500000,
	},

	["ig_lamardavis"] = {
		name = "Lamar Davis",
		RP = 500000,
	},

	["ig_stevehains"] = {
		name = "Steve Haines",
		RP = 500000,
	},

	["ig_devin"] = {
		name = "Devin Weston",
		RP = 500000,
	},



	["player_zero"] = {
		name = "Michael De Santa",
		RP = 750000,
	},

	["player_one"] = {
		name = "Franklin Clinton",
		RP = 1000000,
	},

	["player_two"] = {
		name = "Trevor Phillips",
		RP = 1500000,
	},
}


-- Bounties
Settings.bountyEventTimeout = 180000
Settings.bountyEventReward = 25