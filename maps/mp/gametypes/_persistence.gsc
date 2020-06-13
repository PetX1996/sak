//
//
// mnaauuu@4gf.cz
//
//
//#include scripts\core\inc\common;
//#include scripts\core\inc\list;
//#include scripts\core\inc\event;

init()
{
	level thread onPlayerConnect();
	level thread StatFromB3();

	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();
	
	level.stat_migration = 0; //getdvard( "scr_stat_migration", "int", 0, 0, 1 ); // enable(1)/disable(0) rankxp migration to DB
	level.stat_ident = 2328; // identification field in mpdata
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread playerPersSupport();
	}
}

onDisconnect() {
	slot = self getEntityNumber();
	self waittill("disconnect");
	setdvar( "stat_info_" + slot, "" );
	setdvar( "stat_info_live_" + slot, "" );
	
}

playerPersSupport() {
	self endon("disconnect");
	self thread onDisconnect();
	
	setdvar( "stat_info_" + (self getEntityNumber()), "" );
	
	self.save_tick = false;
	self.stat_rankxp = undefined;
	self.stat_info = undefined;
	self.stat_info_enabled = undefined;
	self.stat_last_xp = -1;
	self.stat_ident_migrate = undefined;

	self setClientDvar("ui_xpText", "1");
	self.enableText = true;
	
	if ( isDefined(self.pers["isBot"]) )
		return;
		
	while(true) {
		//iprintln("calam na acp info");
		if ( isDefined(self.acp_info) ) break;
		wait 0.25;
	}
	
	self.stat_ident = self getStat( level.stat_ident );
	if ( self.stat_ident == 0 ) {
		self.stat_ident = getTime() + 1;
		if ( self.stat_ident > 999999999)
			self.stat_ident = RandomIntRange( 999, 999999999 );
		
		self.stat_ident =  self.stat_ident + RandomIntRange( 999, 999999 );
		
		
		if ( level.stat_migration == 1) {
			self.stat_ident_migrate = true;
		} else {
			self setStat( level.stat_ident, self.stat_ident );
			self.pers["rankxp"] = 0;
			self statSet("rankxp", 0);
		}
		
		//self iprintln("^3New B3StatIdent ^2" + self.stat_ident); 
	}

	/*
	if ( self.b3level < 100 ) {
		self setStat( level.stat_ident, self.stat_ident );
		self thread savePersOnly();
		return;
	}
*/
	skip_request = false;
	while(true) {
		if ( isDefined(self.stat_ident_migrate) )
			break;
	
		stat_info = getdvar( "stat_info_live_" + (self getEntityNumber()));
		if ( !isDefined( stat_info ) )
			stat_info = "";
			
		info = strtok( stat_info, ":" );
		//self iprintln("stat_info " + stat_info + "  >>> " + self.pers["rankxp"]);
		if(isDefined(info) 
			&& info.size > 1
			&& self.stat_ident == int(info[0]) 
			&& self.pers["rankxp"] == int(info[1]) ) 
		{
			self.stat_last_xp = self.pers["rankxp"];
			self.stat_info = stat_info;
			setdvar( "stat_info_" + (self getEntityNumber()), self.stat_ident + ":" + self.stat_last_xp);
			skip_request = true;
			break;
		} 
				
		self.stat_info = undefined;
		setdvar( "stat_info_live_" + (self getEntityNumber()), "" );
		break;
	}
	
	stat_info = undefined;
	info = undefined;
	
	self.stat_info_enabled = true;
				

	//if ( !isDefined(self.stat_ident_migrate) )
		//self iprintln("^3B3StatIdent ^2" + self.stat_ident); 
	
	self.save_last = 500 + getTime();
	while(!skip_request) {
		if ( isDefined(self.stat_info) )
			break;

		if ( self.save_last < getTime() ) {
			//self iprintln("^3b3ick ^2XQ ^4" + self.stat_ident);
			logPrint("XQ;" + (self getGuid()) + ";" + (self getEntityNumber()) + ";" + self.stat_ident + ";" + self.name + "\n");
			self.save_last = 2000 + getTime();
		}
		wait 0.1;
	}
	
	skip_request = undefined;
	
	//self iprintln("^3b3ick ^2init");
	
	self thread savePersOnly();
}


