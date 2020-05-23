main()
{
	maps\mp\_load::main();
	
	thread antibug();
	
	ambientPlay("ambient_backlot_ext");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".18");

	setdvar( "r_specularcolorscale", "2.4877" );

	maps\mp\_compass::setupMiniMap("compass_map_mp_modern_rust");
	setdvar("compassmaxrange","1200");
}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (159,-933,220) , 0, 134, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (681,-727,250) , 0, 80, 200); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
}

start_sec()
{	
	while(1)
	{
		players = getentarray("player","classname");
		for(i = 0;i<players.size;i++)
		{
			player = players[i];
			if(isplayer(player)&&isalive(player)&&player IsTouching(self))
			{	
				//player iprintlnbold("This is ^1BUG!! ^7You ^1killed!!");
				player suicide();
			}
		}
		wait 0.5;
	}
}