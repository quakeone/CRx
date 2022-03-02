void () observer_start;
void () observer_end;
void () stats_final_summary;
void () stats_reset_player;
void () observer_walk_start;
//void () observer_chase_start;
void () vote_yes;
void () observer_check_demo_end;
void () stats_team_stats;
void () RemoveFromTeam;
void (entity client) observer_disconnect_notify;
void () vote_reject;
void () RA_Select_Team;

float (string s1, string s2, void() accept) vote_init;
entity ca_mvp_entity;
float () W_BestWeapon;

void () arena_precache =
{
    precache_sound ("ra/1.wav");
	precache_sound ("ra/2.wav");
	precache_sound ("ra/3.wav");
	precache_sound ("ra/fight.wav");
	precache_sound ("ra/laugh.wav");
	precache_sound ("ra/flawless.wav");
	precache_sound ("ra/outstand.wav");	
	precache_sound ("ra/excellent.wav");		
	precache_sound ("ra/welldone.wav");
	precache_sound ("ra/gong.wav");	
}

void () arena_init_world =
{
	local entity oself;
			
	boss 				= spawn ();
	boss.max_rounds 	= 9;
	boss.round			= 1;
	boss.count 			= 10;
	boss.state 			= CA_MATCH_WAITING;
	boss.wait 			= 0;
	boss.maprecycle		= 0;
	boss.health      	= 100;
	boss.armorvalue  	= 200;
	boss.armortype   	= 80.001;
	boss.ammo_shells 	= 100;
	boss.ammo_nails  	= 100;
	boss.ammo_rockets	= 50;
	boss.ammo_cells  	= 100;
	boss.items 			= ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN);


    boss.max_players 	= 8;//R00k: changed v1.52
    boss.start_players	= 3;
    boss.max_teams  	= 4;
    //arena_ammobehavior	= 2;//deplete ammo default
    
    oself = self;
    self = boss;
    self.weapon = W_BestWeapon();
    self = oself;	

	boss.timetofight 	= FALSE;
	boss.next_team 	= world;
	boss.busy		= FALSE;
	boss.aborted 		= FALSE;
	ca_mvp_entity	= world;
};

float () mode_is_arena
{
    if ((clanring_playmode & CLANRING_CA_MODE) || (clanring_playmode & CLANRING_RA_MODE))
        return TRUE;
    return FALSE;
}

float (entity e) IS_CA_OBSERVER
{
     if ((e.style & CLANRING_OBSERVER) && (clanring_playmode & CLANRING_CA_MODE))
        return TRUE;
     else
        return FALSE;
}
  
float (entity team1) number_teammates =
{
	local entity e;
	local float n = 0;

	e = team1;

	while (e.chain_gang)
	{
		n = n + 1;
		e = e.chain_gang;
	}
	return n;
};

float (entity team1) number_teammates_alive =
{
	local entity e;
	local float n = 0;

	e = team1;

	while (e.chain_gang)
	{
        if (e.chain_gang.deadflag == DEAD_NO && (IS_CA_OBSERVER(e.chain_gang) == FALSE) && ((e.chain_gang.style & CLANRING_CONNECTED)))
        n = n + 1;
		e = e.chain_gang;
	}
	return n;
};

float () number_teams =
{
	local float n = 0.0;
	local entity e;

	e = boss.next_team;

	while (e)
	{
		n = n + 1;
		e = e.next_team;
	}

	return n;
};

float () number_teams_alive =
{
	local float n = 0;
	local entity e;

	e = boss.next_team;

	while (e)
	{
		if (number_teammates_alive (e))
		n = n + 1;

		e = e.next_team;
	}

	return n;
};

float () number_players_alive =
{
	local float n = 0;
	local entity e;

	e = find (world, classname, "player");

	while (e)
	{
		if (e.ca_player_flag == PF_PLAYING)
		{
			if (e.health > 1)
			n = n + 1;
		}
		e = find (e, classname, "player");
	}

	return n;
};

void () CheckForLastTwoPlayers =
{
	if (number_teams_alive() != 2)
	return;

	if (number_players_alive() > 2)
	return;

	sound (world, CHAN_ITEM, "ambience/thunder1.wav", 1, ATTN_NONE);
}

float () number_total_players =
{
	local float n = 0;
	local entity e;

	e = find (world, classname, "player");

	while (e)
	{
		n = n + 1;
		e = find (e, classname, "player");
	}

	return n;
};

void () cc_queue_reset =
{
	local entity e, oself;

	e = find (world, classname, "player");

	while (e)
	{
		oself = self;
		self = e;
		if ((self.cc_queue) || (self.cc_queue_vote))
		{
			if (self.next_team != world)
			RemoveFromTeam ();

			self.cc_queue_vote = 0;
			self.cc_queue = 0;
		}
		self = oself;

		e = find (e, classname, "player");
	}
};

void (string msg) ctprint =
{
	local	entity  e;

	e = find (world, classname, "player");

	while (e != world)
	{
		if (IS_CA_OBSERVER(e) == FALSE)
		centerprint (e, msg);

		e = find (e, classname, "player");
	}
};

// Add player to the beginning of the chain
void(entity list, entity player) add_player_to_chain_pre =
{
	//??? if (list == world) return;
	
	player.chain_gang = list.chain_gang;
	list.chain_gang = player;
};

