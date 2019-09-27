Settings = { }


-- General
Settings.maxPlayerCount = 32 -- For internal usage only, do not touch it!
Settings.afkTimeout = 300 --in seconds
Settings.autoSavingTimeout = 180000
Settings.pingThreshold = 350
Settings.maxPlayerNameLength = 24
Settings.enableVoiceChat = false
Settings.discordNotificationTimeout = 900000
Settings.serverTimeZone = '(CET+1)'
Settings.maxMenuOptionCount = 7


-- Prestige
Settings.minPrestigeRank = 100
Settings.maxPrestige = 10
Settings.prestigeBonus = 0.1


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
		{ x = -1275.0126953125, y = -1203.6892089844, z = 4.8633379936218 },
		{ x = -1396.0938720703, y = -919.03540039063, z = 11.050843238831 },
		{ x = -1377.6763916016, y = -504.88446044922, z = 33.157428741455 },
		{ x = -787.05938720703, y = -252.57595825195, z = 37.093433380127 },
		{ x = -363.12307739258, y = 32.533153533936, z = 47.93822860717 },
		{ x = 163.58355712891, y = 23.325786590576, z = 72.530029296875 },
		{ x = 540.58258056641, y = 33.678867340088, z = 94.50659942627 },
		{ x = 832.34368896484, y = -188.13970947266, z = 72.766952514648 },
		{ x = 1039.6545410156, y = -639.00189208984, z = 57.242095947266 },
		{ x = 1259.6784667969, y = -1484.6651611328, z = 36.934307098389 },
		{ x = 991.29486083984, y = -1786.0711669922, z = 31.257905960083 },
		{ x = 400.71084594727, y = -2001.3033447266, z = 23.181797027588 },
		{ x = 55.665958404541, y = -1483.5288085938, z = 29.252729415894  },
		{ x = -257.04217529297, y = -978.82458496094, z = 31.220012664795 },
		{ x = -149.85647583008, y = -874.92401123047, z = 29.640981674194 },
		{ x = 10.80757522583, y = -399.60745239258, z = 39.527442932129 },
		{ x = 60.717437744141, y = 8.6226987838745, z = 69.138847351074 },
		{ x = -529.57513427734, y = 92.357269287109, z = 60.316272735596 },
		{ x = -692.64880371094, y = -627.58905029297, z = 31.556943893433 },
	},
	deathTime = 8000,
	timeout = 30000,
	respawnFasterPerControlPressed = 250, -- holy
	tryCount = 100,
	radius = { min = 100., increment = 25. },
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

Settings.calculateRank = function(experience)
	if experience == 0 then return 1 end

	for i = 2, #Settings.ranks do
		if Settings.ranks[i] > experience then
			return i - 1
		end
	end

	-- Some algebra, I hope I didn't fuck up
	-- f(x)=25x^2 + 23575x - 1023150

	local a = 25
	local b = 23575
	local c = -1023150-experience

	local d = b * b - 4 * a * c
	if d == 0 then return math.floor(-b/ (2 * a)) end

	if d > 0 then return math.floor(math.max((-b + math.sqrt(d)) / (2 * a), (-b - math.sqrt(d)) / (2 * a)))
	else return #Settings.ranks end -- Fail
end


Settings.calculateExp = function(rank)
	-- f(x)=25x^2 + 23575x - 1023150
	if rank <= #Settings.ranks then return Settings.ranks[rank]
	else return 25 * rank * rank + 23575 * rank - 1023150 end
end


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
Settings.calculateSkillStat = function(rank) return math.min(100, math.floor(20 + (rank / 25) * 20)) end
Settings.maxArmour = 100


-- Patreon
Settings.patreonBonus = 1.25
Settings.patreonDailyReward = { time = 86400, cash = 5000 , exp = 2500 }


