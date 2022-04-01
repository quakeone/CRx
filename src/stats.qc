//
// Stats.qc
//
// Various routines for displaying statistics.
//
// All code by J.P. Grossman unless otherwise commented.
//

//
//  P R O T O T Y P E S
//
void(float frac, float tot) stats_print_percent3;

//
//  R E S E T  P L A Y E R
//
void() stats_reset_player =
{
	self.mangle = self.dest = self.dest2 = self.dest1 = self.clanring_badstats = self.clanring_qdkill = self.clanring_qdwep = '0 0 0';
	self.dmg_taken	= 0;
	self.dmg_given	= 0;
	self.dmg_given_round = 0;
	self.dmg_cache = 0;
	self.dmg_tally = 0;
	self.clanring_did_damage = 0; // CRMOD moved here from put_client_in_server
	self.fpickups = 0;
	self.fcaptures = 0;
	self.fdefenses = 0;
	self.freturns = 0;
	self.fcassists = 0;
	self.fcfrags = 0;
	self.captime = 1200;//default time = matchtime;
	self.true_kills = 0;
	self.killed = FALSE;
};

//
//  R E S E T  T E A M
//
void (entity pteam) stats_reset_team = 
{
	pteam.dest = pteam.dest1 = pteam.dest2 = pteam.pos1 = pteam.mangle = '0 0 0';
};

//
//  S H O W  B A D S T A T S
//
void() stats_show_badstats =
{
	local entity player;
	local float tot_enemy, tot_done;

	if (!(clanring_playmode & CLANRING_MATCH_MODE) || !teamplay)
	{
		sprint(self, "badstats valid in match mode only\n");
		return;
	}
	sprint(self, "\n");
	sprint(self, "\bbad stuff\n");
	sprint(self, "\n");
	sprint(self, "paks - number of RL paks given away\n");
	sprint(self, "self - percent damage done to self\n");
	sprint(self, "team - percent damage done to team\n");
	sprint(self, "\n");
	sprint(self, " paks ü self ü team ü      name\n");
	sprint(self, "­­­­­­«­­­­­­«­­­­­­«­­­­­­­­­­­­­­­­\n");
	player = clanring_sentinel.next_player;
	while (player)
	{
		tot_enemy = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		tot_done = tot_enemy + player.clanring_badstats_y + player.clanring_badstats_z;
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.clanring_badstats_x);
			sprint(self, "‘ü \x90");
			stats_print_percent3(player.clanring_badstats_y, tot_done);
			sprint(self, "‘ü \x90");
			stats_print_percent3(player.clanring_badstats_z, tot_done);
			sprint(self, "‘ü ");
		}
		else
		{
			sprint(self, "  ");
			utils_print_int3(player.clanring_badstats_x);
			sprint(self, " ü  ");
			stats_print_percent3(player.clanring_badstats_y, tot_done);
			sprint(self, " ü  ");
			stats_print_percent3(player.clanring_badstats_z, tot_done);
			sprint(self, " ü ");
		}
		sprint2(self, player.netname, "\n");
		player = player.next_player;
	}
	sprint(self, "\n");
};

//
//  S H O W  Q U A D S T A T S
//

void() stats_show_quadstats =
{
    local entity player, pteam;
	local float useteams;
	//local string teamname;

	if (teamplay && ((clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER)) || clanring_sentinel.owner != clanring_sentinel))
		useteams = TRUE;
	else
		useteams = FALSE;

	sprint(self, "\n");
	sprint(self, "\bquad damage\b\n");
	sprint(self, "\n");
	sprint(self, "quadsüeffüoppüslfütm ü     name\n");
	sprint(self, "­­­­­«­­­«­­­«­­­«­­­«­­­­­­­­­­­­­­­\n");
	player = clanring_sentinel.next_player;
	pteam = player.next_team;
	while (player)
	{
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.clanring_qdwep_z);
			sprint(self, "‘ü");
		}
		else
		{
			sprint(self, " ");
			utils_print_int3(player.clanring_qdwep_z);
			sprint(self, " ü");
		}
		stats_print_percent3(player.clanring_qdwep_x, player.clanring_qdwep_y);
		sprint(self, "ü");
		utils_print_int3(player.clanring_qdkill_x);
		sprint(self, "ü");
		utils_print_int3(player.clanring_qdkill_z);
		sprint(self, "ü");
		utils_print_int3(player.clanring_qdkill_y);
		sprint3(self, "ü", player.netname, "\n");
		player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint(self, " ");
			utils_print_int3_gold(pteam.dest2_x);
			sprint3(self, " ü   ü   ü   ü   ü", pteam.mdl, "\n");
			pteam = player.next_team;
		}
	}
	sprint(self, "\n");
};

