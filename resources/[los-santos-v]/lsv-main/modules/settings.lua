Settings = { }


-- General
Settings.maxPlayerCount = 32 -- For internal usage only, do not touch it!
Settings.afkTimeout = 300 --in seconds
Settings.autoSavingTimeout = 180000
Settings.pingThreshold = 200


-- Hud
Settings.deathstreakMinCount = 3
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
	radius = { min = 95., increment = 25. },
}


-- World
Settings.world = { }
Settings.world.blacklistVehicles = {
	'rhino',
	'hydra',
	'lazer',
	'buzzard',
	'akula',
	'annihilator',
	'hunter',
	'savage',
	'khanjali',
	'apc',
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
Settings.skillStat = 40
Settings.maxArmour = 100


-- Cash
Settings.cashPerKill = 150
Settings.cashPerKillstreak = 75
Settings.cashPerMission = 1000
Settings.cashGainedNotificationTime = 5000


-- Duel
Settings.duel = {
	targetScore = 5,
	reward = 1500,
	requestTimeout = 10000,
}


-- Request Vehicle
Settings.requestVehicle = {
	vehicles = {
		['Free'] = {
			['bmx'] = { name = 'BMX', cash = 0 },
		},

		['Super'] = {
			['adder'] = { name = 'Truffade Adder', cash = 10000 },
			['bullet'] = { name = 'Bullet GT', cash = 1550 },
			['cheetah'] = { name = 'Grotti Cheetah', cash = 6500 },
			['entityxf'] = { name = 'Overflod Entity XF', cash = 7950 },
			['infernus'] = { name = 'Pegassi Infernus', cash = 4400 },
			['vacca'] = { name = 'Pegassi Vacca', cash = 2400 },
			['voltic'] = { name = 'Coil Voltic', cash = 1500 },
		},

		['Motocycles'] = {
			['akuma'] = { name = 'Dinka Akuma', cash = 900 },
			['bagger'] = { name = 'Bagger', cash = 1600 },
			['bati'] = { name = 'Pegassi Bati 801', cash = 1500 },
			['double'] = { name = 'Dinka Double T', cash = 1200 },
			['daemon'] = { name = 'Daemon', cash = 1450 },
			['hexer'] = { name = 'Hexer', cash = 1500 },
			['nemesis'] = { name = 'Principe Nemesis', cash = 1200 },
			['pcj'] = { name = 'PCJ-600', cash = 900 },
			['ruffian'] = { name = 'Pegassi Ruffian', cash = 900 },
			['sanchez'] = { name = 'Sanchez', cash = 800 },
			['vader'] = { name = 'Shitzu Vader', cash = 900 },
		},

		['Sports'] = {
			['ninef'] = { name = 'Obey 9F', cash = 1200 },
			['banshee'] = { name = 'Banshee', cash = 900 },
			['buffalo'] = { name = 'Buffalo', cash = 350 },
			['comet2'] = { name = 'Comet', cash = 1000 },
			['coquette'] = { name = 'Invetero Coquette', cash = 1380 },
			['feltzer2'] = { name = 'Feltzer', cash = 1300 },
			['futo'] = { name = 'Karin Futo', cash = 250 },
			['penumbra'] = { name = 'Maibatsu Penumbra', cash = 240 },
			['rapidgt'] = { name = 'Dewbauchee Rapid GT', cash = 1320 },
			['schwarzer'] = { name = 'Benefactor Schwartzer', cash = 800 },
			['sultan'] = { name = 'Sultan', cash = 120 },
		},

		['Special'] = {
			['deluxo'] = { name = 'Deluxo', cash = 99999 },
			['stromberg'] = { name = 'Stromberg', cash = 66666 },
		},
	}
}


-- Events
Settings.event = {
	timeout = 600000,
	minPlayers = 3,
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
	},
	radius = 50.0,
	rewards = { 10000, 7500, 5000 },
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
	},
	rewards = { 10000, 7500, 5000 },
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
	},
	radius = 175.0,
	reward = 10000,
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
			'WEAPON_SAWNOFFSHOTGUN',
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_BULLPUPSHOTGUN',
			'WEAPON_ASSAULTSHOTGUN',
		},
		ammo = 16,
		price = 48,
	},

	['SMG Rounds'] = {
		weapons = {
			'WEAPON_MICROSMG',
			'WEAPON_SMG',
			'WEAPON_ASSAULTSMG',
		},
		ammo = 30,
		price = 72,
	},

	['Gusenberg Rounds'] = {
		weapons = {
			'WEAPON_GUSENBERG',
		},
		ammo = 30,
		price = 129,
	},

	['MG Rounds'] = {
		weapons = {
			'WEAPON_MG',
			'WEAPON_COMBATMG',
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
	['WEAPON_COMPACTLAUNCHER'] = {
		ammo = 1 * 3,
		price = 584,
		type = 'Grenades',
	},
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
		price = 1156,
		type = 'Rockets',
	},
	['WEAPON_MINIGUN'] = {
		ammo = 1 * 250,
		price = 604,
		type = 'Rounds',
	},
	['WEAPON_HEAVYSNIPER'] = {
		ammo = 12 * 1,
		price = 497,
		type = 'Rounds',
	},
	['WEAPON_SNIPERRIFLE'] = {
		ammo = 12 * 1,
		price = 497, -- same as Heavy Sniper
		type = 'Rounds',
	},
	['WEAPON_MARKSMANRIFLE'] = {
		ammo = 8 * 2,
		price = 471,
		type = 'Rounds',
	},
	['WEAPON_DOUBLEACTION'] = {
		ammo = 6 * 2,
		price = 404,
		type = 'Rounds',
	},
	['WEAPON_MUSKET'] = {
		ammo = 2 * 6,
		price = 445,
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
		{ ['x'] = -3047.0500488281, ['y'] = 585.65979003906, ['z'] = 7.9089307785034 },
		{ ['x'] = -3249.46875, ['y'] = 1003.5993652344, ['z'] = 12.830706596375 },
		{ ['x'] = 1733.5750732422, ['y'] = 6420.5815429688, ['z'] = 35.037227630615 },
		{ ['x'] = 1707.1936035156, ['y'] = 4919.4487304688, ['z'] = 42.063674926758 },
		{ ['x'] = 547.52557373047, ['y'] = 2663.9638671875, ['z'] = 42.156494140625 },
		{ ['x'] = 1959.1160888672, ['y'] = 3748.2690429688, ['z'] = 32.343738555908 },
		{ ['x'] = 2672.8278808594, ['y'] = 3285.5939941406, ['z'] = 55.241142272949 },
		{ ['x'] = 2549.9296875, ['y'] = 384.43780517578, ['z'] = 108.62294769287 },
		{ ['x'] = 146.25691223145, ['y'] = -1044.6046142578, ['z'] = 29.377824783325 },
		{ ['x'] = -354.23629760742, ['y'] = -53.998760223389, ['z'] = 49.046318054199 },
		{ ['x'] = 1176.9967041016, ['y'] = 2711.8190917969, ['z'] = 38.097778320313 },
		{ ['x'] = -104.46595001221, ['y'] = 6477.015625, ['z'] = 32.505443572998 },
	},
	minReward = 5000,
	maxReward = 10000,
	cashPerRobbery = 500,
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
	minReward = 5000,
	maxReward = 10000,
	cashPerAboutToDetonate = 500,
}


