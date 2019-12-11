Settings = { }


-- General
Settings.afkTimeout = 300 --in seconds
Settings.autoSavingTimeout = 180000
Settings.pingThreshold = 350
Settings.maxPlayerNameLength = 24
Settings.enableVoiceChat = false
Settings.discordNotificationTimeout = 900000
Settings.serverTimeZone = '(CET+1)'
Settings.maxMenuOptionCount = 7


-- Weather
Settings.weatherTypes = { 'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'SNOWLIGHT' }
Settings.weatherOverTime = 15 * 60000


-- Damage/defense modifiers
Settings.weaponDamageModifier = 0.95
Settings.defenseModifier = 1.05


-- Prestige
Settings.minPrestigeRank = 100
Settings.maxPrestige = 10
Settings.prestigeBonus = 0.05


-- Crew
Settings.crewInvitationTimeout = 10000


-- Vehicle restriction
Settings.specialVehicleMinRank = 5


-- Moderation
Settings.moderatorLevel = {
	['Moderator'] = 1,
	['SuperModerator'] = 2,
	['Administrator'] = 3
}


-- Hud
Settings.killstreakInterval = 5000


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
		{ x = 1952.4854736328, y = 3842.5568847656, z = 32.178901672363 },
		{ x = 1921.1795654297, y = 3745.5158691406, z = 32.322116851807 },
		{ x = 917.11938476563, y = 3643.119140625, z = 32.635433197021 },
		{ x = 1423.8725585938, y = 3662.9357910156, z = 39.728401184082 },
		{ x = -105.0784072876, y = 6534.3359375, z = 29.809169769287 },
		{ x = -697.46954345703, y = 5803.373046875, z = 17.330968856812 },
		{ x = -284.17599487305, y = 6174.6455078125, z = 31.499332427979 },
		{ x = -411.56826782227, y = 6367.1450195313, z = 13.503661155701 },
		{ x = 404.65307617188, y = 6526.345703125, z = 27.682704925537 },
		{ x = -4.4725255966187, y = 6650.7827148438, z = 31.182081222534 },
		{ x = 1834.2113037109, y = 3910.0612792969, z = 33.175727844238 },
		{ x = 1701.4327392578, y = 3596.1328125, z = 35.451236724854 },
	},
	deathTime = 8000,
	timeout = 30000,
	respawnFasterPerControlPressed = 250, -- holy
	tryCount = 150,
	radius = { min = 100., increment = 25., minDistanceToPlayer = 50. },
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
	'rhino',
	'khanjali',
	'hydra',
	'hunter',
	'cargoplane',
}


-- Pickup
Settings.pickup = {
	radius = 150.,
	drops = {
		{
			id = 'PICKUP_ARMOUR_STANDARD',
			chance = 0.25,
			armour = true,
		},

		{
			id = 'PICKUP_HEALTH_STANDARD',
			chance = 0.30,
		},

		{
			id = 'PICKUP_VEHICLE_ARMOUR_STANDARD',
			chance = 0.25,
			vehicle = true,
			armour = true,
		},

		{
			id = 'PICKUP_VEHICLE_HEALTH_STANDARD',
			chance = 0.30,
			vehicle = true,
		},
	}
}


-- Place markers
Settings.placeMarkerRadius = 1.25
Settings.placeMarkerOpacity = 196


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
	{ id = 'WEAPON_PISTOL', ammo = 80, components = { }, selected = true },
}
Settings.maxArmour = 100
Settings.stats = {
	strength = { min = 90, max = 100 },
	shooting = { min = 10, max = 60 },
	flying = { min = 30, max = 80 },
	driving = { min = 30, max = 80 },
	lung = { min = 30 , max = 80 },
	stealth = { min = 50 , max = 100 },
	stamina = { min = 50, max = 100 },
}


-- Patreon
Settings.patreonBonus = 1.25
Settings.patreonDailyReward = { time = 86400, cash = 5000 , exp = 2500 }


-- Cash
Settings.cashPerKill = 125
Settings.cashPerKillstreak = 50
Settings.maxCashPerKillstreak = 500
Settings.cashPerHeadshot = 50
Settings.cashPerMission = 200
Settings.cashGainedNotificationTime = 5000


-- Experience
Settings.expPerKill = 100
Settings.expPerKillstreak = 50
Settings.maxExpPerKillstreak = 500
Settings.expPerHeadshot = 75
Settings.expPerMission = 125


-- Fast Travel
Settings.travel = {
	cashPerRank = 50,
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
	}
}


-- Challenges
Settings.challenge = {
	requestTimeout = 10000,
}


