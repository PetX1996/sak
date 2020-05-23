//#include maps\mp\gametypes\_hud_util;

init()
{
thread onplayerconnected();
}
 
onplayerconnected()
{
	for(;;)
	{
		level waittill("connected", player);


		player thread onplayerspawned();

		player.point_hud = undefined;

		player.point_hud_c = undefined;
		//player.upoint = 0;
		
		player.bonus_point["axis"] = 0;
		player.bonus_point["allies"] = 0;

		if (!isdefined(player.pers["upoint"]))
		{
			player setclientdvar("ui_upoint_hide", 1);
			player.pers["upoint"] = 0; //prve kolo
			player setclientdvar("ui_upoint", player.pers["upoint"]);
		}
		if (!isdefined(player.pers["score"]))
			player.pers["score"] = 0; //prve kolo
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");

		self thread givepoint();
		self thread bonuspoint();
	}
}

givepoint()
{
self endon("death");
self endon("disconnected");
level endon("end_round");

	for(;;)
	{
		if (!level.sltime && isplayer(self) && isalive(self) && self.pers["team"] == "allies")
		{
			//iprintln ("give point");
			//self.upoint += 20;
			self setclientdvar("ui_upoint_hide", 0);
			
			self.pers["upoint"] += level.petx_point_life;
			
			self setclientdvar("ui_upoint", self.pers["upoint"]);
			
			score = self.pers["score"];
			maps\mp\gametypes\_globallogic::_setPlayerScore( self, score+level.petx_point_life );
			self thread maps\mp\gametypes\_rank::giveRankXP( "life", level.petx_point_life );
			self notify ("upoint");
			
			self setclientdvar("ui_upoint_hide", 1);
		}
		
		wait 15;//15;		
	}
}

remove_point(hodnota)
{			
	self.pers["upoint"] -= hodnota;	
	self setclientdvar("ui_upoint", self.pers["upoint"]);

	self notify ("upoint");
}

giveupoint(typ,hodnota)
{
	if (!isdefined(typ))
	{
		//iprintln ("give point");
		self setclientdvar("ui_upoint_hide", 0);
		
		self.pers["upoint"] += hodnota;
		
		self setclientdvar("ui_upoint", self.pers["upoint"]);
		
		self notify ("upoint");
		
		self setclientdvar("ui_upoint_hide", 1);
	}	

	if (isdefined(typ) && typ == "kill")
	{
		//iprintln ("give point");
		self setclientdvar("ui_upoint_hide", 0);
		
		self.pers["upoint"] += level.petx_point_kill;
		
		self setclientdvar("ui_upoint", self.pers["upoint"]);
		
		self notify ("upoint");
		
		self setclientdvar("ui_upoint_hide", 1);
	}
}

bonuspoint()
{
	self endon("disconnect");
	self endon("death");
	
	for(;;)
	{
		wait 1;
		
		if(!level.sltime)
		{
			//self iprintln("Bonus point: "+self.pers["team"]);
			self.bonus_point[self.pers["team"]]++;
		}	
	}
}

