init()
{
	thread sets_value();
}
 
/*
// ---------- ---------- ---------- ---------- ---------- ---------- ---------- //
// ---------- Config --- ---------- ---------- ---------- ---------- ---------- //
// ---------- ---------- ---------- ---------- ---------- ---------- ---------- //
// ---------- Moznost menit zakladne udaje!! - ---------- ---------- ---------- //
// ---------- ---------- ---------- ---------- ---------- ---------- ---------- //
// ---------- Aktualizuje sa pri nacitani novej mapy!! -- ---------- ---------- //
// ---------- ---------- ---------- ---------- ---------- ---------- ---------- //
// ---------- za riadkom je vzdy zakomentovana default hodnota... -- ---------- //
// ---------- nestanovenie niektorej premennej môze spôsobit pad serveru!! ---- //
// ---------- ---------- ---------- ---------- ---------- ---------- ---------- //
*/
sets_value()
{
	level.petx_point_kill = 40; //body za zabitie hraca(ubody,score,XP) //50
	level.petx_point_headshot = 20; //body za headku(ubody,score,XP) //80
	level.petx_point_life = 20;  //body za zitie ako jumper (ubody,score,XP) //10
	level.petx_bonus_point = 10;  //bonusove body na konci kola(dlzka hrania vydelena touto hodnotou), berie do uvahy aj team hraca, a kto vyhral kolo... //3 
	level.petx_point_damage = 2; //damage udeleny hracovi / touto hodnotou = body
	
	level.petx_time_limit = 5; //dlzka kola v minutach //3-5
	level.petx_time_lovec = 30;  //cas, za ktory sa vyberie lovec/lovci v sekundach //20-60
	level.petx_lovec_speed = 1;  //pridana rychlost pre lovcov //2
	level.petx_round_limit = 6; //pocet kol //10
	
	level.tk_axis = false;  //teamkill lovcov
	level.tk_allies = true; //teamkill jumperov
	
	level.petx_jump_dmg = 0; //damage pad: 0 - vypnute, 1 - zapnute, 2 - polovicna //2
	
	////**********************
	//// Ceny v shope!!!
	////**********************
	
	level.shop_price_skin = 1; //20
	level.shop_price_speed = 80; //80
	level.shop_price_repelent = 100; //100
	level.shop_price_neviditelnost = 150; //150
	level.shop_price_teleport = 150; //150
	level.shop_price_freeze = 150; //150
	
	level.shop_price_flash = 30; //30
	level.shop_price_granat = 50; //50
	level.shop_price_claymore = 100; //100
	level.shop_price_c4 = 180; //150
	
	level.shop_price_health = 40; //50
	level.shop_price_repnad = 100; //100
	level.shop_price_allies_radar = 80; //150
	level.shop_price_axis_radar = 150; //200
}