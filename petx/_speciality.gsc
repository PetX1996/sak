init()
{
	thread Onplayerconnect();
}
 
Onplayerconnect()
{
	while(1)
	{
		level waittill("connected",player);
		
		player thread OnSpawnPlayer();
		player thread create_hud();
		
		player thread zadanie_dvarov();
	}
}
 
OnSpawnPlayer()
{
	while(1)
	{
		self waittill("spawned_player");
		
		//self thread test_thread(); //pridavanie bodov
		self thread speciality_on_spawn();
		self thread waiter_gun(); //repelent granat
		//self thread MenuResponses();
	}
}
 
zadanie_dvarov() //stanovenie dvarov/premennych
{
	self setclientdvar("ui_spec1",""); 
	self setclientdvar("ui_spec2",""); 
	self setclientdvar("ui_speciality_locked", 0);
	
	if(!isdefined(self.pers["spec1_allies"]))
		self.pers["spec1_allies"] = "";
	if(!isdefined(self.pers["spec2_allies"]))
		self.pers["spec2_allies"] = "";	
	if(!isdefined(self.pers["spec1_axis"]))
		self.pers["spec1_axis"] = "";
	if(!isdefined(self.pers["spec2_axis"]))
		self.pers["spec2_axis"] = "";	

	self.active_skin = false;	
	self.active_speed = false;	
	self.active_neviditelnost = false;
	self.active_repelent = false;	
	self.active_freeze = false;	
	self.active_teleport = false;
}

speciality_on_spawn() //pridanie speciality po spawne
{
	self endon("death");
	self endon("disconnect");
	
	i = 0;
	self setclientdvar("ui_speciality_locked", 0);
	self setclientdvar("ui_spec1",""); 
	self setclientdvar("ui_spec2",""); 
	
	if(self.pers["spec1_"+self.pers["team"]] != "")
	{
		self setclientdvar("ui_spec1",self.pers["spec1_"+self.pers["team"]]);
		i++;
	}	
		
	if(self.pers["spec2_"+self.pers["team"]] != "")
	{
		self setclientdvar("ui_spec2",self.pers["spec2_"+self.pers["team"]]);
		i++;
	}	
		
	if(i == 2)
		self setclientdvar("ui_speciality_locked", 1);
}

test_thread()
{
	self thread petx\_upoint::giveupoint(undefined,100);
	
	/*for(;;)
	{
		r = randomint(4);
		if(r == 0)
			self thread add_speciality("hmm");	
		else if(r == 1)	
			self thread add_speciality("ehm");
		if(r == 2)	
			self thread remove_speciality(randomintrange(1,3));
		else if(r == 0)
			self thread remove_speciality(randomintrange(1,3));
			
		wait 3;
	}*/
	
	while(1)
	{
		PlayFXOnTag( level._effect[ "speed" ], self, "J_Helmet");
		wait 0.8;
	}
}

add_speciality(string) //pridanie speciality na volne miesto
{
	if(!isdefined(string))
	{	
		iprintln("Nespravne volanie funkcie -add_speciality(string)-");
		return;
	}
	
	for(i = 1;i < 3;i++)
	{
		if(self.pers["spec"+i+"_"+self.pers["team"]] == "")
		{
			self.pers["spec"+i+"_"+self.pers["team"]] = string;
			self setclientdvar("ui_spec"+i,self.pers["spec"+i+"_"+self.pers["team"]]);
			
			if(self.pers["spec1_"+self.pers["team"]] != "" && self.pers["spec2_"+self.pers["team"]] != "")
				self setclientdvar("ui_speciality_locked", 1);		
				
			return;
		}

	}
}

remove_speciality(cislo) //odstranenie konkretnej speciality
{
	if(!isdefined(cislo)||(cislo != 1 && cislo != 2))
	{
		iprintln("Nespravne volanie funkcie -remove_speciality(cislo)-");
		return;
	}
	
	self.pers["spec"+cislo+"_"+self.pers["team"]] = "";
	self setclientdvar("ui_spec"+cislo, ""); 
	
	if(self.pers["spec1_"+self.pers["team"]] == "" || self.pers["spec2_"+self.pers["team"]] == "")
		self setclientdvar("ui_speciality_locked", 0);		
}

use_speciality(typ) //pouzitie speciality
{
	if(!isdefined(typ) || typ == "")
	{
		iprintln("nespravne volanie funkcie -use_speciality(typ)-");
		return;
	}
	
	if(typ == "Skin nepriatela")
		self thread active_skin();
		
	if(typ == "Pridanie rychlosti")
		self thread active_speed();
		
	if(typ == "Repelent")
		self thread active_repelent();
		
	if(typ == "Neviditelnost")
		self thread active_neviditelnost();
		
	if(typ == "Zmrazovac")
		self thread active_freeze();

	if(typ == "Teleport")
		self thread active_teleport();
		
}

