init()
{
	SetAllClass();
	
	thread Onplayerconnect();
}
 
Onplayerconnect()
{
	while(1)
	{
		level waittill("connected",player);
		
		player.class_add_speed = false;
		player.class_bdamage = false;
		player.class_shield = false;
		player.electric_timer = 0;
		
		player thread Stat_debug();
		player thread OnSpawnPlayer();
		
		player thread SendDvars();
		//player thread GetSpecialClassStat();
		
		player thread WaittillChangeSpecialClass();
	}
}
 
OnSpawnPlayer()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("spawned_player");
		
		self thread Active_Respawn();
		
		if(self.class_special == "explode")
			self thread explode_player();
		
		if(self.class_special == "poison")
			self thread smoke_poison();
			
		if(self.class_special == "medic")
			self thread medic_init();	

		if(self.class_special == "electric")	
		{
			self thread electric_timer();
			
		}
		
		//self thread WaittillChangeSpecialClass();
		//self thread SetSpecialClassStat();
	}
 
}

SetAllClass()
{
	level.sak_class = [];
	
	//**************** ALLIES - JUMPERI ****************//
	//**************************************************//
	//******************** CLASS 1 *********************//
	//**************************************************//
	
	//zbran
	level.sak_class["class1_jumper"]["weapon"] = "beretta_mp";
	//model hraca
	level.sak_class["class1_jumper"]["playermodel"] = "body_mp_arab_regular_sniper";
	level.sak_class["class1_jumper"]["playerhead"] = "head_mp_arab_regular_sadiq";
	level.sak_class["class1_jumper"]["playerhands"] = "viewhands_desert_opfor";
	//rychlost, zdravie
	level.sak_class["class1_jumper"]["speed"] = 100;
	level.sak_class["class1_jumper"]["health"] = 100;
	//perky
	level.sak_class["class1_jumper"]["perk1"] = undefined;
	level.sak_class["class1_jumper"]["perk2"] = undefined;
	level.sak_class["class1_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class1_jumper"]["speciality"] = "back-damage"; 
	//level
	level.sak_class["class1_jumper"]["lvl"] = 0; //0
	
	//******************** CLASS 2 *********************//
	//**************************************************//
	
	//zbran
	level.sak_class["class2_jumper"]["weapon"] = "usp_mp";
	//model hraca
	level.sak_class["class2_jumper"]["playermodel"] = "body_mp_sas_urban_support";
	level.sak_class["class2_jumper"]["playerhead"] = undefined;
	level.sak_class["class2_jumper"]["playerhands"] = "viewhands_black_kit";
	//rychlost, zdravie
	level.sak_class["class2_jumper"]["speed"] = 120;
	level.sak_class["class2_jumper"]["health"] = 80;
	//perky
	level.sak_class["class2_jumper"]["perk1"] = undefined;
	level.sak_class["class2_jumper"]["perk2"] = undefined;
	level.sak_class["class2_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class2_jumper"]["speciality"] = "shield";
	//level
	level.sak_class["class2_jumper"]["lvl"] = 15; //15
	
	//******************** CLASS 3 *********************//
	//**************************************************//
	
	//zbran
	level.sak_class["class3_jumper"]["weapon"] = "usp_silencer_mp";
	//model hraca
	level.sak_class["class3_jumper"]["playermodel"] = "body_mp_opforce_sniper";
	level.sak_class["class3_jumper"]["playerhead"] = "head_mp_opforce_ghillie";
	level.sak_class["class3_jumper"]["playerhands"] = "viewhands_marine_sniper";
	//rychlost, zdravie
	level.sak_class["class3_jumper"]["speed"] = 110;
	level.sak_class["class3_jumper"]["health"] = 100;
	//perky
	level.sak_class["class3_jumper"]["perk1"] = "specialty_gpsjammer";
	level.sak_class["class3_jumper"]["perk2"] = "specialty_quieter";
	level.sak_class["class3_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class3_jumper"]["speciality"] = "energy_drink"; //ok, porovnat rychlost s utocnikom
	//level
	level.sak_class["class3_jumper"]["lvl"] = 35; //35
	
	//******************** CLASS 4 *********************//
	//**************************************************//
	
	//zbran
	level.sak_class["class4_jumper"]["weapon"] = "deserteagle_mp";
	//model hraca
	level.sak_class["class4_jumper"]["playermodel"] = "body_complete_mp_russian_farmer";
	level.sak_class["class4_jumper"]["playerhead"] = undefined;
	level.sak_class["class4_jumper"]["playerhands"] = "viewmodel_base_viewhands";
	//rychlost, zdravie
	level.sak_class["class4_jumper"]["speed"] = 90;
	level.sak_class["class4_jumper"]["health"] = 200;
	//perky
	level.sak_class["class4_jumper"]["perk1"] = undefined;
	level.sak_class["class4_jumper"]["perk2"] = undefined;
	level.sak_class["class4_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class4_jumper"]["speciality"] = "explode"; //na mieste hraca vyvola exploziu po jeho smrti a poskodi opacny team v jeho dosahu
	level.sak_class["class4_jumper"]["lvl"] = 50; //50
	
	//******************** CLASS 5 *********************//
	//**************************************************//
	
	//zbran
	level.sak_class["class5_jumper"]["weapon"] = "deserteaglegold_mp";
	//model hraca
	level.sak_class["class5_jumper"]["playermodel"] = "body_complete_mp_velinda_desert";
	level.sak_class["class5_jumper"]["playerhead"] = undefined;
	level.sak_class["class5_jumper"]["playerhands"] = "viewmodel_base_viewhands";
	//rychlost, zdravie
	level.sak_class["class5_jumper"]["speed"] = 100;
	level.sak_class["class5_jumper"]["health"] = 150;
	//perky
	level.sak_class["class5_jumper"]["perk1"] = undefined;
	level.sak_class["class5_jumper"]["perk2"] = undefined;
	level.sak_class["class5_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class5_jumper"]["speciality"] = "medic";
	//level
	level.sak_class["class5_jumper"]["lvl"] = 80; //80
	
	//******************** CLASS 6 - SPECIAL *********************//
	//************************************************************//
	
	//zbran
	level.sak_class["class6_jumper"]["weapon"] = "beretta_silencer_mp"; //magnum mw2 model
	//model hraca
	level.sak_class["class6_jumper"]["playermodel"] = "playermodel_dnf_duke"; //duke-nuken
	level.sak_class["class6_jumper"]["playerhead"] = undefined;
	level.sak_class["class6_jumper"]["playerhands"] = "viewhands_dnf_duke";
	//rychlost, zdravie
	level.sak_class["class6_jumper"]["speed"] = 110;
	level.sak_class["class6_jumper"]["health"] = 110;
	//perky
	level.sak_class["class6_jumper"]["perk1"] = undefined;
	level.sak_class["class6_jumper"]["perk2"] = undefined;
	level.sak_class["class6_jumper"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class6_jumper"]["speciality"] = undefined;
	//level
	level.sak_class["class6_jumper"]["lvl"] = 100; //100
	
	
	
	//**************************************************//
	//***************** AXIS - LOVCI *******************//
	//**************************************************//
	
	/*precacheModel("body_mp_usmc_woodland_support");
	precacheModel("head_mp_usmc_shaved_head");
	precacheModel("viewhands_sas_woodland");*/
	
	//******************** CLASS 1 *********************//
	//**************************************************//
	
	//knife damage
	level.sak_class["class1_lovec"]["damage"] = 30;
	//zbran
	level.sak_class["class1_lovec"]["weapon"] = "colt45_mp";
	//model hraca
	level.sak_class["class1_lovec"]["playermodel"] = "body_mp_usmc_woodland_support"; 
	level.sak_class["class1_lovec"]["playerhead"] = "head_mp_usmc_shaved_head";
	level.sak_class["class1_lovec"]["playerhands"] = "viewhands_sas_woodland";
	//rychlost, zdravie
	level.sak_class["class1_lovec"]["speed"] = 100;
	level.sak_class["class1_lovec"]["health"] = 100;
	//perky
	level.sak_class["class1_lovec"]["perk1"] = undefined;
	level.sak_class["class1_lovec"]["perk2"] = undefined;
	level.sak_class["class1_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class1_lovec"]["speciality"] = "respawn";	
	//level
	level.sak_class["class1_lovec"]["lvl"] = 0; //0
	
	//******************** CLASS 2 *********************//
	//**************************************************//
	
	//knife damage
	level.sak_class["class2_lovec"]["damage"] = 20;
	//zbran
	level.sak_class["class2_lovec"]["weapon"] = "colt45_mp";
	//model hraca
	level.sak_class["class2_lovec"]["playermodel"] = "body_mp_usmc_woodland_support";
	level.sak_class["class2_lovec"]["playerhead"] = "head_mp_usmc_shaved_head";
	level.sak_class["class2_lovec"]["playerhands"] = "viewhands_sas_woodland";
	//rychlost, zdravie
	level.sak_class["class2_lovec"]["speed"] = 120;
	level.sak_class["class2_lovec"]["health"] = 80;
	//perky
	level.sak_class["class2_lovec"]["perk1"] = undefined;
	level.sak_class["class2_lovec"]["perk2"] = undefined;
	level.sak_class["class2_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class2_lovec"]["speciality"] = "none"; //magnet, ktory pritahuje opacny team(hmm...)
	//level
	level.sak_class["class2_lovec"]["lvl"] = 15; //15
	
	//******************** CLASS 3 *********************//
	//**************************************************//
	
	//knife damage
	level.sak_class["class3_lovec"]["damage"] = 30;
	//zbran
	level.sak_class["class3_lovec"]["weapon"] = "colt45_mp";
	//model hraca
	level.sak_class["class3_lovec"]["playermodel"] = "body_mp_usmc_engineer";
	level.sak_class["class3_lovec"]["playerhead"] = undefined;
	level.sak_class["class3_lovec"]["playerhands"] = "viewmodel_base_viewhands";
	//rychlost, zdravie
	level.sak_class["class3_lovec"]["speed"] = 110;
	level.sak_class["class3_lovec"]["health"] = 100;
	//perky
	level.sak_class["class3_lovec"]["perk1"] = undefined;
	level.sak_class["class3_lovec"]["perk2"] = undefined;
	level.sak_class["class3_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class3_lovec"]["speciality"] = "poison";
	//level
	level.sak_class["class3_lovec"]["lvl"] = 25; //35
	
	//******************** CLASS 4 *********************//
	//**************************************************//
	
	//knife damage
	level.sak_class["class4_lovec"]["damage"] = 50;
	//zbran
	level.sak_class["class4_lovec"]["weapon"] = "colt45_mp"; //colt45 model+new knife
	//model hraca
	level.sak_class["class4_lovec"]["playermodel"] = "body_mp_usmc_rifleman";
	level.sak_class["class4_lovec"]["playerhead"] = undefined;
	level.sak_class["class4_lovec"]["playerhands"] = "viewmodel_base_viewhands";
	//rychlost, zdravie
	level.sak_class["class4_lovec"]["speed"] = 90;
	level.sak_class["class4_lovec"]["health"] = 200;
	//perky
	level.sak_class["class4_lovec"]["perk1"] = undefined;
	level.sak_class["class4_lovec"]["perk2"] = undefined;
	level.sak_class["class4_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class4_lovec"]["speciality"] = "anti-repel";
	//level
	level.sak_class["class4_lovec"]["lvl"] = 50; //50
	
	//******************** CLASS 5 *********************//
	//**************************************************//
	
	// medic or electric?? tot otazka :-)
	
	//knife damage
	level.sak_class["class5_lovec"]["damage"] = 30;
	//zbran
	level.sak_class["class5_lovec"]["weapon"] = "colt45_mp";
	//model hraca
	level.sak_class["class5_lovec"]["playermodel"] = "body_mp_usmc_rifleman";
	level.sak_class["class5_lovec"]["playerhead"] = undefined;
	level.sak_class["class5_lovec"]["playerhands"] = "viewmodel_base_viewhands";
	//rychlost, zdravie
	level.sak_class["class5_lovec"]["speed"] = 110;
	level.sak_class["class5_lovec"]["health"] = 100;
	//perky
	level.sak_class["class5_lovec"]["perk1"] = "specialty_detectexplosive";
	level.sak_class["class5_lovec"]["perk2"] = undefined;
	level.sak_class["class5_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class5_lovec"]["speciality"] = "electric"; //electric - pri priblizeni k hracovi udeli el. sok, taktiez aj knife..
	//level
	level.sak_class["class5_lovec"]["lvl"] = 80; //80
	
	//******************** CLASS 6 - SPECIAL *********************//
	//************************************************************//
	
	//knife damage
	level.sak_class["class6_lovec"]["damage"] = 30;
	//zbran
	level.sak_class["class6_lovec"]["weapon"] = "colt45_mp";
	//model hraca
	level.sak_class["class6_lovec"]["playermodel"] = "body_mp_usmc_woodland_specops";
	level.sak_class["class6_lovec"]["playerhead"] = "head_mp_usmc_tactical_mich_stripes_nomex";
	level.sak_class["class6_lovec"]["playerhands"] = "viewhands_sas_woodland";
	//rychlost, zdravie
	level.sak_class["class6_lovec"]["speed"] = 110;
	level.sak_class["class6_lovec"]["health"] = 110;
	//perky
	level.sak_class["class6_lovec"]["perk1"] = undefined;
	level.sak_class["class6_lovec"]["perk2"] = undefined;
	level.sak_class["class6_lovec"]["perk3"] = undefined;
	//specialna vlastnost
	level.sak_class["class6_lovec"]["speciality"] = undefined;	
	//level
	level.sak_class["class6_lovec"]["lvl"] = 100;	//100
}

SendDvars()
{
	self setclientdvars(
	"ui_allies_class1_speed" , level.sak_class["class1_jumper"]["speed"],
	"ui_allies_class1_health" , level.sak_class["class1_jumper"]["health"],
	"ui_allies_class1_lvl" , level.sak_class["class1_jumper"]["lvl"],
	
	"ui_allies_class2_speed" , level.sak_class["class2_jumper"]["speed"],
	"ui_allies_class2_health" , level.sak_class["class2_jumper"]["health"],
	"ui_allies_class2_lvl" , level.sak_class["class2_jumper"]["lvl"],

	"ui_allies_class3_speed" , level.sak_class["class3_jumper"]["speed"],
	"ui_allies_class3_health" , level.sak_class["class3_jumper"]["health"],
	"ui_allies_class3_lvl" , level.sak_class["class3_jumper"]["lvl"],

	"ui_allies_class4_speed" , level.sak_class["class4_jumper"]["speed"],
	"ui_allies_class4_health" , level.sak_class["class4_jumper"]["health"],
	"ui_allies_class4_lvl" , level.sak_class["class4_jumper"]["lvl"],

	"ui_allies_class5_speed" , level.sak_class["class5_jumper"]["speed"],
	"ui_allies_class5_health" , level.sak_class["class5_jumper"]["health"],
	"ui_allies_class5_lvl" , level.sak_class["class5_jumper"]["lvl"],

	"ui_allies_class6_speed" , level.sak_class["class6_jumper"]["speed"],
	"ui_allies_class6_health" , level.sak_class["class6_jumper"]["health"],
	"ui_allies_class6_lvl" , level.sak_class["class6_jumper"]["lvl"],

	"ui_axis_class1_speed" , level.sak_class["class1_lovec"]["speed"],
	"ui_axis_class1_health" , level.sak_class["class1_lovec"]["health"],
	"ui_axis_class1_lvl" , level.sak_class["class1_lovec"]["lvl"],	
	"ui_axis_class1_damage" , level.sak_class["class1_lovec"]["damage"],
	
	"ui_axis_class2_speed" , level.sak_class["class2_lovec"]["speed"],
	"ui_axis_class2_health" , level.sak_class["class2_lovec"]["health"],
	"ui_axis_class2_lvl" , level.sak_class["class2_lovec"]["lvl"],	
	"ui_axis_class2_damage" , level.sak_class["class2_lovec"]["damage"],

	"ui_axis_class3_speed" , level.sak_class["class3_lovec"]["speed"],
	"ui_axis_class3_health" , level.sak_class["class3_lovec"]["health"],
	"ui_axis_class3_lvl" , level.sak_class["class3_lovec"]["lvl"],	
	"ui_axis_class3_damage" , level.sak_class["class3_lovec"]["damage"],

	"ui_axis_class4_speed" , level.sak_class["class4_lovec"]["speed"],
	"ui_axis_class4_health" , level.sak_class["class4_lovec"]["health"],
	"ui_axis_class4_lvl" , level.sak_class["class4_lovec"]["lvl"],	
	"ui_axis_class4_damage" , level.sak_class["class4_lovec"]["damage"]

	);
	
	self setclientdvars(
	"ui_axis_class5_speed" , level.sak_class["class5_lovec"]["speed"],
	"ui_axis_class5_health" , level.sak_class["class5_lovec"]["health"],
	"ui_axis_class5_lvl" , level.sak_class["class5_lovec"]["lvl"],	
	"ui_axis_class5_damage" , level.sak_class["class5_lovec"]["damage"],

	"ui_axis_class6_speed" , level.sak_class["class6_lovec"]["speed"],
	"ui_axis_class6_health" , level.sak_class["class6_lovec"]["health"],
	"ui_axis_class6_lvl" , level.sak_class["class6_lovec"]["lvl"],	
	"ui_axis_class6_damage" , level.sak_class["class6_lovec"]["damage"]
	);
	
	//self setclientdvar("player_sprintTime", 50);
	
}

Stat_debug()
{
	self endon("disconnect");

	while(1)
	{
		wait 2;
		
		stat = self getStat(271);
		if(isdefined(stat))
			self iprintln("stat 271: "+stat);
	}
}

WaittillChangeSpecialClass()
{
	self endon("disconnect");

	value = self maps\mp\gametypes\_persistence::statGet( "speciality_allies" );
	value1 = self maps\mp\gametypes\_persistence::statGet( "speciality_axis" );
	self setclientdvar("ui_class_attribute_allies", GetClassAttributeName(value,"allies",true), "ui_class_attribute_axis", GetClassAttributeName(value1,"axis",true));
	
	while(1)
	{
		self waittill("menuresponse", menu, response);
		
		//self iprintln("response: "+response);
		
		string = StrTok(response, "_");
			
		if(isdefined(string[0]) && (string[0] == "classattributejumper" || string[0] == "classattributelovec")&& isdefined(string[1]) && int(string[1]) > 0 && int(string[1]) < 6)
		{				
			attribute = int(string[1]);
			
			self iprintln("attribute: "+attribute);
			
			team = "allies";
			
			if(string[0] == "classattributejumper")
				team = "allies";
			else if(string[0] == "classattributelovec")
				team = "axis";
			
			self iprintln("menu: "+menu+" team: "+team);
			
			self SetSpecialClassStat(team,attribute);
		}
	}
}

GetSpecialClassStat(team)
{
	if(!isdefined(self.class_spec_stat))
		self.class_spec_stat = [];
	
	self.class_spec_stat[team] = self maps\mp\gametypes\_persistence::statGet( "speciality_"+team );
	
	attribute = int(self.class_spec_stat[team]);
	
	if(!isdefined(attribute) || attribute > 5 || attribute < 1)
		attribute = 1;
	
	return GetClassAttributeName(attribute,team);
}

GetClassAttributeName(attribute,team,menu)
{
	if(!isdefined(menu))
	{
		if(team == "allies")
		{
			if(attribute == 1)
				attribute = "back-damage";
			else if(attribute == 2)
				attribute = "shield";
			else if(attribute == 3)
				attribute = "energy_drink";		
			else if(attribute == 4)
				attribute = "explode";
			else
				attribute = "medic";
		}
		else if(team == "axis")
		{
			if(attribute == 1)
				attribute = "respawn";
			else if(attribute == 2)
				attribute = "none";
			else if(attribute == 3)
				attribute = "poison";		
			else if(attribute == 4)
				attribute = "anti-repel";
			else
				attribute = "electric";		
		}
	}
	
	if(isdefined(menu)&&menu)
	{
		if(team == "allies")
		{
			if(attribute == 1)
				attribute = "Back-Damage";
			else if(attribute == 2)
				attribute = "FF Shield";
			else if(attribute == 3)
				attribute = "Energy Drink";		
			else if(attribute == 4)
				attribute = "Explode";
			else
				attribute = "Medic";
		}
		else if(team == "axis")
		{
			if(attribute == 1)
				attribute = "Respawn";
			else if(attribute == 2)
				attribute = "none";
			else if(attribute == 3)
				attribute = "Poison";		
			else if(attribute == 4)
				attribute = "Anti-Repel";
			else
				attribute = "Electric";		
		}	
	}
	
	return attribute;
}

SetSpecialClassStat(team,value)
{
	self maps\mp\gametypes\_persistence::statSet( "speciality_"+team, value );
	
	self setclientdvar("ui_class_attribute_"+team, GetClassAttributeName(value,team,true));
	
	self.class_spec_stat[team] = value;
}

OnPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(eAttacker) && isplayer(eAttacker) && isalive(eAttacker) && isdefined(eAttacker.pers["team"]) && eAttacker.pers["team"] == "axis") //nastavenie damagu knifu podla classu
	{
		for(i = 1;i < 7;i++)
		{
			if(sWeapon == level.sak_class["class"+i+"_lovec"]["weapon"] && isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_MELEE")
			{
				//iprintln("setdamage");
				iDamage = level.sak_class[eAttacker.class_damage]["damage"];
			}	
		}
	}	
	
	if(isdefined(self)&&isplayer(self)&&self.class_special == "energy_drink") //specialita classu energy drink
	{
		if(isdefined(eAttacker)&&isplayer(eAttacker)&&!self.class_add_speed&&randomint(2))
		{
			if(self.pers["team"] != eAttacker.pers["team"] && self != eAttacker)
			{
				aspeed = eAttacker.speed;
				sspeed = self.speed;
				self.class_add_speed = true;
				
				self iprintlnbold("^1RedBull ^4ti dava kridla!!!");
				self setMoveSpeedScale((aspeed+10)/100);
				self thread speed_down(15,sspeed);
			}
		}
	}
	
	if(isdefined(self)&&isplayer(self)&&isalive(self))
	{
		if(isdefined(eAttacker)&&isplayer(eAttacker)&&isalive(eAttacker) && eAttacker.class_special == "poison")
		{
			self thread poisoned_hunter(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
		}
	}

	if(isdefined(self)&&isplayer(self)&&isalive(self)&&self.class_special == "back-damage")
	{
		if(isdefined(eAttacker)&&isplayer(eAttacker)&&isalive(eAttacker)&&!self.class_bdamage&&randomint(2))
		{
			self.class_bdamage = true;
			self iprintlnbold("^4Damage navrateny ^1*_*");
			eAttacker thread maps\mp\gametypes\_globallogic::Callback_PlayerDamage( self, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
		}
	}

	if(isdefined(self)&&isplayer(self)&&isalive(self))
	{
		if(isdefined(eAttacker)&&isplayer(eAttacker)&&isalive(eAttacker)&&eAttacker.class_special == "electric"&&randomint(2))
		{	
			iDamage += eAttacker.electric_timer;
			eAttacker.electric_timer = 0;
			
			//angles = VectorToAngles( VectorNormalize( eAttacker.origin+(0,0,44)-self.origin+(0,0,44) ) );
			
			//PlayFX( level._effect[ "blesk" ], eAttacker.origin+(0,0,44), AnglesToForward( angles ), AnglesToUp( angles ) );
		}
	}			
	
	return iDamage;
}

poisoned_hunter(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.poisoned)
	{
		eAttacker iprintlnbold("^2Hrac ^1"+self.name+" ^2uz je infikovany!");
		return;
	}
	rank = self maps\mp\gametypes\_rank::getrank();
	if (rank < 99)
	{
		self.poisoned = true;

		self thread smoke_poison(); //efekt dymu

		self iprintlnbold("^2Bol si infikovany hracom ^1"+eAttacker.name);
		eAttacker iprintlnbold("^2Infikoval si hraca ^1"+self.name);

		self poison_smrt( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		self.poisoned = false;
		self notify("konec_efektu");
	}
	else
	{
		eAttacker iprintlnbold("^1"+self.name+"^2 je imunny!");
		return;
	}
}

poison_smrt(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	self endon("death");
	self endon("disconnect");

	j = randomintrange(5,21);
	
	for (i = 0;i < j; i++)
	{
		self.health -= 1;
		self notify("health_change");
		
		if(i == int(j*0.75))
			self ShellShock( "rpg_mp", j-j*0.75 );
		
		if (self.health < 2)
			self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		wait 1;
	}
}

smoke_poison()
{
	self endon("konec_efektu");
	self endon("death");
	self endon("disconnect");
	self endon("spawned_player");

	//iprintln("poison");
	
	while(1)
	{
		playFx(level._effect[ "smoke_poison" ], self.origin+(0, 0, 40));
		wait 0.4;
	}
}

speed_down(time,speed)
{
	self endon("disconnect");
	self endon("death");
	
	wait time;
	
	self iprintlnbold("^4Rychlost znizena.");
	self setMoveSpeedScale(speed/100);	
}

waittill_or_wait(time,wait2,wait3)
{
	if(isdefined(wait2))
		self endon(wait2);
	if(isdefined(wait3))	
		self endon(wait3);
		
	wait time;	
}

Active_Respawn()
{
	self endon("spawned_player");
	self endon("disconnect");
	self endon("kill_class_respawn");
	level endon("konec_kola");

	self waittill("death");
	
	if(self.pers["team"] != "axis")
		return;
		
	if(!isdefined(self.class_special) || self.class_special != "respawn")	
		return;
		
	wait 0.1;
	
	self thread create_hud(5);
	self thread kill_on_time(7.5,"kill_class_respawn");
	self wait_but_f();
	
	if(!isdefined(self) || isalive(self))
		return;
	
	if(isdefined(self.pers["respawn_class"])&&self.pers["respawn_class"] > 1)
		return;
	
	if(!isdefined(self.pers["respawn_class"]))
		self.pers["respawn_class"] = 0;
		
	self.pers["respawn_class"]++;

	self petx\_weapons::give_class("axis",self.class_damage);	
	self notify("spawned_player");
}

kill_on_time(time,wait1)
{
	wait time;
	
	self notify(wait1);
}

wait_but_f()
{
	self endon("spawned_player");
	self endon("disconnect");
	//self endon("kill_class_respawn");
	
	while(true)
	{
		if(self UseButtonPressed())
		{
			self notify("class_respawn");
			return;
		}
		
		wait 0.001;
	}
}

create_hud(time)
{
	self add_hud(time);
	
	self.class_respawn_hud destroy();
}

add_hud(time)
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("class_respawn");
	self endon("kill_class_respawn");
	level endon("konec_kola");
	
	self.class_respawn_hud = NewClientHudElem(self);
	self.class_respawn_hud.alignX = "center";
	self.class_respawn_hud.alignY = "middle";
	self.class_respawn_hud.font = "objective";
	self.class_respawn_hud.archived = false;
	self.class_respawn_hud.x = 320;//doprava
	self.class_respawn_hud.y = 300;//dole
	self.class_respawn_hud.alpha = 1;
	self.class_respawn_hud.sort = 1001;
	self.class_respawn_hud.fontscale = 1.5;	
	self.class_respawn_hud.hidewheninmenu = true;
	
	self.class_respawn_hud SetText("Stlac ^3F ^7pre respawn.");
	
	wait time;
	
	self.class_respawn_hud FadeOverTime( time/2 );
	self.class_respawn_hud.alpha = 0;
	
	wait time/2;
}

medic_init()
{
	self.allow_medic = false;
	self.medic_complete = false;

	self thread wait_other_player();
	self thread add_info_hud_init();
	self thread wait_button_f();
	
	self thread waittill_use();
}

wait_other_player()
{
	self endon("disconnect");
	self endon("death");
	level endon("konec_kola");
	
	while(true)
	{
		wait 0.1;
	
		players = getentarray("player","classname");
	
		for(i = 0;i < players.size;i++)
		{
			player = players[i];
			
			if(isdefined(player) && isplayer(player) && isalive(player) && player != self && player.pers["team"] == self.pers["team"])
			{
				if(isdefined(distance(player.origin,self.origin)) && distance(player.origin,self.origin) < 50 && player.health != player.maxhealth)
				{
					self.medic_player = player;
					self.allow_medic = true;
					self.class_medic.alpha = 1;
				}	
				else
				{
					self.allow_medic = false;
					self.class_medic.alpha = 0;
				}	
			}
		}
	}
}

add_info_hud_init()
{
	self add_info_hud();
	
	if(isdefined(self.class_medic))
		self.class_medic destroy();
}

add_info_hud()
{
	self endon("disconnect");
	level endon("konec_kola");
	
	self.class_medic = NewClientHudElem(self);
	self.class_medic.alignX = "center";
	self.class_medic.alignY = "middle";
	self.class_medic.font = "objective";
	self.class_medic.archived = false;
	self.class_medic.x = 320;//doprava
	self.class_medic.y = 340;//dole
	self.class_medic.alpha = 0;
	self.class_medic.sort = 1001;
	self.class_medic.fontscale = 1.5;	
	self.class_medic.hidewheninmenu = true;
	
	self.class_medic SetText("Stlac ^3F ^7pre vyliecenie.");
	
	self waittill("death");
}

wait_button_f()
{
	self endon("death");
	self endon("disconnect");
	level endon("konec_kola");
	
	while(true)
	{
		if(self UseButtonPressed())
		{
			self notify("class_medic");
			self.use_medic = true;
			wait 0.5;
		}
		else
			self.use_medic = false;
		
		wait 0.001;
	}
}
	
waittill_use()	
{
	self endon("death");
	self endon("disconnect");
	level endon("konec_kola");

	while(true)
	{
		self waittill("class_medic");
		self waittill_use_loop();
		
		if(self.medic_complete)
		{
			self.class_medic SetText("Stlac ^3F ^7pre vyliecenie.");
			self EnableWeapons();
			self.medic_complete = false;
		}
	}
}

waittill_use_loop()
{
	self endon("death");
	self endon("disconnect");
	level endon("konec_kola");

	if(!self.allow_medic || !self.use_medic)
		return false;
	
	self.class_medic SetText("^1Liecenie...");
	self DisableWeapons();
	
	while(true)
	{
		if(!self.allow_medic || !self.use_medic)
			return false;
			
		self.medic_complete = true;
		
		player = self.medic_player;
		
		if(player.health != player.maxhealth)
		{
			player.health++;
			player notify("health_change");
			player ShellShock( "rpg_mp", 1 );
		}
		else
			return true;
		
		wait 0.5;
	}	
}

explode_player()
{
	self endon("disconnect");

	self waittill( "killed_player" );
	origin = self.origin+(0,0,50);
	
	wait 3;
	
	PlayFX( level._effect[ "player_explode" ], origin);
	
	RadiusDamage( origin, 250, 50, 10, self );

}

electric_timer()
{
	self endon("disconnect");
	self endon("death");
	
	self.electric_timer = 0;
	
	while(1)
	{
		self.electric_timer++;
		wait 2;
	}
}
