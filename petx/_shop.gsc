init()
{
level.shop_object = [];

vytvorenie_lokaci();

//thread zadanie_dvarov();
thread debug();

thread vybranie_lokaci();
thread onplayerconnected();
}

onplayerconnected()
{
	for(;;)
	{
		level waittill ("connected", player);
		player thread zadanie_dvarov();
		player.openshop = false;
		player.shop_print = undefined;
		
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ("spawned_player");
		self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter();
		self thread print_shop();
		self thread avb_dvar(self.pers["team"]);
		self thread weapon_on_spawn();
		
		//self thread test_funkcion();
	}
}

test_funkcion()
{
	while(1)
	{
		wait 5;
		self thread give_speciality(randomint(50));
	}
}

zadanie_dvarov()
{
	//ceny allies
	self setclientdvars("ui_shop_price_allies_skin", level.shop_price_skin ,
	"ui_shop_price_allies_speed", level.shop_price_speed ,
	"ui_shop_price_allies_repelent", level.shop_price_repelent ,
	"ui_shop_price_allies_neviditelnost", level.shop_price_neviditelnost ,
	"ui_shop_price_allies_teleport", level.shop_price_teleport ,
	"ui_shop_price_allies_flash", level.shop_price_flash ,
	"ui_shop_price_allies_granat", level.shop_price_granat ,
	"ui_shop_price_allies_claymore", level.shop_price_claymore ,
	"ui_shop_price_allies_c4", level.shop_price_c4 ,
	"ui_shop_price_allies_health", level.shop_price_health ,
	"ui_shop_price_allies_radar", level.shop_price_allies_radar);
	
	//ceny axis
	self setclientdvars("ui_shop_price_axis_speed", level.shop_price_speed,
	"ui_shop_price_axis_radar", level.shop_price_axis_radar,
	"ui_shop_price_axis_freeze", level.shop_price_freeze,
	"ui_shop_price_axis_health", level.shop_price_health,
	"ui_shop_price_allies_repnad", level.shop_price_repnad,
	"ui_shop_price_axis_neviditelnost", level.shop_price_neviditelnost,
	"ui_shop_price_axis_flash", level.shop_price_flash);	
	//other	
	
	if (isdefined(self.pers["hardPointItem"]) && self.pers["hardPointItem"] == "radar_mp")
		self setclientdvar("ui_shop_radar_avb", 0);
	else
		self setclientdvar("ui_shop_radar_avb", 1);	
	
	team = "allies";
	
	for(i = 0;i<2;i++)
	{
		if (!isdefined(self.pers["frag_grenade_mp"+team]))
			self.pers["frag_grenade_mp"+team] = 0;
		if (!isdefined(self.pers["flash_grenade_mp"+team]))
			self.pers["flash_grenade_mp"+team] = 0;	
		if (!isdefined(self.pers["claymore_mp"+team]))
			self.pers["claymore_mp"+team] = 0;
		if (!isdefined(self.pers["c4_mp"+team]))
			self.pers["c4_mp"+team] = 0;	
		if (!isdefined(self.pers["radar_mp"+team]))	
			self.pers["radar_mp"+team] = 0;
		if (!isdefined(self.pers["smoke_grenade_mp"+team]))	
			self.pers["smoke_grenade_mp"+team] = 0;			
		team = "axis";	
	}	
}

