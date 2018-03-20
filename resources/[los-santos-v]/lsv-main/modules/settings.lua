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
Settings.RPPerDeath = 1
Settings.RPPerKillstreak = 1


-- Crate Drops
Settings.crateDropSettings = {
	RP = 50,
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
Settings.bountyEventReward = 25