-- Most Wanted Mission
Settings.mostWanted = {
	time = 600000,
	maxReward = 10000,
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
	minReward = 5000,
	maxReward = 10000,
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
	minReward = 5000,
	maxReward = 10000,
}


-- Crates
Settings.crate = {
	chance = 25,
	timeout = 1200000,
	cash = 2500,
	radius = 200.,
	weapons = {
		{ id = 'WEAPON_COMPACTLAUNCHER', name = 'Compact Grenade Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_GRENADELAUNCHER', name = 'Grenade Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_RPG', name = 'Rocket Launcher', ammo = 1 * 10 },
		{ id = 'WEAPON_HOMINGLAUNCHER', name = 'Homing Launcher', ammo = 1 * 8 },
		{ id = 'WEAPON_MINIGUN', name = 'Minigun', ammo = 1 * 500 },
		{ id = 'WEAPON_HEAVYSNIPER', name = 'Heavy Sniper', ammo = 12 * 2 },
		{ id = 'WEAPON_SNIPERRIFLE', name = 'Sniper Rifle', ammo = 12 * 2 },
		{ id = 'WEAPON_MARKSMANRIFLE', name = 'Marksman Rifle', ammo = 8 * 3 },
		{ id = 'WEAPON_DOUBLEACTION', name = 'Double-Action Revolver', ammo = 6 * 4 },
		{ id = 'WEAPON_MUSKET', name = 'Musket', ammo = 1 * 20 },
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
	},

	['g_m_m_chemwork_01'] = {
		name = 'Chemist',
		kills = 500,
	},

	['s_m_y_fireman_01'] = {
		name = 'Fireman',
		kills = 1000,
	},

	['s_m_m_fibsec_01'] = {
		name = 'FIB Security',
		kills = 1500,
	},

	['s_m_y_clown_01'] = {
		name = 'Clown',
		kills = 2000,
	},

	['u_m_y_zombie_01'] = {
		name = 'Zombie',
		kills = 2500,
	},

	['s_m_m_strperf_01'] = {
		name = 'Street Performer',
		kills = 3000,
	},

	['u_m_y_pogo_01'] = {
		name = 'Pogo',
		kills = 3500,
	},

	['s_m_m_movalien_01'] = {
		name = 'Alien',
		kills = 4000,
	},

	['u_m_y_rsranger_01'] = {
		name = 'RS Ranger',
		kills = 4500,
	},

	['u_m_y_imporage'] = {
		name = 'Imporage',
		kills = 5000,
	},
}

-- Weapon tints
Settings.weaponTints = {
	[0] = {
		name = 'Normal',
		kills = 0,
	},

	[1] = {
		name = 'Green',
		kills = 50,
	},

	[2] = {
		name = 'Gold',
		kills = 250,
	},

	[3] = {
		name = 'Pink',
		kills = 500,
	},

	[4] = {
		name = 'Army',
		kills = 1000,
	},

	[5] = {
		name = 'LSPD',
		kills = 1500,
	},

	[6] = {
		name = 'Orange',
		kills = 2000,
	},

	[7] = {
		name = 'Platinum',
		kills = 2500,
	},
}