-- Cash
Settings.cashPerKill = 125
Settings.cashPerKillstreak = 75
Settings.maxCashPerKillstreak = 800
Settings.cashPerHeadshot = 75
Settings.cashPerMission = 250
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
		{ x = -845.87677001953, y = -3376.2429199219, z = 13.944359779358 },
		{ x = -508.96585083008, y = -2928.2375488281, z = 6.0003814697266 },
		{ x = 186.83126831055, y = -3320.0522460938, z = 5.6273703575134 },
		{ x = 219.7088470459, y = -2315.0947265625, z = 8.4016227722168 },
		{ x = 370.65002441406, y = -2131.0170898438, z = 16.210426330566 },
		{ x = -1486.0161132813, y = -1476.2647705078, z = 2.634242773056 },
		{ x = -1847.56640625, y = -1229.1634521484, z = 13.017266273499 },
		{ x = -888.43792724609, y = -1489.2298583984, z = 5.024055480957 },
		{ x = -2994.1015625, y = 17.080907821655, z = 6.9866771697998 },
		{ x = -3413.0749511719, y = 967.44000244141, z = 8.3466844558716 },
		{ x = -2506.0861816406, y = 755.91625976563, z = 301.98696899414 },
		{ x = -2319.9265136719, y = 384.73645019531, z = 174.46664428711 },
		{ x = -2243.9494628906, y = 262.83520507813, z = 174.61549377441 },
		{ x = -1932.0732421875, y = 170.71830749512, z = 84.65412902832 },
		{ x = -1667.2713623047, y = 401.68734741211, z = 88.995323181152 },
		{ x = -2752.3781738281, y = 1187.8350830078, z = 94.649917602539 },
		{ x = -2270.90625, y = 1328.9090576172, z = 298.80294799805 },
		{ x = -1533.560546875, y = 884.00518798828, z = 181.71989440918 },
		{ x = -1024.2127685547, y = 1048.4678955078, z = 173.73756408691 },
		{ x = -409.96801757813, y = 1180.30078125, z = 325.61047363281 },
		{ x = -201.38606262207, y = 1309.6477050781, z = 304.49716186523 },
		{ x = 202.76136779785, y = 1166.6563720703, z = 227.0048828125 },
		{ x = -116.88822937012, y = 899.69128417969, z = 235.80456542969 },
		{ x = 32.373760223389, y = 856.84271240234, z = 197.73667907715 },
		{ x = 168.7543182373, y = 665.86444091797, z = 206.73274230957 },
		{ x = -486.38897705078, y = 597.96118164063, z = 126.11904144287 },
		{ x = -711.78002929688, y = 596.66107177734, z = 142.05392456055 },
		{ x = -112.56798553467, y = 354.41998291016, z = 112.69616699219 },
		{ x = -661.04150390625, y = 403.44506835938, z = 101.25228118896 },
		{ x = -1073.6116943359, y = -23.468688964844, z = 50.175617218018 },
		{ x = -1392.5510253906, y = 143.81143188477, z = 56.135433197021 },
		{ x = -1281.3978271484, y = -1078.5212402344, z = 7.6106238365173 },
		{ x = -1185.5891113281, y = -464.80328369141, z = 33.539070129395 },
		{ x = -881.57922363281, y = -206.73352050781, z = 38.937652587891 },
		{ x = -768.88208007813, y = -413.71401977539, z = 35.650127410889 },
		{ x = 402.68658447266, y = -953.84881591797, z = 29.447750091553 },
		{ x = 153.02626037598, y = -570.09240722656, z = 43.870571136475 },
		{ x = -8.2442741394043, y = -685.27655029297, z = 32.338069915771 },
		{ x = -251.3383026123, y = -229.70063781738, z = 49.101440429688 },
		{ x = 147.59950256348, y = -124.38256835938, z = 54.826652526855 },
		{ x = -186.20439147949, y = 24.747470855713, z = 64.556694030762 },
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
	},
	rewards = {
		{ cash = 15000, exp = 7000 },
		{ cash = 10000, exp = 6000 },
		{ cash = 5000, exp = 5000 },
	},
}


-- Executive Search
Settings.executiveSearch = {
	duration = 900000,
	outOfAreaTimeout = 5000,
	places = {
		{ x = 979.19995117188, y = -3039.0483398438, z = 5.9006385803223 },
		{ x = 914.90887451172, y = -2246.5708007813, z = 30.527393341064 },
		{ x = 169.64849853516, y = -1768.7640380859, z = 29.112857818604 },
		{ x = 1129.6751708984, y = -528.21081542969, z = 64.166290283203 },
		{ x = -623.10504150391, y = -180.28044128418, z = 37.762023925781 },
		{ x = -1643.4249267578, y = -328.91735839844, z = 50.673767089844 },
		{ x = -1118.4345703125, y = -1473.1253662109, z = 4.8473377227783 },
		{ x = -109.28057861328, y = 916.17199707031, z = 235.89839172363 },
		{ x = 1669.0047607422, y = -1567.4741210938, z = 112.41025543213 },
		{ x = -1034.8332519531, y = -1071.1206054688, z = 4.0847549438477 },
	},
	radius = 175.0,
	reward = {
		cash = 10000,
		exp = 6000,
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
	time = 600000,
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
	['u_m_y_baygor'] = {
		name = 'Default',
		kills = 0,
		rank = 1,
	},

	['g_m_m_chemwork_01'] = {
		name = 'Chemist',
		kills = 500,
		rank = 10,
	},

	['s_m_y_fireman_01'] = {
		name = 'Fireman',
		kills = 1000,
		rank = 20,
	},

	['s_m_m_fibsec_01'] = {
		name = 'FIB Security',
		kills = 1500,
		rank = 30,
	},

	['s_m_y_clown_01'] = {
		name = 'Clown',
		kills = 2000,
		rank = 40,
	},

	['u_m_y_zombie_01'] = {
		name = 'Zombie',
		kills = 2500,
		rank = 50,
	},

	['s_m_m_strperf_01'] = {
		name = 'Street Performer',
		kills = 3000,
		rank = 60,
	},

	['u_m_y_pogo_01'] = {
		name = 'Pogo',
		kills = 3500,
		rank = 70,
	},

	['s_m_m_movalien_01'] = {
		name = 'Alien',
		kills = 4000,
		rank = 80,
	},

	['u_m_y_rsranger_01'] = {
		name = 'RS Ranger',
		kills = 4500,
		rank = 90,
	},

	['u_m_y_imporage'] = {
		name = 'Imporage',
		kills = 5000,
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
