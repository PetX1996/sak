#include maps\mp\gametypes\_hud_util;

init()
{
level.spawnhunter = false;

thread cas();
thread onplayerconnected();
}

onplayerconnected()
{
	for(;;)
	{
		level waittill ("connected", player);

		//player.health_hud = undefined;
		player.onehunter = false;
		player.lovec = false;
		
		if(!isdefined(player.pers["lastteam"]))
			player.pers["lastteam"] = "spectator";
		
		if(!isdefined(player.pers["randomlovec"]))
			player.pers["randomlovec"] = 0;
		
		player thread onplayerspawned();
		if (!game["first_round"])
			player thread round_respawn();
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ("spawned_player");
		//self thread player_health_hud_init();
		self thread wait_health();
		self thread waitdeath();
		self thread restore_health();
	}
}

restore_health()
{
	self endon("disconnect");
	self endon("death");
	
	level waittill("start_round");

	if (isplayer(self) && isalive(self) && self.pers["team"] == "allies")
	{
		if (self.health < self.maxhealth)
		{
			self.health = self.maxhealth;
			self notify("health_change");
			self iprintlnbold("Zdravie obnovene");
		}
	}
}

round_respawn()
{
	self closeMenu();
	self closeInGameMenu();

	if(self.pers["lastteam"] == "spectator")
		return;
	
	wait 0.001;
	
	self Join();
}

player_health_hud_init()
{
	self player_health_hud();
	
	if (isdefined(self.health_hud))
	{
		self.health_hud destroy();
		self.health_hud = undefined;
	}	
	
	if (isdefined(self.health_hud_c))
	{
		self.health_hud_c destroy();
		self.health_hud_c = undefined;
	}	
}

player_health_hud()
{
	self endon("disconnect");
	self endon("death");
	level endon("delete_hud");

	player = self;

	self.health_hud = NewClientHudElem(self);
	self.health_hud.alignX = "center";
	self.health_hud.alignY = "middle";
	self.health_hud.font = "objective";
	self.health_hud.archived = false;
	self.health_hud.x = 570;//doprava
	self.health_hud.y = 425;//dole
	self.health_hud.alpha = 1;
	self.health_hud.sort = 1001;
	self.health_hud.fontscale = 1.4;	
	self.health_hud.hidewheninmenu = true;
	self.health_hud settext("Health:");
	
	self.health_hud_c = NewClientHudElem(self);
	self.health_hud_c.alignX = "center";
	self.health_hud_c.alignY = "middle";
	self.health_hud_c.font = "objective";
	self.health_hud_c.archived = false;
	self.health_hud_c.x = 613;//doprava
	self.health_hud_c.y = 425;//dole
	self.health_hud_c.alpha = 1;
	self.health_hud_c.sort = 1001;
	self.health_hud_c.fontscale = 1.4;	
	self.health_hud_c.hidewheninmenu = true;
	//self.health_hud_c.color = 0,255,0;
	//self.health_hud_c SetValue(self.health);
	
	for(;;)
	{
		if (player.health < player.maxhealth/3 || player.health == player.maxhealth/3)
		{
			self.health_hud_c.color = (255,0,0);
			self.health_hud_c SetValue(self.health);
		}	
		if (player.health > (player.maxhealth/3)*2 || player.health == (player.maxhealth/3)*2)
		{
			self.health_hud_c.color = (0,255,0);
			self.health_hud_c SetValue(self.health);
		}	
		if (player.health > player.maxhealth/3 && player.health < (player.maxhealth/3)*2)
		{
			self.health_hud_c.color = (255,255,0);
			self.health_hud_c SetValue(self.health);
		}
		//wait 0.5;
		self wait_health();
	}
}

wait_health()
{
	self endon("disconnect");
	self endon("death");
	//level endon("delete_hud");
	
	player = self;
	
	for(;;)
	{
	self setclientdvar("ui_health", self.health);
	self setclientdvar("ui_health_red", 0);
	self setclientdvar("ui_health_green", 0);
	self setclientdvar("ui_health_zlta", 0);
	//self iprintlnbold("H: "+GetDvarInt("ui_health"));
	
	if (self.health != self.maxhealth)
		self setclientdvar("ui_shop_health_avb", 1);
	else
		self setclientdvar("ui_shop_health_avb", 0);
	
	if (player.health < player.maxhealth/3 || player.health == player.maxhealth/3)
	{
		self setclientdvar("ui_health_red", 1);
	}	
	if (player.health > (player.maxhealth/3)*2 || player.health == (player.maxhealth/3)*2)
	{
		self setclientdvar("ui_health_green", 1);
	}	
	if (player.health > player.maxhealth/3 && player.health < (player.maxhealth/3)*2)
	{
		self setclientdvar("ui_health_zlta", 1);
	}
	
	self waittill("health_change");

	}
}

