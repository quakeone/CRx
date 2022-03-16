
//In Game Module for ClanArenaX
//by R00k
//--------
//ra.qc		v1.0 12/12/2011 4:19PM
//--------
//round robin mode 1 on 1 match
//single round eliminiation


//Two teams, ONE ON ONE, winner plays next in line...

// void () observer_start;
// void () observer_end;
// void () stats_final_summary;
// void () stats_reset_player;
// void () observer_walk_start;
// void () observer_chase_start;
// void () vote_yes;
// void () observer_check_demo_end;
// void () stats_team_stats;
// void () RemoveFromTeam;
// void (entity client) observer_disconnect_notify;
// void () vote_reject;
// void () motd_playercount;
//float (string s1, string s2, string class, void() accept) vote_init;

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
	if (mapname == "2pyramid")  	return TRUE;
	if (mapname == "2towers")  	return TRUE;
	if (mapname == "arenarg2")  	return TRUE;
	if (mapname == "arenarg4")  	return TRUE;
	if (mapname == "arenarg5")  	return TRUE;
	if (mapname == "arenarg6")  	return TRUE;
        if (mapname == "arenax")  	return TRUE;	
        if (mapname == "arenazap")  	return TRUE;
        if (mapname == "arendm1a")  	return TRUE;
        if (mapname == "arenrg3a")  	return TRUE;
        if (mapname == "arma4")  	return TRUE;
        if (mapname == "barena1") 	return TRUE;	
        if (mapname == "basarena")	return TRUE;
        if (mapname == "bbarena2")	return TRUE;
        if (mapname == "bunmoo3")	return TRUE;
        if (mapname == "bunski")	return TRUE;
        if (mapname == "chamber1")	return TRUE;
        if (mapname == "crandome") 	return TRUE;
        if (mapname == "dm2arena")  	return TRUE;
        if (mapname == "dom2_1ra")  	return TRUE;
        if (mapname == "egyptra")  	return TRUE;
        if (mapname == "football")  	return TRUE;
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
        if (mapname == "nilsrar3")  	return TRUE;
        if (mapname == "pen2")  	return TRUE;
        if (mapname == "pitarena")  	return TRUE;
        if (mapname == "ptucket")  	return TRUE;
        if (mapname == "ra_funkf")  	return TRUE;
        if (mapname == "rarena3")  	return TRUE;
        if (mapname == "rgarden")  	return TRUE;	
        if (mapname == "soyarena")  	return TRUE;
        if (mapname == "terrain2")  	return TRUE;
        if (mapname == "uarena1")  	return TRUE;
        if (mapname == "unholy")  	return TRUE;
        if (mapname == "xarena3")  	return TRUE;
        if (mapname == "yard1")  	return TRUE;
	
        return FALSE;
};

//
//Sequential spawns, with telefrag scan.
//
entity() SelectRASpawnPoint =
{
	local entity lastspawn = world; //TODO: MAKE GOBAL OR PASS?

	local entity spot, e;
	local float c, f;
	
	c = 64;

	spot = lastspawn;
	
	while (c > 0)
	{		
		spot = find(spot, classname, "info_teleport_destination");
	
		f = 0;		
		
		if (spot != world)
		{
			if ((spot == lastspawn)&&(c <= 1))			//just in case there is only 1 spawnpoint on this map :|  (7/22/2014 12:29PM)
				return lastspawn;

			if (spot != self.trigger_field)
			{
				e = findradius (spot.origin, 32);			
				while (e)
				{
					if ((e.classname == "player") && (e != self) && (e.health > 0) && (e.style & CLANRING_CONNECTED) && (IS_CA_OBSERVER(e) == FALSE))
					{
						e = world;
						f = 1;						
					}
					else
					{
						e = e.chain;
					}
				}
			}
			else
			{
				f = 1;
			}
			
			if (f == 0)
			{
				lastspawn = spot;
				return (spot);
			}
		}		
		c = c - 1;
	}	
	return (lastspawn);
};

//string (string s) stats_name;

// float (entity list, entity player) ca_check_player_in_list =
// {
// 	local entity e;
// 	local float check;
	
// 	e = list;	
	
// 	check = 16;//crash test (fixme: change from 16 to SV_MAXPLAYERS) check = max(16, sv_maxplayers);

// 	while ((e != world) && (e.next_player))
// 	{
// 		if (check < 1)
// 			return FALSE;
			
// 		if (e.next_player == player)
// 		{		
// 			return TRUE;
// 		}
// 		check = check - 1;
// 		e = e.next_player;
// 	}
// 	return FALSE;
// };

// void (entity list, entity player) add_player_to_stat_list =
// {
// 	if (ca_check_player_in_list(list, player) == FALSE)// just incase 
// 	{
// 		player.next_player = list.next_player;
// 		list.next_player = player;
// 	}
// };

// void (entity list, entity player) remove_player_from_stat_list =
// {
// 	local   entity  e;

// 	e = list;
// 	while (e.next_player)
// 	{
// 		if (e.next_player == player)
// 		{
// 			e.next_player = player.next_player;
// 			player.next_player = world;
// 			return;
// 		}
// 		e = e.next_player;
// 	}
// };

// entity (float whichteam) find_team_entity =
// {
// 	local entity e;

// 	e = boss.next_team;

// 	while (e)
// 	{
// 		if (e.team2 == whichteam)
// 			return e;
		
// 		e = e.next_team;
// 	}
// 	return world;
// };

// void () find_team_place =
// {
// 	local entity 	pteam;

// 	team_first_place 	= boss;
// 	team_second_place 	= boss;
// 	team_third_place 	= boss;
// //	team_fourth_place	= boss;//unused

// 	pteam = boss.next_team;

// 	while (pteam)
// 	{
// 		if ((pteam.wins >= team_first_place.wins))
// 		{
// 			team_second_place = team_first_place;
// 			team_first_place = pteam;
// 		}
// 		else
// 		{
// 			if ((pteam.wins >= team_second_place.wins))
// 			{
// 				team_third_place = team_second_place;
// 				team_second_place = pteam;
// 			}
// 			else
// 			{
// 				if ((pteam.wins >= team_third_place.wins))
// 				{
// 				//	team_fourth_place = team_third_place;
// 					team_third_place = pteam;
// 				}
// /*				else
// 				{
// 					if ((pteam.wins >= team_fourth_place.wins))
// 						team_fourth_place = pteam;
// 				}*/
// 			}
// 		}
// 		pteam = pteam.next_team;
// 	}
// };