-- Duel
Settings.duel = {
	targetScore = 5,
	reward = {
		exp = 2000,
		cash = 3000,
	},
}


-- Personal Vehicles
Settings.personalVehicle = {
	maxDistance = 50.0,
	vehicles = {
		['Free'] = {
			['bmx'] = { name = 'BMX', cash = 0 },
			['ruiner'] = { name = 'Imponte Ruiner', cash = 0 },
			['sanchez'] = { name = 'Sanchez', cash = 0 },
		},

		['Sports'] = {
			['sultan'] = { name = 'Sultan', cash = 12, rank = 5 },
			['penumbra'] = { name = 'Maibatsu Penumbra', cash = 24, rank = 8 },
			['futo'] = { name = 'Karin Futo', cash = 25, rank = 11 },
			['buffalo'] = { name = 'Buffalo', cash = 35, rank = 14 },
			['schwarzer'] = { name = 'Benefactor Schwartzer', cash = 80, rank = 17 },
			['banshee'] = { name = 'Banshee', cash = 90, rank = 20 },
			['comet2'] = { name = 'Comet', cash = 100, rank = 23 },
			['ninef'] = { name = 'Obey 9F', cash = 120, rank = 26 },
			['feltzer2'] = { name = 'Feltzer', cash = 130, rank = 29 },
			['rapidgt'] = { name = 'Dewbauchee Rapid GT', cash = 132, rank = 32 },
			['coquette'] = { name = 'Invetero Coquette', cash = 138, rank = 35 },
			['italigto'] = { name = 'Itali GTO', cash = 196, rank = 38 },
			['jester'] = { name = 'Dinka Jester', cash = 240, rank = 41 },
		},

		['Motorcycles'] = {
			['akuma'] = { name = 'Dinka Akuma', cash = 90, rank = 4 },
			['pcj'] = { name = 'PCJ-600', cash = 90, rank = 7 },
			['ruffian'] = { name = 'Pegassi Ruffian', cash = 90, rank = 10 },
			['vader'] = { name = 'Shitzu Vader', cash = 90, rank = 13 },
			['nemesis'] = { name = 'Principe Nemesis', cash = 120, rank = 16 },
			['double'] = { name = 'Dinka Double T', cash = 120, rank = 19 },
			['daemon'] = { name = 'Daemon', cash = 145, rank = 22 },
			['bati'] = { name = 'Pegassi Bati 801', cash = 150, rank = 25 },
			['hexer'] = { name = 'Hexer', cash = 150, rank = 28 },
			['bagger'] = { name = 'Bagger', cash = 160, rank = 31 },
		},

		['Super'] = {
			['voltic'] = { name = 'Coil Voltic', cash = 150, rank = 9 },
			['bullet'] = { name = 'Bullet GT', cash = 155, rank = 12 },
			['vacca'] = { name = 'Pegassi Vacca', cash = 240, rank = 15 },
			['infernus'] = { name = 'Pegassi Infernus', cash = 440, rank = 18 },
			['cheetah'] = { name = 'Grotti Cheetah', cash = 650, rank = 21 },
			['entityxf'] = { name = 'Overflod Entity XF', cash = 795, rank = 24 },
			['adder'] = { name = 'Truffade Adder', cash = 1000, rank = 27 },
		},

		['Military'] = {
			['dune3'] = { name = 'Dune FAV', cash = 1130, rank = 5 },
			['technical'] = { name = 'Karin Technical', cash = 1263, rank = 10 },
			['caracara'] = { name = 'Vapid Caracara', cash = 1775, rank = 15 },
			['barrage'] = { name = 'HVY Barrage', cash = 2121, rank = 20 },
			['boxville5'] = { name = 'Armored Boxville', cash = 2926, rank = 25 },
		},

		['Premium'] = {
			['t20'] = { name = 'Progen T20', cash = 2200, rank = 30 },
			['xa21'] = { name = 'Ocelot XA-21', cash = 2375, rank = 40 },
			['voltic2'] = { name = 'Rocket Voltic', cash = 2880, rank = 50 },
		},

		['Prestige'] = {
			['deluxo'] = { name = 'Deluxo', cash = 4721, prestige = 1, rank = 20 },
			['phantom2'] = { name = 'Phantom Wedge', cash = 2553, prestige = 2, rank = 40 },
			['thruster'] = { name = 'Thruster', cash = 3657, prestige = 3, rank = 60 },
		},
	}
}


-- Events
Settings.event = {
	timeout = 900000,
	minPlayers = 3,
}


