init()
{
	//thread petx\_settings::init();

	precache_mod();

	thread petx\_teams::init();
	thread petx\_class::init();
	thread petx\_weapons::init();
	thread petx\_rounds::init();
	thread petx\_upoint::init();
	thread petx\_logo::init();
	thread petx\_ammo::init();
	thread petx\_sound::init();	
	thread petx\_hud_menu::init();
	thread petx\_shop::init();
	thread petx\_admins::init();
	thread petx\_afk::init();
	thread petx\_speciality::init();
	thread petx\_info::init();
	thread fixbug();
}

precache_mod()
{
	//****************Modely*********************//

	//class2 jumper - fast
	precacheModel("body_mp_sas_urban_support");
	precacheModel("viewhands_black_kit");
	
	//class4 jumper - armored
	precacheModel("body_complete_mp_russian_farmer");
	
	//class5 jumper - medic
	precacheModel("body_complete_mp_velinda_desert");
	
	//class3 lovec - price(pison)
	precacheModel("body_mp_usmc_engineer");
	precacheModel("viewmodel_base_viewhands");

	//class1 jumper - normal
	precacheModel("body_mp_arab_regular_sniper");
	precacheModel("head_mp_arab_regular_sadiq");
	precacheModel("viewhands_desert_opfor");
	
	/*
	precacheModel("body_mp_usmc_woodland_sniper");
	precacheModel("head_mp_usmc_ghillie");*/
	precacheModel("viewhands_marine_sniper");	
	
	
	//speciality class jumper
	precacheModel("playermodel_dnf_duke");
	precacheModel("viewhands_dnf_duke");

	//lovec 1.2.
	precacheModel("body_mp_usmc_woodland_support");
	precacheModel("head_mp_usmc_shaved_head");
	precacheModel("viewhands_sas_woodland");	
	
	//lovec 5. - speciality
	precacheModel("body_mp_usmc_woodland_specops");
	precacheModel("head_mp_usmc_tactical_mich_stripes_nomex");
	
	//lovec 3.4. -armored, electric
	precacheModel("body_mp_usmc_rifleman");
	
	//class3 jumper - secret
	precacheModel("body_mp_opforce_sniper");
	precacheModel("head_mp_opforce_ghillie");
	
	//shop,box
	precacheModel("com_vending_bottle");
	precacheModel("com_plasticcase_beige_big");

	precacheModel("ch_sign_noentry");
	
	//zbrane
	//precacheItem( "frag_grenade_mp" );
	//precacheItem("magnum_mw2_mp");
	
	//****************Materialy*****************//
	precacheShader("faction_128_sas");
	precacheShader("faction_128_arab");
	precacheShader("info_fast");
	precacheShader("info_camper");
	precacheShader("info_score");

	precacheShader("shop_icon");
	precacheShader("shop_box_icon");
	
	precacheShader("logo_jumper");
	precacheShader("logo_lovec");
	precacheShader("invisible_hud");
	
	//****************Efekty*********************//
	
	level._effect[ "speed" ] = loadfx( "speed" );
	level._effect[ "smoke_poison" ] = loadfx( "poison" );
	level._effect[ "smoke_repel" ] = loadfx( "repelent" );
	level._effect[ "shop_glow" ] = loadfx( "misc/ui_pickup_available_down" );
	level._effect[ "player_explode" ] = loadfx( "explosions/aa_explosion" );
	level._effect[ "blesk" ] = loadfx( "laser" );
	
	//*************Shellshock - "motanie palice" - copyright Col!ar xD***************//
	
	precacheShellShock( "rpg_mp" );
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	//*********************Globalne Premenne***************************************************//
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	if (!isdefined(game["first_round"]))
		game["first_round"] = true;
	if (!isdefined(game["aktualround"]))
	{
		game["aktualround"] = 1;
	}	
	if (!isdefined(game["jumperscore"]))
	{
		game["jumperscore"] = 0;
		setdvar ("ui_jumper_score", "0");
	}	
	else
		setdvar ("ui_jumper_score", game["jumperscore"]);
		
	if (!isdefined(game["hunterscore"]))
	{
		game["hunterscore"] = 0;	
		setdvar ("ui_hunter_score", "0");
	}	
	else
		setdvar ("ui_hunter_score", game["hunterscore"]);
	
	//***********Zapnutie hudu*******************//
	setdvar ("ui_hud_hardcore", "0");
	
	
	level.end_round_go = false;
	level.onehunter = false;
}


///////////////////////////fixuje bugy//////////////////////////

fixbug()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread spawn();
	}	
}

spawn()
{
	for(;;)
	{
		self waittill("spawned_player");
		self thread maps\mp\gametypes\_missions::playerSpawned();
	}	
}