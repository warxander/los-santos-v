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


-- Money
Settings.moneyPerKill = 300
Settings.moneyPerDeath = 100
Settings.moneyPerKillstreak = 50
Settings.repairPersonalVehiclePrice = 500


-- Crate Drops
Settings.crateDropSettings = {
	money = 5000,
	weaponClipCount = 5,
	weapons = {
		--Heavy Weapons
		{ id = "WEAPON_COMPACTLAUNCHER", name = "Compact Grenade Launcher" },
		{ id = "WEAPON_GRENADELAUNCHER", name = "Grenade Launcher" },
		{ id = "WEAPON_RPG", name = "Rocket Laucher" },
		{ id = "WEAPON_HOMINGLAUNCHER", name = "Homing Laucher" },
		{ id = "WEAPON_MINIGUN", name = "Minigun" },

		--Sniper Rifles
		{ id = "WEAPON_HEAVYSNIPER", name = "Heavy Sniper" },
		{ id = "WEAPON_SNIPERRIFLE", name = "Sniper Rifle" },
		{ id = "WEAPON_MARKSMANRIFLE", name = "Marksman Rifle" },
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


-- Bounties
Settings.bountyEventTimeout = 180000
Settings.bountyEventReward = 2500


--Robberies
Settings.robberySettings = {
	store = {
		hash = 'PICKUP_MONEY_PAPER_BAG',
		money = { min = 2500, max = 5000 },
		timeout = 300000,
		wantedLevel = 2
	},
	bank = {
		hash = 'PICKUP_MONEY_CASE',
		money = { min = 7500, max = 15000 },
		timeout = 600000,
		wantedLevel = 4
	},
}


-- Vehicles
-- https://pastebin.com/dutqk6jb
Settings.vehicleSettings = {
	superCars = {
		blipName = "Super",
		blipSprite = Blip.PersonalVehicleCar(),
		menuName = "vehicle_super",
		vehicles = {
			{ hash = "deluxo", name = "Imponte Deluxo", price = 3550 },
			{ hash = "stromberg", name = "Ocelot Stromberg", price = 2395 },
			{ hash = "vigilante", name = "Grotti Vigilante", price = 3750 },
			{ hash = "sc1", name = "Übermacht SC1", price = 1600 },
			{ hash = "autarch", name = "Överflöd Autarch", price = 1955 },
			{ hash = "pfister811", name = "Pfister 811", price = 1135 },
			{ hash = "adder", name = "Truffade Adder", price = 1000 },
			{ hash = "banshee", name = "Bravado Banshee 900R", price = 565 },
			{ hash = "bullet", name = "Bullet", price = 155 },
			{ hash = "cheetah", name = "Cheetah", price = 650 },
			{ hash = "fmj", name = "Vapid FMJ", price = 1750 },
			{ hash = "infernus", name = "Infernus", price = 440 },
			{ hash = "italigtb", name = "Itali GTB", price = 1189 },
			{ hash = "nero", name = "Truffade Nero", price = 1440 },
			{ hash = "osiris", name = "Pegassi Osiris", price = 1950 },
			{ hash = "penetrator", name = "Penetrator", price = 880 },
			{ hash = "le7b", name = "Annis RE-7B", price = 2475 },
			{ hash = "reaper", name = "Pegassi Reaper", price = 1595 },
			{ hash = "sultanrs", name = "Karin Sultan RS", price = 795 },
			{ hash = "t20", name = "Progen T20", price = 2200 },
			{ hash = "tempesta", name = "Pegassi Tempesta", price = 1329 },
			{ hash = "turismor", name = "Grotti Turismo R", price = 500 },
			{ hash = "tyrus", name = "Progen Tyrus", price = 2550 },
			{ hash = "vacca", name = "Pegassi Vacca", price = 240 },
			{ hash = "Sheava", name = "Emperor ETR1", price = 1995 },
			{ hash = "prototipo", name = "Grotti X80 Proto", price = 2700 },
			{ hash = "entityxf", name = "Överflöd Entity XF", price = 795 },
			{ hash = "zentorno", name = "Pegassi Zentorno", price = 725 },
		}
	},
	motorcycles = {
		blipName = "Motocycles",
		blipSprite = Blip.PersonalBikeCar(),
		menuName = "vehicle_moto",
		vehicles = {
			{ hash = "akuma", name = "Dinka Akuma", price = 90 },
			{ hash = "bagger", name = "Bagger", price = 160 },
			{ hash = "bati", name = "Pegassi Bati 801", price = 150 },
			{ hash = "bati2", name = "Pegassi Bati 801RR", price = 150 },
			{ hash = "carbonrs", name = "Nagasaki Carbon RS", price = 400 },
			{ hash = "daemon", name = "Daemon", price = 1450 },
			{ hash = "double", name = "Dinka Double T", price = 120 },
			{ hash = "faggio", name = "Faggio", price = 50 },
			{ hash = "hexer", name = "Hexer", price = 150 },
			{ hash = "nemesis", name = "Principe Nemesis", price = 120 },
			{ hash = "pcj", name = "PCJ-600", price = 90 },
			{ hash = "ruffian", name = "Pegassi Ruffian", price = 90 },
			{ hash = "sanchez", name = "Sanchez", price = 80 },
			{ hash = "vader", name = "Shitzu Vader", price = 90 },
		}
	},
	helicopters = {
		blipName = "Helicopters",
		blipSprite = Blip.Helicopter(),
		menuName = "vehicle_heli",
		vehicles = {
			{ hash = "hunter", name = "FH-1 Hunter", price = 3100 },
			{ hash = "akula", name = "Akula", price = 2785 },
			{ hash = "buzzard", name = "Buzzard", price = 1500 },
			{ hash = "savage", name = "Savage", price = 1950 },
			{ hash = "annihilator", name = "Annihilator", price = 1825 },
		}
	},
	planes = {
		blipName = "Planes",
		blipSprite = Blip.Plane(),
		menuName = "vehicle_planes",
		vehicles = {
			{ hash = "starling", name = "LF-22 Starling", price = 2750 },
			{ hash = "pyro", name = "Buckingham Pyro", price = 3350 },
			{ hash = "mogul", name = "Mammoth Mogul", price = 3125 },
			{ hash = "avenger2", name = "Mammoth Avenger", price = 4785 },
			{ hash = "bombushka", name = "RM-10 Bombushka", price = 4450 },
			{ hash = "volatol", name = "Volatol", price = 2800 },
			{ hash = "deluxo", name = "Imponte Deluxo", price = 3550 },
			{ hash = "hydra", name = "Hydra", price = 3000 },
			{ hash = "lazer", name = "Jobuilt P-996 LAZER", price = 6500 },
		}
	},
	boats = {
		blipName = "Boats",
		blipSprite = Blip.Boat(),
		menuName = "vehicle_boats",
		vehicles = {
			{ hash = "stromberg", name = "Ocelot Stromberg", price = 2395 },
			{ hash = "dinghy", name = "Dinghy", price = 125 },
			{ hash = "jetmax", name = "Cuban Jetmax", price = 299 },
			{ hash = "submersible", name = "Submersible", price = 1 },
			{ hash = "marquis", name = "Marquis", price = 414 },
			{ hash = "seashark", name = "Speedophile Seashark", price = 169 },
			{ hash = "speeder", name = "Speeder", price = 325 },
			{ hash = "squalo", name = "Squalo", price = 197 },
			{ hash = "suntrap", name = "Shitzu Suntrap", price = 256 },
			{ hash = "toro", name = "Lampadati Toro", price = 1750 },
			{ hash = "tropic", name = "Tropic", price = 220 },
			{ hash = "tug", name = "Tug", price = 1250 },
		}
	},
	military = {
		blipName = "Military",
		blipSprite = Blip.GunCar(),
		menuName = "vehicle_military",
		vehicles = {
			{ hash = "thruster", name = "Mammoth Thruster", price = 2750 },
			{ hash = "khanjali", name = "TM-02 Khanjali", price = 28950 },
			{ hash = "vigilante", name = "Grotti Vigilante", price = 3750 },
			{ hash = "barrage", name = "HVY Barrage", price = 1595 },
			{ hash = "chernobog", name = "HVY Chernobog", price = 2490 },
			{ hash = "rhino", name = "Rhino Tank", price = 15000 },
		}
	},
}