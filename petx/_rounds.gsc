#include maps\mp\gametypes\_hud_util;

init()
{
	level.new_round = false;
	level.end_map = false;
	level.end_time = false;
	
	//game["state"] = "postgame";
	
	//thread DvarOnAllPlayer("ui_hud_bold_messages", true);

	//thread timer();
	thread logic();
	//thread dvarallplayer("ui_aktualround",game["aktualround"]);
	thread update_dvar();
}
 
update_dvar()
{
	for(;;)
	{
		thread dvarallplayer("ui_aktualround",game["aktualround"]);	
		thread dvarallplayer("ui_hunter_score",game["hunterscore"]);
		thread dvarallplayer("ui_jumper_score",game["jumperscore"]);
		thread dvarallplayer("ui_round_limit",level.petx_round_limit);
		wait 1;
	}
}
 
logic()
{
	timer = level.petx_time_limit*60;
	//level waittill("start_round");
	for (i = 0;i < timer;i++)
	{
		wait 1;
		if (!level.sltime)
		{
			jumper = alljumper();
			if (level.spawnhunter && jumper == 0) 
			{
				thread winhunter();
				return;
			}
			
			hunter = allhunter();
			if (level.spawnhunter && !level.onehunter && hunter == 0) 
			{
				thread winjumper();
				return;
			}
		}

	}
	
	thread winjumper();
}

freeze_control()
{
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isalive(player[i]) && isplayer(player[i]) && (player[i].pers["team"] == "allies" || player[i].pers["team"] == "axis"))
			player[i] freezeControls( true );
	}
}

rounds(team)
{
	game["aktualround"]++;
	setdvar ("ui_aktualround", game["aktualround"]);
	thread dvarallplayer("ui_aktualround",game["aktualround"]);
	level notify("konec_kola");
	
	thread clear_hud();
	thread freeze_control();
	level.end_round_go = true;
	visionSetNaked( "end_round_red", 10 );
	
	wait 1;
	
	level.special_round = false;
	
	if (game["aktualround"] > level.petx_round_limit)
	{
		player = getentarray("player", "classname");
		if(isdefined(game["special_round"]) || player.size < 4)
			level.end_map = true;
		else
			level.special_round = true;
		
		if(game["aktualround"] == level.petx_round_limit+1 && (player.size != 0 || player.size != 1))
		{
			thread bonus_info_hud();
			thread DvarOnAllPlayer("ui_hud_bold_messages", true);
			thread petx\_sound::final_info_sound();
		}
	}
	else
	{
		level.new_round = true;
		thread DvarOnAllPlayer("ui_hud_bold_messages", false);
		thread endround_hud(game["aktualround"],team,game["jumperscore"],game["hunterscore"]);
		thread petx\_sound::end_round_sound();
	}

	if(level.special_round)
		wait 18;
	else if(level.new_round)
		wait 12;
	else if(game["aktualround"] == level.petx_round_limit+1)
		wait 18;
	
	if (level.new_round)
	{
		level.new_round = false;
		//spectator_team();
		//autorespawn();
		game["first_round"] = false;
		game["state"] = "playing";
		map_restart( true );
	}
	
	if(level.special_round)
	{
		game["first_round"] = false;
		game["state"] = "playing";
		game["special_round"] = true;
		map_restart( true );	
	}
	
	if (level.end_map)
		end_map_go();
}