// string () report_winning_team =
// {
// 	local entity 	pteam;
// 	local float	team_score_number,tnum;
// 	local string 	tmp;
// 	local string	team_winning_teamname,output;

// 	team_first_place 	= boss;
// 	team_second_place 	= boss;
// 	team_third_place 	= boss;

// 	if (boss.round == 1) return string_null; //Match just started we know...

// 	if (!HUNK_CONTEXT)//R00k just incase
// 		return string_null;

// 	output = allocate_string_size(64);//R00k

// 	pteam = boss.next_team;

// 	while (pteam)
// 	{
// 		if ((pteam.wins > team_first_place.wins))
// 		{
// 			team_third_place = team_second_place;
// 			team_second_place = team_first_place;
// 			team_first_place = pteam;
// 		}
// 		else
// 		{
// 			if ((pteam.wins > team_second_place.wins))
// 			{
// 				team_third_place = team_second_place;
// 				team_second_place = pteam;
// 			}
// 			else
// 			{
// 				if ((pteam.wins >= team_third_place.wins))//R00k: v1.55
// 				{
// 					team_third_place = pteam;
// 				}
// 			}
// 		}
// 		pteam = pteam.next_team;
// 	}

// 	if ((team_first_place.wins > team_second_place.wins))
// 	{
// 		team_score_number = (team_first_place.wins - team_second_place.wins);
// 		team_winning_teamname = strings_get_teamname_leads_by (team_first_place.team2);

// 		tmp = ftos(team_score_number);
// 		output = (strcat("ùThe",team_winning_teamname));
// 		output = (strcat(output,tmp));

// 		tnum = (ceil(boss.max_rounds / 2));
// 		team_score_number = (tnum - team_first_place.wins);
// 		tmp = ftos(team_score_number);

// 		output = (strcat(output," needs "));
// 		output = (strcat(output,tmp));
// 		output = (strcat(output," to winë"));
// 	}
// 	else
// 	{
// 		if ((number_teams () > 2) && ((team_first_place.wins == team_second_place.wins) && (team_first_place.wins > team_third_place.wins)) )
// 		{
// 				team_score_number = team_first_place.wins;
// 				team_winning_teamname = team_first_place.netname;
// 				tmp = ftos(team_score_number);

// 				output = ("ùThe ");
// 				output = (strcat(output,team_first_place.netname));
// 				output = (strcat(output," and "));
// 				output = (strcat(output,team_second_place.netname));
// 				output = (strcat(output," are tied at "));
// 				output = (strcat(output,tmp));

// 				tnum 	= (ceil(boss.max_rounds / 2));
// 				team_score_number = (tnum - team_first_place.wins);
// 				tmp 	= ftos(team_score_number);
// 				output 	= (strcat(output," need "));
// 				output 	= (strcat(output,tmp));
// 				output 	= (strcat(output," to winë"));
// 		}
// 		else
// 		{
// 				team_score_number = team_first_place.wins;

// 				tmp = ftos(team_score_number);
// 				output = (strcat("ùTeams \btied\b at ",tmp));

// 				tnum = (ceil(boss.max_rounds / 2));
// 				team_score_number = (tnum - team_first_place.wins);
// 				tmp = ftos(team_score_number);
// 				output = (strcat(output," need "));
// 				output = (strcat(output,tmp));
// 				output = (strcat(output," to winë"));
// 		}
// 	}
// 	return output;
// };

// void () match_ready_players =
// {
// 	local entity pteam, player;
	
// 	pteam = boss.next_team;
// 	while (pteam != world)
// 	{
// 		player = pteam.chain_gang;
// 		while (player != world)
// 		{
// 			if (player.style & CA_CONNECTED)
// 			{
// 				player.player_flag = PF_READY;
// 			}
// 			player = player.chain_gang;
// 		}
// 		pteam = pteam.next_team;
// 	}
// };

// //BAM: Returns size of linked list.
// float (entity list) chain_gang_size =
// {
// 	local entity e;
// 	local float n;
	
// 	e = list.chain_gang;
	
// 	while (e)
// 	{
// 		n = n + 1;
// 		e = e.chain_gang;
// 	}
	
// 	return n;
// };

// //R00k used for debugging: Maybe pre-round onscreen display?
// void (entity pteam, entity admin) print_chain_gang =
// {
// 	local entity e;
	
// 	e = pteam;
	
// 	while (e.chain_gang)
// 	{
// 		e = e.chain_gang;
// 		sprint (admin, e.netname, "\n");
// 	}
// };

/*
the way the rotation should work is like this...
EXAMPLE: a team of 5 with 3 in, 2 waiting:
    ye olde code     NEW: (#1 is the captain!)
    round 1:	     round 1:	                   
    1 2 3 [4 5]      1 2 3 [4 5]                             
    round 2:         round 2:                                
    4 1 2 [5 3]	     5 1 2 [3 4] 
    round 3:         round 3:                                
    5 4 1 [3 2]      4 5 1 [2 3] 
    round 4:         round 4:                                
    3 5 4 [2 1]      3 4 5 [1 2]
    round 5:         round 5:                                
    2 3 5 [1 4]      2 3 4 [5 1]
    round 6:	     round 6:                                 
    1 2 3 [4 5]      1 2 3 [4 5]
    round 7:         round 7:                                      
    4 1 2 [5 3]      5 1 2 [3 4]
    round 8:         round 8:                                      
    5 4 1 [3 2]      4 5 1 [2 3] 
    round 9:         round 9:                                      
    3 5 4 [2 1]      3 4 5 [1 2]

1 plays 6 rounds
2 plays 5 rounds
3 plays 5 rounds
4 plays 6 rounds
5 plays 5 rounds
*/

// //R00k
// void (entity pteam) rotate_chain_gang =
// {
// 	local entity e, thedude;
// 	local float n, p;
	
// 	p = chain_gang_size (pteam);
	
// 	if (p <= boss.start_players)
// 		return;
			
// 	e = pteam;
		
// 	for (n = 1; n <= p; n = n + 1)
// 	{
// 		e = e.chain_gang;
		
