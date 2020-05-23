init()
{
	game["menu_clientcmd"] = "clientcmd";
	precacheMenu( game["menu_clientcmd"] );

	thread Onplayerconnect();
	thread zoznam_map();
}
 
Onplayerconnect()
{
	while(1)
	{
		level waittill("connected",player);
		
		player.player_icon_true = false;
		
		player.admin = false;
		player.sponzor = true;
		player.acpacess = false;
		player setclientdvars("ui_admbut_vis", 0, "ui_adm_blue", 0);

		player thread zobrazenie_mapy();
		player thread zobrazenie_hraca();
		player thread ACPAccessFromB3();
		
		//auto admin
		/*
		player.admin = true;
		player setclientdvar("ui_admbut_vis", 1);
		player notify("overenie_prav");
		//
		*/
		
		player thread OnSpawnPlayer();
	}
}
 
OnSpawnPlayer()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("spawned_player");
		
		self thread player_delete_point();
		
		//self thread MenuResponses();
	}
}
 
wait_guid()
{
	guid = self getGuid();

	if(!isdefined(guid) || guid == "")
	{
		iprintln("Connect player: ^1 "+self.name+"^7 No guid!");
		return;
	}	
	else
	{
		if (guid == "8efa4cbada87e6348e7db02e3893dd89")	//moj guid xD
		{
			self.admin = true;
			iprintln("Connect admin: ^1 "+self.name+"^7 Guid: "+guid);
		}	
		else
		{
			self.admin = false;
			iprintln("Connect player: ^1 "+self.name+"^7 Guid: "+guid);
		}
	}
	self notify("overenie_prav");	
}

debug_onspawn(text)
{
	self waittill("spawned_player");

	self iprintln(text);
}

zoznam_map()
{
	map_mix = strtok(getdvar("sv_mapRotation"), " ");
	m = 0;
	gametype = false;
	//sv_mapRotation "gametype war map mp_citystreets gametype war map mp_broadcast gametype war map mp_overgrown
	
	for(i = 0;i<map_mix.size;i++)
	{
		if(map_mix[i] == "gametype") //vylucenie stringu "gametype"
		{
			gametype = true;
			continue;
		}
		
		if(gametype) //vylucenie konkretneho gametypu
		{
			gametype = false;
			continue;
		}	
		
		if(map_mix[i] == "map") //vylucenie stringu "map"
			continue;
			
		level.zoznam_map[m] = map_mix[i]; //pridanie mapy do zoznamu
		m++;
	}
	
	/*level waittill("connected",player);
	for(a = 0;a <level.zoznam_map.size;a++)
		player thread debug_onspawn(level.zoznam_map[a]);
	*/	
}

zobrazenie_mapy()
{
	self waittill("overenie_prav");

	if (!self.admin)
		return;

	self setclientdvar("admin_map_first",level.zoznam_map[level.zoznam_map.size-1]);
	self setclientdvar("admin_map_second",level.zoznam_map[0]);
	self setclientdvar("admin_map_third",level.zoznam_map[1]);
	
	level.admin_set_map = level.zoznam_map[0];
	i = 0;
	
	for(;;)
	{
		
		self waittill("admin_map_rotate",stav);

		if (stav == "next")
		{	
			i++;

			if (i == level.zoznam_map.size)
				i = 0;
			
			if (i == 0)
				self setclientdvar("admin_map_first",level.zoznam_map[(level.zoznam_map.size-1)]);
			else
				self setclientdvar("admin_map_first",(level.zoznam_map[i-1]));		
				
			self setclientdvar("admin_map_second",level.zoznam_map[i]); //center
			
			if(i == level.zoznam_map.size-1)
				self setclientdvar("admin_map_third",level.zoznam_map[0]);
			else
				self setclientdvar("admin_map_third",level.zoznam_map[i+1]);		
		}
		
		if (stav == "prev")
		{	
			i--;

			if (i == -1)
				i = level.zoznam_map.size-1;
			
			if (i == 0)
				self setclientdvar("admin_map_first",level.zoznam_map[(level.zoznam_map.size-1)]);
			else
				self setclientdvar("admin_map_first",(level.zoznam_map[i-1]));		
				
			self setclientdvar("admin_map_second",level.zoznam_map[i]); //center
			
			if (i == level.zoznam_map.size-1)
				self setclientdvar("admin_map_third",level.zoznam_map[0]);		
			else
				self setclientdvar("admin_map_third",level.zoznam_map[i+1]);	
		}
		
		level.admin_set_map = level.zoznam_map[i];
	}
}

