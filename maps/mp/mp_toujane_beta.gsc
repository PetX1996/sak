main()
{
maps\mp\_load::main();
thread antibug();

maps\mp\_compass::setupMiniMap("compass_map_mp_toujane_beta");

//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
ambientPlay("ambient_middleeast_ext");
//VisionSetNaked( "mp_vacant" );

game["allies"] = "sas";
game["axis"] = "russian";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar( "r_specularcolorscale", "1" );

setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setdvar("compassmaxrange","1500");




}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (2476,594,293) , 0, 24, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (2446,598,293) , 0, 37, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (2526,606,293) , 0, 18, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (2558,594,293) , 0, 20, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (2600,692,293) , 0, 158, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (2549,-954,232) , 0, 110, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (2348,-942,215) , 0, 100, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
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