JoinSpectator()
{
	self.spectator = true;
	
	if(self.pers["team"] == "axis")
		self.axisalive = false;
	
	if(self.onehunter && level.onehunter)
		level.onehunter = false;
	
	if (isalive(self))
	{
		self suicide();
	}

	//self [[level.spectator]]();
	
	//origin = level.spectator_spawn.origin;
	//angles = level.spectator_spawn.angles;
	self notify( "joined_spectators" );
	self.sessionstate = "spectator";
	self.sessionteam = "spectator";
	self.spectatorclient = -1;
	self.statusicon = "";
	//self spawn( origin, angles );
	self.pers["team"] = "spectator";
	self.pers["lastteam"] = "spectator";
	
	self allowSpectateTeam( "allies", false );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", false );
}

health_hud(color)
{	
	//self endon("death");
	//self endon("disconnect");

	//self iprintln ("hud");
	self.health_hud = NewClientHudElem(self);
	self.health_hud.alignX = "center";
	self.health_hud.alignY = "middle";
	self.health_hud.font = "objective";
	self.health_hud.archived = false;
	self.health_hud.x = 585;//doprava
	self.health_hud.y = 425;//dole
	self.health_hud.alpha = 1;
	self.health_hud.sort = 1001;
	self.health_hud.fontscale = 1.4;
	
	if (color == "green")
		self.health_hud SetValue("Health: ^2"+self.health);
		
	if (color == "red")
		self.health_hud SetValue("Health: ^1"+self.health);		

	if (color == "zlta")
		self.health_hud SetValue("Health: ^3"+self.health);
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

allplayer_all()
{
	players = 0;
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isalive(player[i]) && isplayer(player[i]))
			players++;
	}
	return players;
}

cas()
{
	level endon("konec_kola");
	level.sltime = true;
	
	thread WaitPlayers();
}

WaitPlayers()
{
	level endon("konec_kola");

	while(1)
	{
		wait 0.1;
		players = AllAlivePlayers();
		
		if(players > 1)
		{
			if(StartTimer())
				return;
			else
				wait 1;
		}	
		else
		{
			level.pick_error = true;
			wait 1;
		}
	}
}

StartTimer()
{
	level endon("konec_kola");

	max = level.petx_time_lovec;
	
	for(;;)
	{
		if(AllAlivePlayers() < 2)
			return false;
			
		level.pick_error = false;
		level.secondtostart = max;
		
		wait 1;
		
		max--;
		
		if(max == 0)
			break;
	}

	if(AllAlivePlayers() < 2)
		return false;
	
	level.sltime = false;
	players = AllAlivePlayers();
	
	if(isdefined(game["special_round"]))
		pick_all_jumper(players);
	else
		pickenemy(players);
		
	return true;	
}

AllAlivePlayers(team)
{
	players = getentarray("player","classname");
	p = 0;
	
	for(i = 0;i < players.size;i++)
	{
		//iprintln("start"+i);
		player = players[i];

		if(isdefined(player)&&isplayer(player)&&isalive(player))
		{
			//iprintln("if1"+i);
			if(isdefined(team))
			{
				if(team == player.pers["team"])
					p++;
				else
					continue;	
			}
			else
				p++;
		}
	}
	return p;
}