restart(stav)
{
	guid = self getguid();
	num = self GetEntityNumber();

	if (stav == "round")
	{
		iprintlnbold("Aktualne kolo restartovane adminom o 3 sekundy.");
		wait 1;
		iprintlnbold("Aktualne kolo restartovane adminom o 2 sekundy.");
		wait 1;
		iprintlnbold("Aktualne kolo restartovane adminom o 1 sekundu.");
		wait 1;
		logPrint("A;FastRestart;Admin:"+self.name+";Guid:"+guid+";Num:"+num+"\n");
		map_restart( true );
	}	
	if (stav == "map")
	{
		map_rest = getDvar( "mapname" );
		nextmap = getDvar( "sv_mapRotationCurrent" );
		
		iprintlnbold("Aktualna mapa restartovana adminom o 3 sekundy.");
		wait 1;
		iprintlnbold("Aktualna mapa restartovana adminom o 2 sekundy.");
		wait 1;
		iprintlnbold("Aktualna mapa restartovana adminom o 1 sekundu.");
		wait 1;	
		logPrint("A;MapRestart;Admin:"+self.name+";Guid:"+guid+";Num:"+num+"\n");
		setDvar( "sv_maprotationcurrent", "gametype war map " + map_rest +" "+ nextmap ); //thanks BraX xD
		exitLevel(false);
	}	
	if(stav == "set")
	{
		map = level.admin_set_map;
		nextmap = getDvar( "sv_mapRotationCurrent" );
		
		iprintlnbold("Mapa ^1"+map+"^7 spustena adminom o 3 sekundy.");
		wait 1;
		iprintlnbold("Mapa ^1"+map+"^7 spustena adminom o 2 sekundy.");
		wait 1;
		iprintlnbold("Mapa ^1"+map+"^7 spustena adminom o 1 sekundu.");
		wait 1;
		logPrint("A;MapSet;Map:"+map+";Admin:"+self.name+";Guid:"+guid+";Num:"+num+"\n");
		setDvar( "sv_maprotationcurrent", "gametype war map " + map +" "+ nextmap ); //thanks BraX xD
		exitLevel(false);
	}
	
	if(stav == "set_next")
	{
		map = level.admin_set_map;
		nextmap = getDvar( "sv_mapRotationCurrent" );
		
		iprintlnbold("Nasledujuca mapa: ^1"+map);
		logPrint("A;MapSetNext;Map:"+map+";Admin:"+self.name+";Guid:"+guid+";Num:"+num+"\n");
		setDvar( "sv_maprotationcurrent", "gametype war map "+ map +" "+ nextmap ); //thanks BraX xD
	}
	
	if (stav == "next_map")
	{
		
		iprintlnbold("Dalsia mapa spustena o 3 sekundy.");
		wait 1;
		iprintlnbold("Dalsia mapa spustena o 2 sekundy.");
		wait 1;
		iprintlnbold("Dalsia mapa spustena o 1 sekundu.");
		wait 1;	
		logPrint("A;RunNextMap;Admin:"+self.name+";Guid:"+guid+";Num:"+num+"\n");
		exitLevel(false);
	}
}

