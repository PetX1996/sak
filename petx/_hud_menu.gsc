init()
{
thread pocet_hracov();
//thread onplayerconnected();
}

onplayerconnected()
{
	for(;;)
	{
		level waittill ("connected", player);
		thread setuidvar(0,"lovec");
		thread setuidvar(0,"jumper");
		player thread onplayerspawned();
		
	}
}

onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ("spawned_player");
		
		jumperi = allplayer("allies");
		lovci = allplayer("axis");
	
		thread setuidvar(lovci,"lovec");
		thread setuidvar(jumperi,"jumper");
	}
}

pocet_hracov()
{
	thread onplayerconnected();
	
	for(;;)
	{
	jumperi = allplayer("allies");
	lovci = allplayer("axis");
	
	wait 0.5;
	
	newjumperi = allplayer("allies");
	newlovci = allplayer("axis");

	if (jumperi != newjumperi)
		thread setuidvar(newjumperi,"jumper");	
	if (lovci != newlovci)
		thread setuidvar(newlovci,"lovec");	
	}
}

setuidvar(pocet,team)
{
	player = getentarray ("player" , "classname");
	
	for (i = 0;i <player.size;i++)
	{
		player[i] setclientdvar("ui_"+team+"_number",pocet);
		//iprintln ("setdvar, team:"+team+" pocet: "+pocet);
	}	
}

allplayer(team)
{
	players = 0;
	player = getentarray ("player" , "classname");

	for (i = 0;i <player.size;i++)
	{
		if(isalive(player[i]) && isplayer(player[i]) && player[i].pers["team"] == team)
			players++;
	}
	return players;
}