vytvorenie_lokaci()
{
	ctf_primary = getEntArray( "flag_primary", "targetname" ); //domination - zakladne 3
	ctf_secondary = getEntArray( "flag_secondary", "targetname" );
	
	//level.shop_object = [];
	
	j = 0;
	if (isdefined(ctf_primary))
	{
		for(i = 0;i < ctf_primary.size;i++)
		{
			if (isdefined(ctf_primary[i].script_gameobjectname) &&(isdefined(ctf_primary[i].model)||isdefined(ctf_primary[i].target)))
			{
				level.shop_object[j] = ctf_primary[i].origin;	
				j++;
			}	
		}	
	}
		
	if (isdefined(ctf_secondary))	
	{
		for(x = 0;x < ctf_secondary.size;x++)
		{
			if (isdefined(ctf_secondary[x].script_gameobjectname) &&(isdefined(ctf_secondary[x].model)||isdefined(ctf_secondary[x].target)))
			{
				level.shop_object[j] = ctf_secondary[x].origin;
				j++;
			}	
		}				
	}	
	
	//j = 10;
	
	sab_allies = getEntArray( "sab_bomb_allies", "targetname" ); //sabotage - zakladne 2
	sab_axis = getEntArray( "sab_bomb_axis", "targetname" );
	
	if (isdefined(sab_allies))
	{
		for(s = 0 ; s<sab_allies.size ; s++)
		{
			level.shop_object[j] = sab_allies[s].origin;
			j++;
		}			
	}	
	
	//j = 15
	
	if(isdefined(sab_axis))	
	{
		for(a = 0 ; a<sab_axis.size ; a++)
		{
			level.shop_object[j] = sab_axis[a].origin;
			j++;
		}	
	}	
	
	//j = 20
	
	sd_bomb = getEntArray( "bombzone", "targetname" );//search & destroy - zakladne 2

	if(isdefined(sd_bomb))	
	{
		for(b = 0 ; b<sd_bomb.size ; b++)
		{
			level.shop_object[j] = sd_bomb[b].origin;
			j++;
		}	
	}	
	
	//j = 30
	
	hq_radio = getEntArray( "radiotrigger", "targetname" ); //hq - zakladne 7 
	
	if(isdefined(hq_radio))	
	{
		for(h = 0 ; h<hq_radio.size ; h++)
		{
			level.shop_object[j] = hq_radio[h].origin;
			j++;
		}	
	}	
	
	ctf_ctf_allies = getEntArray( "ctf_zone_allies", "targetname" );
	ctf_ctf_axis = getEntArray( "ctf_zone_axis", "targetname" );	
	
	if (isdefined(ctf_ctf_allies))
	{
		for(y = 0;y < ctf_ctf_allies.size;y++)
		{
			level.shop_object[j] = ctf_ctf_allies[y].origin;	
			j++;
		}		
	}	
	
	if (isdefined(ctf_ctf_axis))
	{
		for(u = 0;u < ctf_ctf_axis.size;u++)
		{
			level.shop_object[j] = ctf_ctf_axis[u].origin;	
			j++;
		}		
	}
	
	
	allies_spawn = getentarray("mp_tdm_spawn_allies_start", "classname");
	axis_spawn = getentarray("mp_tdm_spawn_axis_start", "classname");
	spawn = getentarray("mp_tdm_spawn", "classname");
	
	if (isdefined(allies_spawn))
	{
		for(u = 0;u < allies_spawn.size;u++)
		{
			level.shop_object[j] = allies_spawn[u].origin;	
			j++;
		}		
	}	
	
	if (isdefined(axis_spawn))
	{
		for(u = 0;u < axis_spawn.size;u++)
		{
			level.shop_object[j] = axis_spawn[u].origin;	
			j++;
		}		
	}

	if (isdefined(spawn))
	{
		for(u = 0;u < spawn.size;u++)
		{
			level.shop_object[j] = spawn[u].origin;	
			j++;
		}		
	}	
	
	//j = 50
	//ak su vsetky gametypy, je 14 lokacii
	
	delete_point();
	
	
}

delete_point()
{
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
	{
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			//println("DELETED: ", entitytypes[i].classname);
			entitytypes[i] delete();
		}
	}
}

show_model(orig)
{
	trace = bullettrace( orig + (0,0,50), orig + (0,0,-300), false, undefined );
	
	flag = spawn("script_model", (orig[0], orig[1], trace["position"][2]));
    flag setModel("com_vending_bottle");
	
	efekt = playloopedFx( level._effect[ "shop_glow" ],10,(orig[0], orig[1], trace["position"][2])  );
	
	flag thread zobrazenie_lokaci(true, "shop_icon");
}

vybranie_lokaci()
{
	if(isdefined(level.shop_object)&&1<level.shop_object.size )
	{
		r = randomint(level.shop_object.size);
		r2 = randomint(level.shop_object.size);

		s1 = level.shop_object[r];
		s2 = level.shop_object[r2];
		
		level.random_fail = 0;
		v = 1300; //v sa s kazdym dalsim cyklom zmensuje...

		while(s1==s2||(isdefined(distance(s1,s2))&&distance(s1,s2) < v))
		{
			r2 = randomint(level.shop_object.size);
			s2 = level.shop_object[r2];
			level.random_fail++;
			v -= 5;
		}
		
		level.shop1 = s1;
		level.shop2 = s2;
		
		//thread zobrazenie_lokaci(s1);
		//thread zobrazenie_lokaci(s2);
		
		trace1 = bullettrace( s1 + (0,0,50), s1 + (0,0,-300), false, undefined );
		trace2 = bullettrace( s2 + (0,0,50), s2 + (0,0,-300), false, undefined );
		thread vytvorenie_triggeru((s1[0],s1[1],trace1["position"][2]),(s2[0],s2[1],trace2["position"][2]));
		
		thread show_model(s1);
		thread show_model(s2);
		
		rs = randomint(level.shop_object.size);
		s = level.shop_object[rs];
		
		v = 1300;
		while(s==s2 || s == s1 || (isdefined(distance(s,s2))&&distance(s,s2) < v) || (isdefined(distance(s,s1))&&distance(s,s1) < v))
		{
			rs = randomint(level.shop_object.size);
			s = level.shop_object[rs];
			level.random_fail++;
			v -= 2;
		}
		
		thread create_speciality_box(s);
	}
}