DvarOnAllPlayer(string, value)
{
	if(!isdefined(string) || string == "" || !isdefined(value))
		return;

	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
		players[i] SetClientDvar(string, value);
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

end_map_go()
{
	setdvar ("ui_jumper_score", 0);
	thread dvarallplayer("ui_jumper_score",0);

	setdvar ("ui_hunter_score", 0);
	thread dvarallplayer("ui_hunter_score",0);

	setdvar ("ui_aktualround", 1);
	thread dvarallplayer("ui_aktualround",1);
	
	exitLevel( false );
}

winhunter()
{
	level notify ("end_round");
	game["hunterscore"]++;
	
	setdvar ("ui_hunter_score", game["hunterscore"]);
	thread dvarallplayer("ui_hunter_score",game["hunterscore"]);
	
	//thread winninghud("hunter");
	thread rounds("Lovci");
}

dvarallplayer(dvar,hodnota)
{
	player = getentarray("player", "classname");
	
	for(i = 0;i<player.size;i++)
	{
		player[i] setclientdvar(dvar,hodnota);
	}
}

winjumper()
{
	level notify ("end_round");
	game["jumperscore"]++;
	
	setdvar ("ui_jumper_score", game["jumperscore"]);
	thread dvarallplayer("ui_jumper_score",game["jumperscore"]);
	
	//thread winninghud("jumper");
	thread rounds("Jumperi");
}

clear_hud()
{
	level notify("delete_hud");
	
	/*//hodiny
	if (isdefined(level.timer))
	{
		level.timer destroyElem();
		level.timer_text destroyElem();
		level.timer = undefined;
	}*/

	//potrebny 2 hraci
	if (isdefined(level.starttime_error))
	{
		level.starttime_error destroyElem();
		level.starttime_error = undefined;
	}	
	
	//odpocitavanie do lovca
	if (isdefined(level.starttime_cislo))
	{
		level.starttime_cislo destroyElem();
		level.starttime_cislo = undefined;
	}	
	
	if (isdefined(level.starttime_text))
	{
		level.starttime_text destroyElem();
		level.starttime_text = undefined;
	}	

	//zatvorenie menus
	thread clear_player_hud();
	
	//zmazanie bold/iprintln
	/*for( i = 0; i < 6; i++ )
	{
		iPrintlnBold( " " );
		iPrintln( " " );
	}*/
	
	//vypnutie hudu
	setdvar ("ui_hud_hardcore", "1");
	
	//vypnutie casu
	setGameEndTime( 0 );
	game["state"] = "postgame";
}

clear_player_hud()
{
	player = getentarray("player", "classname");
	for(i = 0;i < player.size;i++)
	{
		if (isplayer(player[i]))
		{
			player[i] closeMenu();
			player[i] closeInGameMenu();
		}
	}
}

endround_hud(round,team,jumper,hunter)
{	
	player = getentarray ("player" , "classname");
	for(i = 0; i < player.size; i++)
	{	
		if (isplayer(player[i]))
		{
		
			startround = SpawnStruct();
			startround.titleText = team+" vyhrali";
			
			if(level.new_round)
				startround.notifyText = "Startuje kolo "+round+" z "+level.petx_round_limit;
				
			startround.duration = 11;
			startround.glowcolor = (0,255,0);
			player[i] thread maps\mp\gametypes\_hud_message::notifyMessage( startround );
		}
	}	

	score_jumper_icon = NewHudElem();
	score_jumper_icon.alignX = "center";
	score_jumper_icon.alignY = "middle";
	//score_jumper_icon.font = "objective";
	//score_jumper_icon.archived = false;
	score_jumper_icon.x = 235;//doprava
	score_jumper_icon.y = 180;//dole
	score_jumper_icon.alpha = 1;
	score_jumper_icon.sort = 1001;
	score_jumper_icon.hidewheninmenu = true;
	//score_jumper_icon.fontscale = 1.4;
	score_jumper_icon SetShader("logo_jumper", 150, 150);	

	score_hunter_icon = NewHudElem();
	score_hunter_icon.alignX = "center";
	score_hunter_icon.alignY = "middle";
	//score_hunter_icon = "objective";
	//score_hunter_icon.archived = false;
	score_hunter_icon.x = 405;//doprava
	score_hunter_icon.y = 180;//dole
	score_hunter_icon.alpha = 1;
	score_hunter_icon.sort = 1001;
	score_hunter_icon.hidewheninmenu = true;
	//score_hunter_icon.fontscale = 1.4;
	score_hunter_icon SetShader("logo_lovec", 150, 150);				
	
	score_jumper = NewHudElem();
	score_jumper.alignX = "center";
	score_jumper.alignY = "middle";
	score_jumper.font = "objective";
	score_jumper.archived = false;
	score_jumper.x = 237;//doprava
	score_jumper.y = 280;//dole
	score_jumper.alpha = 1;
	score_jumper.sort = 1001;
	score_jumper.fontscale = 3.5;
	score_jumper.hidewheninmenu = true;
	score_jumper SetValue(jumper);
	
	score_hunter = NewHudElem();
	score_hunter.alignX = "center";
	score_hunter.alignY = "middle";
	score_hunter.font = "objective";
	score_hunter.archived = false;
	score_hunter.x = 404;//doprava
	score_hunter.y = 280;//dole
	score_hunter.alpha = 1;
	score_hunter.sort = 1001;
	score_hunter.fontscale = 3.5;
	score_hunter.hidewheninmenu = true;
	score_hunter SetValue(hunter);
	
	player = getentarray("player","classname");
	for(i = 0;i<player.size;i++)
	{
		//player[i] iprintln("for(;;)");
		if (player[i].pers["team"] == "allies" || player[i].pers["team"] == "axis")
		{
			//player[i] iprintln("if(team)");

			if(!player[i].lovec && player[i].bonus_point["allies"] != 0)
			{
				//player[i] iprintln("if(allies)");
				if(team == "Jumperi" ) //vyhra jumperov-hrac bol/je jumper
					player[i] thread bonus_hud(int(player[i].bonus_point["allies"]/level.petx_bonus_point*2));
				else //vyhra lovcov-hrac bol/je jumper	
					player[i] thread bonus_hud(int(player[i].bonus_point["allies"]/level.petx_bonus_point));
			}

			if(player[i].lovec && player[i].bonus_point["axis"] != 0)
			{
				//player[i] iprintln("if(axis)");
				if(team == "Jumperi" ) //vyhra jumperov-hrac je lovec
					player[i] thread bonus_hud(int(player[i].bonus_point["axis"]/level.petx_bonus_point));
				else //vyhra lovcov-hrac je lovec	
					player[i] thread bonus_hud(int(player[i].bonus_point["axis"]/level.petx_bonus_point*1.5));	
			}	
		}			
	}
}

bonus_info_hud()
{
	bonus_hud_icon = newHudElem();
	bonus_hud_icon.x = 320;
	bonus_hud_icon.y = 95;
	bonus_hud_icon.alignX = "center";
	bonus_hud_icon.alignY = "middle";
	bonus_hud_icon.alpha = 0;
	bonus_hud_icon.sort = 10;
	bonus_hud_icon.hidewheninmenu = true;

	clean();
	
	if(game["jumperscore"] != game["hunterscore"])
	{
		if(game["jumperscore"] > game["hunterscore"])
			bonus_hud_icon thread bonus_info_hud_change("faction_128_sas");
		else
			bonus_hud_icon thread bonus_info_hud_change("faction_128_arab");
			
		wait 0.001;
		iprintlnbold("Najlepsi Team");
		
		if(game["jumperscore"] > game["hunterscore"])
			iprintlnbold("^4Jumperi");
		else
			iprintlnbold("^1Lovci");
			
		wait 3;
	}
	
	bonus_hud_icon thread bonus_info_hud_change("info_score");
	wait 0.001;
	player = petx\_info::getbest("score");
	iprintlnbold("Najlepsi hrac");
	iprintlnbold("^1"+player.name);
	
	wait 3;

	bonus_hud_icon thread bonus_info_hud_change("faction_128_sas");
	wait 0.001;	
	player = petx\_info::getbest("bestjumper");
	iprintlnbold("Najlepsi Jumper");
	iprintlnbold("^1"+player.name);	

	wait 3;

	bonus_hud_icon thread bonus_info_hud_change("faction_128_arab");
	wait 0.001;	
	player = petx\_info::getbest("bestlovec");
	iprintlnbold("Najlepsi Lovec");
	iprintlnbold("^1"+player.name);	

	wait 3;

	bonus_hud_icon thread bonus_info_hud_change("info_fast");
	wait 0.001;	
	player = petx\_info::getbest("bestdistance");
	iprintlnbold("Najlepsi bezec");
	iprintlnbold("^1"+player.name);
	
	wait 3;

	bonus_hud_icon thread bonus_info_hud_change("info_camper");
	wait 0.001;	
	player = petx\_info::lowdistance("lowdistance");
	iprintlnbold("Najlepsi kemper");
	iprintlnbold("^1"+player.name);	
}

clean()
{
	for(i = 0;i < 6;i++)
	{
		iprintlnbold(" ");
	}
}

bonus_info_hud_change(shader)
{	
	clean();
	self SetShader(shader, 64, 64);
	self.alpha = 0;
	self fadeOverTime( 0.3 );
	self.alpha = 1;
	wait 2.4;
	self fadeOverTime( 0.3 );
	self.alpha = 0;
}

bonus_hud(hodnota)
{
	//self iprintln("bonus");
	self petx\_upoint::giveupoint(undefined,hodnota);
	score = self.pers["score"];
	maps\mp\gametypes\_globallogic::_setPlayerScore( self, score+hodnota );
	self thread maps\mp\gametypes\_rank::giveRankXP( "bonus", hodnota );
	
	self.bonus_hud = NewClientHudElem(self);
	self.bonus_hud.alignX = "center";
	self.bonus_hud.alignY = "middle";
	self.bonus_hud.font = "objective";
	self.bonus_hud.archived = false;
	self.bonus_hud.x = 320;//doprava
	self.bonus_hud.y = 340;//dole
	self.bonus_hud.hidewheninmenu = true;
	self.bonus_hud.alpha = 1;
	self.bonus_hud.sort = 1001;
	self.bonus_hud.fontscale = 2.3;
	self.bonus_hud settext("Bonus za kolo: "+hodnota);
}	

alljumper()
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

allhunter()
{
	players = 0;
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isalive(player[i]) && isplayer(player[i]) && player[i].pers["team"] == "axis")
			players++;
	}
	return players;
}