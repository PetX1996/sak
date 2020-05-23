init()
{
	thread randomspawnsound();
	thread starttext_time();
	thread onplayerconnected();
	thread startime_text_allies();
	
	level.playertext_start = true;
}

onplayerconnected()
{
	for(;;)
	{
		level waittill("connected",player);
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		
		if(!isdefined(game["special_round"]))
			self thread class_text();
			
		if((!self.alliesspawn && self.pers["team"] == "allies") || (!self.axisspawn && self.pers["team"] == "axis"))
			self thread spawnsound();
	}
}

end_round_sound()
{
	j = level.endround_sound_random;
	player = getentarray("player", "classname");
	
	for(i = 0;i < player.size;i++)
	{
		if (isplayer(player[i]))
			player[i] playLocalSound("round_end_"+j);
	}
}

bonus_round_sound(r)
{
	AmbientPlay("bonus_round_"+r);	
}

final_info_sound()
{
	player = getentarray("player", "classname");

	r = level.spawnsound_random_allies;
	
	for(i = 0;i < player.size;i++)
	{
		if (isplayer(player[i]))
			player[i] playLocalSound("round_"+r);
	}	
}

randomspawnsound()
{
	srs = 10;//zvuk po spawne-pocet
	ers = 17;//zvuk na konci kola-pocet

	level.spawnsound_random_allies = randomintrange(1,srs+1);
	level.spawnsound_random_axis = randomintrange(1,srs+1);
	level.endround_sound_random = randomintrange(1,ers+1);

	if (level.spawnsound_random_allies == level.spawnsound_random_axis)
	{
		while (level.spawnsound_random_allies == level.spawnsound_random_axis)
		{
			level.spawnsound_random_axis = randomintrange(1,srs+1);
		}
	}
}

spawnsound()
{
	self endon ("disconnect");
	i = 1;

	if (self.pers["team"] == "allies")
		i = level.spawnsound_random_allies;
	else if (self.pers["team"] == "axis")
		i = level.spawnsound_random_axis;

	self playLocalSound("round_"+i);
	self thread starttext();
}

starttext_time()
{
level waittill("start_round");
wait 15;
level.playertext_start = false;
}

startime_text_allies()
{
level.freezecontrols_players = true;
wait 5;
level notify ("start_game_sak");
level.freezecontrols_players = false;
}

starttext()
{
	self endon("disconnect");
	self endon("death");
	
	if (self.pers["team"] == "allies")
	{
		if(level.sltime)
		{
			starttext = SpawnStruct();
			starttext.titleText = "Ciel 1: Zdrhaj!";
			starttext.notifyText = "Ciel 2: Zabi Lovca!";
			starttext.duration = 5;
			starttext.glowcolor = (0,255,0);
			self thread maps\mp\gametypes\_hud_message::notifyMessage( starttext );
		}
		
		if (level.freezecontrols_players)
		{
			thread freezecontrols_players();
		}
	}
	else if (self.pers["team"] == "axis")
	{
		if (level.playertext_start)
		{
			//self FreezeControls(true);
			starttext = SpawnStruct();
			starttext.titleText = "Ciel 1: Zabi Jumperov!";
			//starttext.notifyText = "Ciel 2: Zabi Lovca!";
			starttext.duration = 5;
			starttext.glowcolor = (0,255,0);
			self thread maps\mp\gametypes\_hud_message::notifyMessage( starttext );
			//wait 7;
			//self FreezeControls(false);
			//self thread class_text();
		}
		//else 
			//self thread class_text();
	}
}

freezecontrols_players()
{
	self FreezeControls(true);
	level waittill("start_game_sak");
	self FreezeControls(false);
}

class_text()
{
	text = "class"; //ak premenna nieje definovana
	text2 = undefined;
	
	switch(self.class_damage)
	{
	case "class1_jumper":
		text = "Normal Class!";
		text2 = "Back-damage";
		break;
	case "class2_jumper":
		text = "Fast Class!";
		text2 = "FF shield";
		break;
	case "class3_jumper":
		text = "Secret Class!";
		text2 = "Energy drink";
		break;
	case "class4_jumper":
		text = "Armored Class!";
		text2 = "Player explode";
		break;
	case "class5_jumper":
		text = "Medic Class!";
		text2 = "Medic";
		break;
	case "class6_jumper":
		text = "Special Class!";
		attribute = self maps\mp\gametypes\_persistence::statGet( "speciality_"+self.pers["team"] );
		text2 = self petx\_class::GetClassAttributeName(attribute,self.pers["team"],true);
		break;
	case "class1_lovec":
		text = "Normal Class!";
		text2 = "Respawn";
		break;
	case "class2_lovec":
		text = "Fast Class!";
		//text2 = "";
		break;
	case "class3_lovec":
		text = "Poison Class!";
		text2 = "Poison";
		break;
	case "class4_lovec":
		text = "Armored Class!";
		text2 = "Anti-repel";
		break;
	case "class5_lovec":
		text = "Electric Class!";
		text2 = "Electric knife";
		break;	
	case "class6_lovec":
		text = "Special Class!";
		attribute = self maps\mp\gametypes\_persistence::statGet( "speciality_"+self.pers["team"] );
		text2 = self petx\_class::GetClassAttributeName(attribute,self.pers["team"],true);
		break;		
	
	}
	
	wait 2;
	
	if(isdefined(self)&&isalive(self))
	{
		classtext = SpawnStruct();
		classtext.titleText = text;
		if(isdefined(text2))
			classtext.notifyText = text2;
		classtext.duration = 5;
		classtext.glowcolor = (255,0,0);
		self thread maps\mp\gametypes\_hud_message::notifyMessage( classtext );
	}
}