// Add player to the end of the chain
void (entity list, entity player) add_player_to_chain =
{
	while (list.chain_gang)
	list = list.chain_gang;

	list.chain_gang = player;
	player.chain_gang = world;
};

void (entity list, entity player) remove_player_from_chain =
{
	local   entity  e;

	e = list;
	while (e.chain_gang)
	{
		if (e.chain_gang == player)
		{
			e.chain_gang = player.chain_gang;
			player.chain_gang = world;//v1.5
			return;
		}
		e = e.chain_gang;
	}
};

float (entity list, entity player) ca_check_player_in_list =
{
	local entity e;
	local float check;

	e = list;

	check = 16;//crash test (fixme: change from 16 to SV_MAXPLAYERS) check = max(16, sv_maxplayers);

	while ((e != world) && (e.next_player))
	{
		if (check < 1)
		return FALSE;

		if (e.next_player == player)
		{
			return TRUE;
		}
		check = check - 1;
		e = e.next_player;
	}
	return FALSE;
};

void (entity list, entity player) add_player_to_stat_list =
{
	if (ca_check_player_in_list(list, player) == FALSE)// just incase
	{
		player.next_player = list.next_player;
		list.next_player = player;
	}
};

void (entity list, entity player) remove_player_from_stat_list =
{
	local   entity  e;

	e = list;
	while (e.next_player)
	{
		if (e.next_player == player)
		{
			e.next_player = player.next_player;
			player.next_player = world;
			return;
		}
		e = e.next_player;
	}
};

entity (float whichteam) find_team_entity =
{
	local entity e;

	e = boss.next_team;

	while (e)
	{
		if (e.team2 == whichteam)
		return e;

		e = e.next_team;
	}
	return world;
};

float () high_team =
{
	local entity e;
	local float plr_highest, n;

	e = boss.next_team;
	plr_highest = 1;

	// Find team with most players
	while (e != world)
	{
		n = number_teammates (e);
		if (n > plr_highest)
		plr_highest = n;
		e = e.next_team;
	}

	return (plr_highest);
};

float (float whichteam) lower_team =
{
	local entity pteam;
	local float t,n;

	pteam 	= find_team_entity (whichteam);
	n 	= high_team();
	t 	= number_teammates (pteam);

	if (t < n)
	return TRUE;
	else
	return FALSE;
};

void () find_team_place =
{
	local entity 	pteam;

	team_first_place 	= boss;
	team_second_place 	= boss;
	team_third_place 	= boss;
	//	team_fourth_place	= boss;//unused

	pteam = boss.next_team;

	while (pteam)
	{
		if ((pteam.wins >= team_first_place.wins))
		{
			team_second_place = team_first_place;
			team_first_place = pteam;
		}
		else
		{
			if ((pteam.wins >= team_second_place.wins))
			{
				team_third_place = team_second_place;
				team_second_place = pteam;
			}
			else
			{
				if ((pteam.wins >= team_third_place.wins))
				{
					//	team_fourth_place = team_third_place;
					team_third_place = pteam;
				}
				/*				else
				{
				if ((pteam.wins >= team_fourth_place.wins))
				team_fourth_place = pteam;
				}*/
			}
		}
		pteam = pteam.next_team;
	}
};

string () report_winning_team =
{
	local entity 	pteam;
	local float	team_score_number,tnum;
	local string 	tmp;
	local string	team_winning_teamname,output;

	team_first_place 	= boss;
	team_second_place 	= boss;
	team_third_place 	= boss;

	if (boss.round == 1) return string_null; //Match just started we know...

	pteam = boss.next_team;

	while (pteam)
	{
		if ((pteam.wins > team_first_place.wins))
		{
			team_third_place = team_second_place;
			team_second_place = team_first_place;
			team_first_place = pteam;
		}
		else
		{
			if ((pteam.wins > team_second_place.wins))
			{
				team_third_place = team_second_place;
				team_second_place = pteam;
			}
			else
			{
				if ((pteam.wins >= team_third_place.wins))//R00k: v1.55
				{
					team_third_place = pteam;
				}
			}
		}
		pteam = pteam.next_team;
	}

	if ((team_first_place.wins > team_second_place.wins))
	{
		team_score_number = (team_first_place.wins - team_second_place.wins);
		team_winning_teamname = strings_get_teamname_leads_by (team_first_place.team2);

		tmp = ftos(team_score_number);
		output = (strcat("\x85The",team_winning_teamname));
		output = (strcat(output,tmp));

		tnum = (ceil(boss.max_rounds / 2));
		team_score_number = (tnum - team_first_place.wins);
		tmp = ftos(team_score_number);

		output = (strcat(output," needs "));
		output = (strcat(output,tmp));
		output = (strcat(output," to win\x85"));
	}
	else
	{
		if ((number_teams () > 2) && ((team_first_place.wins == team_second_place.wins) && (team_first_place.wins > team_third_place.wins)) )
		{
			team_score_number = team_first_place.wins;
			team_winning_teamname = team_first_place.netname;
			tmp = ftos(team_score_number);

			output = ("\x85The ");
			output = (strcat(output,team_first_place.netname));
			output = (strcat(output," and "));
			output = (strcat(output,team_second_place.netname));
			output = (strcat(output," are tied at "));
			output = (strcat(output,tmp));

			tnum 	= (ceil(boss.max_rounds / 2));
			team_score_number = (tnum - team_first_place.wins);
			tmp 	= ftos(team_score_number);
			output 	= (strcat(output," need "));
			output 	= (strcat(output,tmp));
			output 	= (strcat(output," to win\x85"));
		}
		else
		{
			team_score_number = team_first_place.wins;

			tmp = ftos(team_score_number);
			output = (strcat("Teams \btied\b at ",tmp));

			tnum = (ceil(boss.max_rounds / 2));
			team_score_number = (tnum - team_first_place.wins);
			tmp = ftos(team_score_number);
			output = (strcat(output," need "));
			output = (strcat(output,tmp));
			output = (strcat(output," to win\x85"));
		}
	}
	return output;
};

