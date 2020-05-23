init()
{
	thread onplayerconnected();
	thread delete_turret();
}
 
onplayerconnected()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon ("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread ammo();
	}
}

delete_turret()
{
	turret = getentarray("misc_turret" , "classname");

	if(isdefined(turret))
	{
		for(i = 0;i < turret.size;i++)
		{
			turret[i] delete();
		}
	}	
}

ammo()
{
	self endon("death");
	self endon("disconnect");
	//self.weapon = self GetCurrentWeapon();
	//self.maxammo = WeaponMaxAmmo(self.weapon);
	
	for(;;)
	{
		wait 1;
		
		weapon = self.pers["weapon"];
		maxammo = WeaponMaxAmmo(weapon);
		
		for(i = 1;i < 7;i++)
		{
			if(weapon == level.sak_class["class"+i+"_lovec"]["weapon"] || weapon == level.sak_class["class"+i+"_jumper"]["weapon"])
			{
				ammo = self GetAmmoCount(weapon);
				
				if(ammo != maxammo)
					self GiveMaxAmmo(weapon);
			}
		}
	}
}