// 		if (e.chain_gang == world)//find the end of the chain
// 		{
// 			thedude = e;
// 			break;
// 		}
// 	}
	
// 	remove_player_from_chain (pteam, thedude);//remove him from the END
// 	add_player_to_chain_pre (pteam, thedude); //place him at the START
// };

// void () update_chain_gang =
// {
// 	local entity pteam;

// 	pteam = boss.next_team;
	
// 	while (pteam != world)
// 	{
// 		rotate_chain_gang(pteam);
// 		pteam = pteam.next_team;
// 	}
// };

// void () respawn_teams =
// {
// 	local float 	cp;
// 	local entity 	pteam, player, tmp;
	
// 	pteam = boss.next_team;
// 	player = pteam.chain_gang;
			
// 	while (pteam != world)
// 	{
// 		while (player != world)
// 		{
// 			if (player.cc_queue != 0)//BAM
// 			{
// 				bprint4 (player.netname, " \bColor-Changed\b to: ", pteam.netname, "\n");
// 				player.cc_queue = 0;
// 				player.cc_queue_vote = 0;
// 			}

// 			if (ca_gametype & CA_SPAWN_LIMIT)
// 				cp = number_teammates_alive (pteam);//R00k: fixed 1.56
// 			else
// 				cp = 0;
				
// 			if (mode_speedball())//override
// 				cp = 0;
			
// 			if (ca_gametype & CA_ELIMINATION_MODE)			
// 				cp = 0; //spawn whole teams
			
// 			if (cp < boss.start_players)
// 			{
// 				tmp = self;
// 				self = player;
// 				observer_end ();
// 				self = tmp;
// 			}
// 			else
// 			{
// 				wait_name (player);
// 				centerprint (player, "you will spawn when a teammate dies");
// 			}				
			
// 			player.dmg_given_round = 0;
			
// 			player = player.chain_gang;
// 		}
	
// 		pteam = pteam.next_team;
// 		player = pteam.chain_gang;
// 	}	
// };

// void (entity pteam) spawn_next_player =
// {
// 	local entity e,tmp;
// 	local float n;
	
// 	//BAM
// 	if (chain_gang_size (pteam) <= boss.start_players)
// 		return;
		
// 	n = number_teammates (pteam);
// 	e = pteam.chain_gang;

// 	while ((e != world) && (n > 0))
// 	{
// 		if ((e.style & CA_CONNECTED) && (IS_CA_OBSERVER(e)) && (e.player_flag == PF_READY))
// 		{
// 			tmp = self;
// 			self = e;			
// 			observer_end();			
// 			self = tmp;			
// 			return;
// 		}
// 		e = e.chain_gang;
// 		n = n - 1;
// 	}
// };

// void () im_dead_now_what =
// {
// 	entity tmp, player;
	
// 	if (self.style & CLANRING_CONNECTED)
// 	{		
// 		self.team2 = 0;
// 		stuffcmd(self,";color 0;\n");
// 		dead_name();
// 	}
	
// 	self.player_flag = PF_DEAD;	
// };

// void (entity pteam) arena_remove_team =
// {
// 	//local string pstring;
// 	local entity plast;

// 	//pstring = (pteam.netname);
// 	//bprint3 ("Removing the ",(pstring),"\n");

// 	plast = boss;

// 	while (plast.next_team)
// 	{
// 		if (plast.next_team == pteam)
// 		{
// 			plast.next_team = pteam.next_team;
// 			break;
// 		}
// 		plast = plast.next_team;
// 	}

// 	remove (pteam);
// };

// void () RemoveFromTeam =
// {
// 	if (self.next_team == world)
// 		return;

// 	if (self.next_team == self)
// 		return;

// 	if (!self.cc_queue)
// 		bprint4 (self.netname, "\b has left the ", self.next_team.netname, "\n");

// 	if (self.player_flag == PF_PLAYING)
// 	{
// 		if (number_teammates_alive (self.next_team))
// 			spawn_next_player (self.next_team);
// 	}

// 	remove_player_from_chain(self.next_team, self);
// 	remove_player_from_stat_list(self.next_team, self);
	
// 	//no players exist on this team, kill the team
// 	if (number_teammates (self.next_team) == 0)
// 	{
// 		pqc_erase_team(self.next_team.team2);
// 		arena_remove_team(self.next_team);
// 	}

// 	//reset player
// 	self.team2 	= TEAM_SPECTATOR;
// 	self.team 	= ((self.team2) + 1);//v1.1b fixed?
// 	self.next_team 	= world;
	
// 	if (self.style & CLANRING_CONNECTED)	
// 	{		
// 		setname(self,self.netname);
// 		setcolour (self, 0, 0);
// 		stuffcmd(self,";color 0;\n");		
// 	}
	
// 	if ((mode_match() && (boss.state == CA_MATCH_WAITING)) || (mode_speedball() && (boss.state == CA_MATCH_WAITING))) 
// 		motd_playercount();// R00k v1.53	

// 	self.player_flag 	= PF_WAITING;
// 	self.movetarget 	= world;
// 	self.frags 		= -99;
// };

// void () observer_cancel_leave =
// {
// 	if ((self.owner.style & CA_CONFIRM_LEAVE))
// 	{
// 		self.owner.style = (self.owner.style - (self.owner.style & CA_CONFIRM_LEAVE));
// 		sprint (self.owner, "Cancelled\n");
// 	}
// 	remove (self);
// };

// void () observer_confirm =
// {
// 	if ((self.style & CA_CONFIRM_LEAVE))
// 	{
// 		return;
// 	}
// 	sprint (self, "Leave match?  Type \byes\b to confirm.\n");
// 	self.style = (self.style | CA_CONFIRM_LEAVE);
// 	utils_make_scheduled_event (observer_cancel_leave, 5);
// };

// void (float response) observer_confirm_leave_response =
// {
// 	self.style = self.style - (self.style & CA_CONFIRM_LEAVE);
// 	if (response)
// 	{
// 		if (self.next_team != world)
// 		{
// 			RemoveFromTeam();
// 			observer_start();
// 		}
// 	}
// 	else
// 	{
// 		sprint (self, "Cancelled\n");
// 	}
// };

// void () arena_delete_teams =
// {
// 	local entity pteam;

