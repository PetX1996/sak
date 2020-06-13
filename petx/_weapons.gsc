//#include maps\mp\gametypes\_hud_util;

init()
{
spawn_placed();
thread Onplayerconnect();
}
 
Onplayerconnect()
{
	while(1)
	{
		level waittill("connected",player);
		player.axisspawn = false;
		player.alliesspawn = false;
		player.normaldeath = false;
		player.spectator = false;
		player.suicidedeath = false;
		player.poisoned = false;
		player.axisalive = undefined;
		player.onehunter_death = false;
		player.caszmenyclassu = 0;
	}
}

give_weapon_allies(response)
{	
	if(isdefined(self.class_damage) && response == self.class_damage && isalive(self))
		return;

	if (level.end_round_go)
		return;

	if (!level.sltime)
	{
		if (isAlive(self)||self.alliesspawn)
		{
		self iprintlnbold("^2Nieje mozne zmenit class.");
		return;
		}
	}
	if (!self.suicidedeath)
		self.suicidedeath = true;	
	if(isalive(self))
	{
		self suicide();
	}

	self give_class("allies",response);
}

give_weapon_axis(response)
{
	if(isdefined(self.class_damage) && response == self.class_damage && isalive(self))
		return;

	if (level.end_round_go)
		return;
	
	/*if (!level.onehunter)
	{
		self.statusicon = "hud_status_dead";
		self.sessionstate =  "spectator";
		return;
	}*/
	if(!self.axisalive)
	{
		self iprintlnbold("Pre zmenu classu musis byt zivy!");
		return;
	}
	
	if(self.caszmenyclassu != 0&&!self.onehunter_death)
	{
		self iprintlnbold("Class je mozne zmenit o "+self.caszmenyclassu+" sekund.");
		return;
	}
	
	self give_class("axis",response);
	self notify("change_class");

	self thread caszmenyclassu(15);
}

give_class(team,response)
{
	wait 0.001; //cas pre vytvorenie "fake" hraca pri smrti

	if(isdefined(self.spawn_progress))
		return;
	
	self.spawn_progress = true;
	
	self.class_damage = response;
	self.voice = "british";
	
	self.selectedClass = true;
	self.team = self.pers["team"];
	self.sessionteam = self.team;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";

	playermodel = level.sak_class[response]["playermodel"];
	playerhands = level.sak_class[response]["playerhands"];
	playerhead = level.sak_class[response]["playerhead"];
	
	self detachAll();
	self setModel(playermodel);
	self setViewModel(playerhands);
	if(isdefined(playerhead))
		self attach(playerhead, "", true);
		
	spawnpoint = undefined;
	
	if (self.pers["team"] == "allies") 
		spawnpoint = level.spawn_allies[randomInt(level.spawn_allies.size)];
	else if (self.pers["team"] == "axis")
		spawnpoint = level.spawn_axis[randomInt(level.spawn_axis.size)];

	self spawn( spawnPoint.origin, spawnPoint.angles );
	
	weapon = level.sak_class[response]["weapon"];
	self.pers["weapon"] = weapon;
	self.pers["class"] = response;
	self.weapons_select = false;
	
	self GiveWeapon(weapon);
	self SetSpawnWeapon(weapon);
	wait 0.01;
	self SwitchToWeapon(weapon);
	
	self.speed = level.sak_class[response]["speed"];
	if(self.pers["team"] == "axis")
		self.speed += level.petx_lovec_speed;
	self setMoveSpeedScale(self.speed/100);
	
	self.health = level.sak_class[response]["health"];
	self.maxhealth = self.health;
	
	perk[1] = level.sak_class[response]["perk1"];
	perk[2] = level.sak_class[response]["perk2"];
	perk[3] = level.sak_class[response]["perk3"];
	
	for(i = 1;i < 4;i++)
	{
		if(isdefined(perk[i]))
			self SetPerk(perk[i]);
	}		
	
	self.class_special = level.sak_class[response]["speciality"];
	
	if(!isdefined(self.class_special))
		self.class_special = self petx\_class::GetSpecialClassStat(self.pers["team"]);
	
	if(!isdefined(self.class_special))
		self.class_special = "respawn";
	
	/*if(response == "class6_jumper")
		self.class_special = self.class_spec_stat["allies"];
		
	if(response == "class6_lovec")
		self.class_special = self.class_spec_stat["axis"];*/
		
	self.suicidedeath = false;
	
	if(self.pers["team"] == "allies")
		self.alliesspawn = true;
	if(self.pers["team"] == "axis")	
		self.axisspawn = true;
	
	self.spawn_progress = undefined;
	self notify("spawned_player");
	
	//self iprintln("spawn");
}

caszmenyclassu(cas)
{
self endon("disconnect");

self.caszmenyclassu = cas;

	for(;;)
	{
		wait 1;
		self.caszmenyclassu--;

		if(self.caszmenyclassu == 0)
			break;
	}
}

spawn_placed()
{
	level.spawn_axis = getEntArray( "mp_tdm_spawn", "classname" );
	spectatorspawn = getEntArray( "mp_global_intermission", "classname" );

	if(!isdefined(spectatorspawn) || !isdefined(spectatorspawn[0]))
		spectatorspawn = level.spawn_axis;
	
	s = randomint(spectatorspawn.size);
	r = randomint(2);
	
	if (r == 0)
		team = "allies";
	else
		team = "axis";
		
	level.spawn_allies = getEntArray( "mp_tdm_spawn_"+team+"_start", "classname" );		
	
	for (i = 0;i < level.spawn_allies.size;i++)
	{
		level.spawn_allies[i] placeSpawnPoint();
	}
	
	for (j = 0;j < level.spawn_axis.size;j++)
	{
		level.spawn_axis[j] placeSpawnPoint();
	}
	
		level.spectator_spawn = spectatorspawn[s];

}