waitdeath()
{
	self endon("disconnect");

	//for(;;)
	//{
		self waittill ("death");
		
		//self iprintln("^1death_notify");
		
		if (!self.spectator && !self.suicidedeath && self.pers["team"] == "allies" && !level.sltime) //po zacati kola, pridanie k lovcom
		{
			self Join();
			self thread radar_on_death();
		}	
		
		if (!self.spectator && !self.suicidedeath && self.pers["team"] == "allies" && level.sltime) //respawn allies
		{
			self petx\_weapons::give_class("allies", self.class_damage);
		}
		
		if (!self.spectator && !self.suicidedeath && self.pers["team"] == "axis" && !level.sltime && !level.onehunter && !isdefined(game["special_round"])) //mrtvy lovec, respawn prveho lovca deaktivovany
		{
			self.axisalive = false;
			self.sessionstate = "spectator";
			self.spectatorclient = -1;
			self allowSpectateTeam( "allies", false );
			self allowSpectateTeam( "axis", true );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", false );	
		}		

		if (!self.spectator && !self.suicidedeath && self.pers["team"] == "axis" && !level.sltime && level.onehunter && !isdefined(game["special_round"])) //mrtvy lovec, respawn prveho lovca aktivovany
		{
			wait 1;
			if (self.onehunter&&allhunter() == 1)  //respawn prveho lovca
			{		
				self.axisalive = true;
				self.onehunter_death = true;
				self petx\_weapons::give_class("axis",self.class_damage);
				self.onehunter_death = false;	
			}		
			else //mrtvy lovec
			{
				self.axisalive = false;
				self.sessionstate = "spectator";
				self.spectatorclient = -1;
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", true );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			
			wait 1;
			level.onehunter = false;
		}

		if(!self.spectator && !self.suicidedeath && self.pers["team"] == "axis" && !level.sltime && isdefined(game["special_round"])) //respawn axis pri poslednom kole
		{
			wait 1;
			self.axisalive = true;
			self petx\_weapons::give_class("axis",self.class_damage);
		}
	//}
}

radar_on_death()
{
	SetTeamRadar( "axis", true );
	setDvar( "ui_uav_axis", 1 );
	wait 4;
	SetTeamRadar( "axis", false );
	setDvar( "ui_uav_axis", 0 );
}

allhunter()
{
	players = 0;
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isplayer(player[i]) && player[i].pers["team"] == "axis")
			players++;
	}
	return players;
}

pick_all_jumper(players)
{
	players = giveallallies();
	score = 0;
	bestplayer = players[0];
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		iprintln("P: ^1"+player.name+"^7 ; S: ^1"+player.pers["score"]);
	}
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if(player.pers["score"] > score)
		{
			bestplayer = player;
			score = player.pers["score"];
		}
	}
	
	level.bestplayer = bestplayer;
	bestplayer thread give_final_weapons();
	
	for(i = 0;i < players.size;i++)
	{
		lovec = players[i];
		
		if(lovec == bestplayer)
			continue;
			
		lovec.lovec = true;	
		lovec thread lovec_team_change();
		lovec thread wait_hunterspawn();
		//lovec thread wait_hunterspawn();
	}
	
	iprintlnbold ("^1"+bestplayer.name+"^7, najlepsi hrac, ziskal zbrane.");
	level notify("start_round");
	thread petx\_sound::bonus_round_sound(randomint(3)+1);
}

give_final_weapons()
{
	weapons = [];
	weapons[weapons.size] = "saw_reflex_mp";
	weapons[weapons.size] = "rpd_reflex_mp";
	weapons[weapons.size] = "p90_reflex_mp";
	weapons[weapons.size] = "mp5_silencer_mp";
	weapons[weapons.size] = "m60e4_reflex_mp";
	weapons[weapons.size] = "m4_reflex_mp";
	weapons[weapons.size] = "m21_acog_mp";
	weapons[weapons.size] = "m16_mp";
	weapons[weapons.size] = "m14_reflex_mp";
	weapons[weapons.size] = "g3_mp";
	weapons[weapons.size] = "dragunov_acog_mp";
	weapons[weapons.size] = "ak74u_acog_mp";
	weapons[weapons.size] = "ak47_mp";

	if(isplayer(self) && isalive(self))
	{
		r = randomint(weapons.size);
		r2 = randomint(weapons.size);
		
		while(r == r2)
			r2 = randomint(weapons.size);
		
		self TakeAllWeapons();
		self GiveWeapon(weapons[r]);
		self GiveWeapon(weapons[r2]);
		self SwitchToWeapon(weapons[r]);
	}
}

