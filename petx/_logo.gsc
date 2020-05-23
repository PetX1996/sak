//#include maps\mp\gametypes\_hud_util;

init()
{
	thread onplayerconnected();
	//thread get_spawn_origin();
}

onplayerconnected()
{
	//level waittill("connected", player);
	thread logo();
}

logo()
{
	logo = NewHudElem();
	logo.alignX = "center";
	logo.alignY = "middle";
	//logo = "objective";
	logo.archived = true;
	logo.x = 320;//doprava
	logo.y = 470;//dole
	logo.alpha = 1;
	logo.sort = 1001;
	logo.fontscale = 1.5;
	logo settext("For Gamers Fusion");
	
	for(;;)
	{
	wait 15;
	
	logo FadeOverTime( 2 );
	logo.alpha = 0;
	wait 2;
	logo settext("4GF.CZ");	

	wait 3;
	
	logo FadeOverTime( 2 );
	logo.alpha = 1;		

	wait 15;

	logo FadeOverTime( 2 );
	logo.alpha = 0;
	wait 2;
	logo settext("Mod by PetX");	

	wait 3;
	
	logo FadeOverTime( 2 );
	logo.alpha = 1;		
	
	wait 15;
	
	logo FadeOverTime( 2 );
	logo.alpha = 0;
	wait 2;
	logo settext("For Gamers Fusion");	

	wait 3;
	
	logo FadeOverTime( 2 );
	logo.alpha = 1;		
	}
}

get_spawn_origin()
{
	precacheModel("com_bottle1");

	corner = getentarray("minimap_corner","targetname");
	
	if(!isdefined(corner))
		return;
	
	orig1 = corner[0].origin;
	orig2 = corner[1].origin;
	
	pos1x = orig1[0];
	pos2x = orig2[0];
	pos1y = orig1[1];
	pos2y = orig2[1];
	
	level waittill("connected", player);
	player waittill("spawned_player");
	
	player iprintln("corner1 X: "+pos1x);
	player iprintln("corner1 Y: "+pos1y);
	player iprintln("corner2 X: "+pos2x);
	player iprintln("corner2 Y: "+pos2y);
	
	rz = player.origin[2]+1000;
	player iprintln("position Z: "+rz);
	
	final_origin = [];
	model = [];

	while(1)
	{
		for(o = 0; o < 10; o++)
		{
			if(pos1x < pos2x)
				rx = RandomFloatRange(pos1x, pos2x);
			else
				rx = RandomFloatRange(pos2x, pos1x);
				
			if(pos1y < pos2y)
				ry = RandomFloatRange(pos1y, pos2y);
			else
				ry = RandomFloatRange(pos2y, pos1y);	

			final_origin[o] = (rx, ry, rz);	
				
			player iprintln("Origin: "+final_origin[o]);
		}

		for(i = 0; i < final_origin.size; i++)
		{
			model[i] = spawn("script_model",final_origin[i]);
			model[i] setModel("com_bottle1");

		}
		wait 5;
		
		for(i = 0; i < final_origin.size; i++)
		{
			model[i] delete();
		}		
	}
}
