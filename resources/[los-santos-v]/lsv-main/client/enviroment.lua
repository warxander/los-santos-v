RegisterNetEvent('lsv:weatherUpdated')
AddEventHandler('lsv:weatherUpdated', function(weather)
	ClearOverrideWeather()
	SetOverrideWeather(weather)

	local isSnow = weather == 'XMAS'
	SetForceVehicleTrails(isSnow)
	SetForcePedFootstepsTracks(isSnow)
end)


Citizen.CreateThread(function()
	local vehiclesToDelete = { }

	while true do
		Citizen.Wait(100)

		local handle, vehicle = FindFirstVehicle()
		if handle ~= -1 then
			local finished = false
			repeat
				local modelHash = GetEntityModel(vehicle)
				if table.find_if(Settings.world.blacklistVehicles, function(model) return modelHash == GetHashKey(model) end) then
					table.insert(vehiclesToDelete, vehicle)
					break
				end
				finished, vehicle = FindNextVehicle(handle)
			until not finished
		end
		EndFindVehicle(handle)

		Citizen.Wait(1) --amortize performance

		for i = #vehiclesToDelete, 1, -1 do
			if DoesEntityExist(vehiclesToDelete[i]) then
				NetworkRequestControlOfEntity(vehiclesToDelete[i])
				SetEntityAsMissionEntity(vehiclesToDelete[i], true, true)
				DeleteVehicle(vehiclesToDelete[i])
			end

			table.remove(vehiclesToDelete, i)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		NetworkOverrideClockTime(NetworkGetServerTime())
	end
end)


Citizen.CreateThread(function()
	RequestIpl('chop_props')
	RequestIpl('FIBlobby')
	RemoveIpl('FIBlobbyfake')
	RequestIpl('FBI_colPLUG')
	RequestIpl('FBI_repair')
	RequestIpl('v_tunnel_hole')
	RequestIpl('TrevorsMP')
	RequestIpl('TrevorsTrailer')
	RequestIpl('TrevorsTrailerTidy')
	RemoveIpl('farm_burnt')
	RemoveIpl('farm_burnt_lod')
	RemoveIpl('farm_burnt_props')
	RemoveIpl('farmint_cap')
	RemoveIpl('farmint_cap_lod')
	RequestIpl('farm')
	RequestIpl('farmint')
	RequestIpl('farm_lod')
	RequestIpl('farm_props')
	RequestIpl('facelobby')
	RemoveIpl('CS1_02_cf_offmission')
	RequestIpl('CS1_02_cf_onmission1')
	RequestIpl('CS1_02_cf_onmission2')
	RequestIpl('CS1_02_cf_onmission3')
	RequestIpl('CS1_02_cf_onmission4')
	RequestIpl('v_rockclub')
	RequestIpl('v_janitor')
	RemoveIpl('hei_bi_hw1_13_door')
	RequestIpl('bkr_bi_hw1_13_int')
	RequestIpl('ufo')
	RequestIpl('ufo_lod')
	RequestIpl('ufo_eye')
	RemoveIpl('v_carshowroom')
	RemoveIpl('shutter_open')
	RemoveIpl('shutter_closed')
	RemoveIpl('shr_int')
	RequestIpl('csr_afterMission')
	RequestIpl('v_carshowroom')
	RequestIpl('shr_int')
	RequestIpl('shutter_closed')
	RequestIpl('smboat')
	RequestIpl('smboat_distantlights')
	RequestIpl('smboat_lod')
	RequestIpl('smboat_lodlights')
	RequestIpl('cargoship')
	RequestIpl('railing_start')
	RemoveIpl('sp1_10_fake_interior')
	RemoveIpl('sp1_10_fake_interior_lod')
	RequestIpl('sp1_10_real_interior')
	RequestIpl('sp1_10_real_interior_lod')
	RemoveIpl('id2_14_during_door')
	RemoveIpl('id2_14_during1')
	RemoveIpl('id2_14_during2')
	RemoveIpl('id2_14_on_fire')
	RemoveIpl('id2_14_post_no_int')
	RemoveIpl('id2_14_pre_no_int')
	RemoveIpl('id2_14_during_door')
	RequestIpl('id2_14_during1')
	RemoveIpl('Coroner_Int_off')
	RequestIpl('coronertrash')
	RequestIpl('Coroner_Int_on')
	RemoveIpl('bh1_16_refurb')
	RemoveIpl('jewel2fake')
	RemoveIpl('bh1_16_doors_shut')
	RequestIpl('refit_unload')
	RequestIpl('post_hiest_unload')
	RequestIpl('Carwash_with_spinners')
	RequestIpl('KT_CarWash')
	RequestIpl('ferris_finale_Anim')
	RemoveIpl('ch1_02_closed')
	RequestIpl('ch1_02_open')
	RequestIpl('AP1_04_TriAf01')
	RequestIpl('CS2_06_TriAf02')
	RequestIpl('CS4_04_TriAf03')
	RemoveIpl('scafstartimap')
	RequestIpl('scafendimap')
	RemoveIpl('DT1_05_HC_REMOVE')
	RequestIpl('DT1_05_HC_REQ')
	RequestIpl('DT1_05_REQUEST')
	RequestIpl('FINBANK')
	RemoveIpl('DT1_03_Shutter')
	RemoveIpl('DT1_03_Gr_Closed')

	RequestIpl('golfflags')
	RequestIpl('airfield')
	RequestIpl('v_garages')
	RequestIpl('v_foundry')
	RequestIpl('hei_yacht_heist')
	RequestIpl('hei_yacht_heist_Bar')
	RequestIpl('hei_yacht_heist_Bedrm')
	RequestIpl('hei_yacht_heist_Bridge')
	RequestIpl('hei_yacht_heist_DistantLights')
	RequestIpl('hei_yacht_heist_enginrm')
	RequestIpl('hei_yacht_heist_LODLights')
	RequestIpl('hei_yacht_heist_Lounge')

	RequestIpl('hei_carrier')
	RequestIpl('hei_Carrier_int1')
	RequestIpl('hei_Carrier_int2')
	RequestIpl('hei_Carrier_int3')
	RequestIpl('hei_Carrier_int4')
	RequestIpl('hei_Carrier_int5')
	RequestIpl('hei_Carrier_int6')
	RequestIpl('hei_carrier_LODLights')

	RequestIpl('bkr_bi_id1_23_door')
	RequestIpl('lr_cs6_08_grave_closed')
	RequestIpl('hei_sm_16_interior_v_bahama_milo_')
	RequestIpl('CS3_07_MPGates')
	RequestIpl('cs5_4_trains')
	RequestIpl('v_lesters')
	RequestIpl('v_trevors')
	RequestIpl('v_michael')
	RequestIpl('v_comedy')
	RequestIpl('v_cinema')
	RequestIpl('V_Sweat')
	RequestIpl('V_35_Fireman')

	RequestIpl('redCarpet')
	RequestIpl('triathlon2_VBprops')
	RequestIpl('jetstealtunnel')
	RequestIpl('Jetsteal_ipl_grp1')

	RequestIpl('v_hospital')
	RemoveIpl('RC12B_Default')
	RemoveIpl('RC12B_Fixed')
	RequestIpl('RC12B_Destroyed')
	RequestIpl('RC12B_HospitalInterior')
end)
