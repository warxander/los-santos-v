-- https://pastebin.com/7KqdP3vy
Skin = { }

local skins = {
	"a_f_m_beach_01",
	"a_f_m_bevhills_01",
	"a_f_m_bevhills_02",
	"a_f_m_bodybuild_01",
	"a_f_m_business_02",
	"a_f_m_downtown_01",
	"a_f_m_eastsa_01",
	"a_f_m_eastsa_02",
	"a_f_m_fatbla_01",
	"a_f_m_fatcult_01",
	"a_f_m_fatwhite_01",
	"a_f_m_ktown_01",
	"a_f_m_ktown_02",
	"a_f_m_prolhost_01",
	"a_f_m_salton_01",
	"a_f_m_skidrow_01",
	"a_f_m_soucentmc_01",
	"a_f_m_soucent_01",
	"a_f_m_soucent_02",
	"a_f_m_tourist_01",
	"a_f_m_trampbeac_01",
	"a_f_m_tramp_01",
	"a_f_o_genstreet_01",
	"a_f_o_indian_01",
	"a_f_o_ktown_01",
	"a_f_o_salton_01",
	"a_f_o_soucent_01",
	"a_f_o_soucent_02",
	"a_f_y_beach_01",
	"a_f_y_bevhills_01",
	"a_f_y_bevhills_02",
	"a_f_y_bevhills_03",
	"a_f_y_bevhills_04",
	"a_f_y_business_01",
	"a_f_y_business_02",
	"a_f_y_business_03",
	"a_f_y_business_04",
	"a_f_y_eastsa_01",
	"a_f_y_eastsa_02",
	"a_f_y_eastsa_03",
	"a_f_y_epsilon_01",
	"a_f_y_fitness_01",
	"a_f_y_fitness_02",
	"a_f_y_genhot_01",
	"a_f_y_golfer_01",
	"a_f_y_hiker_01",
	"a_f_y_hippie_01",
	"a_f_y_hipster_01",
	"a_f_y_hipster_02",
	"a_f_y_hipster_03",
	"a_f_y_hipster_04",
	"a_f_y_indian_01",
	"a_f_y_juggalo_01",
	"a_f_y_runner_01",
	"a_f_y_rurmeth_01",
	"a_f_y_scdressy_01",
	"a_f_y_skater_01",
	"a_f_y_soucent_01",
	"a_f_y_soucent_02",
	"a_f_y_soucent_03",
	"a_f_y_tennis_01",
	"a_f_y_topless_01",
	"a_f_y_tourist_01",
	"a_f_y_tourist_02",
	"a_f_y_vinewood_01",
	"a_f_y_vinewood_02",
	"a_f_y_vinewood_03",
	"a_f_y_vinewood_04",
	"a_f_y_yoga_01",
	"a_m_m_acult_01",
	"a_m_m_afriamer_01",
	"a_m_m_beach_01",
	"a_m_m_beach_02",
	"a_m_m_bevhills_01",
	"a_m_m_bevhills_02",
	"a_m_m_business_01",
	"a_m_m_eastsa_01",
	"a_m_m_eastsa_02",
	"a_m_m_farmer_01",
	"a_m_m_fatlatin_01",
	"a_m_m_genfat_01",
	"a_m_m_genfat_02",
	"a_m_m_golfer_01",
	"a_m_m_hasjew_01",
	"a_m_m_hillbilly_01",
	"a_m_m_hillbilly_02",
	"a_m_m_indian_01",
	"a_m_m_ktown_01",
	"a_m_m_malibu_01",
	"a_m_m_mexcntry_01",
	"a_m_m_mexlabor_01",
	"a_m_m_og_boss_01",
	"a_m_m_paparazzi_01",
	"a_m_m_polynesian_01",
	"a_m_m_prolhost_01",
	"a_m_m_rurmeth_01",
	"a_m_m_salton_01",
	"a_m_m_salton_02",
	"a_m_m_salton_03",
	"a_m_m_salton_04",
	"a_m_m_skater_01",
	"a_m_m_skidrow_01",
	"a_m_m_socenlat_01",
	"a_m_m_soucent_01",
	"a_m_m_soucent_02",
	"a_m_m_soucent_03",
	"a_m_m_soucent_04",
	"a_m_m_stlat_02",
	"a_m_m_tennis_01",
	"a_m_m_tourist_01",
	"a_m_m_trampbeac_01",
	"a_m_m_tramp_01",
	"a_m_m_tranvest_01",
	"a_m_m_tranvest_02",
	"a_m_o_acult_01",
	"a_m_o_acult_02",
	"a_m_o_beach_01",
	"a_m_o_genstreet_01",
	"a_m_o_ktown_01",
	"a_m_o_salton_01",
	"a_m_o_soucent_01",
	"a_m_o_soucent_02",
	"a_m_o_soucent_03",
	"a_m_o_tramp_01",
	"a_m_y_acult_01",
	"a_m_y_acult_02",
	"a_m_y_beachvesp_01",
	"a_m_y_beachvesp_02",
	"a_m_y_beach_01",
	"a_m_y_beach_02",
	"a_m_y_beach_03",
	"a_m_y_bevhills_01",
	"a_m_y_bevhills_02",
	"a_m_y_breakdance_01",
	"a_m_y_busicas_01",
	"a_m_y_business_01",
	"a_m_y_business_02",
	"a_m_y_business_03",
	"a_m_y_cyclist_01",
	"a_m_y_dhill_01",
	"a_m_y_downtown_01",
	"a_m_y_eastsa_01",
	"a_m_y_eastsa_02",
	"a_m_y_epsilon_01",
	"a_m_y_epsilon_02",
	"a_m_y_gay_01",
	"a_m_y_gay_02",
	"a_m_y_genstreet_01",
	"a_m_y_genstreet_02",
	"a_m_y_golfer_01",
	"a_m_y_hasjew_01",
	"a_m_y_hiker_01",
	"a_m_y_hippy_01",
	"a_m_y_hipster_01",
	"a_m_y_hipster_02",
	"a_m_y_hipster_03",
	"a_m_y_indian_01",
	"a_m_y_jetski_01",
	"a_m_y_juggalo_01",
	"a_m_y_ktown_01",
	"a_m_y_ktown_02",
	"a_m_y_latino_01",
	"a_m_y_methhead_01",
	"a_m_y_mexthug_01",
	"a_m_y_motox_01",
	"a_m_y_motox_02",
	"a_m_y_musclbeac_01",
	"a_m_y_musclbeac_02",
	"a_m_y_polynesian_01",
	"a_m_y_roadcyc_01",
	"a_m_y_runner_01",
	"a_m_y_runner_02",
	"a_m_y_salton_01",
	"a_m_y_skater_01",
	"a_m_y_skater_02",
	"a_m_y_soucent_01",
	"a_m_y_soucent_02",
	"a_m_y_soucent_03",
	"a_m_y_soucent_04",
	"a_m_y_stbla_01",
	"a_m_y_stbla_02",
	"a_m_y_stlat_01",
	"a_m_y_stwhi_01",
	"a_m_y_stwhi_02",
	"a_m_y_sunbathe_01",
	"a_m_y_surfer_01",
	"a_m_y_vindouche_01",
	"a_m_y_vinewood_01",
	"a_m_y_vinewood_02",
	"a_m_y_vinewood_03",
	"a_m_y_vinewood_04",
	"a_m_y_yoga_01",
	"csb_abigail",
	"csb_anton",
	"csb_ballasog",
	"csb_burgerdrug",
	"csb_car3guy1",
	"csb_car3guy2",
	"csb_chef",
	"csb_chin_goon",
	"csb_cletus",
	"csb_cop",
	"csb_denise_friend",
	"csb_fos_rep",
	"csb_g",
	"csb_grove_str_dlr",
	"csb_hao",
	"csb_hugh",
	"csb_imran",
	"csb_janitor",
	"csb_maude",
	"csb_mweather",
	"csb_ortega",
	"csb_oscar",
	"csb_porndudes",
	"csb_prologuedriver",
	"csb_prolsec",
	"csb_ramp_hic",
	"csb_ramp_hipster",
	"csb_ramp_marine",
	"csb_ramp_mex",
	"csb_reporter",
	"csb_roccopelosi",
	"csb_screen_writer",
	"csb_trafficwarden",
}


function Skin.GetSkins()
	return skins
end


function Skin.ChangePlayerSkin(model)
	RequestModel(model)

	-- load the model for this spawn
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
	end

	local weapons = Player.GetPlayerWeapons()
	local health = GetEntityHealth(GetPlayerPed(-1))
	local armor = GetPedArmour(GetPlayerPed(-1))
	local isHasParachute = HasPedGotWeapon(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), false)

	SetPlayerModel(PlayerId(), model)

	Player.skin = model
	Player.GiveWeaponsToPlayer(weapons)
	SetPedArmour(GetPlayerPed(-1), armor)
	SetEntityHealth(GetPlayerPed(-1), health)

	if Settings.giveParachuteAtSpawn then
		if isHasParachute then
			GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 1, false, false)
		end
	end

	SetModelAsNoLongerNeeded(model)
end