void () match_ready_players =
{
	local entity pteam, player;

	pteam = boss.next_team;
	while (pteam != world)
	{
		player = pteam.chain_gang;
		while (player != world)
		{
			if (player.style & CLANRING_CONNECTED)
			{
				player.ca_player_flag = PF_READY;
			}
			player = player.chain_gang;
		}
		pteam = pteam.next_team;
	}
};

//BAM: Returns size of linked list.
float (entity list) chain_gang_size =
{
	local entity e;
	local float n = 0;

	e = list.chain_gang;

	while (e)
	{
		n = n + 1;
		e = e.chain_gang;
	}

	return n;
};

//R00k used for debugging: Maybe pre-round onscreen display?
void (entity pteam, entity admin) print_chain_gang =
{
	local entity e;

	e = pteam;

	while (e.chain_gang)
	{
		e = e.chain_gang;
		sprint (admin, e.netname, "\n");
	}
};

//R00k
void (entity pteam) rotate_chain_gang =
{
	local entity e, thedude = world;
	local float n, p;

	p = chain_gang_size (pteam);

	if (p <= boss.start_players)
		return;

	e = pteam;

	for (n = 1; n <= p; n = n + 1)
	{
		e = e.chain_gang;

		if (e.chain_gang == world)//find the end of the chain
		{
			thedude = e;
			break;
		}
	}

	remove_player_from_chain (pteam, thedude);//remove him from the END
	add_player_to_chain_pre (pteam, thedude); //place him at the START
};

void () update_chain_gang =
{
	local entity pteam;

	pteam = boss.next_team;

	while (pteam != world)
	{
		rotate_chain_gang(pteam);
		pteam = pteam.next_team;
	}
};

void () respawn_teams =
{
	local float 	cp = 0;
	local entity 	pteam, player, tmp;

	pteam = boss.next_team;
	player = pteam.chain_gang;

	while (pteam != world)
	{
		while (player != world)
		{
			if (player.cc_queue != 0)//BAM
			{
				bprint4 (player.netname, " \bColor-Changed\b to: ", pteam.netname, "\n");
				player.cc_queue = 0;
				player.cc_queue_vote = 0;
			}

			if (cp < boss.start_players)
			{
				tmp = self;
				self = player;
				observer_end ();
				self = tmp;
			}
			else
			{
				wait_name (player);
				centerprint (player, "you will spawn when a teammate dies");
			}

			player.dmg_given_round = 0;

			player = player.chain_gang;
		}

		pteam = pteam.next_team;
		player = pteam.chain_gang;
	}
};

void (entity pteam) spawn_next_player =
{
	local entity e,tmp;
	local float n;

	//BAM
	if (chain_gang_size (pteam) <= boss.start_players)
		return;

	n = number_teammates (pteam);
	e = pteam.chain_gang;

	while ((e != world) && (n > 0))
	{
		if ((e.style & CLANRING_CONNECTED) && (IS_CA_OBSERVER(e)) && (e.ca_player_flag == PF_READY))
		{
			tmp = self;
			self = e;
			observer_end();
			self = tmp;
			return;
		}
		e = e.chain_gang;
		n = n - 1;
	}
};

void () im_dead_now_what =
{
	if (self.style & CLANRING_CONNECTED)
	{
		self.team2 = 0;
		stuffcmd(self,";color 0;\n");
		dead_name();
	}

	self.ca_player_flag = PF_DEAD;
};

void (entity pteam) arena_remove_team =
{
	//local string pstring;
	local entity plast;

	//pstring = (pteam.netname);
	//bprint3 ("Removing the ",(pstring),"\n");

	plast = boss;

	while (plast.next_team)
	{
		if (plast.next_team == pteam)
		{
			plast.next_team = pteam.next_team;
			break;
		}
		plast = plast.next_team;
	}

	remove (pteam);
};

void () RemoveFromTeam =
{
	if (self.next_team == world)
	return;

	if (self.next_team == self)
	return;

	if (!self.cc_queue)
	bprint4 (self.netname, "\b has left the ", self.next_team.netname, "\n");

	if (self.ca_player_flag == PF_PLAYING)
	{
		if (number_teammates_alive (self.next_team))
		spawn_next_player (self.next_team);
	}

	remove_player_from_chain(self.next_team, self);
	remove_player_from_stat_list(self.next_team, self);

	//no players exist on this team, kill the team
	if (number_teammates (self.next_team) == 0)
	{
		//pqc_erase_team(self.next_team.team2);
		arena_remove_team(self.next_team);
	}

	//reset player
	self.team2 	= TEAM_SPECTATOR;
	self.team 	= ((self.team2) + 1);//v1.1b fixed
	self.next_team 	= world;
	self.weaponlevel = 0;

	//This is fine dont change this!
	if (self.style & CLANRING_CONNECTED)
	{
		setcolour (self, 0, 0);
	}

	self.ca_player_flag 	= PF_WAITING;
	self.movetarget 	= world;
	self.frags 		= -99;
};