savePersOnly() {
	self endon("disconnect");

	self.save_last = 20000 + getTime();
	self.save_tick = false;
	while(true) {
		if ( self.stat_last_xp != self.pers["rankxp"] 
				&&  (self.save_tick && self.save_last < getTime())  ) 
		{
			
			self.save_tick = false;
			self.save_last = 30000 + getTime();
			self.stat_last_xp = self.pers["rankxp"];
			
			logPrint("XP;" + (self getGuid()) + ";" + (self getEntityNumber()) + ";" + self.stat_ident + ";"  +  self.stat_last_xp + ";" + self.name + "\n");
			setdvar( "stat_info_live_" + (self getEntityNumber()), self.stat_ident + ":" + self.stat_last_xp);
			
			//if ( self.b3level > 99 )
				//self iprintln("^3b3ick ^2" + self.stat_last_xp);
		}
		//iprintln(">>>" + self.stat_last_xp + ":" + self.pers["rankxp"]);
		wait 1;
	}
}

StatFromB3()
{
	while(1) {
		
		players = getentarray( "player", "classname" );
		
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if ( isDefined( player ) && isDefined(player.stat_info_enabled) )
			{
				enNum = player getEntityNumber();
				//iprintln("hladam " + enNum);
			
				stat_info = getdvar( "stat_info_" + enNum); 
				if ( !isDefined( stat_info ) )
					stat_info = "";
					
				if (!isDefined(player.pers["rankxp"]) || stat_info == "" || (isDefined(player.stat_info) && player.stat_info == stat_info))
					continue;

				info = strtok( stat_info, ":" );
				
				if(!isDefined(info) || !isDefined(player))
					continue;
				
				if(!isDefined(info[0])) {
					continue;
				}
				
				if(isDefined(info[0])) {
					ident = int(info[0]);
					if ( player.stat_ident != ident ) {
						continue;
					}
				}				

				if(isDefined(info[1])) {
					
					stat_rankxp = int(info[1]);
					if ( isDefined(player.stat_ident_migrate) ) {
						player setStat( level.stat_ident, player.stat_ident );
						stat_rankxp = player.pers["rankxp"];
						player.stat_last_xp = stat_rankxp;
						//player iprintln("^3B3ick ^2XP-MiG ^4" + stat_rankxp);
						player.stat_ident_migrate = undefined;
						logPrint("XP;" + (player getGuid()) + ";" + (player getEntityNumber()) + ";" + player.stat_ident + ";"  +  player.stat_last_xp + ";" + player.name + "\n");
					} else {
						player.pers["rankxp"] = stat_rankxp;
						player.stat_last_xp = stat_rankxp;
						//player iprintln("^3B3ick ^2XP ^4" + stat_rankxp);
					}
					
					player.stat_info = stat_info;
					player statSet("rankxp", stat_rankxp);
					setdvar( "stat_info_live_" + (player getEntityNumber()), player.stat_ident + ":" + stat_rankxp);
					//player thread maps\mp\gametypes\_rank::UpdatePlayerData(player);
					player thread maps\mp\gametypes\_rank::updateRank();
				} else {
					//TODO: error!
				}
				
			}
		}
		
		wait 0.5;
	}
}

// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.
/*
=============
statGet

Returns the value of the named stat
=============
*/
statGet( dataName )
{
	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

/*
=============
setStat

Sets the value of the named stat
=============
*/
statSet( dataName, value )
{
	if ( dataName == "rankxp" ) {
		self.save_tick = true;
		//iprintln("xp " + value + "  >>> " + self.pers["rankxp"]);
	}
	
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );	
}

/*
=============
statAdd

Adds the passed value to the value of the named stat
=============
*/
statAdd( dataName, value )
{	
	curValue = self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value + curValue );
}
