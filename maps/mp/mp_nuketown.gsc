main()
{
	maps\mp\_load::main();
	maps\mp\_breakwnd_bomb::main();
	maps\mp\_population::main();
	maps\mp\_fan::main();
	
	thread antibug();
	//maps\mp\mp_nuketown_fx::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_nuketown");

	setExpFog(1200, 1800, 0.66, 0.61, 0.56, 0);

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	setdvar("compassmaxrange","2000");
	
	if( getDvar("g_gametype") == "ctf")
	{
		addobj("allied_flag", (1430, 390, 24), (0, 0, 0));
		addobj("axis_flag", (-1133, 3, 24), (0, 0, 0));
	}
	
	if( getDvar("g_gametype") == "ctfb")
	{
		addobj("allied_flag", (1430, 390, 24), (0, 0, 0));
		addobj("axis_flag", (-1133, 3, 24), (0, 0, 0));
	}	
}

addobj(name, origin, angles)
{
	ent = spawn("trigger_radius", origin, 0, 48, 148);
	ent.targetname = name;
	ent.angles = angles;
}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (1801,749,146) , 0, 80, 50); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
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