vytvorenie_triggeru(s1,s2)
{
	level.shoptrig = [];

	for(b = 0;b < 2;b++)
	{
		if(b == 0)
			orig = s1;
		else
			orig = s2;
			
		if(isdefined(level.shop_object)&&1<level.shop_object.size )
		{
			thread wait_trig(orig,b);
			
		}
	}
}

wait_trig(orig,index,close)
{
	if(index == 2)
		level endon("delete_trig");

	level.shoptrig[index] = spawn( "trigger_radius", orig, 0, 100, 100);
	t = 0;

	for(;;)
	{
		player = getentarray("player" , "classname");
		
		for(i = 0;i < player.size;i++)
		{
			if(isdefined(player[i])&&isplayer(player[i])&&isalive(player[i]))
			{
				if (player[i] istouching(level.shoptrig[index]))
				{	
					//player[i] shop_print(true, "Press ^3[USE] ^7open shop.");
					
					if (player[i] UseButtonPressed() && !player[i].openshop)
					{
						if(isdefined(close)&&close)
						{
							//level.shoptrig[index] delete();
							player[i] give_speciality(t/10);
							level notify("delete_speciality");
							return;
						}
						else
						{
							player[i].openshop = true;
							player[i] thread wait_unlock();
							player[i] openMenu( game["menu_shop_"+player[i].pers["team"]] );
							//iprintln("shop otvoril: "+player[i].name);
							//player notify("open_shop");
						}
					}
				}
				/*else
				{
					player[i] shop_print(false);
				}*/
			}
		}
		wait 0.1;
		t++;
	}	
}

wait_unlock()
{
wait 1;
self.openshop = false;
}

zobrazenie_lokaci(stav, icon)
{
	visuals = [];
	
	if (isdefined(self)&&isdefined(stav)&&stav)
	{
		self.shop_icon = maps\mp\gametypes\_gameobjects::createCarryObject( "allies", self, visuals, (0,0,80) );
		//shop_icon maps\mp\gametypes\_gameobjects::allowCarry( "friendly" );
		self.shop_icon maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", icon );
		self.shop_icon maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", icon );
		self.shop_icon maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", icon );
		self.shop_icon maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", icon );
		self.shop_icon maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		//shop_icon maps\mp\gametypes\_gameobjects::setCarryIcon( "hud_suitcase_bomb" );
	}
	else
	{
		if(isdefined(self.shop_icon))
			self.shop_icon maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	}
}

print_shop()
{
	self print_shop_hud();

	if (isdefined(self.shop_print))
	{
		self.shop_print destroy();
		self.shop_print = undefined;
	}
	return;
}

print_shop_hud()
{
	if(isdefined(level.shop_object)&&1<level.shop_object.size )
	{	

		self endon("disconnect");
		self endon("death");
		level endon("delete_hud");
		
		for(;;)
		{
		
			if (self istouching(level.shoptrig[0])||self istouching(level.shoptrig[1])||(isdefined(level.shoptrig[2])&&self istouching(level.shoptrig[2])))
			{
				if(!isdefined(self.shop_print))
				{
					self.shop_print = NewClientHudElem(self);
					self.shop_print.alignX = "center";
					self.shop_print.alignY = "middle";
					self.shop_print.font = "objective";
					self.shop_print.archived = false;
					self.shop_print.x = 320;//doprava
					self.shop_print.y = 350;//dole
					self.shop_print.alpha = 1;
					self.shop_print.sort = 1001;
					self.shop_print.fontscale = 1.4;
					self.shop_print.hidewheninmenu = true;

					if(isdefined(level.shoptrig[2])&&self istouching(level.shoptrig[2]))
						self.shop_print settext("Aktivuj stlacenim ^3[USE].");
					else
						self.shop_print settext("Stlacenim ^3[USE] ^7otvoris shop.");
				}
			}
			else
			{
				if (isdefined(self.shop_print))
				{
					self.shop_print destroy();
					self.shop_print = undefined;
				}
			}
			wait 0.01;
		}	
	}
}	