-- Stockpiling
Settings.stockPiling = {
	duration = 600000,
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
	rewardPerCheckPoint = { cash = 500, exp = 200 },
	rewards = {
		{ cash = 15000, exp = 7000 },
		{ cash = 10000, exp = 6000 },
		{ cash = 5000, exp = 5000 },
	},
}


-- Sharpshooter
Settings.sharpShooter = {
	duration = 900000,
	rewards = {
		{ cash = 15000, exp = 7000 },
		{ cash = 10000, exp = 6000 },
		{ cash = 5000, exp = 5000 },
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
	},
	radius = 50.0,
	rewards = {
		{ cash = 15000, exp = 7000 },
		{ cash = 10000, exp = 6000 },
		{ cash = 5000, exp = 5000 },
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
		{ cash = 15000, exp = 7000 },
		{ cash = 10000, exp = 6000 },
		{ cash = 5000, exp = 5000 },
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
			min = { cash = 5000, exp = 5000 },
			landmark = { cash = 500, exp = 200 },
		},
		killer = { cash = 3500, exp = 1500 },
	},
}


-- AmmuNation Refill Ammo
Settings.ammuNationRefillAmmo = {
	['Pistol Rounds'] = {
		weapons = {
			'WEAPON_PISTOL',
		},
		ammo = 24,
		price = 0,
	},

	['Shotgun Shells'] = {
		weapons = {
			'WEAPON_ASSAULTSHOTGUN',
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_SAWNOFFSHOTGUN',
		},
		ammo = 16,
		price = 48,
	},

	['SMG Rounds'] = {
		weapons = {
			'WEAPON_SMG',
			'WEAPON_MICROSMG',
		},
		ammo = 30,
		price = 72,
	},

	['MG Rounds'] = {
		weapons = {
			'WEAPON_COMBATMG',
			'WEAPON_MG',
			'WEAPON_RAYCARBINE',
		},
		ammo = 100,
		price = 135,
	},

	['Assault Rifle Rounds'] = {
		weapons = {
			'WEAPON_ASSAULTRIFLE',
			'WEAPON_CARBINERIFLE',
			'WEAPON_ADVANCEDRIFLE',
		},
		ammo = 60,
		price = 124,
	},

	['Tear Gas Units'] = {
		weapons = {
			'WEAPON_SMOKEGRENADE',
		},
		ammo = 3,
		price = 14,
	},

	['Grenade Units'] = {
		weapons = {
			'WEAPON_GRENADE',
		},
		ammo = 3,
		price = 31,
	},

	['Molotov Cocktail Units'] = {
		weapons = {
			'WEAPON_MOLOTOV',
		},
		ammo = 3,
		price = 67,
	},

	['Sticky Bomb Units'] = {
		weapons = {
			'WEAPON_STICKYBOMB',
		},
		ammo = 3,
		price = 94,
	},

	['Proximity Mine Units'] = {
		weapons = {
			'WEAPON_PROXMINE',
		},
		ammo = 3,
		price = 119,
	},

	['Flare Gun Rounds'] = {
		weapons = {
			'WEAPON_FLAREGUN',
		},
		ammo = 2,
		price = 29,
	},
}


-- AmmuNation Special Weapons Ammo
Settings.ammuNationSpecialAmmo = {
	['WEAPON_GRENADELAUNCHER'] = {
		ammo = 3, -- 20
		price = 672,
		type = 'Grenades',
	},
	['WEAPON_RPG'] = {
		ammo = 1 * 3,
		price = 843,
		type = 'Rockets',
	},
	['WEAPON_HOMINGLAUNCHER'] = {
		ammo = 1 * 3,
		price = 971,
		type = 'Rockets',
	},
	['WEAPON_MINIGUN'] = {
		ammo = 1 * 250,
		price = 604,
		type = 'Rounds',
	},
	['WEAPON_RAYMINIGUN'] = {
		ammo = 1 * 250,
		price = 604, -- same as Minigun
		type = 'Rounds',
	},
	['WEAPON_HEAVYSNIPER'] = {
		ammo = 12 * 2,
		price = 497,
		type = 'Rounds',
	},
	['WEAPON_SNIPERRIFLE'] = {
		ammo = 12 * 2,
		price = 497, -- same as Heavy Sniper
		type = 'Rounds',
	},
	['WEAPON_DOUBLEACTION'] = {
		ammo = 6 * 3,
		price = 404,
		type = 'Rounds',
	},
	['WEAPON_PISTOL50'] = {
		ammo = 9 * 2,
		price = 427,
		type = 'Rounds',
	},
}