// 	if (teamplay)
// 	{
// 		while (boss.next_team)
// 		{
// 			pteam = boss.next_team;			
// 			boss.next_team = pteam.next_team;
// 			pqc_erase_team(pteam.team2);//R00k v1.82
// 			remove (pteam);
// 		}
// 	}

// 	boss.next_team 		= world;
// 	boss.next_player 	= world;
// 	boss.wait 		= 0;
// };

// //--FFA start
// void() Join_FFA_Team =
// {
// 	local entity pteam;
// 	local string tmp;

// 	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
// 	{
// 		sprint (self, "Try again in 5 seconds...\n");
// 		return;
// 	}

// 	if (boss.state != CA_MATCH_WAITING)
// 	{
// 		sprint(self,"\bYou may not join at this time.\n");
// 		return;
// 	}
	
// //already on a team
// 	if (self.next_team != world)
// 	{
// 		sprint(self,"\bYou have already commited to a team.\n");
// 		return;
// 	}

// 	if (number_teams () < boss.max_teams)
// 	{
// 		pteam = spawn();

// 		pteam.classname = "ca_team";
// 		pteam.team2	= (self.colormap);
// 		pteam.wins	= 0;
// 		pteam.losses 	= 0;
// 		pteam.armorvalue = 0;
// 		pteam.health	= 0;
// 		pteam.netname 	= strings_get_teamname(pteam.team2);
// 		self.team2	  = (self.colormap);
// 		self.next_team    = pteam;
// 		//self.next_player  = pteam.next_player;
// 		//pteam.next_player = self;
// 		add_player_to_stat_list(pteam,self);
// 		add_player_to_chain(pteam,self);//Needed i suppose for counting teammates alive...
// 		pteam.next_team   = boss.next_team;
// 		boss.next_team    = pteam;
// 		//announce2 ("creating the ", pteam.netname);
// 		announce3 (self.netname, " has joined the ", pteam.netname);
// 		setcolor(self,0,self.team2);
// 		tmp= ftos(self.team2);
// 		stuffcmd(self,";color ");
// 		stuffcmd(self,tmp);
// 		stuffcmd(self,";\n");
		
// 		stats_reset_player (); //BAM MOVED
// 	}
	
// 	motd_top5 = string_null;
// 	motd_top6 = string_null;
// };
// //--FFA end
// void(float whichteam) Join_Team =
// {
// 	local entity pteam;
// 	local string tmp;

// 	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER) || (boss.busy))
// 	{
// 		sprint (self, "Try again in 5 seconds...\n");
// 		return;
// 	}

// 	if (boss.state != CA_MATCH_WAITING)
// 	{
// 		sprint(self,"\bYou may not join at this time.\n");
// 		return;
// 	}

// 	if (self.next_team != world)
// 	{
// 		sprint(self,"\bYou have already commited to a team.\n");
// 		return;//already on a team
// 	}

// 	pteam = find_team_entity(whichteam);

// 	if (pteam == world)
// 	{
// 		if (number_teams () < boss.max_teams)
// 		{
// 			pteam = spawn();

// 			pteam.classname 	= "ca_team";
// 			pteam.team2		= whichteam;
// 			pteam.wins		= 0;
// 			pteam.losses 		= 0;
// 			pteam.armorvalue 	= 0;
// 			pteam.health		= 0;
// 			pteam.netname 		= strings_get_teamname (pteam.team2);
			
// 			pteam.next_player	= world;//init entity
// 			pteam.chain_gang 	= world;//init entity
			
// 			pteam.next_team   	= boss.next_team;
// 			boss.next_team    	= pteam;

// 			//announce2 ("creating the ", pteam.netname);
// 			announce3 (self.netname, " has joined the ", pteam.netname);
// 			pqc_new_team (world,((pteam.team2) * 16) + (pteam.team2));			
// 		}
// 		else
// 		{
// 			//sound (self, CHAN_VOICE, "player/axhit2.wav", 1, ATTN_NORM);
// 			sprint (self, "The maximum amount of teams exists.\n");
// 			return;
// 		}
// 	}
// 	else
// 	{
// 		if (number_teammates (pteam) == boss.max_players)
// 		{
// 			//sound (self, CHAN_VOICE, "player/axhit2.wav", 1, ATTN_NORM);
// 			sprint (self, "That team is \bfull\b.\n");
// 			return;
// 		}

// 		announce3 (self.netname, " has joined the ", pteam.netname);	
// 	}
	
// 	self.team2  	= whichteam;
// 	self.next_team 	= pteam;
	
// 	add_player_to_stat_list(pteam,self);
// 	add_player_to_chain(pteam,self);

// 	tmp = ftos(self.team2);

// 	setcolor(self,self.team2,self.team2);
	
// 	stuffcmd(self,";color ");
// 	stuffcmd(self,tmp);
// 	stuffcmd(self,";\n");			
	
// 	motd_playercount();// R00k v1.53

// 	motd_top5 = string_null;
// 	motd_top6 = string_null;
// 	stats_reset_player (); //BAM MOVED
// };

// float (float n) join_team2 =
// {
// 	local entity pteam;
// 	local string tmp;

// 	if (self.cl[CL_ACTIVE] != %1)
// 		return FALSE;
		
// 	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
// 	{
// 		sprint (self, "Try again in 5 seconds...\n");
// 		self.cc_queue = 0;
// 		self.cc_queue_vote = 0;
// 		return FALSE;
// 	}

// 	pteam = find_team_entity (n);

// 	if (pteam == world)
// 	{
// 		pteam = spawn();
// 		pteam.classname 	= "ca_team";
// 		pteam.team2		= n;
// 		pteam.wins		= 0;
// 		pteam.losses 		= 0;
// 		pteam.netname 		= strings_get_teamname (pteam.team2);
// 		pteam.armorvalue	= 0;
// 		pteam.health		= 0;
// 		pteam.next_player	= world;//init entity
// 		pteam.chain_gang 	= world;//init entity
// 		pteam.next_team   	= boss.next_team;
// 		boss.next_team    	= pteam;	
// 		pqc_new_team (world,((pteam.team2) * 16) + (pteam.team2));
// 	}
		
// 	self.team2		= TEAM_SPECTATOR;//dont allow dead teammates to talk to playing teammates
// 	self.player_flag	= PF_WAITING;
	
