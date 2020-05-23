main()
{
	maps\mp\mp_crash_fx::main();
	maps\createart\mp_crash_art::main();
	maps\mp\_load::main();
	
	thread antibug();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_crash");
	
	ambientPlay("ambient_crash");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("compassmaxrange","1600");

/*	
var = 100;

while(1)
	{
		var = var +10;
		setdvar("compassMaxRange", var);
		if (var >5000)
			var = 100;
		wait .05;
	}
*/
}

antibug()
{
	wait 1;
	
	trig = spawn( "trigger_radius", (501,-277,405) , 0, 50, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (1183,1341,2176) , 0, 500, 500); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (1317,165,459) , 0, 100, 100); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();
	trig = spawn( "trigger_radius", (-698,1512,541) , 0, 50, 50); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	trig thread start_sec();	
	trig = spawn( "trigger_radius", (1382,407,459) , 0, 40, 50); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
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