void() stats_show_killstats =
{
	local entity player;
	local float c;

	c = 16;//Workaround for lag-out players corrupting the link list...

	sprint(self, "\n");
	sprint(self, "\bkills\b\n");
	sprint(self, "\n");
	sprint(self, "fragsüoppüslfütm ükldü dtk ü dgv ü     name\n");
	sprint(self, "­­­­­«­­­«­­­«­­­«­­­«­­­­­«­­­­­«­­­­­­­­­­­­­­­\n");

	player = clanring_sentinel.next_player;

	while (player != world)
	{
		if (c < 1)
		break;
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.frags);
			sprint(self, "‘ü");
		}
		else
		{
			sprint(self, " ");
			utils_print_int3(player.frags);
			sprint(self, " ü");
		}
		utils_print_int3(player.true_kills);
		sprint(self, "ü");
		utils_print_int3(player.mangle_x);
		sprint(self, "ü");
		utils_print_int3(player.mangle_y);
		sprint(self, "ü");
		utils_print_int3(player.mangle_z);
		sprint(self, "ü");
		utils_print_damage_gold(player.dmg_taken);
		sprint(self, "ü");
		utils_print_damage_gold(player.dmg_given);
		sprint3(self, "ü", player.netname, "\n");
		player = player.next_player;
		c -= 1;
	}
	sprint(self, "\n");
};

//
//  P R I N T  P E R C E N T 3
//
//  Helper function for stats_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 3 character integer, or N/A if tot = 0.
//
void (float frac, float tot) stats_print_percent3 =
{
	if (frac > tot)	//R00k
	{
		sprint (self, "100");
	}
	else
	{
		if (tot)
		{
			local float n;
			local string temp = "";

			n = floor(100 * frac / tot);
			if (n < 10)
				sprint(self, " ");
			temp = ftos(n);
			sprint(self, temp);
			if (n < 100)
				sprint(self, "%");
		}
		else
			sprint(self, "N/A");
	}
};

//
//  S H O W  E F F I C I E N C Y
//
//  Show the weapon efficiency for each player.
//
void () stats_show_efficiency =
{
    local entity player;
    local float tot_fired, tot_done;

	sprint(self, "\n");
	sprint(self, "bulünlsüroxülg ütotalü     name\n");
	sprint(self, "­­­«­­­«­­­«­­­«­­­­­«­­­­­­­­­­­­­­­\n");
	player = find(world,classname, "player");
	while (player)
	{
		if (!(player.style & CLANRING_OBSERVER))
		{
			stats_print_percent3(player.dest2_x, player.dest1_x);
			sprint(self, "ü");
			stats_print_percent3(player.dest2_y, player.dest1_y);
			sprint(self, "ü");
			stats_print_percent3(player.dest_y, player.dest_x);
			sprint(self, "ü");
			stats_print_percent3(player.dest2_z, player.dest1_z);
			sprint(self, "ü");
			tot_fired = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
			tot_done = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
			if (player == self)
			{
				sprint(self, " ");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, " ü");
			}
			else
			{
				sprint(self, " ");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, " ü");
			}
			sprint2(self, player.netname, "\n");
		}
		player = find(player,classname, "player");
	}
	sprint(self, "\n");
};