// 	self.next_team 	= pteam;
// 	add_player_to_stat_list(pteam,self);
// 	add_player_to_chain(pteam,self);

// 	tmp = ftos(self.team2);
	
// 	setcolor(self,n,0);
	
// 	stuffcmd(self,";color ");
// 	stuffcmd(self,tmp);
// 	stuffcmd(self," 0;\n");			

// 	motd_playercount();// R00k v1.53

// 	motd_top5 = string_null;
// 	motd_top6 = string_null;
// 	stats_reset_player ();
// 	return TRUE;
// };

// void () ca_cc_vote_join =
// {
// 	local entity pteam, tmp, p;
// 	local string color;	

// 	p = find (world, classname, "player");
	
// 	while (p)
// 	{
// 		if (p.cc_queue_vote)
// 		{	
// 			tmp = self;
// 			self = p;	
// 			self.cc_queue = self.cc_queue_vote;
// 			self.cc_queue_vote = 0;
			
// 			if (join_team2 (self.cc_queue) == TRUE)
// 			{
// 				pteam = find_team_entity (self.cc_queue);
// 				sprint (self, "In queue to \bColor-Change\b to ", pteam.netname, "...\n");
				
// 				color = ftos (self.cc_queue);
// 				setcolor (self, self.cc_queue, 0);
// 				stuffcmd (self, ";color ");
// 				stuffcmd (self, color);
// 				stuffcmd (self, " 0;\n");
// 			}	
			
// 			self = tmp;	
// 		}
// 		p = find (p, classname, "player");
// 	}
// };

// void (float whichteam) Request_Join_Team =
// {
// 	local entity pteam;
// 	local string color;

// 	self.impulse = 0;//R00k

// 	//already on a team
// 	if (self.next_team != world)
// 		return;
		
// 	if (ca_gametype & CA_CC_LOCK)
// 	{
// 		sprint (self, "Match has been locked.\n");
// 		return;
// 	}

// 	// Already in queue to join a team
// 	if ((self.cc_queue) || (self.cc_queue_vote))
// 	{
// 		sprint (self, "In queue to \bjoin\b team, please wait...\n");
// 		return;
// 	}
	
// 	pteam = find_team_entity (whichteam);

// 	if (number_teammates (pteam) >= boss.max_players)
// 	{
// 		sprint (self, "That team is \bfull\b.\n");
// 		return;
// 	}

// 	if (pteam == world)
// 	{
// 		if (number_teams () >= boss.max_teams)
// 		{
// 			sprint (self, "The maximum number of teams already exists.\n");
// 			return;
// 		}
// 	}
	
// 	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
// 	{
// 		sprint (self, "Try again in 5 seconds...\n");
// 		self.cc_queue = 0;
// 		self.cc_queue_vote = 0;
// 		return;
// 	}
	
// 	if (ca_gametype & CA_CC_VOTE)
// 	{			
// 		if ((boss.count < 8))// After team line-up / spawns take place!
// 		{			
// 			if (vote_init("allow new players to join the match.","", "cc_vote", ca_cc_vote_join))
// 			{
// 				self.cc_queue_vote = whichteam;
// 				vote_yes();
// 			}
// 		}
// 		else
// 		{
// 			sprint (self, "Try again in 5 seconds...\n");
// 			return;
// 		}
// 	}
// 	else
// 	{
// 		if ((boss.count < 8))// After team line-up / spawns take place!
// 		{
// 	//		if (cc_queue_allowed (whichteam))
// 			{
// 				self.cc_queue = whichteam;
// 				if (join_team2(whichteam) == TRUE)
// 				{
// 					pteam = find_team_entity (whichteam);
// 					sprint (self, "In queue to \bColor-Change\b to ", pteam.netname, "...\n");
					