debug()
{
	if(isdefined(level.shop_object)&&1<level.shop_object.size )
	{
		p = 0;

		if (isdefined(level.shop_object))
		{
			for(i = 0;i <level.shop_object.size;i++)
			{
				if(isdefined(level.shop_object[i]))
				{
					p++;
				}
			}
			
			level waittill("connected", player);
			player waittill("spawned_player");

			iprintln("Pocet dostupnych lokacii: "+p);
			if(level.random_fail != 0)
				iprintln("Pocet opakovani random pozicii: "+level.random_fail);
		}
	}
}

create_speciality_box(orig)
{
	level waittill("start_round");
	
	max = ((level.petx_time_limit*60)/4)*3;
	if(isdefined(max)&&max <= 10)
		max = 20;
	if(!isdefined(max))	
		max = 20;
	
	wait randomintrange(10,int(max));
	//wait 10;
	
	trace = bullettrace( orig + (0,0,50), orig + (0,0,-300), false, undefined );
	
	flag = spawn("script_model", (orig[0], orig[1], trace["position"][2]));
    flag setModel("com_plasticcase_beige_big");
	efekt = playloopedFx( level._effect[ "shop_glow" ],10,(orig[0], orig[1], trace["position"][2])  );
	
	flag thread zobrazenie_lokaci(true, "shop_box_icon");
	
	thread wait_trig(orig,2,true);
	
	p = allplayer();
	if(p == 0)
		p = 1;
	max = (120/p)+10;
	if(isdefined(max)&&max <= 10)
		max = 20;
	if(!isdefined(max))	
		max = 20;		
		
	//wait randomintrange(10,(int(max)));
	iprintlnbold("^2Special Box ^1online!");
	
	wait_or_notify(randomintrange(10,(int(max))));

	iprintlnbold("^2Special Box ^1offline!");	
	flag thread zobrazenie_lokaci(false, "shop_box_icon");
	flag delete();
	efekt delete();
	level notify("delete_trig");
	level.shoptrig[2] delete();

}

give_speciality(time)
{
	if(!isdefined(time)||time <= 0)
		time = 1;
		
	//iprintln("time: "+time);	

	r = randomintrange(0,10);
	type = undefined;
	price = undefined;
	avaibletype = [];
	
	avaibletype[0]["allies"] = "Skin nepriatela";
	avaibletype[1]["allies"] = "Pridanie rychlosti";
	avaibletype[2]["allies"] = "Repelent";
	avaibletype[3]["allies"] = "Neviditelnost";
	avaibletype[4]["allies"] = "Teleport";
	
	avaibletype[0]["axis"] = undefined;
	avaibletype[1]["axis"] = "Pridanie rychlosti";
	avaibletype[2]["axis"] = "Pridanie rychlosti";
	avaibletype[3]["axis"] = "Neviditelnost";
	avaibletype[4]["axis"] = "Zmrazovac";	
	
	if(r < 7)
	{
		if(time < 5)
		{
			r = randomintrange(3,5);
			type = avaibletype[r][self.pers["team"]];
		}	
		else if(time < 10)
		{
			r = randomintrange(2,5);
			type = avaibletype[r][self.pers["team"]];
		}
		else if(time < 20)
		{
			r = randomintrange(0,3);
			type = avaibletype[r][self.pers["team"]];	
		}	
		else
		{
			r = randomintrange(0,2);
			type = avaibletype[r][self.pers["team"]];			
		}
		
		price = (500/time)+10; //divide by 0 - veery bug xD
	}
	else
	{
		price = (500/time)+10; //divide by 0 - veery bug xD
	}

	if(isdefined(type))
	{
		self iprintlnbold("^2Ziskal si specialitu: ^1"+type);
		self thread petx\_speciality::add_speciality(type);
	}
	else
	{
		price = int(price);
		self iprintlnbold("^2Pridanych ^1"+price+" ^2uPoint.");
		score = self.pers["score"];
		maps\mp\gametypes\_globallogic::_setPlayerScore( self, score+price );
		self thread maps\mp\gametypes\_rank::giveRankXP( "life", price );
		self thread petx\_upoint::giveupoint(undefined,price);	
	}	
}

wait_or_notify(time)
{
	level endon("delete_speciality");

	wait time;
	
	return;
}

allplayer()
{
	players = 0;
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isalive(player[i]) && isplayer(player[i]) && player[i].pers["team"] == "allies")
			players++;
	}
	return players;
}