//**********SKIN LOVCA**********//

active_skin()
{
	self endon("disconnect");

	while(self.active_skin)
		wait 1;

	if(!isalive(self) || self.pers["team"] != "allies")
		return;		
		
	self.active_skin = true;
	
	self skin();
	
	if(isdefined(self))
		self.active_skin = false;

}

skin()
{
	self endon("disconnect");
	self endon("death");
	
	self iprintlnbold("Skin zmeneny!");
	self detachAll();
	self setModel("body_mp_usmc_rifleman");
	self setViewModel("viewmodel_base_viewhands");
	
	wait 60;	
	
	self iprintlnbold("Skin zmeneny!");
	self detachAll();
	self setModel(level.sak_class[self.class_damage]["playermodel"]);
	self setViewModel(level.sak_class[self.class_damage]["playerhands"]);	
	
	if (isdefined(level.sak_class[self.class_damage]["playerhead"]))
		self attach(level.sak_class[self.class_damage]["playerhead"], "", true);
		
}

//********PRIDANIE RYCHLOSTI*************//

active_speed()
{
	self endon("disconnect");

	while(self.active_speed)
		wait 1;

	if(!isalive(self))
		return;		
		
	self.active_speed = true;	

	self speed();
	
	if(isdefined(self))
		self.active_speed = false;	
}

speed()
{			
	self endon("disconnect");
	self endon("death");

	self iprintlnbold("Rychlost zvysena na ^1"+(self.speed+30)+"^7 percent!");
	self setMoveSpeedScale((self.speed+30)/100);
	wait 10;
	self iprintlnbold("Rychlost znizena na ^1"+self.speed+"^7 percent!");
	self setMoveSpeedScale(self.speed/100);	
}

//*********REPELENT***********//

active_repelent()
{
	self endon("disconnect");

	while(self.active_repelent)
		wait 1;
	
	if(!isalive(self) || self.pers["team"] != "allies")
		return;
	
	self iprintlnbold("Repelent aplikovany!");	
	self.active_repelent = true;

	self thread repelent_fx();
	self thread repelent();
	
	self wait_or_death(15);
	
	if(isalive(self))
		self iprintlnbold("Repelent vyprchal!");
	
	if(isdefined(self))
	{
		self.active_repelent = false;
		self notify("kill_repel");
	}	
}

repelent() 
{
	self endon("kill_repel");
	self endon("disconnect");
	self endon("death");
	
	players = getentarray("player","classname");
	
	while(1)
	{
		for (i=0; i<players.size; i++)
		{
			player = players[i];
			self thread repelent_kick(player);
		}
		
		wait 0.05;
	}
}

repelent_kick(player)
{
	self endon("kill_repel");
	self endon("disconnect");
	self endon("death");

	while(player != self && isalive(player) && player.pers["team"] == "axis" && isdefined(distance(player.origin,self.origin)) && distance(player.origin, self.origin) < 150 && player.class_special != "anti-repel")
	{
		player.health = (player.health + 400);
		player thread maps\mp\gametypes\_globallogic::finishPlayerDamageWrapper(player, player, 400, 0, "MOD_PROJECTILE", "rpg_mp", self.origin + (0,0,800), vectornormalize(player.origin - (self.origin + (0, 0, 800))), "none", 0);
		//player StopRumble();
		wait 0.5;
	}
}

repelent_fx()
{
	self endon("kill_repel");

	while(1)
	{
		playFx(level._effect[ "smoke_repel" ], self.origin+(0, 0, 50));
		wait 0.3;
	}
}

//**********NEVIDITELNOST**********//

active_neviditelnost()
{
	self endon("disconnect");
	
	while(self.active_neviditelnost)
		wait 1;

	if(!isalive(self))
		return;
		
	self notify("kill_end_hud");	
		
	self.active_neviditelnost = true;	

	self neviditelnost();
	
	if(isalive(self))
		self iprintlnbold("Neviditelnost deaktivovana!");

	if(isdefined(self))	//disconnect fix
	{
		self show();
		self thread delete_hud_time(1);
		self.active_neviditelnost = false;		
	}
}

neviditelnost()
{
	self endon("disconnect");
	self endon("death");

	self iprintlnbold("Neviditelnost aktivovana!");
	self hide();
	self active_hud("invisible_hud", 0.7, (1, 1, 1));
	wait 10;	
}

//*********ZMRAZOVAC**********//

active_freeze()
{
	self endon("disconnect");
	
	while(self.active_freeze)
		wait 1;	

	if(!isalive(self) || self.pers["team"] != "axis")
		return;
		
	self.active_freeze = true;
	
	self iprintlnbold("Zmrazovac aktivovany!");
	self thread freeze();
	
	wait 5;
	self.active_freeze = false;
}