//
//  S H O W  F L A G   S T A T S 
//
//  Show various flag statistics for each player.
//
void() stats_show_fstats =
{
	local entity player;
	local entity pteam;
	local float useteams;

	if (clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

	sprint(self, "\n");
	sprint(self, "\bctf related\b\n");
	sprint(self, "\n");
	sprint(self, "flag ücapüdefürtnüfcdüfcaüfckü  time  ü     name\n");
	sprint(self, "­­­­­«­­­«­­­«­­­«­­­«­­­«­­­«­­­­­­­­«­­­­­­­­­­­­­­­\n");

	player = clanring_sentinel.next_player;
	pteam = player.next_team;
	while (player)
	{
		if (!(player.style & CLANRING_OBSERVER))
		{
			if (player == self)
			{
				sprint(self, "\x90");
				utils_print_int3(player.fpickups);//pickups
				sprint(self, "‘ü");
			}
			else
			{
				sprint(self, " ");
				utils_print_int3(player.fpickups);
				sprint(self, " ü");
			}

			utils_print_int3(player.fcaptures);
			sprint(self, "ü");
			utils_print_int3(player.fdefenses);
			sprint(self, "ü");
			utils_print_int3(player.freturns);
			sprint(self, "ü");
			utils_print_int3(player.fcdefenses);
			sprint(self, "ü");
			utils_print_int3(player.fcassists);
			sprint(self, "ü");
			utils_print_int3(player.fcfrags);
			sprint(self, "ü");
			utils_sprint_stat_time(self,(player.captime));
			if (player == self)
			{
				sprint(self, "ü\x90");
				sprint(self, player.netname);
				sprint(self, "‘\n");
			}
			else
			{
				sprint(self, "ü ");
				sprint(self, player.netname);
				sprint(self, "\n");
			}
		}
		player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint(self, "    ");
			sprint3(self, " ü   ü   ü   ü   ü", pteam.mdl, "\n");
			pteam = player.next_team;
		}
	}
	sprint(self,"\n");
};

void () stats_team_stats =
{
	local entity e;
	local string t2;
	
	bprint ("\n");
	e = boss.next_team;
	
	while (e != world)
	{
		t2 = strpad (8, e.netname);
		bprint(t2);		
		t2 = "";//testing (second team goes way off the screen)
		bprint(" \bwon:\b ");				
		t2 = ftos (e.wins);
		bprint (t2);
		t2 = "";//testing (second team goes way off the screen)
		bprint(" \blost:\b ");
		t2 = ftos (e.losses);
		bprint (t2);		
		t2 = "";//testing (second team goes way off the screen)
		bprint("\n");
		e = e.next_team;
	}			
	bprint ("\n");
	remove(self);//kill temp ent that called this function.
};