zobrazenie_hraca()
{
	self waittill("overenie_prav");

	if (!self.admin)
		return;
	
	player = getentarray("player","classname");
	
	if(player.size == 1)
	{
		self setclientdvar("admin_player_first","");
		self setclientdvar("admin_player_third","");
		self setclientdvar("admin_player_second",player[0].name);
	}
	else if(player.size == 2)
	{
		self setclientdvar("admin_player_first","");
		self setclientdvar("admin_player_second",player[0].name);
		self setclientdvar("admin_player_third",player[1].name);
	}
	else
	{
	self setclientdvar("admin_player_first",player[player.size-1].name);
	self setclientdvar("admin_player_second",player[0].name);
	self setclientdvar("admin_player_third",player[1].name);
	}
	
	level.admin_set_player = player[0];
	i = 0;
	
	for(;;)
	{
		
		self waittill("admin_player_rotate",stav);
		player = getentarray("player","classname");

		if (player.size == 1)
			continue;
			
		if (stav == "next")
		{	
			i++;

			if (i == player.size)
				i = 0;
			
			if (i == 0)
				if(isdefined(player[player.size-1]))
					self setclientdvar("admin_player_first",player[player.size-1].name);
				else
					self setclientdvar("admin_player_first","");
			else
				if(isdefined(player[i-1]))
					self setclientdvar("admin_player_first",player[i-1].name); //0
				else
					self setclientdvar("admin_player_first","");
			
			if(isdefined(player[i]))
				self setclientdvar("admin_player_second",player[i].name); //center 1
			else
				self setclientdvar("admin_player_second","Pre zobrazenie nicku hraca pockaj do dalsieho kola..."); //center 1
			
			if(i == player.size-1)
				if(isdefined(player[0]))
					self setclientdvar("admin_player_third",player[0].name);
				else
					self setclientdvar("admin_player_third","");
			else
				if(isdefined(player[i+1]))
					self setclientdvar("admin_player_third",player[i+1].name);	
				else
					self setclientdvar("admin_player_third","");
		}
		
		if (stav == "prev")
		{	
			i--;

			if (i == -1)
				i = player.size-1;
			
			if (i == 0)
				if(isdefined(player[player.size-1]))
					self setclientdvar("admin_player_first",player[player.size-1].name);
				else
					self setclientdvar("admin_player_first","");
			else
				if(isdefined(player[i-1]))
					self setclientdvar("admin_player_first",player[i-1].name);	
				else
					self setclientdvar("admin_player_first","");
			
			if(isdefined(player[i]))
				self setclientdvar("admin_player_second",player[i].name); //center
			else
				self setclientdvar("admin_player_second","Pre zobrazenie nicku hraca pockaj do dalsieho kola..."); //center
			
			if (i == player.size-1)
				if(isdefined(player[0]))
					self setclientdvar("admin_player_third",player[0].name);		
				else
					self setclientdvar("admin_player_third","");
			else
				if(isdefined(player[i+1]))
					self setclientdvar("admin_player_third",player[i+1].name);	
				else
					self setclientdvar("admin_player_third","");
		}
		
		level.admin_set_player = player[i];
	}
}