// 					color = ftos (self.cc_queue);
// 					setcolor (self, self.cc_queue, 0);
// 					stuffcmd (self, ";color ");
// 					stuffcmd (self, color);
// 					stuffcmd (self, " 0;\n");
// 				}
// 			}
// 		}
// 		else
// 		{
// 			sprint (self, "Try again in 5 seconds...\n");
// 			return;
// 		}
// 	}
// };
// //---------------------------------------------------------------------------------------------
void () RA_Select_Team =
{
	if (boss.busy == TRUE)
	{
		sprint(self,"Cleaning up match end. Re-join in 3 seconds.\n");		
		return;
	}

	clear_name();
	self.style = self.style - (self.style & CLANRING_AFK_CLIENT);
	self.afk_time = time;
		
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

// //-----------------------------------------------------------------------
// void () arena_pause_item =
// {
// 	if ((self.nextthink == CONTENT_EMPTY))
// 	{
// 		return;
// 	}

// 	self.nextthink = (self.nextthink + 1000000);
// 	self.old_velocity = self.velocity;
// 	self.velocity = VEC_ORIGIN;

// 	if ((self.classname == "grenade"))
// 	{
// 		self.movetype = MOVETYPE_FLY;
// 	}
// };

// void () arena_pause_player =
// {
// 	if ((IS_CA_OBSERVER(self)) || self.deadflag)
// 	{
// 		self.old_velocity = VEC_ORIGIN;
// 		return;
// 	}
// 	self.movetype		= MOVETYPE_FLY;
// 	self.old_velocity 	= self.velocity;
// 	self.velocity 		= VEC_ORIGIN;

// 	if ((self.nextthink == CONTENT_EMPTY))
// 	{
// 		return;
// 	}
// 	self.nextthink = (self.nextthink + 1000000);
// };

// void () arena_pause =
// {
// 	if ((boss.state == CA_MATCH_WAITING) || (boss.paused) || (gameover))
// 	{
// 		return;
// 	}

// 	ca_pause_time = time;
// 	boss.paused = TRUE;
// 	timetofight = FALSE;//v1.4
// 	utils_do_projectiles (arena_pause_item);
// 	utils_do_arena_players (arena_pause_player);
// 	announce ("game paused");
// };

// void () arena_unpause_item =
// {
// 	if ((self.nextthink == CONTENT_EMPTY))
// 	{
// 		return;
// 	}
// 	self.nextthink = ((self.nextthink - 1000000) + ca_pause_time);
// 	self.velocity = self.old_velocity;
// 	if ((self.classname == "grenade"))
// 	{
// 		self.movetype = MOVETYPE_BOUNCE;
// 	}
// };

// void () arena_unpause_player =
// {
// 	self.pain_finished 	= (self.pain_finished + ca_pause_time);
// 	self.air_finished 	= (self.air_finished + ca_pause_time);
	
// 	if ((IS_CA_OBSERVER(self)) || self.deadflag)
// 	{
// 		return;
// 	}
// 	self.movetype = MOVETYPE_WALK;
// 	self.velocity = self.old_velocity;
// 	if ((self.nextthink == CONTENT_EMPTY))
// 	{
// 		return;
// 	}
// 	self.nextthink = ((self.nextthink - 1000000) + ca_pause_time);
// };

// void () arena_unpause =
// {
// 	if (!(boss.paused))
// 	{
// 		return;
// 	}
// 	boss.paused = FALSE;	
// 	utils_do_projectiles (arena_unpause_item);
// 	utils_do_arena_players (arena_unpause_player);
// 	timetofight = TRUE;//R00k added v1.4
// 	announce ("game on!");
// 	WriteByte (MSG_ALL, SVC_CENTERPRINT);
// 	WriteString (MSG_ALL, " ");
// };

// //R00k changed:v1.4
// void () arena_unpause_countdown_think =
// {
// 	if (self.count == 0)
// 	{
// 		boss.unpausing = FALSE;
// 		arena_unpause ();
// 		ctprint("\bFIGHT!");
// 		sound(world, CHAN_AUTO, "ra/fight.wav", 1, ATTN_NONE);
// 		remove (self);
// 	}
// 	else
// 	{
// 		if (self.count == 1)
// 		{
// 			ctprint("1");
// 			sound(world, CHAN_AUTO, "ra/1.wav",1, ATTN_NONE);
// 		}
// 		else
// 		{
// 			if (self.count == 2)
// 			{
// 				ctprint("2\n");
// 				sound(world, CHAN_AUTO, "ra/2.wav", 1, ATTN_NONE);
// 			}
// 			else
// 			{
// 				if (self.count == 3)
// 				{
// 					ctprint("3\n");
// 					sound(world, CHAN_AUTO, "ra/3.wav", 1, ATTN_NONE);
// 				}
// 				else
// 				{
// 					if (self.count == 5)
// 					{
// 						ctprint("prepare to fight\n");
// 					}
// 				}
// 			}
// 		}
// 	}

// 	self.nextthink = (time + 1);
// 	self.count = (self.count - 1);
// };

// void () arena_start_unpause_countdown =
// {
// 	local entity countdown;

// 	if ((boss.unpausing))
// 	{
// 		return;
// 	}
// 	boss.unpausing = TRUE;
// 	countdown = utils_make_scheduled_event (arena_unpause_countdown_think, 1);
// 	countdown.count = 4;
// 	announce ("Unpausing match...");
// };
// //-----------------------------------------------------------------------

// void() respawn;
// void() arena_reset_player =
// {
// 	if (self.next_team != world)
// 		remove_player_from_chain(self.next_team,self);

// 	setname(self,self.netname);
	
// 	self.next_team 	 = world;
// 	self.player_flag = PF_WAITING;
// 	self.movetarget  = world;			
// 	self.model 	 = string_null;
// 	self.mdl	 = string_null;
// 	self.deadflag 	 = DEAD_DYING;
// 	self.think 	 = respawn;
// 	self.nextthink 	 = (time + 1);
// };

// void () execute_changelevel;
// void() reset_match =
// {
// 	utils_do_arena_players (arena_reset_player);
// 	arena_delete_teams();	
// 	boss.busy = FALSE;//triggered TRUE in match_end()
	
// 	motd_playercount();// R00k v1.6

// 	remove(self);
// };

// void () report_mvp_game =
// {
// 	local 	entity	current_player;	
// 	local	float 	mvp;
// 	local	string	name, smvp;
	
// 	mvp = 0;
// 	name = "No one";
	
// 	current_player = find(world, classname, "player");

// 	while (current_player != world)
// 	{		
// 		if ((current_player.cl[CL_ACTIVE] == %1) && (current_player.next_team != world))
// 		{
// 			if (current_player.dmg_given > mvp)
// 			{
// 				mvp = (current_player.dmg_given);
// 				name = current_player.netname;
// 			}		
// 		}
// 		current_player = find(current_player, classname, "player");
// 	}	

// 	ca_mvp_entity = current_player;//R00k added for MVP Intermission

// 	smvp = ftos(mvp);
// 	announce4(name," was the \bmatch\b MVP with ",smvp," points of damage given.");
// };

// void () match_end =
// {
// 	local string temp, mc;
	
// 	boss.busy = TRUE;

// 	if (vote_request.classname == "cc_vote")
// 		vote_reject();
	
// 	cc_queue_reset (); // Cancel Color-Change
	
// 	if (boss.abort == FALSE)
// 	{
// 		stats_final_summary();		
// 		report_mvp_game();	
// 	}
// 	else	
// 		bprint ("Match \baborted\b.\n");//Added v1.4c
		
// 	bprint ("The match is over\n");//required for Qrack cl_autodemo 2

// 	sound (world, CHAN_AUTO, "ra/gong.wav", 1 , ATTN_NONE);

// 	boss.round 		= 1;
// 	boss.count 		= 10;
// 	boss.wait 		= 0;
// 	timetofight 		= FALSE;
// 	boss.state 		= CA_MATCH_CLEANUP;

// 	if ((ca_gametype & CA_ROTATE_NEXTMAP) && (boss.abort == FALSE))
// 	{		
// 		boss.maprecycle = boss.maprecycle - 1;
// 		if (boss.maprecycle < 1)
// 		{			
// 			boss.busy = TRUE;
// 			execute_changelevel();
// 			gameover = TRUE;
// 		}
// 		else
// 		{			
// 			mc=ftos(boss.maprecycle);
// 			if (boss.maprecycle > 1)
// 			{
// 				announce3 ("Next map change after ",mc," more matches.");
// 			}
// 			else 
// 			{
// 				if (boss.maprecycle == 1)
// 					announce ("Next map change after 1 more match.");
// 			}
// 			gameover = FALSE;				
// 		}
// 	}
// 	else
// 	gameover = FALSE;	
	
// 	boss.abort = FALSE;

// 	temp = ftos(boss.round);
// 	localcmd3("skill \"", temp, "\"\n");
		
// 	utils_make_scheduled_event(reset_match, 1);
// 	pqc_match_reset();
// };

// //R00k v1.56
// void() arena_refresh_player =
// {
// 	setname(self,self.netname);
	
// 	self.player_flag = PF_WAITING;
// 	self.movetarget  = world;		
// 	self.model 	 = string_null;
// 	self.mdl	 = string_null;		
// 	self.deadflag 	 = DEAD_DYING;
// 	self.think 	 = respawn;
// 	self.nextthink 	 = (time + 0.05);
// 	self.killed = FALSE;
// };

// void() reset_round =
// {
// 	local string temp;
	
// 	timetofight = FALSE;
// 	boss.wait   = 0;
// 	boss.count  = 10;
// 	boss.round  = boss.round + 1;
// 	temp = ftos(boss.round);
// 	localcmd3 ("skill \"", temp, "\"\n");

// 	utils_do_arena_players(arena_refresh_player);
	
// 	boss.state = CA_MATCH_ROUNDSTART;
// 	boss.busy = FALSE;
// 	remove(self);//delete temp ent that called this function
// };

// void (float x,float y) announce_winner =
// {
// 	if (x == 200 && y == 100)
// 	{
// 		if (!(mode_instagib()))		
// 		sound(world, CHAN_AUTO, "ra/flawless.wav", 1, ATTN_NONE);// Health = 100 Armor == 200 = 300
// 	}
// 	else
// 	if (x >= 100 && y >= 75)
// 	{
// 		sound(world, CHAN_AUTO, "ra/outstand.wav", 1, ATTN_NONE);// Health >= 75 Armor >= 100 = 175
// 	}
// 	else
// 	if (x >= 75 && y >= 50)
// 	{
// 		sound(world, CHAN_AUTO, "ra/excellent.wav", 1, ATTN_NONE);// Health >= 50 Armor >= 75 == 125
// 	}
// 	else
// 	if (x >= 50 && y >= 50)
// 	{
// 		sound(world, CHAN_AUTO, "ra/welldone.wav", 1, ATTN_NONE);// Health >=50 Armor >= 50 == 100
// 	}
// };

// void () report_mvp_round =
// {
// 	local 	entity	current_player;	
// 	local	float 	mvp;
// 	local	string	name, smvp;
	
// 	mvp = 0;
// 	name = "No one";
	
// 	current_player = find(world, classname, "player");

// 	while (current_player != world)
// 	{
// 		if ((current_player.cl[CL_ACTIVE] == %1) && (current_player.next_team != world))
// 		{
// 			if (current_player.dmg_given_round > mvp)
// 			{
// 				mvp = (current_player.dmg_given_round);
// 				name = current_player.netname;
// 			}
// 		}
// 		current_player = find(current_player, classname, "player");
// 	}	
// 	smvp = ftos(mvp);
// 	announce4(name," was the round MVP with ",smvp," points of damage given.");	
// 	bprint("\n");
// };

// void() round_end =
// {
// 	local 	entity	current_player, wteam, lteam;
// 	local	string	temp;

// 	boss.busy = TRUE;//hold the presses!
	
// 	//Look for players alive...

// 	current_player = find(world, classname, "player");

// 	while (current_player != world)
// 	{
// 		if ((current_player.player_flag == PF_PLAYING) || (current_player.player_flag == PF_READY))
// 		{
// 			if ((current_player.health) && (current_player.style & CA_CONNECTED) && (current_player.next_team != world))
// 			{
// 				wteam = current_player.next_team;
// 				wteam.armorvalue = (wteam.armorvalue + current_player.armorvalue);
// 				wteam.health = (wteam.health + current_player.health);				
								
// 				bprint3 ("\b[", current_player.netname, " has ");
// 				temp = ftos (current_player.health);
// 				bprint2 (temp, " Health ");
// 				temp = ftos (current_player.armorvalue);
// 				bprint2 (temp, " Armor\b]\n");		
// 			}
// 		}
// 		current_player = find(current_player, classname, "player");
// 	}
				
// 	if (wteam != world)//ugh lagouts cause all hell
// 	{
// 		wteam.wins = wteam.wins + 1;//up team rounds won
// 		pqc_team_frags(world, (wteam.team2), wteam.wins);
// 	}
	
// 	//BAM: Other teams' losses increases by 1.
// 	lteam = boss.next_team;
// 	while (lteam != world)
// 	{
// 		if (lteam != wteam)
// 			lteam.losses = lteam.losses + 1;
		
// 		lteam = lteam.next_team;
// 	}

// 	bprint ("\n");
// 	announce2((wteam.netname)," has won the round.");	
	
// 	report_mvp_round();
		
// 	if (wteam.wins >= (ceil(boss.max_rounds / 2)))// wins > 50% of rounds wins the match
// 	{
// 		team_first_place = wteam;
// 		gameover = TRUE;
// 		match_end();
// 		return;
// 	}

// 	if (boss.round >= boss.max_rounds)
// 	{			
// 		find_team_place();			
// 		if (team_first_place.wins > team_second_place.wins)//Keep playing until there is a winner!
// 		{
// 			gameover = TRUE;
// 			match_end();
// 			return;
// 		}
// 	}
		
// 	if (wteam != world)//ugh lagouts cause all hell
// 	{
// 		wteam.armorvalue 	= (wteam.armorvalue / number_teammates_alive (wteam));
// 		wteam.health 		= (wteam.health / number_teammates_alive (wteam));	
// 		announce_winner(wteam.armorvalue,wteam.health);
	
// 		wteam.armorvalue 	= 0;
// 		wteam.health 		= 0;
// 	}
// 	utils_make_scheduled_event(reset_round, 0.5);
// };

// //R00k: this finds teams active, and updates the scoreboard for new connecting clients
// void () find_pqc_teamscore_teams =
// {
// 	local entity e;
	
// 	e = boss.next_team;
	
// 	while (e)
// 	{
// 		pqc_new_team (world,((e.team2) * 16) + (e.team2));
// 		pqc_team_frags(world, (e.team2), e.wins);
// 		e = e.next_team;
// 	}
// };

// void () arena_main_loop =
// {
// 	if ((boss.paused) && (!boss.unpausing))
// 	{
// 		WriteByte (MSG_ALL, SVC_CENTERPRINT);
// 		WriteString (MSG_ALL, "\nÖ·ıÛÂ‰Ö\n");
// 		return;
// 	}

// 	if ((boss.busy) || (gameover))
// 		return;

// 	if (boss.state == CA_MATCH_PLAYING)
// 	{
// 		if (number_teams () > 1)
// 		{
// 			if (number_teams_alive () < 2)
// 			{
// 				if (boss.wait == 0)
// 				{
// 					boss.wait = (time + 4);//slight pause before end of round.					
// 					return;
// 				}

// 				if (time > boss.wait)
// 				{
// 					boss.wait = time + 99;//do round end and wait
// 					if (number_teams_alive () == 0)
// 					{
// 						boss.round = (boss.round - 1);// repeat round
// 						announce ("round is a \bdraw\b!");
// 						utils_make_scheduled_event(reset_round,0.5);//fixed v.0.94b
// 						return;
// 					}
// 					round_end();
// 				}
// 			}
// 		}
// 		else
// 		{
// 			gameover = TRUE;
// 			boss.abort = TRUE;
// 			boss.state = CA_MATCH_OVER;
// 			match_end ();
// 		}
// 	}
// 	else if ((boss.state == CA_MATCH_ROUNDSTART))
// 	{
// 		local string temp;
		
// 		motd_top5 = string_null;
// 		motd_top6 = string_null;

// 		if (number_teams () > 1)
// 		{
// 			boss.count = (boss.count) - 1;

// 			if (vote_request.classname == "vote_force")
// 				vote_reject();
			
// 			if (boss.count > 5)
// 			{
// 				if (boss.count == 9)
// 				{
// 					// if (ca_gametype & CA_SPAWN_LIMIT)
// 					// {
// 					// 	if (boss.round > 1)
// 					// 		update_chain_gang ();
// 					// 	match_ready_players ();
// 					// }
// 				}
// 				else if (boss.count == 8)
// 				{
// 					respawn_teams ();
// 					bprint ("ÚÔıÓ‰∫†ù");
// 					if (boss.round <= boss.max_rounds)
// 					{
// 						temp = ftos (boss.round);
// 						bprint(temp);
// 						temp = ftos (boss.max_rounds);
// 						bprint3 (" ÔÊ ",temp,"ë\n");
// 					}
// 					else
// 						bprint ("\bOvertime\bë\n");
						
// 					local string stmp;
// 					stmp = (report_winning_team());
// 					bprint2 (stmp, "\n");
// 				}
// 			}
// 			else
// 			{
// 				if (boss.count == 0)
// 				{					
// 					sound (world, CHAN_ITEM, "ra/fight.wav", 1, ATTN_NONE);
// 					ctprint ("\bFIGHT!");
// 					timetofight = TRUE;
// 					boss.state = CA_MATCH_PLAYING;	
// 					if (boss.round == 1)
// 						announce("The match has begun!");
// 				}
// 				else if (boss.count == 1)
// 				{
// 					ctprint ("1");
// 					sound (world, CHAN_ITEM, "ra/1.wav",1, ATTN_NONE);
// 				}
// 				else if (boss.count == 2)
// 				{
// 					ctprint ("2");
// 					sound (world, CHAN_ITEM, "ra/2.wav", 1, ATTN_NONE);
// 				}
// 				else if (boss.count == 3)
// 				{
// 					ctprint("3");
// 					sound(world, CHAN_ITEM, "ra/3.wav", 1, ATTN_NONE);
// 				}
// 				else if (boss.count == 5)
// 				{
// 					ctprint("prepare to fight");
// 					if (mode_speedball())
// 						utils_make_scheduled_event(StartQballSpawn,3);		
// 				}
// 			}
// 		}
// 		else
// 		{
// 			gameover = TRUE;
// 			boss.abort = TRUE;
// 			boss.state = CA_MATCH_OVER;
// 			match_end();
// 		}
// 	}	
// 	else if ((boss.state == CA_MATCH_WAITING))
// 	{
// 		if (boss.forced)
// 		{
// 			boss.forced 	= FALSE;
// 			timetofight 	= FALSE;
// 			boss.count	= 10;
// 			boss.wait 	= 0;
// 			boss.state 	= CA_MATCH_ROUNDSTART;
// 			sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
// 			announce("Match begins in \b10\b seconds.");
// 			utils_do_players(reset_frags);
// 		}
// 		else if (number_teams () > 1 && boss.allready == TRUE)
// 		{
// 			if (boss.wait == 0)
// 			{
// 				// No need to force match now.
// 				if (vote_request.classname == "vote_force")
// 					vote_reject ();
				
// 				boss.wait = time + 5;
// 				sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
// 				announce("Match begins in \b15\b seconds.");//boss.wait (5) + countdowntimer (10) = 15 seconds...
// 			}

// 			if (time >= boss.wait)
// 			{
// 				timetofight	= FALSE;
// 				boss.count 	= 10;
// 				boss.wait 	= 0;
// 				sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
// 				announce("Match begins in \b10\b seconds.");
// 				utils_do_players(reset_frags);
// 				boss.state = CA_MATCH_ROUNDSTART;	
// 				//pqc_match_reset();
// 				//find_pqc_teamscore_teams();							
// 			}
// 		}
// 		else if (number_teams () < 2 || boss.allready == FALSE)
// 		{
// 			if (boss.wait)
// 			{
// 				announce ("\bResetting \brally\b timer.");
// 				sound (world, CHAN_VOICE, "doors/drclos4.wav", 1, ATTN_NONE);
								
// 				if (number_teams () >= 2)
// 					bprint("Use \bforce\b to start the match.\n");
// 			}
// 			boss.wait = 0;
// 		}
// 		boss.allready = TRUE;
// 	}
// 	else 
// 	{
// 		if (boss.state == CA_MATCH_CLEANUP)
// 		{
// 			if (boss.wait == 0)
// 			{
// 				boss.wait = time + 3;
// 			}
// 			if (time > boss.wait)
// 			{
// 				boss.wait = 0;
// 				boss.state = CA_MATCH_WAITING;
// 			}
// 		}
// 	}
// };