//  S H O W  S U M M A R Y
//
//  Show kill and weapon efficiency for each player.
//
void () stats_show_summary =
{
    local entity player;
    local float wfrac, wtot, kfrac, ktot, useteams;
	local string teamname;

	if ((clanring_state & CLANRING_MATCH_STARTED) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

	sprint(self, "\n");
	sprint(self, "\befficiency\b\n");
	sprint(self, "\n");
	if (useteams)
	{
		sprint(self, "   team  ükill üweapnü     name\n");
		sprint(self, "­­­­­­­­­«­­­­­«­­­­­«­­­­­­­­­­­­­­­\n");
	}
	else
	{
		sprint(self, "kill üweapnü     name\n");
		sprint(self, "­­­­­«­­­­­«­­­­­­­­­­­­­­­\n");
	}

	player = clanring_sentinel.next_player;

	while (player != world)
	{
		if (useteams)
		{
			teamname = strings_get_teamname3(player.height);
			sprint2(self, teamname, " ü");
		}
		kfrac = player.true_kills;
		ktot = kfrac + player.mangle_z;
		wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
		wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		if (player == self)
		{
			sprint(self, "\x90");
			stats_print_percent3(kfrac, ktot);
			sprint(self, "‘ü\x90");
			stats_print_percent3(wfrac, wtot);
			sprint(self, "‘ü");
		}
		else
		{
			sprint(self, " ");
			stats_print_percent3(kfrac, ktot);
			sprint(self, " ü ");
			stats_print_percent3(wfrac, wtot);
			sprint(self, " ü");
		}
		sprint2(self, player.netname, "\n");
		player = player.next_player;
	}
	sprint(self, "\n");
};


void () stats_final_summary =
{
	local entity	player, pteam;
	local float 	wfrac, wtot, kfrac, ktot, tot_tot, tot_frac;
	local string 	t2 = "", teamname = "";
	local float 	n;

	bprint ("\b-----------------------------------------------------------\n");
	bprint ("  team   \b|\bopp\b|\bdth\b|\bkill%\b|\bweap%\b|\bdmgTk\b|\bdmgGv\b|\b      player     \n");
	bprint ("\b---------+---+---+-----+-----+-----+-----+-----------------\n");

	n = 0;
	player = find (world,classname, "player");
	
	while (player != world)
	{
		n = n + 1;
		if ((player.style & CLANRING_CONNECTED) && (player.next_team != world))
		{
			//TODO:Fix stats
			teamname = player.next_team.netname;//stats_get_teamname (player.next_team.team2);
			bprint2 ( teamname, " \b|\b");			
			bprint(sprintf("%s", ftos(player.true_kills)));
			bprint ( "\b|\b");
			bprint(sprintf("%s", ftos(player.mangle_z)));//killed
			bprint ( "\b|\b");
			
			//Kill % stats
			kfrac = player.true_kills;
			ktot = kfrac + player.mangle_z;
			
			//Weapon % stats
			wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
			wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
	
			bprint ( " ");
//FIXME			
//			stats_bprint_percent3(kfrac, ktot);
			bprint ( " \b|\b ");
//			stats_bprint_percent3(wfrac, wtot);
			bprint ( " \b|\b");
//			utils_bprint_damage_gold(player.dmg_taken);
			bprint ( "\b|\b");
//			utils_bprint_damage_gold(player.dmg_given);
			bprint ("\b|\b");							
			bprint3 (" ",player.netname, "\n");
		}
		if (n > 16)
			break;
		player = find (player, classname, "player");
	}
	
	stats_show_efficiency();

	bprint ("\n");
	pteam = boss.next_team;
	
	for (pteam = boss.next_team; pteam != world; pteam = pteam.next_team)
	{
		t2 = strpad (8, pteam.netname);
		bprint(t2);		
		bprint(" \bwon:\b ");				
		t2 = ftos (pteam.wins);
		bprint (t2);
		bprint(" \blost:\b ");
		t2 = ftos (pteam.losses);
		bprint (t2);		
		bprint("\n");
		t2 = "";
	}	
	
	bprint ("\n");	
	announce2((team_first_place.netname)," has won the match.");	
	bprint ("\n");

};

//
//  F O R M A T  V E C T O R
//
//  prints xx:yy:zz to self
//
void (vector v) stats_format_vector = 
{
	local string s;

	sprint(self, "ü");
	if (v_x < 10)
		sprint(self, " ");
	s = ftos(v_x);
	sprint(self, s, "Ž");
	if (v_y < 10)
		sprint(self, " ");
	s = ftos(v_y);
	sprint(self, s, "Ž");
	if (v_z < 10)
		sprint(self, " ");
	s = ftos(v_z);
	sprint(self, s);
};

//
//  S H O W  T E A M  S T A T S
//
void() stats_show_teamstats =
{
	local entity pteam;
	local string s;

	if (!(teamplay && (clanring_playmode & CLANRING_MATCH_MODE)))
	{
		sprint(self, "Teamstats valid in match mode only\n");
		return;
	}
	if (!clanring_sentinel.next_team)
	{
		sprint(self, "No teams\n");
		return;
	}
	if ((clanring_state & CLANRING_MATCH_STARTED) && !(self.style & CLANRING_OBSERVER))
	{
		sprint(self, "Teamstats available to observers only\n");
		return;
	}
	sprint(self, "\n");
	sprint(self, "\bteam related\b\n");
	sprint(self, "\n");
	sprint(self, "          ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		s = strings_get_teamname3(pteam.height);
		sprint2(self, "ü", s);
		pteam = pteam.next_team;
	}
	sprint(self, "\n­­­­­­­­­­");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		sprint(self, "«­­­­­­­­");
		pteam = pteam.next_team;
	}
	sprint(self, "\nQŽ˜˜˜Žring");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest2);
		pteam = pteam.next_team;
	}
	sprint(self, "\nRLŽLGŽGL  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nSNGŽNGŽMH ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.pos1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nRAŽYAŽGA  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest);
		pteam = pteam.next_team;
	}
	sprint(self, "\nrlpak +/- ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		sprint(self, "ü");
		s = ftos(pteam.mangle_y);
		if (pteam.mangle_y < 10)
			sprint(self, " ");
		sprint3(self, "«", s, " ");
		s = ftos(pteam.mangle_z);
		if (pteam.mangle_z < 10)
			sprint(self, " ");
		sprint3(self, "­", s, " ");
		pteam = pteam.next_team;
	}

	sprint(self, "\ncontrol   ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		local float f, control;
		control = 100 * pteam.mangle_x / clanring_sentinel.cnt;
		f = floor(control);
		s = ftos(f);
		sprint2(self, "ü  %", s);
		f = floor((control - f) * 10);
		s = ftos(f);
		sprint3(self, ".", s, " ");
		if (control < 10)
			sprint(self, " ");
		pteam = pteam.next_team;
	}
	sprint(self, "\n");
	sprint(self, "\n");
};