void (float response) arena_observer_confirm_leave_response =
{
	self.style = self.style - (self.style & CLANRING_CONFIRM_LEAVE);
	if (response)
	{
		if (self.next_team != world)
		{
			RemoveFromTeam();
			observer_start();
		}
	}
	else
	{
		sprint (self, "Cancelled\n");
	}
};

void () arena_delete_teams =
{
	local entity pteam;

	if (teamplay)
	{
		while (boss.next_team)
		{
			pteam = boss.next_team;
			boss.next_team = pteam.next_team;
			//pqc_erase_team(pteam.team2);//R00k v1.82
			remove (pteam);
		}
	}

	boss.next_team 		= world;
	boss.next_player 	= world;
	boss.wait 		= 0;
};

void(float whichteam) Join_Team =
{
	local entity pteam;
	local string tmp;

	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
	{
		sprint (self, "Try again in 5 seconds...\n");
		return;
	}

	if (boss.state != CA_MATCH_WAITING)
	{
		sprint(self,"\bYou may not join at this time.\n");
		return;
	}

	if (self.next_team != world)
	{
		sprint(self,"\bYou have already commited to a team.\n");
		return;//already on a team
	}

	self.lip = self.lip + 1;
	
	if (self.lip > 2)//R00k: FIXME
	{
		sprint(self,"\bYou may not join at this time.\n");
		self.lip = 0;
		return;
	}
			
	pteam = find_team_entity(whichteam);

	if (pteam == world)
	{
		if (number_teams () < boss.max_teams)
		{
			pteam = spawn();

			pteam.classname 	= "ca_team";
			pteam.team2			= whichteam;
			pteam.wins			= 0;
			pteam.losses 		= 0;
			pteam.armorvalue 	= 0;
			pteam.health		= 0;
			pteam.netname 		= strings_get_teamname (pteam.team2);

			pteam.next_player	= world;//init entity
			pteam.chain_gang 	= world;//init entity

			pteam.next_team   	= boss.next_team;
			boss.next_team    	= pteam;

			//announce2 ("creating the ", pteam.netname);
			announce3 (self.netname, " has joined the ", pteam.netname);
			//pqc_new_team (world,((pteam.team2) * 16) + (pteam.team2));
		}
		else
		{
			//sound (self, CHAN_VOICE, "player/axhit2.wav", 1, ATTN_NORM);
			sprint (self, "The maximum amount of teams exists.\n");
			return;
		}
	}
	else
	{
		if (number_teammates (pteam) == boss.max_players)
		{
			//sound (self, CHAN_VOICE, "player/axhit2.wav", 1, ATTN_NORM);
			sprint (self, "That team is \bfull\b.\n");
			return;
		}

		announce3 (self.netname, " has joined the ", pteam.netname);
	}

	self.team2  	= whichteam;
	self.next_team 	= pteam;

	add_player_to_stat_list(pteam,self);
	add_player_to_chain(pteam,self);

	tmp = ftos(self.team2);

	setcolour(self,self.team2,self.team2);

	stuffcmd(self,";color ");
	stuffcmd(self,tmp);
	stuffcmd(self,";\n");

	motd_top5 = string_null;
	motd_top6 = string_null;
	stats_reset_player (); //BAM MOVED
};

float (float n) join_team2 =
{
	local entity pteam;
	local string tmp;

	if (!(self.style & CLANRING_CONNECTED))//fixed (02/24/2022)
		return FALSE;

	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
	{
		sprint (self, "Try again in 5 seconds...\n");
		self.cc_queue = 0;
		self.cc_queue_vote = 0;
		return FALSE;
	}

	pteam = find_team_entity (n);

	if (pteam == world)
	{
		pteam = spawn();
		pteam.classname 	= "ca_team";
		pteam.team2		= n;
		pteam.wins		= 0;
		pteam.losses 		= 0;
		pteam.netname 		= strings_get_teamname (pteam.team2);
		pteam.armorvalue	= 0;
		pteam.health		= 0;
		pteam.next_player	= world;//init entity
		pteam.chain_gang 	= world;//init entity
		pteam.next_team   	= boss.next_team;
		boss.next_team    	= pteam;
		//pqc_new_team (world,((pteam.team2) * 16) + (pteam.team2));
	}

	self.team2		= TEAM_SPECTATOR;//dont allow dead teammates to talk to playing teammates
	self.ca_player_flag	= PF_WAITING;

	self.next_team 	= pteam;
	add_player_to_stat_list(pteam,self);
	add_player_to_chain(pteam,self);

	tmp = ftos(self.team2);

	setcolour(self,n,0);

	stuffcmd(self,";color ");
	stuffcmd(self,tmp);
	stuffcmd(self," 0;\n");

	motd_top5 = string_null;
	motd_top6 = string_null;
	stats_reset_player ();
	return TRUE;
};

