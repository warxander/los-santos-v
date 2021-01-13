Settings = { }
Settings.__index = Settings

-- General
Settings.worldModifierDistance = 350.
Settings.allowMultipleAccounts = false
Settings.afkTimeout = 300 -- in seconds
Settings.autoSavingInterval = 180000
Settings.pingThreshold = 200
Settings.maxPlayerNameLength = 24
Settings.enableVoiceChat = false
Settings.discordNotificationInterval = 900000
Settings.minKillstreakNotification = 10
Settings.serverTimeZone = '(UTC+1)'
Settings.maxMenuOptionCount = 7
Settings.spawnProtectionTime = 1500
Settings.killYourselfInterval = 60000

-- Density Multipliers
Settings.density = {
	ped = 0.45,
	vehicle = 0.35,
}

-- Server restart
Settings.serverRestart = {
	times = {
		{ hour = 6, min = 0 },
		{ hour = 12, min = 0 },
		{ hour = 18, min = 0 },
		{ hour = 24, min = 0 },
	},
	warnBeforeMs = 15 * 60 * 1000,
}

-- Weather
Settings.weather = { }
Settings.weather.types = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'CLEARING' }
Settings.weather.interval = { min = 10, max = 20 } -- in minutes

-- Player settings
Settings.player = {
	['disableCrosshair'] = 'Disable Crosshair',
	['disableKillFeed'] = 'Disable Kill Feed',
	['disableTips'] = 'Disable Tips',
	['disableEventTimer'] = 'Disable Event Timer',
}

-- Killstreak
Settings.killstreakTimeout = 5000

-- Prestige
Settings.prestige = {
	minRank = 100,
	rewardMultiplier = 0.005,
	damageMultiplier = 0.0025,
	defenseMultiplier = 0.0025,
}

-- Crew
Settings.crew = {
	rewardBonus = { cash = 0.25, exp = 0.25 },
	salary = {
		timeout = 300000,
		cash = 3000,
		exp = 250,
	},
	memberLimit = 8,
	invitationTimeout = 10000,
	spawnDistance = 100.,
}

-- Vehicle restriction
Settings.specialVehicleMinRank = 5

-- Moderation
Settings.moderator = {
	levels = {
		['Moderator'] = 1,
		['Administrator'] = 2,
	},
}

-- GTA2 Cam
Settings.gta2Cam = {
	min = 24.,
	max = 48.,
	step = 0.25,
	minSpeed = 24.,
	key = { code = 171, name = 'INPUT_SPECIAL_ABILITY_PC' }, -- CAPS LOCK
}

-- Spawn settings
Settings.spawn = {
	points = {
		{ x = -1206.2694091797, y = -1308.7628173828, z = 4.8130288124084 },
		{ x = -1358.4222412109, y = -925.42718505859, z = 9.7058086395264 },
		{ x = -1463.2197265625, y = -371.50479125977, z = 39.337921142578 },
		{ x = -763.75317382813, y = -207.60316467285, z = 37.276252746582 },
		{ x = -361.62969970703, y = 56.131683349609, z = 54.429798126221 },
		{ x = 194.5210723877, y = 11.586701393127, z = 73.324668884277 },
		{ x = 294.6533203125, y = 516.67834472656, z = 150.4945526123 },
		{ x = 857.50549316406, y = -170.21603393555, z = 74.956398010254 },
		{ x = 1000.2170410156, y = -1559.2779541016, z = 30.761838912964 },
		{ x = 295.56491088867, y = -1721.2052001953, z = 29.306119918823 },
		{ x = 35.834465026855, y = -1455.9869384766, z = 29.311674118042 },
		{ x = -296.07638549805, y = -944.802734375, z = 31.209295272827 },
		{ x = 37.500869750977, y = -411.47750854492, z = 39.922351837158 },
		{ x = -950.19488525391, y = 195.03065490723, z = 67.391532897949 },
		{ x = -723.30395507813, y = -994.61871337891, z = 18.177326202393 },
	},
	deathTime = 6000,
	timeout = 30000,
	respawnFasterPerControlPressed = 350, -- holy
	tryCount = 150,
	radius = { min = 100., increment = 25., minDistanceToPlayer = 75. },
}

-- Ranking
-- https://gta.fandom.com/wiki/Rank
Settings.ranks = {
	0,
	800,
	2100,
	3800,
	6100,
	9500,
	12500,
	16000,
	19800,
	24000, -- 10
	28500,
	33400,
	38700,
	44200,
	50200,
	56400,
	63000,
	69900,
	77100,
	84700, -- 20
	92500,
	100700,
	109200,
	118000,
	127100,
	136500,
	146200,
	156200,
	166500,
	177100, -- 30
	188000,
	199200,
	210700,
	222400,
	234500,
	246800,
	259400,
	272300,
	285500,
	299000, -- 40
	312700,
	326800,
	341000,
	355600,
	370500,
	385600,
	401000,
	416600,
	432600,
	448800, -- 50
	465200,
	482000,
	499000,
	516300,
	533800,
	551600,
	569600,
	588000,
	606500,
	625400, -- 60
	644500,
	663800,
	683400,
	703300,
	723400,
	743800,
	764500,
	785400,
	806500,
	827900, -- 70
	849600,
	871500,
	893600,
	916000,
	938700,
	961600,
	984700,
	1008100,
	1031800,
	1055700, -- 80
	1079800,
	1104200,
	1128800,
	1153700,
	1178800,
	1204200,
	1229800,
	1255600,
	1281700,
	1308100, --90
	1334600,
	1361400,
	1388500,
	1415800,
	1443300,
	1471100,
	1499100,
	1527300,
	1555800,
	1584350, -- 100
}

-- World
Settings.world = { }
Settings.world.blacklistVehicles = {
	`rhino`,
	`khanjali`,
	`hydra`,
	`lazer`,
	`hunter`,
	`cargoplane`,
}

-- Place markers
Settings.placeMarker = {
	radius = 0.625,
	opacity = 196,
}

-- Scoreboard
Settings.kdRatioMinStat = 100

-- Player
Settings.disableHealthRegen = false
Settings.giveArmorAtSpawn = true
Settings.giveParachuteAtSpawn = true
Settings.infinitePlayerStamina = true
Settings.weaponClipCount = 10
Settings.defaultPlayerWeapons = {
	{ id = 'WEAPON_KNIFE', ammo = 0, components = { } },
	{ id = 'WEAPON_PISTOL', ammo = 12 * 10, components = { } },
	{ id = 'WEAPON_MICROSMG', ammo = 16 * 10, components = { }, selected = true },
	{ id = 'WEAPON_SAWNOFFSHOTGUN', ammo = 8 * 10, components = { } },
}
Settings.defaultPlayerModel = {
	model = 'a_m_y_hipster_01',
	components = { },
}
Settings.stats = {
	strength = { min = 75, max = 80 },
	shooting = { min = 60, max = 80 },
	flying = { min = 60, max = 80 },
	driving = { min = 60, max = 80 },
	lung = { min = 60 , max = 80 },
	stealth = { min = 80 , max = 100 },
	stamina = { min = 100, max = 100 },
}
Settings.armour = {
	max = 100,
	regenRate = {
		timeout = 6000,
		time = 40,
		armour = 2,
	},
}

-- Patreon
Settings.patreon = {
	reward = { 1.20, 1.35, 1.50 },
	rent = { 0.80, 0.65, 0.50 },
}

-- Cash
Settings.rewardNotificationTime = 5000

Settings.cashMultiplier = 1.
Settings.cashVehicleMultiplier = 0.75
Settings.cashPerKill = 175
Settings.cashPerKillstreak = 25
Settings.maxCashPerKillstreak = 500
Settings.cashPerHeadshot = 25
Settings.cashPerMission = 125
Settings.cashPerMelee = 200
Settings.cashPerCrewLeader = 125
Settings.cashPerRevenge = 75

-- Experience
Settings.expMultiplier = 1.
Settings.expVehicleMultiplier = 0.75
Settings.expPerKill = 100
Settings.expPerKillstreak = 50
Settings.maxExpPerKillstreak = 1000
Settings.expPerHeadshot = 50
Settings.expPerMission = 200
Settings.expPerMelee = 300
Settings.expPerCrewLeader = 200
Settings.expPerRevenge = 150

-- Bounty
Settings.bounty = {
	killstreak = 5,
	reward = {
		cash = 250,
		exp = 125,
	},
}

-- Fast Travel
Settings.travel = {
	cash = 250,
	places = {
		{
			name = 'Davis Sheriff\'s Station',
			inPosition = { x = 360.52108764648, y = -1584.2335205078, z = 29.29195022583 },
			outPosition = { x = 374.51406860352, y = -1610.8005371094, z = 29.291940689087 },
		},

		{
			name = 'Mission Row Police Station',
			inPosition = { x = 440.98419189453, y = -981.23754882813, z = 30.689605712891 },
			outPosition = { x = 457.59268188477, y = -1009.0366210938, z = 28.302804946899 },
		},

		{
			name = 'Rockford Hills Police Station',
			inPosition = { x = -560.86633300781, y = -133.30345153809, z = 38.072071075439 },
			outPosition = { x = -590.10180664063, y = -134.81674194336, z = 39.610427856445 },
		},

		{
			name = 'Vinewood Police Station',
			inPosition = { x = 639.63989257813, y = 1.2733203172684, z = 82.786415100098 },
			outPosition = { x = 535.12512207031, y = -22.661163330078, z = 70.629531860352 },
		},

		{
			name = 'Sandy Shores Sheriff\'s Station',
			inPosition = { x = 1854.0239257813, y = 3687.1411132813, z = 34.267082214355 },
			outPosition = { x = 1827.2972412109, y = 3694.1489257813, z = 34.224239349365 },
		},

		{
			name = 'Paleto Bay Sherrif\'s Station',
			inPosition = { x = -446.99200439453, y = 6013.5122070313, z = 31.716371536255 },
			outPosition = { x = -452.25775146484, y = 6006.0942382813, z = 31.840953826904 },
		},

		{
			name = 'Del Perro Police Station',
			inPosition = { x = -1632.0194091797, y = -1014.7529907227, z = 13.119782447815 },
			outPosition = { x = -1613.0258789063, y = -1028.6661376953, z = 13.153079032898 },
		},

		{
			name = 'Vespucci Police Station',
			inPosition = { x = -1092.8321533203, y = -809.19091796875, z = 19.277364730835 },
			outPosition = { x = -1056.9117431641, y = -842.10626220703, z = 5.0417881011963 },
		},
	},
}

-- Personal Vehicles
Settings.personalVehicle = {
	maxDistance = 50.0,
	rentPrice = {
		['Low'] = 100,
		['Medium'] = 200,
		['High'] = 300,
		['Classic'] = 500,
		['Prestige'] = 1500,
	},
	customizePricePerMod = 2500,
	rerollColorsPrice = { base = 2500, perRoll = 500 },
	rentTimeout = 15000,
}

-- Events
Settings.event = {
	interval = 600000,
	minPlayers = 3,
}