//
//  A U T O D U M P
//
//  Dump statistics if player has autostats enabled.
//
void() stats_autodump =
{
		sprint(self, "\n");
		sprint(self, "\n");
		sprint(self, "\bmatch statisticsŸ\n");
		sprint(self, "\n");
		stats_show_summary ();
		//sprint(self, "\n");

		stats_show_efficiency();
		//sprint(self, "\n");

		stats_show_killstats();
		//sprint(self, "\n");

		if (!(clanring_playmode & CLANRING_NO_QUAD))//R00k -added-
		{
			stats_show_quadstats ();
			//sprint(self, "\n");
		}
/*
		if (!(clanring_playmode & CLANRING_NO_PENT))//R00k -TODO-
		{
			stats_show_pentstats ();
			//sprint(self, "\n");
		}
*/
		if ((clanring_playmode & CLANRING_MATCH_MODE) && (teamplay == 2))
		{
			stats_show_badstats();
			//sprint(self, "\n");
		}

		if (teamplay)
		{
			stats_show_teamstats();
			//sprint(self, "\n");
		}

		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		{
			stats_show_fstats();
			//sprint(self, "\n");
		}
		sprint(self, "\n");
};

//
//  H E L P
//
void () stats_help =
{
	sprint(self, "\n");
	sprint(self, "\bweapon efficiency\b\n");
	sprint(self, "\n");
	sprint(self, "bul - bullet efficiency\n");
	sprint(self, "nls - nail efficiency\n");
	sprint(self, "rox - rocket efficiency\n");
	sprint(self, "lg  - lightning gun efficiency\n");

	sprint(self, "\n");

	sprint(self, "\n");
	sprint(self, "\bkills\b\n");
	sprint(self, "\n");
	sprint(self, "opp - number of opponents killed\n");
	sprint(self, "slf - number of times killed self\n");
	sprint(self, "tm  - teammates killed\n");
	sprint(self, "kld - times killed by enemy\n");
	sprint(self, "dtk - damage taken\n");
	sprint(self, "dgv - damage given\n");
	

	sprint(self, "\n");

	sprint(self, "\n");
	sprint(self, "\bquad damage\b\n");
	sprint(self, "\n");
	sprint(self, "quads - quads picked up\n");
	sprint(self, "eff   - quad weapon efficiency\n");
	sprint(self, "opp   - opponents killed\n");
	sprint(self, "slf   - killed self\n");
	sprint(self, "tm    - teammates killed\n");

	sprint(self, "\n");

	sprint(self, "\n");
	sprint(self, "\bbad stuff\n");
	sprint(self, "\n");
	sprint(self, "paks - number of RL paks given away\n");
	sprint(self, "self - percent damage done to self\n");
	sprint(self, "team - percent damage done to team\n");
	
	sprint(self, "\n");

	sprint(self, "\n");
	sprint(self, "\bctf related\b\n");
	sprint(self, "\n");
	sprint(self, "flag - pickups\n");
	sprint(self, "cap  - captures\n");
	sprint(self, "def  - defenses\n");
	sprint(self, "rtn  - returns\n");
	sprint(self, "fcd  - carrier defenses\n");
	sprint(self, "fca  - carrier assists\n");
	sprint(self, "fck  - flag carriers killed\n");
	sprint(self, "time - best capture time\n");

	sprint(self, "\n");

};