restore_health()
{
	self endon("death");
	self endon("disconnect");
	
	for(;;)
	{
		if (self.health != self.maxhealth)
		{
			self.health += 1;
			self notify("health_change");
		}
		else
			return;
		wait 0.01;
	}
}

shop_weapon(weapon , team) //zavola sa pri kupeni zbrane
{
	maxammo = WeaponMaxAmmo(weapon)+1;
	self.pers[weapon+team] = self GetAmmoCount(weapon);
	
	if (self.pers[weapon+team] < maxammo)
	{
		self.pers[weapon+team]++;
		
		self giveweapon(weapon);
		self SetWeaponAmmoClip(weapon, self.pers[weapon+team]);
		
		if (weapon == "frag_grenade_mp")
			self SwitchToOffhand(weapon);
		else if (weapon == "flash_grenade_mp")	
			self SetOffhandSecondaryClass("flash");
		else if (weapon == "smoke_grenade_mp")	
			self SetOffhandSecondaryClass("smoke");			
		else if (weapon == "claymore_mp")	
			self SetActionSlot( 1, "weapon", weapon );
		else if (weapon == "c4_mp")
			self SetActionSlot( 3, "weapon", weapon );
		else
			self SwitchToWeapon(weapon);
	}	
	
	if (self.pers[weapon+team] == WeaponMaxAmmo(weapon))
		self setclientdvar("ui_shop_"+weapon+"_avb" , 0);
}

weapon_on_spawn() //pridelenie zbrane po spawne(ak je)
{
	self endon("disconnect");
	self endon("death");
	
	team = self.pers["team"];
	
	if (self.pers["radar_mp"+team] != 0)
		self maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem(); //radar
	
	for(i = 0;i < 5;i++)
	{
		weapon = "flash_grenade_mp";

		if (i == 1)
			weapon = "frag_grenade_mp";

		if (i == 2)
			weapon = "claymore_mp";	
			
		if (i == 3)
			weapon = "c4_mp";	
		
		if (i == 4)
			weapon = "smoke_grenade_mp";	
	
		//iprintln("W: "+weapon+" Ammo: "+self.pers[weapon+team]);
		if (self.pers[weapon+team] != 0)
		{
			//self.pers[weapon]++;
			
			self giveweapon(weapon);
			self SetWeaponAmmoClip(weapon, self.pers[weapon+team]);
			
			if (weapon == "frag_grenade_mp")
				self SwitchToOffhand(weapon);
			else if (weapon == "flash_grenade_mp")	
				self SetOffhandSecondaryClass("flash");	
			else if(weapon == "smoke_grenade_mp")	
				self SetOffhandSecondaryClass("smoke");	
			else if (weapon == "claymore_mp")	
				self SetActionSlot( 1, "weapon", weapon );
			else if (weapon == "c4_mp")
				self SetActionSlot( 3, "weapon", weapon );
			else
				self SwitchToWeapon(weapon);
		}	
		
		if (self.pers[weapon+team] == WeaponMaxAmmo(weapon))
			self setclientdvar("ui_shop_"+weapon+"_avb" , 0);
	}	
}	

avb_dvar(team) //dostupnost jednotlivych zbrani - aktualizacie
{
	self endon("disconnect");
	self endon("death");

	wait 0.5;
	for(;;)
	{
		for(i = 0; i < 6;i++)
		{
			weapon = "flash_grenade_mp";

			if (i == 1)
				weapon = "frag_grenade_mp";

			if (i == 2)
				weapon = "claymore_mp";	
				
			if (i == 3)
				weapon = "smoke_grenade_mp";	

			if (i == 4)
				weapon = "c4_mp";	
								
				
			if (i == 5)
			{
				//weapon = "radar_mp";
				if (self.pers["radar_mp"+self.pers["team"]] == 1)
					self setclientdvar("ui_shop_radar_avb", 0);
				else
					self setclientdvar("ui_shop_radar_avb", 1);
				break;
			}	
			maxammo = WeaponMaxAmmo(weapon);
			self.pers[weapon+team] = self GetAmmoCount(weapon);
			if (self.pers[weapon+team] < maxammo)
				self setclientdvar("ui_shop_"+weapon+"_avb" , 1);
			else
				self setclientdvar("ui_shop_"+weapon+"_avb" , 0);	
			//self iprintln("W: "+weapon+" Ammo: "+self.pers[weapon]+" MaxAmmo: "+maxammo);
			wait 0.5;
		}	
	}
}
