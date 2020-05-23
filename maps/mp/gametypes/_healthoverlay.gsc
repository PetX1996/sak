init()
{
	precacheShader("overlay_low_health");
		
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerDisconnect();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self notify("end_healthregen");
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self notify("end_healthregen");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread playerHealthRegen();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self notify("end_healthregen");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
}

playerHealthRegen()
{
	self endon("end_healthregen");
	
	if ( self.health <= 0 )
	{
		assert( !isalive( self ) );
		return;
	}
	
	maxhealth = self.health;
	oldhealth = maxhealth;
	player = self;
	
	self.zranenie = true;
	self.uzdravenie = true;
	
	for (;;)
	{
		wait 0.05;
		
		if (player.health == 0)
			return;
			
		if (player.health <= 0)
			return;
			
		if (player.health == maxhealth)
			continue;
			
		if (player.health == oldhealth)
			continue;
			
		if (player.health < oldhealth)
		{
			if (player.health < (oldhealth/1.8))
			{
				oldhealth = player.health;
				if (self.zranenie)
					player thread zranenie();
			}
			else
			{
				oldhealth = player.health;
				if (self.uzdravenie)
					thread uzdravenie();
			}
		}
		
	}
}

zranenie()
{
	self endon("end_healthregen");
	
	wait 0.5;
	player = self;
	for (i=0;i<3;i++)
	{
		wait (0.2);
		if (player.health <= 0)
			return;
						
		player playLocalSound("breathing_hurt");
		wait .784;
		wait (0.1 + randomfloat (0.8));
		//iprintln ("zranenie");
	}
	if (self.uzdravenie)
		player thread uzdravenie();
}

uzdravenie()
{
	self.uzdravenie = false;			
	wait 1;
	self playLocalSound("breathing_better");
	self.uzdravenie = true;
}			