player_options( stav )
{
	player = level.admin_set_player;

	if(!isdefined(player))
		return;
	
	guid = self getguid();
	num = self GetEntityNumber();
	
	pguid = player getguid();
	pnum = player GetEntityNumber();

	switch(stav)
	{
	case "kill": 
		if(isalive(player)&&(player.pers["team"] == "allies"||player.pers["team"] == "axis"))
		{
			player suicide();
			player iprintlnbold("Zabil ta admin!");
			self iprintlnbold("Zabil si hraca ^1"+player.name);
			iprintln("Hrac ^1"+player.name+" ^7zabity adminom.");
			logPrint("A;KillPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
		}
		break;				

	case "point": 		
		if(!player.player_icon_true)
		{
			player iprintlnbold("Bol si oznaceny adminom!");
			self iprintlnbold("Oznacil si hraca ^1"+player.name);
			iprintln("Hrac ^1"+player.name+" ^7oznaceny adminom.");
			logPrint("A;AddPointPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
		
			player.player_icon_true = true;
			player thread player_point();
		}	
		else
		{
			player iprintlnbold("Znacka bola odstranena!");
			self iprintlnbold("Odstranil si znacku hracovi ^1"+player.name);
			iprintln("Hracovi ^1"+player.name+" ^7bola odstranena znacka.");
			logPrint("A;RemovePointPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
			
			player.player_icon_true = false;
		}		
		break;		

	case "spect":
		if(player.pers["team"] != "spectator")
		{
			player iprintlnbold("Zmena teamu adminom!");
			self iprintlnbold("Zmenil si team hraca ^1"+player.name);
			iprintln("Hrac ^1"+player.name+" ^7presunuty do spectatora adminom.");
			logPrint("A;SpectatorPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
			player petx\_teams::JoinSpectator();
		}
		break;	
		
	case "team":
		if(player.pers["team"] != "allies"&&player.pers["team"] != "axis")
		{
			player iprintlnbold("Zmena teamu adminom!");
			self iprintlnbold("Zmenil si team hraca ^1"+player.name);
			iprintln("Hrac ^1"+player.name+" ^7presunuty do hry adminom.");
			logPrint("A;TeamPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
			player petx\_teams::join();
		}
		break;					

	case "resp":
		if(!isalive(player)&&(player.pers["team"] == "allies"||player.pers["team"] == "axis"))
		{
			player iprintlnbold("Respawn od admina!");
			self iprintlnbold("Respawn hraca ^1"+player.name);
			iprintln("Hrac ^1"+player.name+" ^7oziveny adminom.");
			logPrint("A;RespawnPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");

			player petx\_weapons::give_class(player.pers["team"], player.class_damage);	
		}
		break;

	case "kick":
		player iprintlnbold("^1Kicknutie adminom!");
		
		player closeMenu();
		player closeInGameMenu();	
		
		wait 3;
		self iprintlnbold("Kickol si hraca ^1"+player.name);
		iprintln("Hrac ^1"+player.name+" ^7vyhodeny adminom.");	
		logPrint("A;KickPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");

		player closeMenu();
		player closeInGameMenu();	
		
		player setClientDvar( game["menu_clientcmd"], "quit" );
		player openMenu( game["menu_clientcmd"] );
		player closeMenu( game["menu_clientcmd"] );
		break;		
	
	
	case "level":
		logPrint("A;AddLevelPlayer;Admin:"+self.name+";Guid:"+guid+";Num:"+num+";Player:"+player.name+";Guid:"+pguid+";Num:"+pnum+"\n");
		self iprintlnbold("Pridal si level hracovi ^1"+player.name);
		player iprintlnbold("Level zvyseny adminom.");
		
		max = player maps\mp\gametypes\_persistence::statGet( "maxxp" );
		last = player maps\mp\gametypes\_persistence::statGet( "lastxp" );
		
		if(isdefined(max)&&isdefined(last))
		{
			plus = max-last;
		
			score = player.pers["score"];
			maps\mp\gametypes\_globallogic::_setPlayerScore( player, score+plus );
			player thread maps\mp\gametypes\_rank::giveRankXP( "life", plus );
		}
		
		break;
	}
}

player_point()
{
self endon("disconnect");

objCompass = maps\mp\gametypes\_gameobjects::getNextObjID();

	for(;;)
	{
		if(self.player_icon_true)
		{
			if ( objCompass != -1 ) 
			{
				objective_add( objCompass, "active", self.origin );
				objective_icon( objCompass, "compass_waypoint_bomb" );
				objective_onentity( objCompass, self );
				/*if ( level.teamBased ) 
				{
					objective_team( objCompass, level.otherTeam[ self.pers["team"] ] );
				}*/
			}
		}
		else
		{
			if ( objCompass != -1 ) 
			{
				objective_delete( objCompass );
			}
			return;
		}
		wait 0.1;
	}
}

player_delete_point()
{
	self endon("disconnect");

	self waittill("death");

	if(self.player_icon_true)
		self.player_icon_true = false;
		
	return;
}
		
ACPAccessFromB3()
{
 while(1) 
 {
  
  for ( i = 0; i < level.players.size; i++ )
  {
   player = level.players[i];
   if ( isDefined( player ) )
   {
    enNum = player getEntityNumber();
    //iprintln("hladam " + enNum);
 
	if(!player.acpacess)
	{
		guid = player getguid();
		if(isdefined(guid) && guid == "8efa4cbada87e6348e7db02e3893dd89")
		{
			player.admin = true;
			player setclientdvars("ui_admbut_vis", 1, "ui_adm_blue", 1);
			player notify("overenie_prav");
		}
		player.acpacess = true;
		//player notify("overenie_prav");
	}
 
    info = getdvar( "acp_info_" + enNum );
    if (info == "" || (isDefined(player.acp_info) && player.acp_info == info))
		continue;

    player.acp_info = info;
    info = strtok( info, ":" );
    
    if(!isDefined(info) || !isDefined(player))
     continue;
    
    if(isDefined(info[0])) 
	{
     player.showme = int(info[0]);
    }    

    if(isDefined(info[1])) 
	{
     player.b3level = int(info[1]);
    }
	
    if (player.b3level >= 40)
    {	
		player.admin = true;
		player setclientdvar("ui_admbut_vis", 1);
		//iprintln("Connect admin: ^1 "+player.name);
     //player thread initAACP();
    }
	else if(player.b3level == 10)
	{
		//player.admin = false;
		//iprintln("Connect VIP: ^1 "+player.name);	
	}
	else if(player.b3level == 6)
	{
		//player.admin = false;
		//iprintln("Connect sponzor: ^1 "+player.name);	
	}	
	else
	{
		//player.admin = false;
		//iprintln("Connect player: ^1 "+player.name);	
	}

	if(player.b3level < 6)
		//player.sponzor = false; //zistenie sponzora a vyssie
	
	if(player.b3level >= 100)
		player setclientdvar("ui_adm_blue", 1);
	
	player notify("overenie_prav");
	
   }
  }
  
  wait 0.5;
 }
}

showMarshalIcon()
{
 self endon("disconnect");
 
 self.showme = 1;
 self.b3level = 0;
 
 for (;;) 
 {
  wait(1);

  if (self.showme == 0)
   continue;

  if (self.statusicon != "")
   continue;
  
  if ( self.b3level >= 100 )
   self.statusicon = "hud_status_marshal2";
  else if ( self.b3level >= 80)
   self.statusicon = "hud_status_marshal3";
  else if ( self.b3level >= 60 )
   self.statusicon = "hud_status_marshal";
  else if ( self.b3level >= 40 )
   self.statusicon = "hud_status_marshal";
  else if ( self.b3level >= 10 )
   self.statusicon = "hud_status_vip2";
  else if ( self.b3level >= 6 )
   self.statusicon = "hud_status_sponzor";
  else if ( self.b3level >= 2 )
   self.statusicon = "hud_status_vip2";

 } 
}

start_origin_vis()
{
	origin_hud = NewClientHudElem(self);
	origin_hud.alignX = "center";
	origin_hud.alignY = "middle";
	origin_hud.font = "objective";
	origin_hud.archived = false;
	origin_hud.x = 30;//doprava
	origin_hud.y = 240;//dole
	origin_hud.alpha = 1;
	origin_hud.sort = 1001;
	origin_hud.fontscale = 1.4;	
	origin_hud.hidewheninmenu = true;
	
	origin_hud2 = NewClientHudElem(self);
	origin_hud2.alignX = "center";
	origin_hud2.alignY = "middle";
	origin_hud2.font = "objective";
	origin_hud2.archived = false;
	origin_hud2.x = 30;//doprava
	origin_hud2.y = 260;//dole
	origin_hud2.alpha = 1;
	origin_hud2.sort = 1001;
	origin_hud2.fontscale = 1.4;	
	origin_hud2.hidewheninmenu = true;

	origin_hud3 = NewClientHudElem(self);
	origin_hud3.alignX = "center";
	origin_hud3.alignY = "middle";
	origin_hud3.font = "objective";
	origin_hud3.archived = false;
	origin_hud3.x = 30;//doprava
	origin_hud3.y = 280;//dole
	origin_hud3.alpha = 1;
	origin_hud3.sort = 1001;
	origin_hud3.fontscale = 1.4;	
	origin_hud3.hidewheninmenu = true;	
	
	self thread player_origin(origin_hud, origin_hud2, origin_hud3);
}

player_origin(origin_hud, origin_hud2, origin_hud3)
{
	self endon("disconnect");
	lastorigin = self.origin;
	
	model = spawn("script_model", self.origin);
	model setmodel("ch_sign_noentry");
	
	while(1)
	{
		wait 0.01;
		if(lastorigin != self.origin)
		{
			origin_hud SetValue(int(self.origin[0]));
			origin_hud2 SetValue(int(self.origin[1]));
			origin_hud3 SetValue(int(self.origin[2]));
			model.origin = self.origin;
			lastorigin = self.origin;
		}	
	}
}