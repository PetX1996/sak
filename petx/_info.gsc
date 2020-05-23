//#include maps\mp\gametypes\_hud_util;

init()
{
	level.pick_error = true;
	level.secondtostart = 0;
	
	thread start_huds();
	
	thread onplayerconnected();
}

onplayerconnected()
{
	for(;;)
	{
		level waittill ("connected", player);

		if(!isdefined(player.pers["bestjumper"]))
			player.pers["bestjumper"] = 0;
		if(!isdefined(player.pers["bestlovec"]))
			player.pers["bestlovec"] = 0;
		if(!isdefined(player.pers["bestdistance"]))
			player.pers["bestdistance"] = 0;	
		if(!isdefined(player.pers["lowdistance"]))
			player.pers["lowdistance"] = 100000000;			
		
		player setclientdvar("ui_hud_bold_messages", true);
		
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ("spawned_player");
		
		self thread start_distance();
		self thread start_best_lovec();
		//self thread start_spam();
		//self thread start_huds();
	}
}

start_spam()
{
	self endon("disconnect");
	self endon("death");
	
	while(1)
	{
		self iprintlnbold("^1A ------------ A");
		wait 1;
		self iprintlnbold("^2B ------------ B");
		wait 1;
		self iprintlnbold("^3C ------------ C");
		wait 1;
	}
}

start_huds()
{
	/*
	
	1 = cervena
	2 = zlta
	3 = zelena
	4 = modra
	5 = fialova
	6 = ruzova
	7 = biela
	
	*/
	
	info = [];
	i = 0;
	
	//reklama
	info[i]["text"] = "For Gamers Fusion";
	info[i]["color"] = 4;
	i++;
	info[i]["text"] = "4GF.CZ";
	info[i]["color"] = 4;
	i++;	
	info[i]["text"] = "Search & Kill";
	info[i]["color"] = 4;
	i++;
	info[i]["text"] = "Creator: PetX";
	info[i]["color"] = 4;
	i++;
	info[i]["text"] = "Graphic: Col!ar";
	info[i]["color"] = 4;
	i++;
	info[i]["text"] = "Thanks: mnaauuu, K4r3l01, Briki, Peter";
	info[i]["color"] = 4;
	i++;	
	info[i]["text"] = "Special thanks: mnaauuu, K4r3l01";
	info[i]["color"] = 4;
	i++;
	
	//info
	info[i]["text"] = "More info in the Help menu";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Viac info v menu Help";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Specialitu pouzijes B+1 alebo B+2";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Vlastnost classu sa aktivuje automaticky";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Classy su dostupne od urciteho levelu";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Cielom Jumperov je zdrhat pred Lovcami";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Cielom Lovcov je zabit Jumperov";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Pozicia shopov sa kazde kolo meni";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "V shopoch je mozne nakupovat zbrane a speciality";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Speciality box sa objavi kazde kolo";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Mod je v BETA verzii";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Popis specialit a zbrani najdete priamo v shope";
	info[i]["color"] = 3;
	i++;
	info[i]["text"] = "Ziadne chodenie za mapu!";
	info[i]["color"] = 3;
	i++;	

	info thread score_hud(i);
	
	lastr = randomint(i);
	c = 1;
	while(true)
	{
		wait 0.001;
		//iprintln("modul: "+(c%3));
	
		if(level.sltime && !level.pick_error)
		{
			if(!isdefined(game["special_round"]))
				thread DvarOnAllPlayer("ui_info_mix", "Lovec vybrany za: "+level.secondtostart);
			else
				thread DvarOnAllPlayer("ui_info_mix", "Bonusove kolo startuje za: "+level.secondtostart);
				
			thread DvarOnAllPlayer("ui_info_mix_color", 2);
			wait 0.9;
			continue;
		}
		
		if(level.sltime && level.pick_error && c%3 == 0)
		{
			thread DvarOnAllPlayer("ui_info_mix", "Pre start su potrebni minimalne 2 hraci.");
			thread DvarOnAllPlayer("ui_info_mix_color", 2);			
			
			wait 3;
			c++;
		}
		
		if((level.sltime && level.pick_error && c%3 == 1) || !level.sltime)
		{
			thread DvarOnAllPlayer("ui_info_mix", "Round "+game["aktualround"]+"/"+level.petx_round_limit);
			thread DvarOnAllPlayer("ui_info_mix_color", 1);

			wait 3;	
			c++;
		}
		
		if((level.sltime && level.pick_error && c%3 == 2 ) || !level.sltime)
		{
			r = randomint(i);
			
			while(r == lastr)
				r = randomint(i);
				
			lastr = r;
				
			text = info[r]["text"];
			color = info[r]["color"];
		
			thread DvarOnAllPlayer("ui_info_mix", text);
			thread DvarOnAllPlayer("ui_info_mix_color", color);	

			if(!level.sltime)
				wait 10;
			else
				wait 5;
			c++;
		}
	}
}

score_hud(i)
{
	lastr = randomint(i);
	c = 0;
	
	while(true)
	{
		if(c%2 == 0)
		{
			r = randomint(i);
				
			while(r == lastr)
				r = randomint(i);
				
			lastr = r;
				
			text = self[r]["text"];
			color = self[r]["color"];
		
			thread DvarOnAllPlayer("ui_info_only", text);
			thread DvarOnAllPlayer("ui_info_only_color", 7);	

			wait 10;
			c++;
		}
		else
		{
			thread DvarOnAllPlayer("ui_info_only", "Round "+game["aktualround"]+"/"+level.petx_round_limit);
			thread DvarOnAllPlayer("ui_info_only_color", 7);				
		
			wait 5;
			c++;
		}
	}
}

DvarOnAllPlayer(string, value)
{
	if(!isdefined(string) || string == "" || !isdefined(value))
		return;

	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
		players[i] SetClientDvar(string, value);
}

start_distance()
{
	self endon("disconnect");
	self endon("death");
	
	oldposition = self.origin;
	
	while(1)
	{
		if(self.origin != oldposition && isdefined(distance(self.origin,oldposition)) && (self IsOnLadder() || self IsOnGround()))
			self.pers["bestdistance"] += distance(self.origin,oldposition);
	
		oldposition = self.origin;
		
		if(self.pers["team"] == "allies" && isalive(self))
			self.pers["bestjumper"] += 1;
			
		wait 1;
	}
}

start_best_lovec()
{
	self endon("disconnect");
	self endon("death");

	while(1)
	{
		self waittill("Killed");
		
		if(self.pers["team"] == "axis")
			self.pers["bestlovec"] += 1;
	}
}

getbest(string)
{
	//string = "score"
	//string = "bestjumper"
	//string = "bestlovec"
	//string = "bestdistance"
	//string = "lowdistance"

	players = getentarray("player","classname");
	score = 0;
	best = players[0];
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if((player.pers[string] > score || (string == "lowdistance" && player.pers[string] < score)) && isdefined(player) && isplayer(player))
		{
			score = player.pers[string];
			best = player;	
		}
	}
	
	return best;
}

lowdistance(string)
{
	players = getentarray("player","classname");
	score = 1000000000000000;
	best = players[0];
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if(isdefined(player) && isplayer(player) && player.pers[string] < score)
		{
			score = player.pers[string];
			best = player;	
		}
	}
	
	return best;
}