void () ca_cc_vote_join =
{
	local entity pteam, tmp, p;
	local string color;

	p = find (world, classname, "player");

	while (p)
	{
		if (p.cc_queue_vote)
		{
			tmp = self;
			self = p;
			self.cc_queue = self.cc_queue_vote;
			self.cc_queue_vote = 0;

			if (join_team2 (self.cc_queue) == TRUE)
			{
				pteam = find_team_entity (self.cc_queue);
				sprint (self, "In queue to \bColor-Change\b to ", pteam.netname, "...\n");

				color = ftos (self.cc_queue);
				setcolour (self, self.cc_queue, 0);
				stuffcmd (self, ";color ");
				stuffcmd (self, color);
				stuffcmd (self, " 0;\n");
			}

			self = tmp;
		}
		p = find (p, classname, "player");
	}
};

void (float whichteam) Request_Join_Team =
{
	local entity pteam;
	local string color;

	self.impulse = 0;//R00k

	//already on a team
	if (self.next_team != world)
	return;

	// Already in queue to join a team
	if ((self.cc_queue) || (self.cc_queue_vote))
	{
		sprint (self, "In queue to \bjoin\b team, please wait...\n");
		return;
	}

	pteam = find_team_entity (whichteam);

	if (number_teammates (pteam) >= boss.max_players)
	{
		sprint (self, "That team is \bfull\b.\n");
		return;
	}

	if (pteam == world)
	{
		if (number_teams () >= boss.max_teams)
		{
			sprint (self, "The maximum number of teams already exists.\n");
			return;
		}
	}

	if ((boss.state == CA_MATCH_CLEANUP) || (boss.state == CA_MATCH_OVER))
	{
		sprint (self, "Try again in 5 seconds...\n");
		self.cc_queue = 0;
		self.cc_queue_vote = 0;
		return;
	}

	if (clanring_playmode & CLANRING_MODE_VOTE)
	{
		if ((boss.count < 8))// After team line-up / spawns take place!
		{
			if (vote_init("allow new players to join the match.","", ca_cc_vote_join))
			{
				self.cc_queue_vote = whichteam;
				vote_yes();
			}
		}
		else
		{
			sprint (self, "Try again in 5 seconds...\n");
			return;
		}
	}
	else
	{
		if ((boss.count < 8))// After team line-up / spawns take place!
		{
			//		if (cc_queue_allowed (whichteam))
			{
				self.cc_queue = whichteam;
				if (join_team2(whichteam) == TRUE)
				{
					pteam = find_team_entity (whichteam);
					sprint (self, "In queue to \bColor-Change\b to ", pteam.netname, "...\n");

					color = ftos (self.cc_queue);
					setcolour (self, self.cc_queue, 0);
					stuffcmd (self, ";color ");
					stuffcmd (self, color);
					stuffcmd (self, " 0;\n");
				}
			}
		}
		else
		{
			sprint (self, "Try again in 5 seconds...\n");
			return;
		}
	}
};
//---------------------------------------------------------------------------------------------
void () Teamplay_Select_Team =
{
	if (clanring_playmode & CLANRING_RA_MODE)
	{
		RA_Select_Team();
		return;
	}

	if (boss.busy == TRUE)
	{
		sprint(self,"Cleaning up match end. Try again in a few seconds...\n");
		return;
	}

	clear_afk_status(self);

    if (self.impulse == 1)
    {
        if (boss.state == CA_MATCH_WAITING)
        Join_Team(COLOR_BLUE);
        else
        Request_Join_Team (COLOR_BLUE);
    }
    else if (self.impulse == 2)
    {
        if (boss.state == CA_MATCH_WAITING)
        Join_Team(COLOR_RED);
        else
        Request_Join_Team (COLOR_RED);
    }
    else if (self.impulse == 3)
    {
        if (boss.state == CA_MATCH_WAITING)
        Join_Team(COLOR_YELLOW);
        else
        Request_Join_Team (COLOR_YELLOW);
    }
    else if (self.impulse == 4)
    {
        if (boss.state == CA_MATCH_WAITING)
        Join_Team(COLOR_GREEN);
        else
        Request_Join_Team (COLOR_GREEN);
    }

	// We don't want this team anymore
	if (self.impulse == 5)
	{
		if (self.cc_queue_vote)
		{
			if ((clanring_request.classname == "cc_vote") && (clanring_request.owner == self))
			{
				vote_reject();
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

//-----------------------------------------------------------------------
void () arena_pause_item =
{
	if ((self.nextthink == CONTENT_EMPTY))
	{
		return;
	}

	self.nextthink = (self.nextthink + 1000000);
	self.old_velocity = self.velocity;
	self.velocity = '0 0 0';

	if ((self.classname == "grenade"))
	{
		self.movetype = MOVETYPE_FLY;
	}
};

void () arena_pause_player =
{
	if ((IS_CA_OBSERVER(self)) || self.deadflag)
	{
		self.old_velocity = '0 0 0';
		return;
	}
	self.movetype		= MOVETYPE_FLY;
	self.old_velocity 	= self.velocity;
	self.velocity 		= '0 0 0';

	if ((self.nextthink == CONTENT_EMPTY))
	{
		return;
	}
	self.nextthink = (self.nextthink + 1000000);
};

void () arena_pause =
{
	if ((boss.state == CA_MATCH_WAITING) || (clanring_state & CLANRING_MATCH_PAUSED) || (gameover))
	{
		return;
	}

	clanring_match_pause_time = time;
	clanring_state = clanring_state | CLANRING_MATCH_PAUSED;
	boss.timetofight = FALSE;//v1.4
	utils_do_projectiles (arena_pause_item);
	utils_do_arena_players (arena_pause_player);
	announce ("game paused");
};

void () arena_unpause_item =
{
	if ((self.nextthink == CONTENT_EMPTY))
	{
		return;
	}
	self.nextthink = ((self.nextthink - 1000000) + clanring_match_pause_time);
	self.velocity = self.old_velocity;
	if ((self.classname == "grenade"))
	{
		self.movetype = MOVETYPE_BOUNCE;
	}
};

void () arena_unpause_player =
{
	self.pain_finished 	= (self.pain_finished + clanring_match_pause_time);
	self.air_finished 	= (self.air_finished + clanring_match_pause_time);

	if ((IS_CA_OBSERVER(self)) || self.deadflag)
	{
		return;
	}
	self.movetype = MOVETYPE_WALK;
	self.velocity = self.old_velocity;
	if ((self.nextthink == CONTENT_EMPTY))
	{
		return;
	}
	self.nextthink = ((self.nextthink - 1000000) + clanring_match_pause_time);
};

void () arena_unpause =
{
	if (!(clanring_state & CLANRING_MATCH_PAUSED))
	{
		return;
	}
	clanring_state = clanring_state - (clanring_state & CLANRING_MATCH_PAUSED);
	utils_do_projectiles (arena_unpause_item);
	utils_do_arena_players (arena_unpause_player);
	boss.timetofight = TRUE;//R00k added v1.4
	announce ("game on!");
	WriteByte (MSG_ALL, SVC_CENTERPRINT);
	WriteString (MSG_ALL, " ");
};

//R00k changed:v1.4
void () arena_unpause_countdown_think =
{
	if (self.count == 0)
	{
		boss.unpausing = FALSE;
		arena_unpause ();
		ctprint("\bFIGHT!");
		sound(world, CHAN_AUTO, "ra/fight.wav", 1, ATTN_NONE);
		remove (self);
	}
	else
	{
		if (self.count == 1)
		{
			ctprint("1");
			sound(world, CHAN_AUTO, "ra/1.wav",1, ATTN_NONE);
		}
		else
		{
			if (self.count == 2)
			{
				ctprint("2\n");
				sound(world, CHAN_AUTO, "ra/2.wav", 1, ATTN_NONE);
			}
			else
			{
				if (self.count == 3)
				{
					ctprint("3\n");
					sound(world, CHAN_AUTO, "ra/3.wav", 1, ATTN_NONE);
				}
				else
				{
					if (self.count == 5)
					{
						ctprint("prepare to fight\n");
					}
				}
			}
		}
	}

	self.nextthink = (time + 1);
	self.count = (self.count - 1);
};

void () arena_start_unpause_countdown =
{
	local entity countdown;

	if ((boss.unpausing))
	{
		return;
	}
	boss.unpausing = TRUE;
	countdown = utils_make_scheduled_event (arena_unpause_countdown_think, 1);
	countdown.count = 4;
	announce ("Unpausing match...");
};
//-----------------------------------------------------------------------

void() respawn;
void() arena_reset_player =
{
	if (self.next_team != world)
	remove_player_from_chain(self.next_team,self);

	updatename(self,self.netname);
	self.weaponlevel = 0;
	self.next_team 	 = world;
	self.ca_player_flag = PF_WAITING;
	self.movetarget  = world;
	self.model 	 = string_null;
	self.mdl	 = string_null;
	self.deadflag 	 = DEAD_DYING;
	self.think 	 = respawn;
	self.nextthink 	 = (time + 1);
};

void () execute_changelevel;
void() reset_match =
{
	utils_do_arena_players (arena_reset_player);
	arena_delete_teams();
	boss.busy = FALSE;//triggered TRUE in arena_match_end()

	remove(self);
};

void () report_mvp_game =
{
	local 	entity	current_player;
	local	float 	mvp;
	local	string	name, smvp;

	mvp = 0;
	name = "No one";

	current_player = find(world, classname, "player");

	while (current_player != world)
	{
		if ((current_player.style & CLANRING_CONNECTED) && (current_player.next_team != world))
		{
			if (current_player.dmg_given > mvp)
			{
				mvp = (current_player.dmg_given);
				name = current_player.netname;
			}
		}
		current_player = find(current_player, classname, "player");
	}

	ca_mvp_entity = current_player;//R00k added for MVP Intermission

	smvp = ftos(mvp);
	announce4(name," was the \bmatch\b MVP with ",smvp," points of damage given.");
};

void () arena_match_end =
{
	local string temp;//, mc;

	boss.busy = TRUE;

	if (clanring_request.classname == "cc_vote")
		vote_reject();

	cc_queue_reset (); // Cancel Color-Change

	if (boss.aborted == FALSE)
	{
		stats_final_summary();
		report_mvp_game();
	}
	else bprint ("Match \baborted\b.\n");//Added v1.4c

	bprint ("The match is over\n");//required for Qrack cl_autodemo 2

	sound (world, CHAN_AUTO, "ra/gong.wav", 1 , ATTN_NONE);

	boss.round 		= 1;
	boss.count 		= 10;
	boss.wait 		= 0;
	boss.timetofight 	= FALSE;
	boss.state 		= CA_MATCH_CLEANUP;

    gameover = FALSE;

	boss.aborted = FALSE;

	temp = ftos(boss.round);
	localcmd("skill \"", temp, "\"\n");

	utils_make_scheduled_event(reset_match, 1);
//	pqc_match_time (world, 0, 0);
//	pqc_match_reset();
};

//R00k v1.56
void() arena_refresh_player =
{
	updatename(self,self.netname);

	self.ca_player_flag = PF_WAITING;
	self.movetarget  = world;
	self.model  = string_null;
	self.mdl = string_null;
	self.deadflag = DEAD_DYING;
	self.think = respawn;
	self.nextthink = (time + 0.05);
	self.killed	 = FALSE;
};

void() reset_round =
{
	local string temp;

	boss.timetofight = FALSE;
	boss.wait   = 0;
	boss.count  = 10;
	boss.round  = boss.round + 1;
	temp = ftos(boss.round);
	localcmd("skill \"", temp, "\"\n");
	
	utils_do_arena_players(arena_refresh_player);

	boss.state = CA_MATCH_ROUNDSTART;
	boss.busy = FALSE;
	remove(self);//delete temp ent that called this function
};

void (float x,float y) announce_winner =
{
	if (x == 200 && y == 100)
	{
		sound(world, CHAN_AUTO, "ra/flawless.wav", 1, ATTN_NONE);// Health = 100 Armor == 200 = 300
	}
	else
	if (x >= 100 && y >= 75)
	{
		sound(world, CHAN_AUTO, "ra/outstand.wav", 1, ATTN_NONE);// Health >= 75 Armor >= 100 = 175
	}
	else
	if (x >= 75 && y >= 50)
	{
		sound(world, CHAN_AUTO, "ra/excellent.wav", 1, ATTN_NONE);// Health >= 50 Armor >= 75 == 125
	}
	else
	if (x >= 50 && y >= 50)
	{
		sound(world, CHAN_AUTO, "ra/welldone.wav", 1, ATTN_NONE);// Health >=50 Armor >= 50 == 100
	}
};

void () report_mvp_round =
{
	local 	entity	current_player;
	local	float 	mvp;
	local	string	name, smvp;

	mvp = 0;
	name = "No one";

	current_player = find(world, classname, "player");

	while (current_player != world)
	{
		if ((current_player.style & CLANRING_CONNECTED) && (current_player.next_team != world))
		{
			if (current_player.dmg_given_round > mvp)
			{
				mvp = (current_player.dmg_given_round);
				name = current_player.netname;
			}
		}
		current_player = find(current_player, classname, "player");
	}
	smvp = ftos(mvp);
	announce4(name," was the round MVP with ",smvp," points of damage given.");
	bprint("\n");
};

void() round_end =
{
	local 	entity	current_player, wteam = world, lteam;
	local	string	temp;

	boss.busy = TRUE;//hold the presses!

	//Look for players alive...

	current_player = find(world, classname, "player");

	while (current_player != world)
	{
		if ((current_player.ca_player_flag == PF_PLAYING) || (current_player.ca_player_flag == PF_READY))
		{
			if ((current_player.health) && (current_player.style & CLANRING_CONNECTED) && (current_player.next_team != world))
			{
				wteam = current_player.next_team;
				wteam.armorvalue = (wteam.armorvalue + current_player.armorvalue);
				wteam.health = (wteam.health + current_player.health);

				bprint3 ("\b[", current_player.netname, " has ");
				temp = ftos (current_player.health);
				bprint2 (temp, " Health ");
				temp = ftos (current_player.armorvalue);
				bprint2 (temp, " Armor\b]\n");
			}
		}
		current_player = find(current_player, classname, "player");
	}

	if (wteam != world)//ugh lagouts cause all hell
	{
		wteam.wins = wteam.wins + 1;//up team rounds won
		//pqc_team_frags(world, (wteam.team2), wteam.wins);
	}

	//BAM: Other teams' losses increases by 1.
	lteam = boss.next_team;
	while (lteam != world)
	{
		if (lteam != wteam)
		lteam.losses = lteam.losses + 1;

		lteam = lteam.next_team;
	}

	bprint ("\n");
	announce2((wteam.netname)," has won the round.");

	report_mvp_round();

    if (wteam.wins >= (ceil(boss.max_rounds / 2)))// wins > 50% of rounds wins the match
    {
        team_first_place = wteam;
        gameover = TRUE;
        arena_match_end();
        return;
    }

    if (boss.round >= boss.max_rounds)
    {
        find_team_place();
        if (team_first_place.wins > team_second_place.wins)//Keep playing until there is a winner!
        {
            gameover = TRUE;
            arena_match_end();
            return;
        }
    }

	if (wteam != world)//ugh lagouts cause all hell
	{
		wteam.armorvalue 	= (wteam.armorvalue / number_teammates_alive (wteam));
		wteam.health 	= (wteam.health / number_teammates_alive (wteam));
		announce_winner(wteam.armorvalue,wteam.health);

		wteam.armorvalue 	= 0;//this is not required; it's a local entity.
		wteam.health 	= 0;//this is not required; it's a local entity.
	}
	utils_make_scheduled_event(reset_round, 0.5);
};

void() airshot_round_end =
{
	utils_make_scheduled_event(arena_match_end, 1);
};

void () Practice_Object_Remove;

void () arena_main_loop =
{
	if ((clanring_state & CLANRING_MATCH_PAUSED) && (!boss.unpausing))
	{
		WriteByte (MSG_ALL, SVC_CENTERPRINT);
		WriteString (MSG_ALL, "\n\X90PAUSED\X91\n");
		return;
	}

	if ((boss.busy) || (gameover))
		return;

	if (boss.state == CA_MATCH_PLAYING)
	{
		if (number_teams () > 1)
		{	
            if (number_teams_alive () < 2)
            {
                if (boss.wait == 0)
                {
                    boss.wait = (time + 4);//slight pause before end of round.
                    return;
                }

                if (time > boss.wait)
                {
                    boss.wait = time + 99;//do round end and wait
                    if (number_teams_alive () == 0)
                    {
                        boss.round = (boss.round - 1);// repeat round
                        announce ("round is a \bdraw\b!");
                        utils_make_scheduled_event(reset_round,0.5);//fixed v.0.94b
                        return;
                    }
                    round_end();
                }
            }
		}
		else
		{
			gameover = TRUE;
			boss.aborted = TRUE;
			boss.state = CA_MATCH_OVER;
			arena_match_end ();
		}
	}
	else if ((boss.state == CA_MATCH_ROUNDSTART))
	{
		local string temp;

		motd_top5 = string_null;
		motd_top6 = string_null;

		if (number_teams () > 1)
		{
			boss.count = (boss.count) - 1;

			if (clanring_request.classname == "vote_force")
				vote_reject();

			if (boss.count > 5)
			{
				if (boss.count == 9)
				{
					match_ready_players ();
				}
				else if (boss.count == 8)
				{
					respawn_teams ();
					bprint ("\bround: [");
					if (boss.round <= boss.max_rounds)
					{
						temp = ftos (boss.round);
						bprint(temp);
						temp = ftos (boss.max_rounds);
						bprint3 (" \bof \b",temp,"\b]\n");
					}
					else
						bprint ("Overtime\b]\n");
					
					local string stmp;
					stmp = (report_winning_team());
					bprint2 (stmp, "\n");
				}
			}
			else
			{
				if (boss.count == 0)
				{
					sound (world, CHAN_ITEM, "ra/fight.wav", 1, ATTN_NONE);
					ctprint ("\bFIGHT!");
					boss.timetofight = TRUE;
					boss.state = CA_MATCH_PLAYING;
					if (boss.round == 1)
					announce("The match has begun!");
				}
				else if (boss.count == 1)
				{
					ctprint ("1");
					sound (world, CHAN_ITEM, "ra/1.wav",1, ATTN_NONE);
				}
				else if (boss.count == 2)
				{
					ctprint ("2");
					sound (world, CHAN_ITEM, "ra/2.wav", 1, ATTN_NONE);
				}
				else if (boss.count == 3)
				{
					ctprint("3");
					sound(world, CHAN_ITEM, "ra/3.wav", 1, ATTN_NONE);
				}
				else if (boss.count == 5)
				{
					ctprint("prepare to fight");
				}
			}
		}
		else
		{
			gameover = TRUE;
			boss.aborted = TRUE;
			boss.state = CA_MATCH_OVER;
			arena_match_end();
		}
	}
	else if ((boss.state == CA_MATCH_WAITING))
	{
		if (boss.forced)
		{
			boss.forced 	= FALSE;
			boss.timetofight 	= FALSE;
			boss.count	= 10;
			boss.wait 	= 0;
			boss.state 	= CA_MATCH_ROUNDSTART;
			sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
			announce("Match begins in \b10\b seconds.");
			utils_do_players(reset_frags);
		}
		else if (number_teams () > 1 && boss.allready == TRUE)
		{
			if (boss.wait == 0)
			{
				// No need to force match now.
				if (clanring_request.classname == "vote_force")
				vote_reject ();

				boss.wait = time + 5;
				sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
				announce("Match begins in \b15\b seconds.");//boss.wait (5) + countdowntimer (10) = 15 seconds...
			}

			if (time >= boss.wait)
			{
				boss.timetofight	= FALSE;
				boss.count 	= 10;
				boss.wait 	= 0;
				sound (world, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
				announce("Match begins in \b10\b seconds.");
				utils_do_players(reset_frags);
				Practice_Object_Remove();
				utils_do_items(SUB_Remove);
				boss.state = CA_MATCH_ROUNDSTART;
				//pqc_match_reset();
				//find_pqc_teamscore_teams();
			}
		}
		else if (number_teams () < 2 || boss.allready == FALSE)
		{
			if (boss.wait)
			{
				announce ("\bResetting \brally\b timer.");
				sound (world, CHAN_VOICE, "doors/drclos4.wav", 1, ATTN_NONE);

				if (number_teams () >= 2)
				bprint("Use \bforce\b to start the match.\n");
			}
			boss.wait = 0;
		}
		boss.allready = TRUE;
	}
	else
	{
		if (boss.state == CA_MATCH_CLEANUP)
		{
			if (boss.wait == 0)
			{
				boss.wait = time + 3;
			}
			if (time > boss.wait)
			{
				boss.wait = 0;
				boss.state = CA_MATCH_WAITING;
			}
		}
	}
};