pickenemy(player)
{
	j = 1;

	if (player < 5) //>< //1,2,3,4
		j = 1;		
	else if (player < 9 && player > 4) //>< //5,6,7,8
		j = 2;		
	else if (player < 13 && player > 8) //>< //9,10,11,12
		j = 3;	
	else if (player < 17 && player > 12) //>< //13,14,15,16
		j = 4;		
	else if (player < 21 && player > 16) //>< //17,18,19,20
		j = 5;		
	else
		j = 6;
		
	for (i = 0; i < j;i++)
	{
		lovec = randomlovec();
		iprintlnbold ("Hrac ^1"+lovec.name+"^7 vybrany za lovca.");

		if (j == 1 && player > 2)
		{
			lovec.onehunter = true;
			level.onehunter = true;
		}
		
		lovec.lovec = true;
		lovec thread lovec_team_change();
		lovec thread wait_hunterspawn();
		lovec thread wait_new_hunter();
		lovec thread wait_hunter_disconnect();
	}
	
	level notify("start_round");
}

lovec_team_change()
{
	rank = 99;
	if (!getDvarInt("scr_classIgnoreRank"))
	{
		rank = self maps\mp\gametypes\_rank::getrank();
	}
	self setclientdvar("ui_player_lvl", rank);

	self.suicidedeath = true;
	if( isAlive( self ) )
		self suicide();

	self.spectator = false;	
	self.axisalive = true;
	
	self.pers["team"] = "axis";
	self.sessionteam = "axis";	
	self openMenu(game["menu_changeclass_axis"]);	
}

wait_hunterspawn()
{
	hunter_spawn();

	level.spawnhunter = true;
}

hunter_spawn()
{
self endon("disconnect");
self waittill("spawned_player");
}

wait_new_hunter()
{
	self endon("disconnect");
	self endon("spawned_player");
	
	wait 60;
	
	if(!level.spawnhunter && allhunter() == 1)
		thread pickenemy(allplayer());
}

wait_hunter_disconnect()
{
	self endon("death");
	self waittill("disconnect");
	
	if(AllAlivePlayers() > 1 && AllAlivePlayers("axis") == 0)
		thread pickenemy(allplayer());
}

randomlovec()
{
	while(1)
	{
		wait 0.1;
	
		giveallallies();
		
		lovec = givescore(level.allies_players);

		if (isalive(lovec)&&isplayer(lovec)&&lovec.pers["team"] == "allies")
		{
			lovec.pers["randomlovec"]++;
			return lovec;
		}
		else
			continue;
	}
}

giveallallies()
{
	player = getentarray("player","classname");
	
	level.allies_players = undefined;
	level.allies_players = [];
		
	for(i = 0;i < player.size;i++)
	{
		if(isdefined(player[i])&&isplayer(player[i])&&player[i].pers["team"] == "allies"&&isalive(player[i]))
			level.allies_players[level.allies_players.size] = player[i];
	}
	
	return level.allies_players;
}

givescore(players)
{
	score = 100;
	lovec = undefined;
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		iprintln("P: ^1"+player.name+"^7 ; S: ^1"+player.pers["randomlovec"]);
	}
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if(player.pers["randomlovec"] < score)
		{
			lovec = player;
			score = player.pers["randomlovec"];
		}
	}
	
	if(!isdefined(lovec))
	{
		lovec = players[randomint(players.size)];
		iprintln("random_lovec");
	}
	else
		iprintln("score_lovec");
	
	return lovec;
}

Join()
{
	if(!self.sponzor)
	{
		self iprintln("^1Mod je dostupny iba pre sponzorov, VIP a adminov.");
		return;
	}
	
	rank = 99;
	if (!getDvarInt("scr_classIgnoreRank"))
	{
		rank = self maps\mp\gametypes\_rank::getrank();
	}
	self setclientdvar("ui_player_lvl", rank);

	self.suicidedeath = true;
	if( isAlive( self ) )
		self suicide();
	
	if (level.sltime)
	{
		self.spectator = false;	
			
		self.pers["team"] = "allies";
		self.pers["lastteam"] = "allies";
		self.sessionteam = "allies";	
		self openMenu(game["menu_changeclass_allies"]);
	}
	else
	{
		self.spectator = false;	
		if(!isdefined(self.axisalive))
			self.axisalive = true;
		
		self.pers["team"] = "axis";
		self.pers["lastteam"] = "axis";
		self.sessionteam = "axis";	
		self openMenu(game["menu_changeclass_axis"]);	
	}	
}