-- Gang Wars
Settings.gangWars = {
	duration = 900000,
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Simeon Export
Settings.simeon = {
	duration = 900000,
	vehicles = {
		{ hash = `bagger`, name = 'Bagger' },
		{ hash = `penumbra`, name = 'Maibatsu Penumbra' },
		{ hash = `prairie`, name = 'Bollokan Prairie' },
		{ hash = `bjxl`, name = 'Karin BeeJay XL' },
		{ hash = `buccaneer`, name = 'Buccaneer' },
		{ hash = `gresley`, name = 'Bravado Gresley' },
		{ hash = `dominator`, name = 'Vapid Dominator' },
		{ hash = `fusilade`, name = 'Schyster Fusilade' },
		{ hash = `surge`, name = 'Cheval Surge' },
		{ hash = `habanero`, name = 'Emperor Habanero' },
		{ hash = `fq2`, name = 'Fathom FQ 2' },
		{ hash = `patriot`, name = 'Patriot' },
		{ hash = `tailgater`, name = 'Obey Tailgater' },
		{ hash = `landstalker`, name = 'Landstalker' },
		{ hash = `sentinel`, name = 'Sentinel XS' },
	},
	vehiclesCount = 3,
	rewards = { cash = 10000, exp = 5000 },
	dropRadius = 1.5,
	blipRadius = 50.,
	location = { x = 1204.4508056641, y = -3116.7836914062, z = 5.5403265953064 },
}

-- Gun Game
Settings.gun = {
	duration = 600000,
	categories = { 'Melee', 'Handguns', 'Shotguns', 'Submachine & Lightmachine Guns', 'Assault Rifles' },
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Stockpiling
Settings.stockPiling = {
	duration = 900000,
	checkPoints = {
		{ x = -1336.3083496094, y = -3043.9572753906, z = 13.944443702698 },
		{ x = -1916.6357421875, y = -2883.4919433594, z = 2.2101058959961 },
		{ x = 370.65002441406, y = -2131.0170898438, z = 16.210426330566 },
		{ x = -1486.0161132813, y = -1476.2647705078, z = 2.634242773056 },
		{ x = -1847.56640625, y = -1229.1634521484, z = 13.017266273499 },
		{ x = -2994.1015625, y = 17.080907821655, z = 6.9866771697998 },
		{ x = -3413.0749511719, y = 967.44000244141, z = 8.3466844558716 },
		{ x = -2243.9494628906, y = 262.83520507813, z = 174.61549377441 },
		{ x = -2270.90625, y = 1328.9090576172, z = 298.80294799805 },
		{ x = -1533.560546875, y = 884.00518798828, z = 181.71989440918 },
		{ x = -1024.2127685547, y = 1048.4678955078, z = 173.73756408691 },
		{ x = -409.96801757813, y = 1180.30078125, z = 325.61047363281 },
		{ x = -116.88822937012, y = 899.69128417969, z = 235.80456542969 },
		{ x = 168.7543182373, y = 665.86444091797, z = 206.73274230957 },
		{ x = -486.38897705078, y = 597.96118164063, z = 126.11904144287 },
		{ x = -661.04150390625, y = 403.44506835938, z = 101.25228118896 },
		{ x = -1073.6116943359, y = -23.468688964844, z = 50.175617218018 },
		{ x = -1392.5510253906, y = 143.81143188477, z = 56.135433197021 },
		{ x = -768.88208007813, y = -413.71401977539, z = 35.650127410889 },
		{ x = 402.68658447266, y = -953.84881591797, z = 29.447750091553 },
		{ x = 153.02626037598, y = -570.09240722656, z = 43.870571136475 },
		{ x = -251.3383026123, y = -229.70063781738, z = 49.101440429688 },
		{ x = 147.59950256348, y = -124.38256835938, z = 54.826652526855 },
		{ x = -569.11511230469, y = -157.98637390137, z = 38.060680389404 },
		{ x = -1230.4274902344, y = -2730.3347167969, z = 13.953640937805 },
		{ x = -1115.2401123047, y = -2426.0676269531, z = 13.945163726807 },
		{ x = -1369.5837402344, y = -2334.8679199219, z = 13.944553375244 },
		{ x = -1006.3687133789, y = -1756.9224853516, z = 6.5498008728027 },
		{ x = -1173.6881103516, y = -1773.2373046875, z = 3.8475110530853 },
		{ x = -237.16279602051, y = -2045.02734375, z = 27.755414962769 },
		{ x = -697.82586669922, y = -2116.7375488281, z = 43.201431274414 },
		{ x = -1018.7079467773, y = -940.74395751953, z = 3.9379351139069 },
		{ x = -710.0576171875, y = -924.31732177734, z = 19.013902664185 },
		{ x = -458.84182739258, y = -1029.787109375, z = 23.550479888916 },
		{ x = -12.4260597229, y = -1085.4757080078, z = 26.686298370361 },
		{ x = -112.37512207031, y = -952.02941894531, z = 27.780033111572 },
		{ x = -693.76171875, y = -627.56378173828, z = 31.556966781616 },
		{ x = 97.86841583252, y = -1933.7349853516, z = 20.803693771362 },
		{ x = -44.686100006104, y = -1684.1784667969, z = 29.406301498413 },
		{ x = -22.662431716919, y = -1462.4112548828, z = 30.792766571045 },
		{ x = 264.77066040039, y = -1762.9516601563, z = 28.721403121948 },
		{ x = 311.60852050781, y = -1203.5598144531, z = 38.892589569092 },
		{ x = -224.61524963379, y = -1536.0466308594, z = 31.6276512146 },
		{ x = -688.12017822266, y = -1421.1513671875, z = 5.0005016326904 },
		{ x = 306.08633422852, y = 263.80908203125, z = 105.23339080811 },
		{ x = -2708.0163574219, y = 2285.0014648438, z = 18.862909317017 },
		{ x = -1909.8930664063, y = 2051.3168945313, z = 140.73783874512 },
		{ x = -1567.7503662109, y = 2771.3178710938, z = 17.37317276001 },
		{ x = -53.203418731689, y = 1949.9564208984, z = 190.18603515625 },
		{ x = 310.44241333008, y = 2578.9968261719, z = 44.142951965332 },
		{ x = 847.06799316406, y = 2209.35546875, z = 50.63000869751 },
		{ x = 1552.7023925781, y = 2203.8825683594, z = 78.780197143555 },
		{ x = 1429.6849365234, y = 1184.5096435547, z = 114.10710906982 },
		{ x = 695.40606689453, y = 635.31689453125, z = 128.9111328125 },
		{ x = 2561.4592285156, y = -301.66592407227, z = 92.992736816406 },
		{ x = 2562.7062988281, y = 480.96463012695, z = 108.5029296875 },
		{ x = 2279.9067382813, y = 1338.6087646484, z = 74.341827392578 },
		{ x = 2222.2431640625, y = 1727.1955566406, z = 88.996925354004 },
		{ x = 2688.3718261719, y = 1642.8406982422, z = 24.605836868286 },
		{ x = 2044.0572509766, y = 2353.0397949219, z = 95.410797119141 },
		{ x = 2352.5913085938, y = 2584.7861328125, z = 46.667652130127 },
		{ x = 2960.1711425781, y = 2872.4370117188, z = 58.522445678711 },
		{ x = 3517.8569335938, y = 3768.794921875, z = 29.946256637573 },
		{ x = 2683.0104980469, y = 3446.9934082031, z = 55.808784484863 },
		{ x = 1770.4974365234, y = 3345.3811035156, z = 40.88060760498 },
		{ x = 1577.81640625, y = 3716.0046386719, z = 34.518661499023 },
		{ x = 2142.8666992188, y = 3891.32421875, z = 33.185470581055 },
		{ x = 926.47259521484, y = 3632.564453125, z = 32.507034301758 },
		{ x = 1178.9708251953, y = -511.19033813477, z = 65.140090942383 },
		{ x = 1132.5310058594, y = 52.768749237061, z = 80.756080627441 },
		{ x = 1335.2327880859, y = -1610.4481201172, z = 52.485500335693 },
		{ x = 1491.7934570313, y = -2261.1296386719, z = 69.204490661621 },
		{ x = 915.50909423828, y = -2247.2807617188, z = 30.538305282593 },
		{ x = 796.07885742188, y = -1432.8244628906, z = 27.200159072876 },
		{ x = 695.91271972656, y = 15.012089729309, z = 84.19792175293 },
		{ x = -1606.0737304688, y = 3165.9331054688, z = 30.11336517334 },
		{ x = -3000.0346679688, y = 3434.6181640625, z = 9.6652679443359 },
		{ x = -1094.5321044922, y = 4914.9106445313, z = 215.29824829102 },
		{ x = 717.70245361328, y = 4176.2641601563, z = 40.709224700928 },
		{ x = 1453.1275634766, y = 4497.8852539063, z = 50.362659454346 },
		{ x = 2855.6328125, y = 4486.412109375, z = 48.314010620117 },
		{ x = 2034.1824951172, y = 4833.6083984375, z = 41.462303161621 },
		{ x = 2222.8522949219, y = 5159.9536132813, z = 57.664150238037 },
		{ x = 1663.0145263672, y = 4906.314453125, z = 42.106376647949 },
		{ x = 3787.6064453125, y = 4464.0590820313, z = 5.9159359931946 },
		{ x = 3257.4245605469, y = 5146.5078125, z = 19.593757629395 },
		{ x = 2224.6821289063, y = 5637.3364257813, z = 55.34451675415 },
		{ x = 1508.0504150391, y = 6339.1767578125, z = 23.909559249878 },
		{ x = 72.016571044922, y = 6606.9516601563, z = 31.525604248047 },
		{ x = -172.85244750977, y = 6358.0815429688, z = 31.476022720337 },
		{ x = -854.98846435547, y = 5444.2016601563, z = 34.387084960938 },
		{ x = 103.93124389648, y = 6961.3247070313, z = 12.499313354492 },
		{ x = -2408.4819335938, y = 4233.107421875, z = 10.573749542236 },
		{ x = -230.98617553711, y = 3893.5434570313, z = 37.351898193359 },
		{ x = 873.79034423828, y = 2852.4760742188, z = 56.891750335693 },
		{ x = -227.2001953125, y = 122.42472839355, z = 69.688529968262 },
		{ x = -1387.1737060547, y = -390.22091674805, z = 36.690052032471 },
		{ x = 519.78051757813, y = -2979.9724121094, z = 6.0442643165588 },
		{ x = 1886.4422607422, y = 431.0895690918, z = 164.13516235352 },
		{ x = 2168.572265625, y = 3509.1450195313, z = 45.455860137939 },
	},
	radius = 2.0,
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Sharpshooter
Settings.sharpShooter = {
	duration = 600000,
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- King of the Castle
Settings.castle = {
	duration = 900000,
	places = {
		{ x = -429.50573730469, y = 1109.7385253906, z = 327.68228149414 },
		{ x = 2747.3190917969, y = 1524.2060546875, z = 42.893901824951 },
		{ x = -1806.5964355469, y = 443.03262329102, z = 128.50791931152 },
		{ x = 937.27996826172, y = -3033.9206542969, z = 5.9020395278931 },
		{ x = 1459.8696289063, y = 1112.6547851563, z = 114.33392333984 },
		{ x = 100.60562133789, y = -1937.0286865234, z = 20.803699493408 },
		{ x = -1033.8146972656, y = -1072.1015625, z = 4.0820965766907 },
		{ x = -1651.9538574219, y = -1099.3696289063, z = 13.078674316406 },
		{ x = 1234.7498779297, y = -648.01989746094, z = 66.377662658691 },
		{ x = 1364.8551025391, y = -579.05023193359, z = 74.380249023438 },
		{ x = -1664.5391845703, y = -152.79943847656, z = 58.008377075195 },
		{ x = 1448.15625, y = 6350.9267578125, z = 23.653469085693 },
		{ x = 1665.9049072266, y = -15.893600463867, z = 173.77449035645 },
		{ x = -367.48580932617, y = 6076.2182617188, z = 31.478071212769 },
		{ x = -531.49578857422, y = 5322.77734375, z = 91.377044677734 },
		{ x = 249.20080566406, y = 217.67642211914, z = 106.28646850586, radius = 20. },
	},
	radius = 50.0,
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Penned In
Settings.penned = {
	duration = 600000,
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Highway
Settings.highway = {
	duration = 600000,
	rewards = {
		{ cash = 30000, exp = 15000 },
		{ cash = 20000, exp = 10000 },
		{ cash = 10000, exp = 5000 },
	},
}

-- Hot Property
Settings.property = {
	duration = 900000,
	places = {
		{ x = 456.44708251953, y = -226.61473083496, z = 55.968910217285 },
		{ x = 686.36315917969, y = 577.81451416016, z = 130.46127319336 },
		{ x = -482.61212158203, y = -56.368179321289, z = 39.99422454834 },
		{ x = -1251.0491943359, y = -1540.7322998047, z = 4.2961750030518 },
		{ x = -1181.9063720703, y = -2918.6696777344, z = 13.94495677948 },
		{ x = -145.44644165039, y = -2046.9323730469, z = 22.956035614014 },
		{ x = 1240.3864746094, y = -1927.2956542969, z = 38.531646728516 },
		{ x = -1651.9538574219, y = -1099.3696289063, z = 13.078674316406 },
		{ x = 1234.7498779297, y = -648.01989746094, z = 66.377662658691 },
		{ x = 1364.8551025391, y = -579.05023193359, z = 74.380249023438 },
		{ x = 1920.7384033203, y = 3729.5568847656, z = 32.78893661499 },
		{ x = 1901.9664306641, y = 4920.1513671875, z = 48.730365753174 },
		{ x = -157.02299499512, y = 6589.9370117188, z = 4.4816722869873 },
		{ x = -285.13888549805, y = 2532.4814453125, z = 74.667221069336 },
		{ x = -3418.2944335938, y = 967.32739257813, z = 11.936135292053 },
	},
	rewards = {
		top = {
			{ cash = 30000, exp = 15000 },
			{ cash = 20000, exp = 10000 },
			{ cash = 10000, exp = 5000 },
		},
	},
}

-- Hunt The Beast
Settings.huntTheBeast = {
	duration = 900000,
	lives = 5,
	targetLandmarks = 10,
	landmarks = {
		{ x = -1336.3083496094, y = -3043.9572753906, z = 13.944443702698 },
		{ x = -2994.1015625, y = 17.080907821655, z = 6.9866771697998 },
		{ x = -1024.2127685547, y = 1048.4678955078, z = 173.73756408691 },
		{ x = -409.96801757813, y = 1180.30078125, z = 325.61047363281 },
		{ x = -661.04150390625, y = 403.44506835938, z = 101.25228118896 },
		{ x = 153.02626037598, y = -570.09240722656, z = 43.870571136475 },
		{ x = -1018.7079467773, y = -940.74395751953, z = 3.9379351139069 },
		{ x = -458.84182739258, y = -1029.787109375, z = 23.550479888916 },
		{ x = -22.662431716919, y = -1462.4112548828, z = 30.792766571045 },
		{ x = 306.08633422852, y = 263.80908203125, z = 105.23339080811 },
		{ x = 790.27349853516, y = 1280.9708251953, z = 360.29656982422 },
		{ x = 161.32760620117, y = 2238.3051757813, z = 90.317764282227 },
		{ x = 1727.6921386719, y = 3053.3933105469, z = 59.436401367188 },
		{ x = 2950.6801757813, y = 2805.3674316406, z = 41.562049865723 },
		{ x = 3515.7553710938, y = 3769.1823730469, z = 29.945058822632 },
		{ x = -1894.9313964844, y = 2030.2058105469, z = 140.73773193359 },
		{ x = -2402.9509277344, y = 3425.3767089844, z = 33.334217071533 },
		{ x = -644.27685546875, y = 4136.6635742188, z = 165.60166931152 },
		{ x = -1579.2475585938, y = 5164.212890625, z = 19.526447296143 },
		{ x = -575.81390380859, y = 5251.9223632813, z = 70.468421936035 },
		{ x = 2591.2399902344, y = -283.96057128906, z = 92.885665893555 },
		{ x = 1551.2873535156, y = 2202.8833007813, z = 78.766426086426 },
		{ x = 715.20159912109, y = 4175.521484375, z = 40.709232330322 },
		{ x = -1121.7340087891, y = 4926.3920898438, z = 218.64079284668 },
		{ x = 3322.4523925781, y = 5151.5615234375, z = 18.261245727539 },
		{ x = 2209.9099121094, y = 5597.0913085938, z = 53.871311187744 },
		{ x = 2684.3569335938, y = 1365.1351318359, z = 24.519201278687 },
		{ x = 1450.2357177734, y = 6547.1391601563, z = 15.213680267334 },
		{ x = -237.91500854492, y = 6598.34375, z = 7.5258054733276 },
		{ x = 497.82437133789, y = 5592.6508789063, z = 795.26770019531 },
		{ x = 2929.8669433594, y = 4586.4208984375, z = 48.890003204346 },
		{ x = -2305.4213867188, y = 417.84399414063, z = 174.46662902832 },
		{ x = 539.14556884766, y = -2279.0031738281, z = 5.9856915473938 },
		{ x = 1167.494140625, y = -3217.6416015625, z = 5.7997517585754 },
		{ x = -972.88031005859, y = -2238.6149902344, z = 8.8616981506348 },
		{ x = 390.38961791992, y = 2967.0288085938, z = 40.997524261475 },
		{ x = 2306.8295898438, y = 4780.7685546875, z = 37.462158203125 },
		{ x = 1936.9365234375, y = 594.42718505859, z = 175.8582611084 },
		{ x = -262.52056884766, y = 2623.5795898438, z = 62.265342712402 },
		{ x = 1578.1273193359, y = -1838.0938720703, z = 93.337890625 },
	},
	radius = 2.0,
	rewards = {
		beast = {
			landmark = { cash = 3000, exp = 1500 },
		},
		killer = { cash = 6000, exp = 3000 },
	},
}

-- AmmuNation weapons
Settings.ammuNationWeapons = {
	['Melee'] = {
		'WEAPON_KNIFE',
		'WEAPON_HAMMER',
		'WEAPON_SWITCHBLADE',
		'WEAPON_BAT',
		'WEAPON_POOLCUE',
		'WEAPON_MACHETE',
		'WEAPON_BATTLEAXE',
		'WEAPON_GOLFCLUB',
		'WEAPON_HATCHET',
		'WEAPON_CROWBAR',
		'WEAPON_KNUCKLE',
	},
	['Handguns'] = {
		'WEAPON_PISTOL',
		'WEAPON_COMBATPISTOL',
		'WEAPON_APPISTOL',
		'WEAPON_HEAVYPISTOL',
		'WEAPON_FLAREGUN',
		'WEAPON_STUNGUN',
		'WEAPON_PISTOL50',
		'WEAPON_DOUBLEACTION',
		'WEAPON_PISTOL_MK2',
	},
	['Shotguns'] = {
		'WEAPON_SAWNOFFSHOTGUN',
		'WEAPON_DBSHOTGUN',
		'WEAPON_PUMPSHOTGUN',
		'WEAPON_AUTOSHOTGUN',
		'WEAPON_ASSAULTSHOTGUN',
		'WEAPON_PUMPSHOTGUN_MK2',
	},
	['Submachine & Lightmachine Guns'] = {
		'WEAPON_MICROSMG',
		'WEAPON_SMG',
		'WEAPON_MACHINEPISTOL',
		'WEAPON_MG',
		'WEAPON_MINISMG',
		'WEAPON_COMBATMG',
		'WEAPON_SMG_MK2',
		'WEAPON_COMBATMG_MK2',
	},
	['Assault Rifles'] = {
		'WEAPON_ASSAULTRIFLE',
		'WEAPON_CARBINERIFLE',
		'WEAPON_SPECIALCARBINE',
		'WEAPON_BULLPUPRIFLE',
		'WEAPON_ADVANCEDRIFLE',
		'WEAPON_COMPACTRIFLE',
		'WEAPON_ASSAULTRIFLE_MK2',
		'WEAPON_CARBINERIFLE_MK2',
		'WEAPON_BULLPUPRIFLE_MK2',
		'WEAPON_SPECIALCARBINE_MK2',
	},
	['Sniper Rifles'] = {
		'WEAPON_SNIPERRIFLE',
		'WEAPON_HEAVYSNIPER',
		'WEAPON_HEAVYSNIPER_MK2',
	},
	['Thrown'] = {
		'WEAPON_SMOKEGRENADE',
		'WEAPON_GRENADE',
		'WEAPON_MOLOTOV',
		'WEAPON_STICKYBOMB',
		'WEAPON_PROXMINE',
	},
	['Special'] = {
		'WEAPON_FIREWORK',
	},
}

-- AmmuNation Refill Ammo
Settings.ammuNationRefillAmmo = {
	['Pistol Rounds'] = {
		weapons = {
			'WEAPON_PISTOL',
			'WEAPON_COMBATPISTOL',
			'WEAPON_APPISTOL',
			'WEAPON_HEAVYPISTOL',
			'WEAPON_PISTOL50',
			'WEAPON_DOUBLEACTION',
			'WEAPON_PISTOL_MK2',
		},
		ammo = 24,
		price = 0,
	},

	['Shotgun Shells'] = {
		weapons = {
			'WEAPON_ASSAULTSHOTGUN',
			'WEAPON_AUTOSHOTGUN',
			'WEAPON_DBSHOTGUN',
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_SAWNOFFSHOTGUN',
			'WEAPON_PUMPSHOTGUN_MK2',
		},
		ammo = 8,
		price = 54,
	},

	['SMG Rounds'] = {
		weapons = {
			'WEAPON_SMG',
			'WEAPON_MICROSMG',
			'WEAPON_MACHINEPISTOL',
			'WEAPON_MINISMG',
			'WEAPON_SMG_MK2',
		},
		ammo = 30,
		price = 169,
	},

	['MG Rounds'] = {
		weapons = {
			'WEAPON_COMBATMG',
			'WEAPON_MG',
			'WEAPON_COMBATMG_MK2',
		},
		ammo = 100,
		price = 345,
	},

	['Assault Rifle Rounds'] = {
		weapons = {
			'WEAPON_ASSAULTRIFLE',
			'WEAPON_CARBINERIFLE',
			'WEAPON_SPECIALCARBINE',
			'WEAPON_BULLPUPRIFLE',
			'WEAPON_ADVANCEDRIFLE',
			'WEAPON_COMPACTRIFLE',
			'WEAPON_ASSAULTRIFLE_MK2',
			'WEAPON_SPECIALCARBINE_MK2',
			'WEAPON_BULLPUPRIFLE_MK2',
			'WEAPON_CARBINERIFLE_MK2',
		},
		ammo = 60,
		price = 243,
	},

	['Sniper Rifle Rounds'] = {
		weapons = {
			'WEAPON_SNIPERRIFLE',
			'WEAPON_HEAVYSNIPER',
			'WEAPON_HEAVYSNIPER_MK2',
		},
		ammo = 20,
		price = 670,
	},

	['Tear Gas Units'] = {
		weapons = {
			'WEAPON_SMOKEGRENADE',
		},
		ammo = 1,
		price = 150,
	},

	['Grenade Units'] = {
		weapons = {
			'WEAPON_GRENADE',
		},
		ammo = 1,
		price = 300,
	},

	['Molotov Cocktail Units'] = {
		weapons = {
			'WEAPON_MOLOTOV',
		},
		ammo = 1,
		price = 200,
	},

	['Sticky Bomb Units'] = {
		weapons = {
			'WEAPON_STICKYBOMB',
		},
		ammo = 1,
		price = 400,
	},

	['Proximity Mine Units'] = {
		weapons = {
			'WEAPON_PROXMINE',
		},
		ammo = 1,
		price = 600,
	},

	['Flare Gun Rounds'] = {
		weapons = {
			'WEAPON_FLAREGUN',
		},
		ammo = 2,
		price = 150,
	},

	['Fireworks'] = {
		weapons = {
			'WEAPON_FIREWORK',
		},
		ammo = 2,
		price = 450,
	},
}

-- AmmuNation Special Weapons Ammo
Settings.ammuNationSpecialAmmo = {
	['WEAPON_GRENADELAUNCHER'] = {
		ammo = 1 * 2,
		price = 500,
		type = 'Grenades',
	},
	['WEAPON_RPG'] = {
		ammo = 1 * 2,
		price = 1000,
		type = 'Rockets',
	},
	['WEAPON_HOMINGLAUNCHER'] = {
		ammo = 1 * 2,
		price = 1500,
		type = 'Rockets',
	},
	['WEAPON_MINIGUN'] = {
		ammo = 1 * 150,
		price = 1000,
		type = 'Rounds',
	},
}

-- Garages
Settings.garages = {
	-- Low-end
	['bighorn'] = { name = '12 Little Bighorn Avenue', location = { x = 724.84875488281, y = -1193.2897949219, z = 24.279363632202 }, exportPos = { x = 745.16888427734, y = -1186.9566650391, z = 23.862798690796, heading = 179.29594421387 }, capacity = 2, price = 25000 },
	['popular'] = { name = 'Unit 124 Popular Street', location = { x = 850.49475097656, y = -1054.1494140625, z = 28.072996139526 }, exportPos = { x = 852.34204101562, y = -1067.7164306641, z = 27.638542175293, heading = 298.35974121094 }, capacity = 2, price = 25000 },
	['strawberry'] = { name = '1 Strawberry Ave', location = { x = -243.27192687988, y = 6236.60546875, z = 31.489896774292 }, exportPos = { x = -236.02571105957, y = 6251.2338867188, z = 31.074998855591, heading = 180.44511413574 }, capacity = 2, price = 26000 },
	['paleto'] = { name = '142 Paleto Boulevard', location = { x = -75.815055847168, y = 6425.3857421875, z = 31.490455627441 }, exportPos = { x = -85.855415344238, y = 6425.8515625, z = 31.076944351196, heading = 9.9898443222046 }, capacity = 2, price = 26500 },
	['grapeseed'] = { name = '1932 Grapeseed Ave', location = { x = 2552.7360839844, y = 4672.2963867188, z = 33.948055267334 }, exportPos = { x = 2539.9235839844, y = 4667.8383789062, z = 33.636329650879, heading = 316.12057495117 }, capacity = 2, price = 27500 },
	['route68'] = { name = '1200 Route 68', location = { x = 645.95910644531, y = 2792.4018554688, z = 41.934226989746 }, exportPos = { x = 640.73187255859, y = 2780.67578125, z = 41.566078186035, heading = 244.71063232422 }, capacity = 2, price = 28500 },
	['lowenstein'] = { name = '0754 Roy Lowenstein Boulevard', location = { x = 217.00907897949, y = 2605.5505371094, z = 46.025905609131 }, exportPos = { x = 225.76179504394, y = 2604.5578613281, z = 45.461112976074, heading = 11.545246124268 }, capacity = 2, price = 29500 },
	['ocean'] = { name = '2000 Great Ocean Highway', location = { x = -2214.7111816406, y = 4239.3349609375, z = 47.444316864014 }, exportPos = { x = -2224.400390625, y = 4231.4140625, z = 46.571208953857, heading = 338.03921508789 }, capacity = 2, price = 31500 },
	['senora'] = { name = '1920 Senora Way', location = { x = 2465.7077636719, y = 1589.3356933594, z = 32.720333099365 }, exportPos = { x = 2463.4279785156, y = 1599.1195068359, z = 32.30638885498, heading = 225.43823242188 }, capacity = 2, price = 32000 },
	['perro'] = { name = '634 Boulevard Del Perro', location = { x = -1243.2457275391, y = -257.56817626953, z = 38.988910675049 }, exportPos = { x = -1254.8660888672, y = -264.32922363281, z = 38.547180175781, heading = 299.79345703125 }, capacity = 2, price = 33500 },
	['mirror'] = { name = '0897 Mirror Park Boulevard', location = { x = 971.50524902344, y = -115.44449615479, z = 74.353134155273 }, exportPos = { x = 952.14764404297, y = -124.66337585449, z = 73.94783782959, heading = 227.5818939209 }, capacity = 2, price = 33500 },
	['innocence'] = { name = 'Garage Innocence Boulevard', location = { x = -338.61236572266, y = -1464.3701171875, z = 30.57995223999 }, exportPos = { x = -336.50442504883, y = -1495.2662353516, z = 30.211177825928, heading = 1.8535748720169 }, capacity = 2, price = 34000 },

	-- Medium
	['lowenstein2'] = { name = '0552 Roy Lowenstein Boulevard', location = { x = 501.50500488281, y = -1497.0181884766, z = 29.2887134552 }, exportPos = { x = 504.46109008789, y = -1521.4616699219, z = 28.671909332275, heading = 48.719287872314 }, capacity = 6, price = 80000 },
	['popular2'] = { name = 'Unit 14 Popular Street', location = { x = 892.61022949219, y = -887.27728271484, z = 26.992183685303 }, exportPos = { x = 861.90808105469, y = -885.46246337891, z = 24.955965042114, heading = 179.55696105957 }, capacity = 6, price = 77500 },
	['route682'] = { name = '8754 Route 68', location = { x = -1133.1859130859, y = 2696.2443847656, z = 18.800424575806 }, exportPos = { x = -1147.6901855469, y = 2681.1328125, z = 17.476257324219, heading = 259.07339477539 }, capacity = 6, price = 65000 },
}

-- Drug Business
Settings.drugBusiness = {
	types = {
		['weed'] = {
			name = 'Weed Farm',
			productName = 'Weed',
			price = {
				supply = 3240, -- 0.4 from default
				default = 8100,
				upgraded = 12150, -- 1.5 from default
			},
			time = {
				default = 126000,
				upgraded = 90000,
			},
		},
		['cocaine'] = {
			name = 'Cocaine Lockup',
			productName = 'Cocaine',
			price = {
				supply = 4320,
				default = 10800,
				upgraded = 16200,
			},
			time = {
				default = 168000,
				upgraded = 120000,
			},
		},
		['meth'] = {
			name = 'Meth Lab',
			productName = 'Meth',
			price = {
				supply = 6480,
				default = 16200,
				upgraded = 24300,
			},
			time = {
				default = 252000,
				upgraded = 180000,
			},
		},
	},

	limits = {
		stock = 10,
		supplies = 10,
	},

	businesses = {
		['weed_chianski'] = {
			type = 'weed',
			price = 715000,
			location = { x = 2856.5283203125, y = 4459.6982421875, z = 48.498035430908 },
			vehicleLocation = { x = 2870.0515136719, y = 4470.06640625, z = 48.200050354004, heading = 47.266815185547 },
		},
		['weed_chiliad'] = {
			type = 'weed',
			price = 805200,
			location = { x = 417.62976074219, y = 6520.7631835938, z = 27.717031478882 },
			vehicleLocation = { x = 435.55755615234, y = 6526.6489257812, z = 27.723098754883, heading = 40.130340576172 },
		},
		['weed_elysian'] = {
			type = 'weed',
			price = 1072500,
			location = { x = 137.66839599609, y = -2473.3046875, z = 5.9999890327454 },
			vehicleLocation = { x = 146.44578552246, y = -2476.8327636719, z = 5.7800230979919, heading = 169.13246154785 },
		},
		['weed_downtown'] = {
			type = 'weed',
			price = 1358500,
			location = { x = 163.40872192383, y = 151.35762023926, z = 105.17762756348 },
			vehicleLocation = { x = 144.10664367676, y = 151.73318481445, z = 104.39183807373, heading = 247.93951416016 },
		},
	},

	upgrades = {
		['security'] = {
			name = 'Security Upgrade',
			toolTip = 'Disable cops during Drug Export mission.',
			prices = {
				['weed'] = 627000,
				['cocaine'] = 1026000,
				['meth'] = 1140000,
			},
		},
		['staff'] = {
			name = 'Staff Upgrade',
			toolTip = 'Increase value of product.',
			prices = {
				['weed'] = 546000,
				['cocaine'] = 663000,
				['meth'] = 780000,
			},
		},
		['equip'] = {
			name = 'Equipment Upgrade',
			toolTip = 'Speed up production rate.',
			prices = {
				['weed'] = 935000,
				['cocaine'] = 990000,
				['meth'] = 1100000,
			},
		},
	},

	export = {
		missionName = 'Drug Export',
		time = 1200000,
		dropRadius = 10.,
		expRate = 0.15,
		locations = {
			{ x = -1055.5090332031, y = -2017.0299072266, z = 13.161571502686 },
			{ x = -306.30072021484, y = -2699.01953125, z = 6.0002951622009 },
			{ x = 264.00634765625, y = -3020.0100097656, z = 5.7394118309021 },
			{ x = 1006.5920410156, y = -2518.396484375, z = 28.303230285645 },
			{ x = 1564.9898681641, y = -2149.2104492188, z = 77.581161499023 },
			{ x = 1017.9209594727, y = -1861.7778320313, z = 30.889822006226 },
		},
		vehicles = {
			['weed'] = { `pony`, `pony2` },
			['cocaine'] = { `speedo`, `speedo2` },
			['meth'] = { `boxville`, `boxville2`, `boxville3`, `boxville4` },
		},
	},
}

-- Missions
Settings.mission = {
	resetTimeInterval = 900000,
	places = {
		{ x = -57.338516235352, y = -2448.7080078125, z = 7.2357640266418 },
		{ x = 1013.4348754883, y = -2150.8464355469, z = 31.533414840698 },
		{ x = 1213.0318603516, y = -1251.0944824219, z = 36.325752258301 },
		{ x = 707.24340820313, y = -966.26904296875, z = 30.412851333618 },
		{ x = 114.35282897949, y = -1961.0159912109, z = 21.334199905396 },
		{ x = -429.37182617188, y = -1727.9987792969, z = 19.783857345581 },
		{ x = -1320.5399169922, y = -1264.0423583984, z = 4.5883016586304 },
		{ x = -1747.4803466797, y = -394.7268371582, z = 43.688488006592 },
		{ x = -1274.0612792969, y = 315.11770629883, z = 65.511779785156 },
		{ x = -564.36932373047, y = 278.0114440918, z = 83.13631439209 },
		{ x = -288.54412841797, y = -710.89288330078, z = 33.493518829346 },
		{ x = 81.447616577148, y = 274.64431762695, z = 110.21018981934 },
		{ x = -1008.0339355469, y = -487.32397460938, z = 39.969467163086 },
		{ x = -66.46614074707, y = 490.74649047852, z = 144.69189453125 },
	},
}

-- Sightseer Mission
Settings.sightseer = {
	time = 1200000,
	count = 3,
	radius = 150.,
	reward = { cash = 8000, exp = 4000 },
	locations = {
		{
			pickup = { x = -599.75555419922, y = 2092.7365722656, z = 131.34963989258 },
			blip = { x = -608.19818115234, y = 2168.2839355469, z = 132.06150817871 },
		},

		{
			pickup = { x = -58.449527740479, y = 4415.794921875, z = 56.943382263184 },
			blip = { x = -102.0174331665, y = 4336.361328125, z = 64.431060791016 },
		},

		{
			pickup = { x = 171.10818481445, y = 6655.9453125, z = 31.263204574585 },
			blip = { x = 180.10113525391, y = 6603.1606445312, z = 31.868167877197 },
		},

		{
			pickup = { x = -1521.1121826172, y = 1492.6697998047, z = 111.58812713623 },
			blip = { x = -1463.5482177734, y = 1555.7222900391, z = 112.20551300049 },
		},

		{
			pickup = { x = -823.94573974609, y = -1222.0697021484, z = 7.3654088973999 },
			blip = { x = -770.58081054688, y = -1117.0239257812, z = 10.702531814575 },
		},

		{
			pickup = { x = -2012.4709472656, y = -237.6145324707, z = 24.230735778809 },
			blip = { x = -2042.6817626953, y = -323.37023925781, z = 24.190572738647 },
		},

		{
			pickup = { x = -175.30905151367, y = -633.02911376953, z = 48.982280731201 },
			blip = { x = -260.16171264648, y = -661.34729003906, z = 33.254501342773 },
		},

		{
			pickup = { x = -680.76568603516, y = 5799.2431640625, z = 17.330949783325 },
			blip = { x = -666.47509765625, y = 5724.1142578125, z = 24.474815368652 },
		},

		{
			pickup = { x = -2080.9743652344, y = 2608.7509765625, z = 3.0839750766754 },
			blip = { x = -1957.7847900391, y = 2537.9438476562, z = 2.7406125068665 },
		},

		{
			pickup = { x = 708.80535888672, y = -1256.3937988281, z = 26.15807723999 },
			blip = { x = 782.04046630859, y = -1200.8443603516, z = 27.151304244995 },
		},
	},
}

-- Survival Mission
Settings.survival = {
	waveInterval = 15000,
	radius = 200.,
	places = {
		['delPerroPier'] = {
			name = 'Del Perro Pier',
			position = { x = -1812.7276611328, y = -1200.2236328125, z = 13.017380714417 },
			spawnPoints = {
				{ x = -1792.1228027344, y = -1205.8507080078, z = 13.01727771759 },
				{ x = -1829.9234619141, y = -1249.4245605469, z = 13.017275810242 },
				{ x = -1843.1929931641, y = -1238.1595458984, z = 13.01727104187 },
				{ x = -1859.3570556641, y = -1198.33203125, z = 13.017113685608 },
				{ x = -1841.5341796875, y = -1174.2681884766, z = 13.017238616943 },
			},
			pedModels = { `s_m_m_fiboffice_01`, `s_m_m_fiboffice_02` },
		},

		['boneyard'] = {
			name = 'Boneyard',
			position = { x = 2398.6564941406, y = 3100.9060058594, z = 48.152835845947 },
			spawnPoints = {
				{ x = 2432.2937011719, y = 3103.146484375, z = 48.15311050415 },
				{ x = 2429.263671875, y = 3122.6384277344, z = 48.233783721924 },
				{ x = 2405.5139160156, y = 3136.4226074219, z = 48.153293609619 },
				{ x = 2373.4743652344, y = 3085.6376953125, z = 48.15306854248 },
				{ x = 2371.2937011719, y = 3047.7802734375, z = 48.152400970459 },
				{ x = 2396.5988769531, y = 3052.2856445312, z = 48.80778503418 },
			},
			pedModels = { `a_m_m_hillbilly_01` },
		},

		['industrialPlant'] = {
			name = 'Industrial Plant',
			position = { x = 290.63095092773, y = 2864.5021972656, z = 43.642414093018 },
			spawnPoints = {
				{ x = 393.7438659668, y = 2885.2692871094, z = 41.626586914062 },
				{ x = 399.55828857422, y = 2914.0847167969, z = 41.777881622314 },
				{ x = 301.61053466797, y = 2814.2705078125, z = 43.436069488525 },
				{ x = 281.68664550781, y = 2888.1027832031, z = 43.605697631836 },
			},
			pedModels = { `s_m_m_armoured_01`, `s_m_m_armoured_02`, `s_m_m_security_01` },
		},

		['processed'] = {
			name = 'Processed',
			position = { x = 1531.1279296875, y = -2131.9848632812, z = 76.903244018555 },
			spawnPoints = {
				{ x = 1556.4866943359, y = -2173.5100097656, z = 77.428253173828 },
				{ x = 1560.2288818359, y = -2069.5710449219, z = 77.08618927002 },
				{ x = 1501.3900146484, y = -2170.6591796875, z = 77.985824584961 },
				{ x = 1487.9365234375, y = -2152.4020996094, z = 76.963684082031 },
				{ x = 1494.2650146484, y = -2077.9951171875, z = 77.190147399902 },
			},
			pedModels = { `s_m_m_armoured_01`, `s_m_m_armoured_02`, `s_m_m_security_01` },
		},

		['railyard'] = {
			name = 'Railyard',
			position = { x = 1092.7104492188, y = -2295.0122070312, z = 30.121719360352 },
			spawnPoints = {
				{ x = 1074.1257324219, y = -2319.6306152344, z = 30.313261032104 },
				{ x = 1115.7362060547, y = -2316.4497070312, z = 30.565713882446 },
				{ x = 1142.7464599609, y = -2300.6674804688, z = 30.696245193481 },
				{ x = 1124.6759033203, y = -2243.6569824219, z = 30.317899703979 },
				{ x = 1099.3756103516, y = -2219.5349121094, z = 30.569871902466 },
			},
			pedModels = { `s_m_m_armoured_01`, `s_m_m_armoured_02`, `s_m_m_security_01` },
		},

		['sandy'] = {
			name = 'Sandy',
			position = { x = 1890.4010009766, y = 3784.640625, z = 32.797779083252 },
			spawnPoints = {
				{ x = 1853.3210449219, y = 3753.416015625, z = 33.14192199707 },
				{ x = 1838.4857177734, y = 3780.7014160156, z = 33.185558319092 },
				{ x = 1921.9552001953, y = 3735.2009277344, z = 32.701507568359 },
				{ x = 1928.3527832031, y = 3831.3879394531, z = 32.260299682617 },
			},
			pedModels = { `a_m_m_hillbilly_02` },
		},

		['farmhouse'] = {
			name = 'Farmhouse',
			position = { x = 2439.3093261719, y = 4970.5356445312, z = 46.825611114502 },
			spawnPoints = {
				{ x = 2412.2314453125, y = 5004.736328125, z = 46.619197845459 },
				{ x = 2425.2802734375, y = 5016.2529296875, z = 46.738616943359 },
				{ x = 2435.9274902344, y = 5013.0639648438, z = 46.890449523926 },
				{ x = 2494.0275878906, y = 4967.0395507812, z = 44.63484954834 },
				{ x = 2485.0385742188, y = 4957.9506835938, z = 44.899726867676 },
				{ x = 2432.5437011719, y = 4908.1303710938, z = 41.560020446777 },
			},
			pedModels = { `a_m_m_hillbilly_01`, `a_m_m_hillbilly_02` },
		},

		['humaneLabs'] = {
			name = 'Humane Labs And Research',
			position = { x = 3519.0922851562, y = 3675.5209960938, z = 33.888694763184 },
			spawnPoints = {
				{ x = 3501.73046875, y = 3647.1701660156, z = 41.34029006958 },
				{ x = 3558.8024902344, y = 3647.0881347656, z = 41.340343475342 },
				{ x = 3537.9184570312, y = 3626.435546875, z = 41.34033203125 },
				{ x = 3517.9624023438, y = 3629.8852539062, z = 41.340293884277 },
				{ x = 3477.5869140625, y = 3700.1665039062, z = 33.888427734375 },
				{ x = 3585.0666503906, y = 3690.2839355469, z = 40.808391571045 },
			},
			pedModels = { `s_m_m_chemsec_01`, `g_m_m_chemwork_01` },
		},
	},
	reward = {
		cash = 25000, exp = 15000,
		cashPerWave = 5000, expPerWave = 3000,
	},
	personalReward = { cash = 5000, exp = 1500 },
	recordReward = { cash = 15000, exp = 10000 },
}

-- Vehicle Import Mission
Settings.vehicleImport = {
	time = 1200000,
	minVehicleHealthRatio = 0.5,
	dropRadius = 10.,
	plates = {
		'PR0BOZ',
		'X4ND3R',
		'P4NP00L',
		'SW34TZ',
		'N3KR0Z',
		'R1PJH',
		'K3V1N',
		'PL3XT4Y',
		'URM3MK3K',
		'W4LT3R',
		'W4S1L',
		'T0KY0',
	},
	removedVehicles = {
		['fmj'] = 15000,
		['sheava'] = 15000,
		['jester'] =  10000,
		['jester2'] = 10000,
		['viseris'] = 15000,
		['xls2'] = 15000,
		['baller5'] = 15000,
		['schafter2'] = 15000,
		['cog552'] = 15000,
		['insurgent2'] = 15000,
		['nightshark'] = 15000,
		['insurgent'] = 15000,
		['kuruma2'] = 15000,
		['barrage'] = 15000,
		['jb700'] = 25000,
		['tezeract'] = 15000,
	},
	tiers = {
		{
			name = 'Low',
			price = 5000,
			models = {
				['sultan'] = { name = 'Karin Sultan' },
				['penumbra'] = { name = 'Maibatsu Penumbra' },
				['futo'] = { name = 'Karin Futo' },
				['buffalo'] = { name = 'Bravado Buffalo' },
				['buffalo2'] = { name = 'Bravado Buffalo S' },
				['schwarzer'] = { name = 'Benefactor Schwartzer' },
				['sentinel'] = { name = 'Ubermacht Sentinel XS' },
				['cogcabrio'] = { name = 'Enus Cognoscenti Cabrio' },
				['warrener'] = { name = 'Vulcan Warrener' },
				['windsor'] = { name = 'Enus Windsor' },
				['windsor2'] = { name = 'Enus Windsor Drop' },
				['fusilade'] = { name = 'Schyster Fusilade' },
				['blista2'] = { name = 'Dinka Blista Compact' },
				['blista3'] = { name = 'Dinka Blista GGM' },
				['ruiner'] = { name = 'Imponte Ruiner' },
				['vigero'] = { name = 'Declasse Vigero' },
				['phoenix'] = { name = 'Imponte Phoenix' },
				['tampa'] = { name = 'Declasse Tampa' },
				['nightshade'] = { name = 'Imponte Nightshade' },
				['tulip'] = { name = 'Declasse Tulip' },
				['ellie'] = { name = 'Vapid Ellie' },
				['hotknife'] = { name = 'Vapid Hotknife' },
				['savestra'] = { name = 'Annis Savestra' },
				['retinue'] = { name = 'Vapid Retinue' },
				['vamos'] = { name = 'Declasse Vamos' },
				['sabregt'] = { name = 'Declasse Sabre' },
				['brioso'] = { name = 'Brioso R/A' },
				['bifta'] = { name = 'BF Bifta' },
				['panto'] = { name = 'Benefactor Panto' },

				['hexer'] = { name = 'LCC Hexer', isBike = true },
				['bagger'] = { name = 'Western Bagger', isBike = true },
				['nemesis'] = { name = 'Principe Nemesis', isBike = true },
				['pcj'] = { name = 'Shitzu PCJ-600', isBike = true },
				['ruffian'] = { name = 'Pegassi Ruffian', isBike = true },
				['vader'] = { name = 'Shitzu Vader', isBike = true },
				['enduro'] = { name = 'Dinka Enduro', isBike = true },
				['manchez'] = { name = 'Maibatsu Manchez', isBike = true },
				['daemon'] = { name = 'Western Daemon', isBike = true },
				['sanchez'] = { name = 'Maibatsu Sanchez', isBike = true },
				['sanchez2'] = { name = 'Maibatsu Sanchez', isBike = true },
				['avarus'] = { name = 'LCC Avarus', isBike = true },
				['sovereign'] = { name = 'Western Sovereign', isBike = true },
			},
		},

		{
			name = 'Medium',
			price = 10000,
			models = {
				['banshee'] = { name = 'Bravado Banshee' },
				['comet2'] = { name = 'Pfister Comet' },
				['ninef'] = { name = 'Obey 9F' },
				['feltzer2'] = { name = 'Benefactor Feltzer' },
				['rapidgt'] = { name = 'Dewbauchee Rapid GT' },
				['coquette'] = { name = 'Invetero Coquette' },
				['massacro2'] = { name = 'Dewbauchee Massacro' },
				['massacro'] = { name = 'Dewbauchee Massacro' },
				['voltic'] = { name = 'Coil Voltic' },
				['ruston'] = { name = 'Hijak Ruston' },
				['lynx'] = { name = 'Ocelot Lynx' },
				['omnis'] = { name = 'Obey Omnis' },
				['tropos'] = { name = 'Lampadati Tropos Rallye' },
				['kuruma'] = { name = 'Karin Kuruma' },
				['gb200'] = { name = 'Vapid GB200' },
				['jester3'] = { name = 'Dinka Jester Classic' },
				['carbonizzare'] = { name = 'Grotti Carbonizzare' },
				['verlierer2'] = { name = 'Bravado Verlierer' },
				['elegy2'] = { name = 'Annis Elegy RH8' },
				['coquette2'] = { name = 'Coquette Classic' },
				['bestiagts'] = { name = 'Grotti Bestia GTS' },
				['elegy'] = { name = 'Annis Elegy RH5' },
				['flashgt'] = { name = 'Vapid Flash GT' },
				['sultanrs'] = { name = 'Karin Sultan RS' },
				['schlagen'] = { name = 'Schlagen GT' },
				['raiden'] = { name = 'Coil Raiden' },
				['sentinel3'] = { name = 'Sentinel Classic' },
				['deviant'] = { name = 'Schyster Deviant' },
				['hotring'] = { name = 'Hotring Sabre' },
				['z190'] = { name = 'Karin 190z' },
				['dominator3'] = { name = 'Dominator GTX' },
				['brawler'] = { name = 'Coil Brawler' },
				['yosemite'] = { name = 'Declasse Yosemite' },

				['akuma'] = { name = 'Dinka Akuma', isBike= true },
				['double'] = { name = 'Dinka Double T', isBike= true },
				['nightblade'] = { name = 'Western Nightblade', isBike= true },
				['esskey'] = { name = 'Pegassi Esskey', isBike= true },
				['daemon2'] = { name = 'Western Daemon', isBike= true },
				['diablous'] = { name = 'Principe Diabolus', isBike= true },
				['fcr'] = { name = 'Pegassi FCR1000', isBike= true },
				['thrust'] = { name = 'Dinka Thrust', isBike= true },
				['defiler'] = { name = 'Shitzu Defiler', isBike= true },
				['diablous2'] = { name = 'Principe Diabolus Custom', isBike= true },
				['vortex'] = { name = 'Pegassi Vortex', isBike= true },
				['zombiea'] = { name = 'Western Zombie Bobber', isBike= true },
				['zombieb'] = { name = 'Western Zombie Chopper', isBike= true },
				['blazer4'] = { name = 'Nagasaki Street Blazer', isBike = true },
				['raptor'] = { name = 'BF Raptor', isBike = true },
			},
		},

		{
			name = 'High',
			price = 15000,
			models = {
				['italigto'] = { name = 'Itali GTO' },
				['italigtb'] = { name = 'Itali GTB' },
				['italigtb2'] = { name = 'Itali GTB' },
				['cheetah'] = { name = 'Grotti Cheetah' },
				['osiris'] = { name = 'Pegassi Osiris' },
				['penetrator'] = { name = 'Ocelot Penetrator' },
				['adder'] = { name = 'Truffade Adder' },
				['tempesta'] = { name = 'Pegassi Tempesta' },
				['comet3'] = { name = 'Comet Retro' },
				['banshee2'] = { name = 'Bravado Banshee 900R' },
				['seven70'] = { name = 'Dewbauchee Seven70' },
				['specter2'] = { name = 'Dewbauchee Specter' },
				['comet5'] = { name = 'Pfister Comet SR' },
				['turismor'] = { name = 'Grotti Turismo R' },
				['nero'] = { name = 'Truffade Nero' },
				['nero2'] = { name = 'Truffade Nero' },
				['pariah'] = { name = 'Ocelot Pariah' },
				['toros'] = { name = 'Pegassi Toros' },
				['cyclone'] = { name = 'Coil Cyclone' },
				['turismo2'] = { name = 'Turismo Classic' },
				['neon'] = { name = 'Pfister Neon' },
				['t20'] = { name = 'Progen T20' },
				['xa21'] = { name = 'Ocelot XA-21' },
				['gp1'] = { name = 'Progen GP1' },

				['bati'] = { name = 'Pegassi Bati 801', isBike = true },
				['bati2'] = { name = 'Pegassi Bati 801RR', isBike = true },
				['hakuchou'] = { name = 'Shitzu Hakuchou', isBike = true },
				['hakuchou2'] = { name = 'Shitzu Hakuchou Drag', isBike = true },
				['carbonrs'] = { name = 'Nagasaki Carbon RS', isBike = true },
				['chimera'] = { name = 'Nagasaki Chimera', isBike = true },
				['bf400'] = { name = 'Nagasaki BF400', isBike = true },
				['gargoyle'] = { name = 'Western Gargoyle', isBike = true },
				['cliffhanger'] = { name = 'Western Cliffhanger', isBike = true },
				['fcr2'] = { name = 'Pegassi FCR1000 Custom', isBike = true },
			},
		},

		{
			name = 'Classic',
			price = 50000,
			isMaxedOut = true,
			models = {
				['casco'] = { name = 'Lampadati Casco' },
				['cheburek'] = { name = 'RUNE Cheburek' },
				['btype2'] = { name = 'Albany Fränken Stange' },
				['gt500'] = { name = 'Grotti GT500' },
				['mamba'] = { name = 'Mamba' },
				['michelli'] = { name = 'Lampadati Michelli GT' },
				['btype3'] = { name = 'Albany Roosevelt Valor' },
				['stinger'] = { name = 'Stinger' },
				['stingergt'] = { name = 'Grotti Stinger GT' },
				['feltzer3'] = { name = 'Benefactor Stirling GT' },
				['swinger'] = { name = 'Ocelot Swinger' },
				['tornado6'] = { name = 'Tornado Rat Rod' },
				['ztype'] = { name = 'Z-Type' },
				['lurcher'] = { name = 'Albany Lurcher' },
			},
		},

		{
			name = 'Prestige',
			price = 100000,
			models = {
				['ardent'] = { name = 'Ocelot Ardent', prestige = 1 },
				['voltic2'] = { name = 'Coil Rocket Voltic', prestige = 2 },
				['shotaro'] = { name = 'Nagasaki Shotaro', prestige = 3, isBike = true },
				['dune3'] = { name = 'Dune FAV', prestige = 4 },
				['dune4'] = { name = 'BF Ramp Buggy', prestige = 5 },
				['boxville5'] = { name = 'Armored Boxville', prestige = 6 },
				['thruster'] = { name = 'Mammoth Thruster', prestige = 7 },
				['vigilante'] = { name = 'Grotti Vigilante', prestige = 8 },
				['phantom2'] = { name = 'Jobuilt Phantom Wedge', prestige = 9 },
				['oppressor'] = { name = 'Pegassi Oppressor', prestige = 10, isBike = true },
			},
		},
	},
	locations = {
		{ x = -1938.2440185547, y = 402.90350341797, z = 95.804191589355, heading = 279.82733154297 },
		{ x = -1940.8181152344, y = 561.69274902344, z = 114.58443450928, heading = 69.090827941895 },
		{ x = -1862.1116943359, y = -352.08901977539, z = 48.557804107666, heading = 50.154594421387 },
		{ x = -3015.7021484375, y = 84.825881958008, z = 10.905931472778, heading = 263.38137817383 },
		{ x = 135.2931060791, y = -1050.8511962891, z = 28.453567504883, heading = 160.54795837402 },
		{ x = 174.56343078613, y = 472.45803833008, z = 141.20491027832, heading = 349.80267333984 },
		{ x = -72.57266998291, y = 356.68804931641, z = 111.74195861816, heading = 243.80653381348 },
		{ x = -52.963829040527, y = 1949.6928710938, z = 189.48358154297, heading = 28.739295959473 },
		{ x = 1384.1202392578, y = -600.91546630859, z = 73.635711669922, heading = 53.564197540283 },
		{ x = -927.52117919922, y = 12.484411239624, z = 47.025131225586, heading = 214.92706298828 },
		{ x = -910.30535888672, y = -1294.3614501953, z = 4.313506603241, heading = 21.569423675537 },
		{ x = 260.06396484375, y = 2578.7683105469, z = 44.404975891113, heading = 97.479026794434 },
		{ x = -767.45104980469, y = 666.22344970703, z = 144.15422058105, heading = 286.42398071289 },
		{ x = -2995.8610839844, y = 721.37957763672, z = 27.794134140015, heading = 112.10511779785 },
		{ x = -448.33157348633, y = 371.36795043945, z = 104.07223510742, heading = 91.293769836426 },
		{ x = 2395.6669921875, y = 3324.3173828125, z = 46.956871032715, heading = 252.67266845703 },
		{ x = 872.00415039062, y = -178.13139343262, z = 75.468406677246, heading = 150.06623840332 },
		{ x = 1905.6434326172, y = 564.49908447266, z = 175.45648193359, heading = 241.69448852539 },
	},
}

-- Time Trials
-- Checkpoint types: 15 - 19
Settings.timeTrial = {
	tracks = {
		['armsRace'] = {
			name = 'Arms Race',
			position = { x = -2522.0732421875, y = 3259.833984375, z = 32.20064163208, heading = 240.08741760254 },
			checkpoints = {
				{ type = 15, x = -2293.9926757812, y = 3136.9899902344, z = 32.197498321533 },
				{ type = 15, x = -2118.8654785156, y = 3075.6335449219, z = 32.192966461182 },
				{ type = 16, x = -1922.9372558594, y = 2947.8576660156, z = 32.193450927734 },
				{ type = 16, x = -1969.5397949219, y = 2858.5942382812, z = 32.194000244141 },
				{ type = 15, x = -2235.6137695312, y = 2991.0412597656, z = 32.194049835205 },
				{ type = 15, x = -2520.5336914062, y = 3153.2783203125, z = 32.20491027832 },
				{ type = 17, x = -2681.189453125, y = 3306.2021484375, z = 32.194755554199 },
				{ x = -2522.0732421875, y = 3259.833984375, z = 32.20064163208 },
			},
			time = { 60000, 90000, 120000 },
		},

		['beforeItWasCool'] = {
			name = 'Before It Was Cool',
			position = { x = 1018.3796386719, y = -320.44540405273, z = 66.615844726562, heading = 239.63208007812 },
			checkpoints = {
				{ type = 16, x = 1080.8134765625, y = -368.98950195312, z = 66.613090515137 },
				{ type = 15, x = 1074.89453125, y = -469.58288574219, z = 64.038146972656 },
				{ type = 15, x = 1029.0557861328, y = -536.35174560547, z = 60.056392669678 },
				{ type = 15, x = 1013.7613525391, y = -642.16619873047, z = 57.92378616333 },
				{ type = 16, x = 981.78332519531, y = -669.24670410156, z = 56.916038513184 },
				{ type = 15, x = 1012.2538452148, y = -719.20123291016, z = 56.998394012451 },
				{ type = 15, x = 1064.2263183594, y = -758.73791503906, z = 57.143306732178 },
				{ type = 16, x = 1230.8063964844, y = -757.25354003906, z = 59.180850982666 },
				{ type = 16, x = 1278.8022460938, y = -716.68206787109, z = 64.196258544922 },
				{ type = 15, x = 1256.9763183594, y = -546.71282958984, z = 68.397109985352 },
				{ type = 16, x = 1187.6148681641, y = -509.66622924805, z = 64.423789978027 },
				{ type = 15, x = 1215.9748535156, y = -375.8801574707, z = 68.235816955566 },
				{ type = 16, x = 1210.9996337891, y = -299.63659667969, z = 68.55207824707 },
				{ type = 15, x = 1146.3439941406, y = -243.97428894043, z = 68.539520263672 },
				{ type = 16, x = 1015.2677001953, y = -211.1280670166, z = 69.63655090332 },
				{ type = 16, x = 970.42694091797, y = -287.25823974609, z = 66.403961181641 },
				{ x = 1018.3796386719, y = -320.44540405273, z = 66.615844726562 },
			},
			time = { 60000, 90000, 120000 },
		},

		['dippingIn'] = {
			name = 'Dipping In',
			position = { x = 891.80639648438, y = 291.97918701172, z = 86.505249023438, heading = 137.16096496582 },
			checkpoints = {
				{ type = 15, x = 654.75317382812, y = -31.838098526001, z = 80.373840332031 },
				{ type = 16, x = 498.89947509766, y = -153.5708770752, z = 55.768962860107 },
				{ type = 15, x = 372.53652954102, y = -118.31114959717, z = 64.795532226562 },
				{ type = 16, x = 126.31434631348, y = -24.060775756836, z = 67.042747497559 },
				{ type = 15, x = 194.02555847168, y = 167.73774719238, z = 104.80919647217 },
				{ type = 16, x = 267.45886230469, y = 383.28604125976, z = 108.56525421143 },
				{ type = 16, x = 239.7067565918, y = 446.12487792969, z = 120.80999755859 },
				{ type = 15, x = 267.84518432617, y = 541.80841064453, z = 140.57237243652 },
				{ type = 15, x = 274.15560913086, y = 624.56597900391, z = 154.73802185058 },
				{ type = 15, x = 290.28268432617, y = 769.42742919922, z = 184.05250549316 },
				{ type = 15, x = 287.67727661133, y = 852.30908203125, z = 193.41627502441 },
				{ type = 15, x = 316.75845336914, y = 969.74761962891, z = 209.15251159668 },
				{ type = 15, x = 321.56875610352, y = 1044.31640625, z = 210.63488769531 },
				{ type = 15, x = 262.97964477539, y = 1175.3020019531, z = 224.51382446289 },
				{ type = 15, x = 225.98330688476, y = 1391.9118652344, z = 239.18594360352 },
				{ type = 15, x = 146.67158508301, y = 1505.8950195312, z = 237.77207946777 },
				{ type = 16, x = 137.74389648438, y = 1653.8446044922, z = 228.26490783691 },
				{ type = 16, x = 15.254334449768, y = 1733.0382080078, z = 221.45399475098 },
				{ type = 16, x = -33.632995605469, y = 1840.5479736328, z = 202.94569396973 },
				{ type = 16, x = -147.47285461426, y = 1869.7644042969, z = 197.57453918457 },
				{ type = 16, x = -164.08087158203, y = 1935.8997802734, z = 195.62405395508 },
				{ type = 15, x = -50.771682739258, y = 2007.1220703125, z = 176.31939697266 },
				{ type = 15, x = 89.707061767578, y = 2093.2529296875, z = 143.73143005371 },
				{ type = 15, x = 377.51220703125, y = 2096.7602539062, z = 96.874732971191 },
				{ type = 15, x = 560.69384765625, y = 2181.3933105469, z = 73.291717529297 },
				{ type = 15, x = 715.16967773438, y = 2192.6906738281, z = 58.078174591064 },
				{ type = 16, x = 874.44171142578, y = 2227.9926757812, z = 47.914485931396 },
				{ type = 15, x = 986.95935058594, y = 2146.6848144531, z = 48.185779571533 },
				{ type = 15, x = 1100.287109375, y = 1960.2211914062, z = 57.672485351562 },
				{ type = 15, x = 1163.3353271484, y = 1809.9996337891, z = 73.518295288086 },
				{ type = 15, x = 1250.1497802734, y = 1696.8708496094, z = 82.836463928223 },
				{ type = 15, x = 1293.2171630859, y = 1517.4437255859, z = 96.901176452637 },
				{ type = 15, x = 1293.7106933594, y = 1233.2443847656, z = 107.68949890137 },
				{ type = 15, x = 1302.7578125, y = 955.57946777344, z = 105.28889465332 },
				{ type = 15, x = 1211.5344238281, y = 663.72729492188, z = 99.302307128906 },
				{ type = 15, x = 1010.2782592773, y = 472.65078735352, z = 95.80534362793 },
				{ x = 891.80639648438, y = 291.97918701172, z = 86.505249023438 },
			},
			time = { 150000, 180000, 210000 },
		},

		['downtownUnderground'] = {
			name = 'Downtown Underground',
			position = { x = -96.678184509277, y = -625.59497070312, z = 35.650379180908, heading = 162.05853271484 },
			checkpoints = {
				{ type = 15, x = -159.29318237305, y = -805.36761474609, z = 31.025585174561 },
				{ type = 16, x = -283.03451538086, y = -1132.2974853516, z = 22.385681152344 },
				{ type = 15, x = -373.32470703125, y = -1126.8551025391, z = 28.77220916748 },
				{ type = 16, x = -529.48315429688, y = -1065.9471435547, z = 21.877658843994 },
				{ type = 15, x = -532.03479003906, y = -946.62420654297, z = 22.966423034668 },
				{ type = 15, x = -499.19921875, y = -804.86865234375, z = 29.925168991089 },
				{ type = 17, x = -542.98687744141, y = -670.216796875, z = 32.612251281738 },
				{ type = 15, x = -453.05648803711, y = -661.84893798828, z = 31.361246109009 },
				{ type = 15, x = -287.63537597656, y = -661.58367919922, z = 32.591289520264 },
				{ type = 15, x = -98.775382995605, y = -724.49938964844, z = 43.446018218994 },
				{ type = 15, x = 5.2460551261902, y = -765.21112060547, z = 43.614719390869 },
				{ type = 15, x = 217.47831726074, y = -841.42681884766, z = 29.797044754028 },
				{ type = 16, x = 376.02728271484, y = -852.11352539062, z = 28.678035736084 },
				{ type = 16, x = 417.62301635742, y = -825.40118408203, z = 28.652936935425 },
				{ type = 16, x = 491.54058837891, y = -824.34979248047, z = 24.255912780762 },
				{ type = 16, x = 503.03881835938, y = -695.02471923828, z = 24.395765304565 },
				{ type = 15, x = 334.40478515625, y = -660.09948730469, z = 28.65025138855 },
				{ type = 15, x = 66.917991638184, y = -554.47094726562, z = 32.517654418945 },
				{ type = 16, x = -61.810863494873, y = -551.70281982422, z = 39.167121887207 },
				{ x = -96.678184509277, y = -625.59497070312, z = 35.650379180908 },
			},
			time = { 90000, 120000, 150000 },
		},

		['dockyard'] = {
			name = 'Dockyard',
			position = { x = 727.67541503906, y = -2827.5346679688, z = 5.6210932731628, heading = 181.8705291748 },
			checkpoints = {
				{ type = 15, x = 713.61206054688, y = -3145.1501464844, z = 18.258142471313 },
				{ type = 16, x = 758.35626220703, y = -3304.6169433594, z = 17.447574615479 },
				{ type = 15, x = 934.24945068359, y = -3326.7683105469, z = 6.6895227432251 },
				{ type = 15, x = 1052.4674072266, y = -3329.7736816406, z = 5.2979621887207 },
				{ type = 15, x = 1159.4051513672, y = -3330.5495605469, z = 5.2866349220276 },
				{ type = 16, x = 1249.5373535156, y = -3334.4262695312, z = 5.2106447219849 },
				{ type = 15, x = 1256.2469482422, y = -3217.0700683594, z = 5.1828451156616 },
				{ type = 16, x = 1252.4904785156, y = -3098.3813476562, z = 5.184844493866 },
				{ type = 15, x = 1213.4049072266, y = -3090.1196289062, z = 5.1844143867493 },
				{ type = 15, x = 1160.3442382812, y = -3112.4106445312, z = 5.1922655105591 },
				{ type = 16, x = 1086.3358154297, y = -3108.5688476562, z = 5.2793159484863 },
				{ type = 16, x = 1071.4217529297, y = -2961.3278808594, z = 5.2833557128906 },
				{ type = 16, x = 985.63775634766, y = -2961.4733886719, z = 5.2770366668701 },
				{ type = 16, x = 973.97314453125, y = -3109.4250488281, z = 5.2837500572205 },
				{ type = 15, x = 871.20745849609, y = -3128.6833496094, z = 5.2828459739685 },
				{ type = 16, x = 784.99047851562, y = -3112.9401855469, z = 5.2584409713745 },
				{ type = 15, x = 780.17266845703, y = -3038.3603515625, z = 5.183967590332 },
				{ type = 15, x = 742.54974365234, y = -2973.1518554688, z = 5.1825556755066 },
				{ type = 16, x = 736.67950439453, y = -2821.2990722656, z = 5.6480441093445 },
				{ type = 15, x = 672.48449707031, y = -2769.0578613281, z = 5.4683032035828 },
				{ type = 15, x = 631.93853759766, y = -2668.1000976562, z = 5.4826531410217 },
				{ type = 15, x = 581.67309570312, y = -2584.4099121094, z = 5.4817662239075 },
				{ type = 16, x = 446.07388305664, y = -2483.16796875, z = 6.5791025161743 },
				{ type = 16, x = 452.92776489258, y = -2414.7299804688, z = 10.862649917603 },
				{ type = 15, x = 514.90759277344, y = -2426.1520996094, z = 13.598086357117 },
				{ type = 15, x = 600.60498046875, y = -2493.5205078125, z = 16.186182022095 },
				{ type = 16, x = 676.31939697266, y = -2506.7395019531, z = 19.215810775757 },
				{ type = 15, x = 725.95513916016, y = -2584.9577636719, z = 18.050830841064 },
				{ x = 727.67541503906, y = -2827.5346679688, z = 5.6210932731628 },
			},
			time = { 90000, 120000, 150000 },
		},

		['stadiumTour'] = {
			name = 'Stadium Tour',
			position = { x = -1000.4892578125, y = -2489.0034179688, z = 13.277319908142, heading = 148.05418395996 },
			checkpoints = {
				{ type = 16, x = -1078.4425048828, y = -2640.8537597656, z = 13.268272399902 },
				{ type = 16, x = -966.24163818359, y = -2730.697265625, z = 13.274431228638 },
				{ type = 15, x = -890.23492431641, y = -2656.4919433594, z = 13.282737731934 },
				{ type = 16, x = -808.14849853516, y = -2474.7895507812, z = 13.235064506531 },
				{ type = 15, x = -849.80059814453, y = -2349.4499511719, z = 17.222919464111 },
				{ type = 15, x = -782.46649169922, y = -2218.5656738281, z = 16.329990386963 },
				{ type = 15, x = -686.11462402344, y = -2127.5483398438, z = 13.141528129578 },
				{ type = 15, x = -562.87750244141, y = -2083.7028808594, z = 26.835748672485 },
				{ type = 15, x = -397.70880126953, y = -2097.1528320312, z = 25.726655960083 },
				{ type = 15, x = -241.35520935058, y = -2130.9296875, z = 22.078144073486 },
				{ type = 15, x = -132.4427947998, y = -2091.0495605469, z = 25.245357513428 },
				{ type = 15, x = 13.099464416504, y = -2045.9080810547, z = 17.850582122803 },
				{ type = 16, x = 237.63961791992, y = -2063.21484375, z = 17.151449203491 },
				{ type = 15, x = 341.55770874023, y = -1948.7133789062, z = 24.002775192261 },
				{ type = 16, x = 459.5270690918, y = -1830.9146728516, z = 27.353366851807 },
				{ type = 15, x = 351.19741821289, y = -1731.5997314453, z = 28.890005111694 },
				{ type = 16, x = 184.91226196289, y = -1598.8775634766, z = 28.761892318726 },
				{ type = 15, x = 29.762624740601, y = -1683.4666748047, z = 28.82054901123 },
				{ type = 15, x = -245.60266113281, y = -1821.5751953125, z = 28.970197677612 },
				{ type = 15, x = -410.17636108398, y = -1838.8128662109, z = 20.048416137695 },
				{ type = 15, x = -493.65414428711, y = -1897.5913085938, z = 16.880882263184 },
				{ type = 15, x = -651.94427490234, y = -2054.1015625, z = 15.567202568054 },
				{ type = 15, x = -813.06829833984, y = -2230.5539550781, z = 16.780836105347 },
				{ type = 15, x = -887.28924560547, y = -2345.0642089844, z = 14.286392211914 },
				{ type = 15, x = -955.64813232422, y = -2409.9240722656, z = 13.283555030823 },
				{ x = -1000.4892578125, y = -2489.0034179688, z = 13.277319908142 },
			},
			time = { 90000, 120000, 150000 },
		},
	},
	reward = {
		{ cash = 7500, exp = 2500 },
		{ cash = 5000, exp = 1500 },
		{ cash = 2500, exp = 1000 },
	},
	personalReward = { cash = 5000, exp = 1500 },
	recordReward = { cash = 15000, exp = 10000, timeout = 900000 },
}

-- Vehicle Export Mission
Settings.vehicleExport = {
	missionName = 'Vehicle Export',
	time = 1200000,
	dropRadius = 10.,
	rewards = {
		['Low'] = { cash = 20000, exp = 13000 },
		['Medium'] = { cash = 30000, exp = 14000 },
		['High'] = { cash = 40000, exp = 15000 },
		['Classic'] = { cash = 75000, exp = 15000 },
		['Prestige'] = { cash = 125000, exp = 15000 },
	},
	locations = {
		-- Private
		{ x = 165.53135681152, y = 2284.5539550781, z = 92.904891967773 },
		{ x = -1083.3449707031, y = -498.56158447266, z = 35.779449462891 },
		{ x = 1573.0148925781, y = 6461.9770507812, z = 24.112468719482 },
		{ x = 2879.1704101562, y = 4486.150390625, z = 47.701683044434 },
		{ x = 1188.5020751953, y = -2997.0634765625, z = 5.2410130500793 },

		-- Showroom
		{ x = 2521.697265625, y = 4113.1098632812, z = 37.969318389893 },
		{ x = -358.03729248047, y = 6068.3051757812, z = 30.838945388794 },
		{ x = 2545.2973632812, y = 2581.4235839844, z = 37.283535003662 },
		{ x = -45.197551727295, y = -1080.7131347656, z = 26.025236129761 },
		{ x = 386.3576965332, y = 3589.7578125, z = 32.631248474121 },
		{ x = -66.830711364746, y = 81.486366271973, z = 70.894477844238 },
		{ x = -806.30999755859, y = -189.03382873535, z = 36.700801849365 },

		-- Dealer
		{ x = -1614.9732666016, y = 16.929958343506, z = 61.516792297363 },
		{ x = -2596.6247558594, y = 1929.9840087891, z = 166.64462280273 },
		{ x = -1910.4896240234, y = 2085.4470214844, z = 139.72282409668 },
		{ x = -3102.4963378906, y = 716.99108886719, z = 19.842819213867 },
		{ x = 1407.4151611328, y = 1116.8214111328, z = 114.17623901367 },
		{ x = -72.888473510742, y = 900.69403076172, z = 234.94180297852 },
		{ x = 216.56733703613, y = 757.58081054688, z = 204.0071105957 },
		{ x = -1788.8603515625, y = 456.27008056641, z = 127.64682006836 },
	},
}

-- Heist Mission
Settings.heist = {
	time = 900000,
	places = {
		{ x = 27.179788589478, y = -1340.0749511719, z = 29.497024536133 },
		{ x = -42.322410583496, y = -1749.1009521484, z = 29.421016693115 },
		{ x = -708.58825683594, y = -904.11706542969, z = 19.215591430664 },
		{ x = -1219.4338378906, y = -916.10382080078, z = 11.326217651367 },
		{ x = -1479.5504150391, y = -373.80960083008, z = 39.163394927979 },
		{ x = 377.10794067383, y = 332.92077636719, z = 103.56636810303 },
		{ x = 1160.6029052734, y = -314.04550170898, z = 69.205139160156 },
		{ x = 1126.3829345703, y = -981.70190429688, z = 45.415824890137 },
		{ x = -1828.1215820313, y = 799.11328125, z = 138.17001342773 },
		{ x = -2958.9916992188, y = 388.09457397461, z = 14.04315662384 },
	},
	radius = 15.,
	take = {
		interval = 3000,
		rate = {
			cash = { min = 250, max = 500, limit = 25000 },
			exp = 0.6,
		},
	},
}

-- Velocity Mission
Settings.velocity = {
	enterVehicleTime = 900000,
	preparationTime = 10000,
	driveTime = 300000,
	detonationTime = 5000,
	locations = {
		{ x = -344.57684326172, y = -932.30975341797, z = 30.422277450562, heading = 69.093620300293 },
		{ x = 850.43420410156, y = -1840.5521240234, z = 28.406866073608, heading = 86.003051757813 },
		{ x = 948.42572021484, y = 163.06883239746, z = 80.172180175781, heading = 260.31057739258 },
		{ x = -1330.0638427734, y = -228.81066894531, z = 42.231548309326, heading = 306.03131103516 },
		{ x = -1215.8439941406, y = -1346.943359375, z = 3.6422889232635, heading = 293.01425170898 },
	},
	minSpeed = 26.8225,
	rewards = {
		cash = { min = 15000, max = 25000, perAboutToDetonate = 1000 },
		exp = { min = 13000, max = 15000, perAboutToDetonate = 200 },
	},
}

-- Most Wanted Mission
Settings.mostWanted = {
	time = 480000,
	rewards = {
		maxCash = 25000,
		maxExp = 15000,
	},
}

-- Asset Recovery Mission
Settings.assetRecovery = {
	time = 1200000,
	nearDistance = 2000.,
	vehicles = {
		`pigalle`,
		`dominator`,
		`comet2`,
		`feltzer3`,
		`blazer`,
	},
	variants = {
		{
			vehicleLocation = { x = -1041.6690673828, y = -850.52899169922, z = 4.7838535308838, heading = 135.58250427246 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicleLocation = { x = 454.39685058594, y = -1024.5531005859, z = 28.112592697144, heading = 92.917694091797 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicleLocation = { x = 852.61529541016, y = -1280.2347412109, z = 26.133306503296, heading = 359.4150390625 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicleLocation = { x = 468.05123901367, y = -65.828109741211, z = 77.158767700195, heading = 238.4743347168 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicleLocation = { x = 1866.5213623047, y = 3699.1994628906, z = 32.8317527771, heading = 210.75952148438 },
			dropOffLocation = { x = 165.90403747559, y = -3081.7749023438, z = 5.5951142311096, heading = 270.91390991211 },
		},
	},
	dropRadius = 10.,
	rewards = {
		cash = { min = 15000, max = 25000 },
		exp = { min = 13000, max = 15000 },
	},
}


-- Headhunter Mission
Settings.headhunter = {
	minTargetCount = 4,
	locations = {
		{ x = -40.054077148438, y = -2701.1606445312, z = 6.1575679779053 },
		{ x = 877.66772460938, y = -2184.248046875, z = 30.519348144531 },
		{ x = -516.50421142578, y = -1712.9973144531, z = 19.319555282593 },
		{ x = -1631.5915527344, y = -1095.9350585938, z = 13.024022102356 },
		{ x = 898.22930908203, y = -1055.4468994141, z = 32.827968597412 },
		{ x = -1228.4931640625, y = -188.05059814453, z = 39.194133758545 },
		{ x = 1100.2220458984, y = -418.21313476562, z = 67.154083251953 },
		{ x = -91.623016357422, y = 836.25329589844, z = 235.72288513184 },
		{ x = -943.87762451172, y = -2121.0480957031, z = 8.6375122070312, heading = 226.78311157226, inVehicle = true },
		{ x = 198.6376953125, y = -1557.1477050781, z = 28.592624664307, heading = 213.32002258301, inVehicle = true },
		{ x = 451.47131347656, y = -934.67437744141, z = 27.890367507935, heading = 179.75053405762, inVehicle = true },
		{ x = 286.20751953125, y = -11.332187652588, z = 76.810470581055, heading = 248.71377563476, inVehicle = true },
		{ x = -722.82861328125, y = 30.727191925049, z = 41.764114379883, heading = 103.85273742676, inVehicle = true },
		{ x = -1357.8287353516, y = -667.52966308594, z = 25.308952331543, heading = 211.10328674316, inVehicle = true },
	},
	models = { `g_m_m_armboss_01`, `u_m_m_filmdirector`, `s_m_m_highsec_01` },
	weapons = {
		`WEAPON_SPECIALCARBINE`,
		`WEAPON_ADVANCEDRIFLE`,
		`WEAPON_AUTOSHOTGUN`,
		`WEAPON_MINISMG`,
		`WEAPON_RPG`,
	},
	vehicles = { `baller5`, `cog552` },
	reward = { cash = 6000, exp = 3750 },
	rewardMultiplier = 0.25,
}

-- Crates
Settings.crate = {
	cash = 15000,
	nthRank = 10,
	reward = {
		exp = 5000,
		cash = 10000,
	},
	radius = 200.,
	weapons = {
		{ id = 'WEAPON_GRENADELAUNCHER', name = 'Grenade Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_RPG', name = 'Rocket Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_MINIGUN', name = 'Minigun', ammo = 1 * 500 },
		{ id = 'WEAPON_PISTOL50', name = 'Pistol .50', ammo = 9 * 3 },
		{ id = 'WEAPON_DOUBLEACTION', name = 'Double-Action Revolver', ammo = 6 * 4 },
		{ id = 'WEAPON_HOMINGLAUNCHER', name = 'Homing Launcher', ammo = 1 * 8 },
		{ id = 'WEAPON_HEAVYSNIPER', name = 'Heavy Sniper', ammo = 12 * 2 },
	},
	locations = {
		{
			blip = { x = 699.15850830078, y = -1594.9453125, z = 9.6801643371582 },
			positions = {
				{ x = 770.97814941406, y = -1636.8605957031, z = 32.921447753906 },
				{ x = 692.00866699219, y = -1555.2824707031, z = 9.7086277008057 },
				{ x = 563.47967529297, y = -1600.3996582031, z = 27.944440841675 },
			},
		},
		{
			blip = { x = 1436.9431152344, y = -2148.8503417969, z = 60.606800079346 },
			positions = {
				{ x = 1563.8139648438, y = -2166.4467773438, z = 77.514312744141 },
				{ x = 1359.4295654297, y = -2096.6870117188, z = 51.998519897461 },
				{ x = 1392.5572509766, y = -2226.4516601563, z = 61.233791351318 },
			},
		},
		{
			blip = { x = -1594.0063476563, y = -1025.740234375, z = 13.018488883972 },
			positions = {
				{ x = -1640.3818359375, y = -1041.4393310547, z = 13.151966094971 },
				{ x = -1690.1785888672, y = -1115.8001708984, z = 13.152278900146 },
				{ x = -1537.3674316406, y = -941.81457519531, z = 11.566101074219 },
			},
		},
		{
			blip = { x = 1136.3858642578, y = 57.870365142822, z = 80.756072998047 },
			positions = {
				{ x = 1104.6691894531, y = 78.141830444336, z = 80.890342712402 },
				{ x = 988.00891113281, y = 97.073616027832, z = 80.991333007813 },
				{ x = 1088.5246582031, y = 198.58590698242, z = 85.740844726563 },
			},
		},
		{
			blip = { x = 990.94891357422, y = -3102.5656738281, z = 5.9009122848511 },
			positions = {
				{ x = 1006.1696777344, y = -3078.3444824219, z = 26.519613265991 },
				{ x = 1097.4591064453, y = -3191.7795410156, z = 26.501348495483 },
				{ x = 860.97943115234, y = -3027.4597167969, z = 26.415704727173 },
			},
		},
		{
			blip = { x = 124.66664123535, y = -23.830966949463, z = 67.74031829834 },
			positions = {
				{ x = 98.000183105469, y = 55.300277709961, z = 73.520904541016 },
				{ x = 176.65950012207, y = -169.74102783203, z = 66.705986022949 },
				{ x = 69.996597290039, y = -58.626159667969, z = 77.021354675293 },
			},
		},
		{
			blip = { x = -856.61743164063, y = -2252.4948730469, z = 6.9274196624756 },
			positions = {
				{ x = -990.27526855469, y = -2242.4963378906, z = 10.614326477051 },
				{ x = -738.06805419922, y = -2277.0534667969, z = 13.437446594238 },
				{ x = -879.84497070313, y = -2387.7094726563, z = 20.07975769043 },
			},
		},
	},
}

-- Skins
Settings.skins = {
	['Regular'] = {
		{ model = 'a_m_y_hipster_01', name = 'Hipster 1 (M)', rank = 1 },
		{ model = 'a_f_y_hipster_01', name = 'Hipster 1 (F)', rank = 1 },
		{ model = 'a_m_y_hipster_02', name = 'Hipster 2 (M)', rank = 1 },
		{ model = 'a_f_y_hipster_02', name = 'Hipster 2 (F)', rank = 1 },
		{ model = 'a_m_y_hipster_03', name = 'Hipster 3 (M)', rank = 1 },
		{ model = 'a_f_y_hipster_03', name = 'Hipster 3 (F)', rank = 1 },
		{ model = 's_m_y_cop_01', name = 'Cop (M)', rank = 1 },
		{ model = 's_f_y_cop_01', name = 'Cop (F)', rank = 1 },
		{ model = 's_m_m_paramedic_01', name = 'Medic (M)', rank = 1 },
		{ model = 'g_m_y_ballaorig_01', name = 'Ballas 1 (M)', rank = 1 },
		{ model = 'g_m_y_ballasout_01', name = 'Ballas 2 (M)', rank = 1 },
		{ model = 'g_m_y_ballaeast_01', name = 'Ballas 3 (M)', rank = 1 },
		{ model = 'g_f_y_ballas_01', name = 'Ballas 4 (F)', rank = 1 },
		{ model = 'g_m_y_famca_01', name = 'Families 1 (M)', rank = 1 },
		{ model = 'g_m_y_famfor_01', name = 'Families 2 (M)', rank = 1 },
		{ model = 'g_m_y_famdnf_01', name = 'Families 3 (M)', rank = 1 },
		{ model = 'g_f_y_families_01', name = 'Families 4 (F)', rank = 1 },
		{ model = 'a_m_m_bevhills_01', name = 'Casual 1 (M)', rank = 1 },
		{ model = 'a_f_m_bevhills_01', name = 'Casual 1 (F)', rank = 1 },
		{ model = 'a_m_y_bevhills_01', name = 'Casual 2 (M)', rank = 1 },
		{ model = 'a_f_y_bevhills_01', name = 'Casual 2 (F)', rank = 1 },
		{ model = 'a_m_m_bevhills_02', name = 'Casual 3 (M)', rank = 1 },
		{ model = 'a_m_y_bevhills_02', name = 'Casual 4 (M)', rank = 1 },
		{ model = 'a_f_y_bevhills_03', name = 'Casual 5 (F)', rank = 1 },
		{ model = 'a_f_y_bevhills_04', name = 'Casual 6 (F)', rank = 1 },
		{ model = 'a_m_m_business_01', name = 'Businessman 1 (M)', rank = 1 },
		{ model = 'a_m_y_business_01', name = 'Businessman 2 (M)', rank = 1 },
		{ model = 'a_f_y_business_01', name = 'Businessman 2 (F)', rank = 1 },
		{ model = 'a_m_y_business_02', name = 'Businessman 3 (M)', rank = 1 },
		{ model = 'a_m_y_business_03', name = 'Businessman 4 (M)', rank = 1 },
		{ model = 'a_f_y_business_04', name = 'Businessman 5 (F)', rank = 1 },
		{ model = 'g_m_m_chigoon_01', name = 'Chigoon 1 (M)', rank = 1 },
		{ model = 'g_m_m_chigoon_02', name = 'Chigoon 2 (M)', rank = 1 },
		{ model = 'a_m_y_hippy_01', name = 'Hippie (M)', rank = 1 },
		{ model = 'a_f_y_hippie_01', name = 'Hippie (F)', rank = 1 },
	},

	['Unlockable'] = {
		{ model = 'g_m_m_chemwork_01', name = 'Chemist', rank = 10 },
		{ model = 's_m_y_fireman_01', name = 'Fireman', rank = 20 },
		{ model = 's_m_m_fibsec_01', name = 'FIB Security', rank = 30 },
		{ model = 's_m_y_clown_01', name = 'Clown', rank = 40 },
		{ model = 'u_m_y_zombie_01', name = 'Zombie', rank = 50 },
		{ model = 's_m_m_strperf_01', name = 'Street Performer', rank = 60 },
		{ model = 'u_m_y_pogo_01', name = 'Pogo', rank = 70 },
		{ model = 's_m_m_movalien_01', name = 'Alien', rank = 80 },
		{ model = 'u_m_y_rsranger_01', name = 'RS Ranger', rank = 90 },
	},

	['Prestige'] = {
		{ model = 's_m_m_doctor_01', name = 'Doctor', prestige = 1 },
		{ model = 's_m_y_mime', name = 'Mime', prestige = 2 },
		{ model = 'u_m_y_mani', name = 'Mani', prestige = 3 },
		{ model = 's_m_m_movspace_01', name = 'Spaceman', prestige = 4 },
		{ model = 'u_m_y_imporage', name = 'Imporage', prestige = 5 },
		{ model = 'u_m_m_griff_01', name = 'Griff?', prestige = 6 },
		{ model = 'u_m_y_babyd', name = 'Baby', prestige = 7 },
		{ model = 's_m_y_factory_01', name = 'Factory Man', prestige = 8 },
		{ model = 'u_m_m_jesus_01', name = 'That Guy', prestige = 9 },
		{ model = 'u_m_o_filmnoir', name = 'Dominus', prestige = 10 },
	},
}

-- Weapon tints
Settings.weaponTints = {
	{
		index = 0,
		name = 'Normal',
		kills = 0,
		cash = 0,
	},

	{
		index = 4,
		kills = 100,
		cash = 5000,
	},

	{
		index = 1,
		kills = 200,
		cash = 5250,
	},

	{
		index = 6,
		kills = 400,
		cash = 5500,
	},

	{
		index = 5,
		kills = 600,
		cash = 5750,
	},

	{
		index = 3,
		kills = 1000,
		cash = 7500,
	},

	{
		index = 2,
		kills = 1500,
		cash = 10000,
	},

	{
		index = 7,
		kills = 2500,
		cash = 12500,
	},
}

Settings.weaponTintNames = {
	'Green',
	'Gold',
	'Pink',
	'Army',
	'LSPD',
	'Orange',
	'Platinum',
}
