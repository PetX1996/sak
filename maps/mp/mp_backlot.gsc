main()
{
	maps\mp\mp_backlot_fx::main();
	maps\createart\mp_backlot_art::main();
	maps\mp\_load::main();	
	
	thread antibug();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_backlot");

	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	//VisionSetNaked( "mp_backlot" );
	ambientPlay("ambient_backlot_ext");

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
	setdvar("compassmaxrange","1800");


}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (635,-1037,360) , 0, 100, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (-243,-820,345) , 0, 100, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (-365,-1435,238) , 0, 50, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (-1045,-878,205) , 0, 50, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
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