freeze()
{
	players = getentarray("player","classname");
	for(i = 0;i < players.size;i++)
	{
		if(players[i].pers["team"] == "allies" && isdefined(distance(self.origin,players[i].origin)) && distance(self.origin,players[i].origin) < 200)
			players[i] thread freeze_player();
	}
}

freeze_player()
{
	self iprintlnbold("Ovladanie zmrazene!");
	self FreezeControls( true );
	self notify("kill_end_hud");
	self active_hud("white", 0.7, (.9, 1, 1));
	
	self wait_or_death(5);
	
	if(isalive(self))
		self iprintlnbold("GO!");
	if(isdefined(self))	
	{
		self FreezeControls( false );
		self thread delete_hud_time(1);
	}	
}

wait_or_death(time)
{
	self endon("death");
	self endon("disconnect");
	
	wait time;
}

active_hud(shader, alpha, color)
{
	self.speciality_hud setshader(shader, 640, 480);
	self.speciality_hud.alpha = alpha;
	self.speciality_hud.color = color;
}

delete_hud()
{
	self.speciality_hud.alpha = 0;
}

delete_hud_time(time)
{
	self endon("disconnect");
	self endon("kill_end_hud");

	self.speciality_hud FadeOverTime( time );
	self.speciality_hud.alpha = 0;
}


create_hud()
{
	self.speciality_hud = newClientHudElem(self);
	self.speciality_hud.x = 0;
	self.speciality_hud.y = 0;
	self.speciality_hud setshader ("white", 640, 480);
	self.speciality_hud.alignX = "left";
	self.speciality_hud.alignY = "top";
	self.speciality_hud.horzAlign = "fullscreen";
	self.speciality_hud.vertAlign = "fullscreen";
	self.speciality_hud.color = (.16, .38, .5);
	self.speciality_hud.alpha = 0;
}

//***************** TELEPORT *****************//

active_teleport()
{
	self endon("disconnect");
	
	/*while(self.active_teleport)
		wait 1;	
		
	self.active_teleport = true;*/
	
	self iprintlnbold("Teleport!");

	players = getentarray("player","classname");
	spawn_orig = getentarray("mp_tdm_spawn","classname");
	r = randomint(spawn_orig.size);
	d = 1000;
	ok = 0;
	okr = 0;
	
	while(1)
	{
		ok = 0;
		players = getentarray("player","classname");
		for(i = 0;i < players.size;i++)
		{
			player = players[i];
			if(isdefined(distance(player.origin,spawn_orig[r].origin))&&distance(player.origin,spawn_orig[r].origin) > d)
				ok++;
			else
				continue;	
		}
		
		if(ok == players.size)
		{
			orig = spawn_orig[r];
			break;
		}	
		else
		{
			r = randomint(spawn_orig.size);
			okr++;
		}	
		
		if(okr == 5)
		{
			okr = 0;
			d -= 5;
		}
		
		/*iprintln("player "+players.size);	
		iprintln("ok "+ok);
		iprintln("okr "+okr);
		iprintln("d "+d);*/
			
		//wait 0.0001;	
	}
	
		/*iprintln("f player "+players.size);	
		iprintln("f spawn "+spawn_orig.size);	
		iprintln("f ok "+ok);	
		iprintln("f okr "+okr);	*/
		
		self setorigin(orig.origin);
		self setplayerangles(orig.angles);
}

//**********************Repel granat(others)***********************//

waiter_gun()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		
		//currentWeapon = self GetOffhandSecondaryClass();
		//self iprintln("weapon: "+weapname);
		
		if(isdefined(weapname)&&weapname == "smoke_grenade_mp"&&isdefined(grenade))
			self thread repnad_init(grenade);
	}
}

repnad_init(weapon)
{
	//iprintln("start");
	weapon waittill( "explode", position );
	
	//iprintln("explode");
	self thread active_repnad(position);
	wait 22;
	self notify("repnad_end");
}

active_repnad(position)
{
	self endon("repnad_end");
	
	players = getentarray("player","classname");
	
	level.repnad_dis = 0;
	
	while(1)
	{
		for (i=0; i<players.size; i++)
		{
			player = players[i];
			self thread active_repnad_dmg(position,player);
		}
		
		wait 0.05;
		players = getentarray("player","classname");
		
		if(level.repnad_dis < 200)
			level.repnad_dis += 2;
	}
}

active_repnad_dmg(position,player)
{
	self endon("repnad_end");

	while(isalive(player) && player.pers["team"] == "axis" && isdefined(distance(player.origin,position)) && distance(player.origin, position) < level.repnad_dis && player.class_special != "anti-repel")
	{
		player.health = (player.health + 100);
		player thread maps\mp\gametypes\_globallogic::finishPlayerDamageWrapper(player, player, 100, 0, "MOD_PROJECTILE", "rpg_mp", position + (0,0,10), vectornormalize(player.origin - (position - (0, 0, 10))), "none", 0);
		//player StopRumble();
		wait 0.5;
	}
}
