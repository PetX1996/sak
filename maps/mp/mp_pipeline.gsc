main()
{
	maps\mp\mp_pipeline_fx::main();
	maps\createart\mp_pipeline_art::main();
	maps\mp\_load::main();
	
	thread antibug();

	maps\mp\_compass::setupMiniMap("compass_map_mp_pipeline");

	//setExpFog(700, 1500, 0.5, 0.5, 0.5, 0);
	ambientPlay("ambient_pipeline");
	//VisionSetNaked( "mp_pipeline" );
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","2200");


}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (2008,1075,158) , 0, 153, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (15,926,430) , 0, 400, 500); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
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