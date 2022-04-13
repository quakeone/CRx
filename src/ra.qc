
//In Game Module for ClanArenaX
//by R00k
//--------
//ra.qc		v1.0 12/12/2011 4:19PM
//--------
//round robin mode 1 on 1 match
//single round eliminiation


//Two teams, ONE ON ONE, winner plays next in line...

void () rocket_arena_init_world =
{
	boss 				= spawn ();
	
	boss.max_rounds 	= 1;
	boss.round 			= 1;
	boss.count 			= 10;
	boss.max_players 	= 1;//R00k: changed v1.52
	boss.start_players	= 1;
 	boss.max_teams  	= 2;
	boss.state 			= CA_MATCH_WAITING;
	boss.wait 			= 0;
	boss.maprecycle		= 0;
		
	boss.items 		= (boss.items | IT_ARMOR3);	

	boss.health      	= 100;
	boss.armorvalue  	= 200;
	boss.ammo_shells 	= 100;
	boss.ammo_nails  	= 100;
	boss.ammo_rockets	= 50;
	boss.ammo_cells  	= 100;

	boss.weapon      	= 4223;//All weapons by default.
	boss.armortype   	= 80.001;
	boss.timetofight 		= FALSE;
	//arena_ammobehavior	= 2;//deplete ammo default
	boss.next_team 		= world;

	boss.busy		= FALSE;
	boss.aborted 		= FALSE;	
};

float() ra_map =
{		
	if (mapname == "23ar-a")	return TRUE;
	if (mapname == "2pyramid")  return TRUE;
	if (mapname == "2towers")  	return TRUE;
	if (mapname == "arenarg2")  return TRUE;
	if (mapname == "arenarg4")  return TRUE;
	if (mapname == "arenarg5")  return TRUE;
	if (mapname == "arenarg6")  return TRUE;
	if (mapname == "arenax")  	return TRUE;	
	if (mapname == "arenazap")  return TRUE;
	if (mapname == "arendm1a")  return TRUE;
	if (mapname == "arenrg3a")  return TRUE;
	if (mapname == "arma4")  	return TRUE;
	if (mapname == "barena1") 	return TRUE;	
	if (mapname == "basarena")	return TRUE;
	if (mapname == "bbarena2")	return TRUE;
	if (mapname == "bunmoo3")	return TRUE;
	if (mapname == "bunski")	return TRUE;
	if (mapname == "chamber1")	return TRUE;
	if (mapname == "crandome") 	return TRUE;
	if (mapname == "dm2arena")  return TRUE;
	if (mapname == "dom2_1ra")  return TRUE;
	if (mapname == "egyptra")  	return TRUE;
	if (mapname == "football")  return TRUE;
	if (mapname == "gear8")  	return TRUE;	
	if (mapname == "gnurena")  	return TRUE;
	if (mapname == "hill20")  	return TRUE;
	if (mapname == "iarena2")  	return TRUE;
	if (mapname == "id3")  		return TRUE;
	if (mapname == "lowgrav")  	return TRUE;
	if (mapname == "marena2")  	return TRUE;	
	if (mapname == "marena3")  	return TRUE;	
	if (mapname == "marena4")  	return TRUE;	
	if (mapname == "mayan1")  	return TRUE;
	if (mapname == "nilsrar3")  return TRUE;
	if (mapname == "pen2")  	return TRUE;
	if (mapname == "pitarena")  return TRUE;
	if (mapname == "ptucket")  	return TRUE;
	if (mapname == "ra_funkf")  return TRUE;
	if (mapname == "rarena3")  	return TRUE;
	if (mapname == "rgarden")  	return TRUE;	
	if (mapname == "soyarena")  return TRUE;
	if (mapname == "terrain2")  return TRUE;
	if (mapname == "uarena1")  	return TRUE;
	if (mapname == "unholy")  	return TRUE;
	if (mapname == "xarena3")  	return TRUE;
	if (mapname == "yard1")  	return TRUE;

	return FALSE;
};


// //---------------------------------------------------------------------------------------------
void () RA_Select_Team =
{
	if (boss.busy == TRUE)
	{
		sprint(self,"Cleaning up match end. Re-join in 3 seconds.\n");		
		return;
	}

	clear_afk_status(self);
		
	if (self.impulse == 1)
	{
		if (boss.state == CA_MATCH_WAITING)
			Join_Team(TEAM_BLUE);
		else
			Request_Join_Team (TEAM_BLUE);
	}
	
	// We don't want this team anymore
	if (self.impulse == 2)
	{
		if (self.cc_queue_vote)
		{
			if ((clanring_request.classname == "cc_vote") && (clanring_request.owner == self))
			{
				Request_Poll_Cleanup();
				self.cc_queue_vote = 0;
			}
		}
		
		if (boss.state == CA_MATCH_WAITING)
		{
			if (self.next_team != world)
				RemoveFromTeam ();
		}
		
		if (self.cc_queue)
		{
			if (self.next_team != world)
				RemoveFromTeam ();
			
			sprint (self, "Cancelling \bColor-Change\b...\n");
			self.cc_queue = 0;
			self.cc_queue_vote = 0;
		}
					
		if (self.style & CLANRING_CONNECTED)
		{		
			stuffcmd(self,";color 0;\n");
		}		
	}
	
	self.impulse = 0;
};

