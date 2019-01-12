Settings = { }


-- General
Settings.maxPlayerCount = 32 -- For internal usage only, do not touch it!
Settings.afkTimeout = 300 --in seconds
Settings.autoSavingTimeout = 180000
Settings.pingThreshold = 200
Settings.playerBlipDistance = 125.


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
	deathTime = 6000,
	timeout = 30000,
	respawnFasterPerControlPressed = 250, -- holy
	tryCount = 100,
	radius = { min = 75., increment = 25. },
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
}


-- Pickup
Settings.pickup = {
	radius = 150.,
	drops = {
		{
			id = 'PICKUP_ARMOUR_STANDARD',
			chance = 0.25,
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
	{ id = "WEAPON_KNIFE", ammo = 0, components = { } },
	{ id = "WEAPON_PISTOL", ammo = 80, components = { }, selected = true },
}
Settings.skillStat = 20


-- Crew
Settings.crewInvitationTimeout = 10000

-- Cash
Settings.cashPerKill = 150
Settings.cashPerKillstreak = 75
Settings.cashPerMission = 1000
Settings.cashGainedNotificationTime = 5000


-- Stunt Jumps
Settings.stuntJumpMinHeight = 18.
Settings.stuntJumpCashPerMeter = 2
Settings.stuntJumpMaxReward = 2000
Settings.stuntMinInterval = 30000


-- Bounties
Settings.bounty = {
	timeout = 300000,
	reward = 1500,
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


-- AmmuNation Refill Ammo
Settings.ammuNationRefillAmmo = {
	['Pistol Rounds'] = {
		ammo = 24,
		price = 0,
	},
	['Shotgun Shells'] = {
		ammo = 16,
		price = 48,
	},
	['SMG Rounds'] = {
		ammo = 30,
		price = 72,
	},
	['MG Rounds'] = {
		ammo = 100,
		price = 135,
	},
	['Assault Rifle Rounds'] = {
		ammo = 60,
		price = 124,
	},
	['Tear Gas Units'] = {
		ammo = 3,
		price = 14,
	},
	['Grenade Units'] = {
		ammo = 3,
		price = 31,
	},
	['Molotov Cocktail Units'] = {
		ammo = 3,
		price = 67,
	},
	['Sticky Bomb Units'] = {
		ammo = 3,
		price = 94,
	}
}


-- Missions
Settings.mission = {
	timeout = 900000,
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
	notification = {
		timeout = 45000,
		messages = {
			'You, my friend have found your level in life... You\'ve joined a society of morons called the police force!',
			'Nice name badge! ...But they misspelt \'dick\'.',
			'Let\'s be clear. Only an idiot joins the cops! ...See? You don\'t even understand simple sentences!',
			'Oh, you look so... tough, officer! ...I know you were bullied in school.',
			'Aren\'t you just a great example to us all? ...Living proof that shit can talk!',
			'Hey... Aren\'t you cool? ...I was being sarcastic. You look like a twat.',
			'Does parking orders get you excited? ...Or do you prefer beating up suspects?',
			'I bet you love giving orders... And arresting jaywalkers and tourists...',
			'What exactly are you looking at? ...Because I\'m looking at a turd.',
			'Nice uniform! ...But you should be working in Burger Shot!',
			'The police force, now that\'s a bad joke! ...Police "farce" would be a better name.',
			'You look ridiculous in that uniform. But I bet you\'re probably used to looking ridiculous.',
			'How did you get in the police force? ...You look like you belong in a mental home.'
		},
	}
}


-- Asset Recovery Mission
Settings.assetRecovery = {
	time = 1200000,
	variants = {
		{
			vehicle = "pigalle",
			vehicleLocation = { x = -1041.6690673828, y = -850.52899169922, z = 4.7838535308838, heading = 135.58250427246 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicle = "dominator",
			vehicleLocation = { x = 454.39685058594, y = -1024.5531005859, z = 28.112592697144, heading = 92.917694091797 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicle = "comet2",
			vehicleLocation = { x = 852.61529541016, y = -1280.2347412109, z = 26.133306503296, heading = 359.4150390625 },
			dropOffLocation = { x = 1537.0913085938, y = 6482.6098632813, z = 22.000032424927 },
		},

		{
			vehicle = "feltzer3",
			vehicleLocation = { x = 468.05123901367, y = -65.828109741211, z = 77.158767700195, heading = 238.4743347168 },
			dropOffLocation = { x = 715.486328125, y = 4175.56640625, z = 40.000110626221 },
		},

		{
			vehicle = "blazer",
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
			pedModel = "a_m_y_beachvesp_01",
		},

		{
			location = { x = -1191.2917480469, y = -508.70294189453, z = 35.566139221191 },
			pedModel = "u_m_m_filmdirector",
		},

		{
			location = { x = -175.79162597656, y = -604.76159667969, z = 48.222152709961 },
			pedModel = "s_m_m_highsec_01",
		},

		{
			location = { x = 624.09893798828, y = -3021.7360839844, z = 6.2169780731201 },
			pedModel = "s_m_y_dockwork_01",
		},

		{
			location = { x = -619.80187988281, y = 323.91040039063, z = 82.263603210449 },
			pedModel = "u_m_m_jesus_01",
		},
	},
	weapons = {
		"WEAPON_SPECIALCARBINE",
		"WEAPON_ADVANCEDRIFLE",
		"WEAPON_AUTOSHOTGUN",
		"WEAPON_MINISMG",
		"WEAPON_RPG",
	},
	wantedLevel = 3,
	minReward = 5000,
	maxReward = 10000,
}

-- Crate Drops
Settings.crateDropSettings = {
	cash = 2500,
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
	timeout = 600000,
	notifyBeforeTimeout = 60000,
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
		radius = 16.,
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
		count = 13,
	},
}


-- Skins
Settings.skins = {
	["s_m_y_blackops_01"] = {
		name = "Default",
		kills = 0,
	},



	["csb_anita"] = {
		name = "Anita Mendoza",
		kills = 50,
	},

	["csb_anton"] = {
		name = "Anton Beaudelaire",
		kills = 60,
	},

	["ig_ashley"] = {
		name = "Ashley Butler",
		kills = 70,
	},

	["ig_casey"] = {
		name = "Casey",
		kills = 80,
	},

	["ig_clay"] = {
		name = "Clay Simons",
		kills = 90,
	},

	["cs_debra"] = {
		name = "Debra",
		kills = 100,
	},

	["csb_hugh"] = {
		name = "Hugh Harrison",
		kills = 110,
	},

	["ig_jay_norris"] = {
		name = "Jay Norris",
		kills = 120,
	},

	["cs_johnnyklebitz"] = {
		name = "Johnny Klebitz",
		kills = 130,
	},

	["ig_karen_daniels"] = {
		name = "Karen Daniels",
		kills = 140,
	},

	["ig_natalia"] = {
		name = "Natalia Zverovna",
		kills = 150,
	},

	["ig_ortega"] = {
		name = "Ortega",
		kills = 160,
	},

	["csb_oscar"] = {
		name = "Oscar Guzman",
		kills = 170,
	},

	["ig_dreyfuss"] = {
		name = "Peter Dreyfuss",
		kills = 180,
	},

	["ig_tanisha"] = {
		name = "Tanisha Jackson",
		kills = 190,
	},

	["ig_terry"] = {
		name = "Terry Thorpe",
		kills = 200,
	},



	["ig_andreas"] = {
		name = "Andreas Sanchez",
		kills = 250,
	},

	["ig_taostranslator"] = {
		name = "Cheng's translator",
		kills = 300,
	},

	["ig_denise"] = {
		name = "Denise Clinton",
		kills = 350,
	},

	["ig_oneil"] = {
		name = "Elwood O'Neil",
		kills = 400,
	},

	["ig_fabien"] = {
		name = "Fabien LaRouche",
		kills = 450,
	},

	["ig_floyd"] = {
		name = "Floyd Hebert",
		kills = 500,
	},

	["ig_drfriedlander"] = {
		name = "Isiah Friedlander",
		kills = 550,
	},

	["ig_lazlow"] = {
		name = "Lazlow Jones",
		kills = 600,
	},

	["ig_patricia"] = {
		name = "Patricia Madrazo",
		kills = 650,
	},

	["ig_roccopelosi"] = {
		name = "Rocco Pelosi",
		kills = 700,
	},

	["ig_siemonyetarian"] = {
		name = "Simeon Yetarian",
		kills = 750,
	},

	["ig_taocheng"] = {
		name = "Tao Cheng",
		kills = 800,
	},



	["ig_amandatownley"] = {
		name = "Amanda De Santa",
		kills = 1000,
	},

	["ig_jimmydisanto"] = {
		name = "Jimmy De Santa",
		kills = 1250,
	},

	["ig_tracydisanto"] = {
		name = "Tracey De Santa",
		kills = 1500,
	},

	["ig_brad"] = {
		name = "Brad Snider",
		kills = 1750,
	},

	["ig_stretch"] = {
		name = "Stretch",
		kills = 2000,
	},

	["ig_chengsr"] = {
		name = "Wei Cheng",
		kills = 2250,
	},

	["cs_martinmadrazo"] = {
		name = "Martin Madrazo",
		kills = 2500,
	},

	["ig_solomon"] = {
		name = "Solomon Richards",
		kills = 2750,
	},

	["ig_nervousron"] = {
		name = "Ron Jakowski",
		kills = 3000,
	},

	["ig_wade"] = {
		name = "Wade Hebert",
		kills = 3250,
	},

	["ig_molly"] = {
		name = "Molly Schultz",
		kills = 3500,
	},



	["ig_lestercrest"] = {
		name = "Lester Crest",
		kills = 5500,
	},

	["ig_davenorton"] = {
		name = "Dave Norton",
		kills = 6000,
	},

	["ig_lamardavis"] = {
		name = "Lamar Devis",
		kills = 6500,
	},

	["ig_stevehains"] = {
		name = "Steve Haines",
		kills = 7000,
	},

	["ig_devin"] = {
		name = "Devin Weston",
		kills = 7500,
	},
}

-- Weapon tints
Settings.weaponTints = {
	[0] = {
		name = "Normal",
		kills = 0,
	},

	[1] = {
		name = "Green",
		kills = 50,
	},

	[2] = {
		name = "Gold",
		kills = 250,
	},

	[3] = {
		name = "Pink",
		kills = 500,
	},

	[4] = {
		name = "Army",
		kills = 1000,
	},

	[5] = {
		name = "LSPD",
		kills = 1500,
	},

	[6] = {
		name = "Orange",
		kills = 2000,
	},

	[7] = {
		name = "Platinum",
		kills = 2500,
	},
}