//
//  I M P U L S E
//
void () stats_impulse =
{
	switch (self.impulse)
	{
		case 170: stats_show_killstats();	break;	
		case 171: stats_show_efficiency();	break;
		case 172: stats_autodump();			break;
		case 173: stats_show_quadstats();	break;
		case 174: stats_show_badstats();	break;
		case 175: stats_show_teamstats();	break;
		case 176: stats_show_fstats();		break;
		case 178: utils_toggle_flag(CLANRING_AUTOSTATS, "Autostats"); break;
		case 179: stats_help(); 			break;
	}
};

//
//  C O P Y  S T A T I S T I C S
//
//  Copy all statistics at the end of a match so that they don't go away.
//
void() stats_copy_statistics = 
{
	return;//FIXME this is broken...
/*
	local entity s, p;

	if (clanring_sentinel == world)//testing
	{
		cprint("stats_copy_statistics: clanring_sentinel == world\n");
		return;
	}

	s = spawn();
	s.classname = "stats_copy";
	s.next_team = clanring_sentinel.next_team;
	clanring_sentinel.owner = s;
	p = clanring_sentinel.next_player;

	while (p)
	{
		s.next_player = p.owner;
		if (!teamplay)
			s.next_team = p.owner;
		s = p.owner;
		if (teamplay)
			s.next_team = p.next_team;
		p.owner = world;

		s.height = p.height;
		s.frags = p.frags;
		s.dest1 = p.dest1;
		s.dest2 = p.dest2;
		s.dest = p.dest;
		s.mangle = p.mangle;
		s.clanring_qdwep = p.clanring_qdwep;
		s.clanring_qdkill = p.clanring_qdkill;
		s.clanring_badstats = p.clanring_badstats;
		s.netname = p.netname;
		s.dmg_taken	= p.dmg_taken;
		s.dmg_given	= p.dmg_given;
		s.fpickups = p.fpickups;
		s.fcaptures = p.fcaptures;
		s.fdefenses = p.fdefenses;
		s.freturns = p.freturns;
		s.fcassists = p.fcassists;
		s.fcfrags = p.fcfrags;
		s.captime = p.captime;
		s.true_kills = p.true_kills;
		p = p.next_player;
	}
	s.next_player = world;
	if (teamplay)
	{
		p = clanring_sentinel.next_team;
		while(p)
		{
			p.next_player = p.next_player.owner;
			p.classname = "stats_copy";
			p = p.next_team;
		}
	}
	clanring_sentinel.next_player = world;
	clanring_sentinel.next_team = world;
	*/
};

//
//  D E L E T E  C O P I E S
//
void() stats_delete_copies = 
{	
//	utils_do_item(SUB_Remove, "stats_copy");
//	clanring_sentinel.owner = clanring_sentinel;
};