-- Missions
Settings.mission = {
	resetTimeInterval = 10800000,
	places = {
		{ x = -57.338516235352, y = -2448.7080078125, z = 7.2357640266418 },
		{ x = 1013.4348754883, y = -2150.8464355469, z = 31.533414840698 },
		{ x = 1213.0318603516, y = -1251.0944824219, z = 36.325752258301 },
		{ x = 707.24340820313, y = -966.26904296875, z = 30.412851333618 },
		{ x = -29.890213012695, y = -1104.3305664063, z = 26.422355651855 },
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
	failedRewards = { cash = 2500, exp = 1000 },
}


-- Market Manipulation Mission
Settings.marketManipulation = {
	time = 900000,
	places = {
		{ ['x'] = 27.179788589478, ['y'] = -1340.0749511719, ['z'] = 29.497024536133 },
		{ ['x'] = -42.322410583496, ['y'] = -1749.1009521484, ['z'] = 29.421016693115 },
		{ ['x'] = -708.58825683594, ['y'] = -904.11706542969, ['z'] = 19.215591430664 },
		{ ['x'] = -1219.4338378906, ['y'] = -916.10382080078, ['z'] = 11.326217651367 },
		{ ['x'] = -1479.5504150391, ['y'] = -373.80960083008, ['z'] = 39.163394927979 },
		{ ['x'] = 377.10794067383, ['y'] = 332.92077636719, ['z'] = 103.56636810303 },
		{ ['x'] = 1160.6029052734, ['y'] = -314.04550170898, ['z'] = 69.205139160156 },
		{ ['x'] = 1126.3829345703, ['y'] = -981.70190429688, ['z'] = 45.415824890137 },
		{ ['x'] = -1828.1215820313, ['y'] = 799.11328125, ['z'] = 138.17001342773 },
		{ ['x'] = -2958.9916992188, ['y'] = 388.09457397461, ['z'] = 14.04315662384 },
	},
	rewards = {
		cash = { min = 5000, max = 15000, perRobbery = 1000 },
		exp = { min = 5000, max = 7000, perRobbery = 200 },
	},
}


-- Velocity Mission
Settings.velocity = {
	enterVehicleTime = 600000,
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
	minSpeed = 60,
	rewards = {
		cash = { min = 5000, max = 15000, perAboutToDetonate = 1000 },
		exp = { min = 5000, max = 7000, perAboutToDetonate = 200 },
	},
}


-- Most Wanted Mission
Settings.mostWanted = {
	time = 600000,
	rewards = {
		maxCash = 15000,
		maxExp = 7000,
	},
}


-- Asset Recovery Mission
Settings.assetRecovery = {
	time = 1200000,
	variants = {
		{
			vehicle = 'pigalle',
			vehicleLocation = { x = -1041.6690673828, y = -850.52899169922, z = 4.7838535308838, heading = 135.58250427246 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicle = 'dominator',
			vehicleLocation = { x = 454.39685058594, y = -1024.5531005859, z = 28.112592697144, heading = 92.917694091797 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicle = 'comet2',
			vehicleLocation = { x = 852.61529541016, y = -1280.2347412109, z = 26.133306503296, heading = 359.4150390625 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicle = 'feltzer3',
			vehicleLocation = { x = 468.05123901367, y = -65.828109741211, z = 77.158767700195, heading = 238.4743347168 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicle = 'blazer',
			vehicleLocation = { x = 1866.5213623047, y = 3699.1994628906, z = 32.8317527771, heading = 210.75952148438 },
			dropOffLocation = { x = 165.90403747559, y = -3081.7749023438, z = 5.5951142311096, heading = 270.91390991211 },
		},
	},
	dropRadius = 25.,
	rewards = {
		cash = { min = 5000, max = 15000 },
		exp = { min = 5000, max = 7000 },
	},
}


-- Headhunter Mission
Settings.headhunter = {
	time = 1200000,
	radius = 200.,
	targets = {
		{
			location = { x = -1813.0296630859, y = -1207.5499267578, z = 19.169616699219 },
			pedModel = 'a_m_y_beachvesp_01',
		},

		{
			location = { x = -1191.2917480469, y = -508.70294189453, z = 35.566139221191 },
			pedModel = 'u_m_m_filmdirector',
		},

		{
			location = { x = -175.79162597656, y = -604.76159667969, z = 48.222152709961 },
			pedModel = 's_m_m_highsec_01',
		},

		{
			location = { x = 624.09893798828, y = -3021.7360839844, z = 6.2169780731201 },
			pedModel = 's_m_y_dockwork_01',
		},

		{
			location = { x = -619.80187988281, y = 323.91040039063, z = 82.263603210449 },
			pedModel = 'u_m_m_jesus_01',
		},
	},
	weapons = {
		'WEAPON_SPECIALCARBINE',
		'WEAPON_ADVANCEDRIFLE',
		'WEAPON_AUTOSHOTGUN',
		'WEAPON_MINISMG',
		'WEAPON_RPG',
	},
	wantedLevel = 3,
	rewards = {
		cash = { min = 5000, max = 15000 },
		exp = { min = 5000, max = 7000 },
	},
}


-- Crates
Settings.crate = {
	chance = 30,
	timeout = 1200000,
	reward = {
		exp = 2500,
		cash = 7500,
	},
	radius = 200.,
	weapons = {
		{ id = 'WEAPON_GRENADELAUNCHER', name = 'Grenade Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_RPG', name = 'Rocket Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_MINIGUN', name = 'Minigun', ammo = 1 * 500 },
		{ id = 'WEAPON_HEAVYSNIPER', name = 'Heavy Sniper', ammo = 12 * 2 },
		{ id = 'WEAPON_SNIPERRIFLE', name = 'Sniper Rifle', ammo = 12 * 2 },
		{ id = 'WEAPON_PISTOL50', name = 'Pistol .50', ammo = 9 * 3 },
		{ id = 'WEAPON_DOUBLEACTION', name = 'Double-Action Revolver', ammo = 6 * 4 },
		{ id = 'WEAPON_HOMINGLAUNCHER', name = 'Homing Launcher', ammo = 1 * 8 },
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
			}
		},
	},
}


-- Skins
Settings.skins = {
	['a_m_y_hipster_01'] = {
		name = 'Hipster',
		kills = 0,
		rank = 1,
	},

	['g_m_m_chigoon_01'] = {
		name = 'Chigoon',
		kills = 0,
		rank = 1,
	},

	['a_f_y_business_04'] = {
		name = 'Business',
		kills = 0,
		rank = 1,
	},

	['g_m_m_chemwork_01'] = {
		name = 'Chemist',
		kills = 100,
		rank = 10,
	},

	['s_m_y_fireman_01'] = {
		name = 'Fireman',
		kills = 200,
		rank = 20,
	},

	['s_m_m_fibsec_01'] = {
		name = 'FIB Security',
		kills = 300,
		rank = 30,
	},

	['s_m_y_clown_01'] = {
		name = 'Clown',
		kills = 400,
		rank = 40,
	},

	['u_m_y_zombie_01'] = {
		name = 'Zombie',
		kills = 500,
		rank = 50,
	},

	['s_m_m_strperf_01'] = {
		name = 'Street Performer',
		kills = 600,
		rank = 60,
	},

	['u_m_y_pogo_01'] = {
		name = 'Pogo',
		kills = 700,
		rank = 70,
	},

	['s_m_m_movalien_01'] = {
		name = 'Alien',
		kills = 800,
		rank = 80,
	},

	['u_m_y_rsranger_01'] = {
		name = 'RS Ranger',
		kills = 900,
		rank = 90,
	},

	['u_m_y_imporage'] = {
		name = 'Imporage',
		kills = 1000,
		rank = 95,
	},

	['s_m_m_doctor_01'] = {
		name = 'Doctor',
		prestige = 1,
	},

	['s_m_y_mime'] = {
		name = 'Mime',
		prestige = 2,
	},

	['u_m_y_mani'] = {
		name = 'Mani',
		prestige = 3,
	},

	['s_m_m_movspace_01'] = {
		name = 'Spaceman',
		prestige = 4,
	},

	['u_m_y_juggernaut_01'] = {
		name = 'Juggernaut',
		prestige = 5,
	},
}

-- Weapon tints
Settings.weaponTints = {
	{
		index = 0,
		name = 'Normal',
		kills = 0,
		cash = 0,
		rank = 1,
	},

	{
		index = 4,
		name = 'Army',
		kills = 100,
		cash = 1000,
		rank = 2,
	},

	{
		index = 1,
		name = 'Green',
		kills = 500,
		cash = 2500,
		rank = 5,
	},

	{
		index = 6,
		name = 'Orange',
		kills = 1000,
		cash = 5000,
		rank = 10,
	},

	{
		index = 5,
		name = 'LSPD',
		kills = 2000,
		cash = 10000,
		rank = 25,
	},

	{
		index = 3,
		name = 'Pink',
		kills = 4000,
		cash = 15000,
		rank = 50,
	},

	{
		index = 2,
		name = 'Gold',
		kills = 6000,
		cash = 20000,
		rank = 75,
	},

	{
		index = 7,
		name = 'Platinum',
		kills = 8000,
		cash = 25000,
		rank = 90,
	},
}
