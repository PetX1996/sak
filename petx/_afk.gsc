//#include maps\mp\gametypes\_hud_util;

init()
{
thread onplayerconnected();
}

onplayerconnected()
{
	for(;;)
	{
		level waittill ("connected", player);

		player.afk_point = 0;
		//player.lovec = false;
		
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ("spawned_player");
		self.afk_point = 0;
		
		//self thread start_afk();
	}
}

start_afk()
{
	self endon("disconnect");
	self endon("death");
	level endon("end_round");
	
	//return;
	
	for(;;)
	{
		self.afk_ang = self GetPlayerAngles();
		origin = self.origin;
		//self iprintlnbold("Angles: "+self.afk_ang);
		
		wait 5;
		
		if(self.afk_ang == self GetPlayerAngles() && self.origin == origin)
			self.afk_point++;
		else
			self.afk_point = 0;
			
		if(self.afk_point == 6)
			self iprintlnbold("^1AFK ^7ochrana aktivovana!");

		if(self.afk_point == 8)
			self iprintlnbold("^1Upozornenie: ^7killnutie pre neaktivitu!");	

		if(self.afk_point == 10)
		{
			self iprintlnbold("^1Killnutie pre neaktivitu!");
			self suicide();
		}	
	}
}
