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

	sprint(self, "-Quad Stats-\n");
	sprint(self, "quads - quads picked up\n");
	sprint(self, "eff   - quad weapon efficiency\n");
	sprint(self, "opp   - number of opponents killed\n");
	sprint(self, "slf   - number of times killed self\n");
	sprint(self, "tm    - number of teammates killed\n");
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
};

void() stats_show_killstats =
{
	local entity player;
	local float c;

	c = 16;//Workaround for lag-out players corrupting the link list...

	sprint(self, "-Kill Stats-\n");
	sprint(self, "opp - number of opponents killed\n");
	sprint(self, "slf - number of times killed self\n");
	sprint(self, "tm  - number of teammates killed\n");
	sprint(self, "kld - number of times killed by enemy\n");
	sprint(self, "dtk - amount of damage taken\n");
	sprint(self, "dgv - amount of damage given\n");
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

	sprint(self, "-Efficiency Stats-\n");
	sprint(self, "bul - bullet efficiency\n");
	sprint(self, "nls - nail efficiency\n");
	sprint(self, "rox - rocket efficiency\n");
	sprint(self, "lg  - lightning gun efficiency\n");
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
				sprint(self, "\x90");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, "\x91");
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

	sprint(self, "-Flag Stats-\n");
	sprint(self, "flag \b-\b pickups\n");
	sprint(self, "cap  \b-\b captures\n");
	sprint(self, "def  \b-\b defenses\n");
	sprint(self, "rtn  \b-\b returns\n");
	sprint(self, "fcd  \b-\b carrier defenses\n");
	sprint(self, "fca  \b-\b carrier assists\n");
	sprint(self, "fck  \b-\b flag carriers killed\n");
	sprint(self, "time \b-\b best capture time\n");
	sprint(self, "­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­\n");
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

	sprint(self, "-Stats Summary-\n");
	sprint(self, "kill  - kill efficiency\n");
	sprint(self, "weapn - weapon efficiency\n");
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
	sprint(self, "\nQŽ˜˜˜ŽÒÉÎÇ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest2);
		pteam = pteam.next_team;
	}
	sprint(self, "\nÒÌŽÌÇŽÇÌ  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nÓÎÇŽÎÇŽÍÈ ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.pos1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nÒÁŽÙÁŽÇÁ  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest);
		pteam = pteam.next_team;
	}
	sprint(self, "\nòìðáë «¯­ ");
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

	sprint(self, "\n\bcontrol   ");
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
};

//
//  A U T O D U M P
//
//  Dump statistics if player has autostats enabled.
//
void() stats_autodump =
{
	if (self.style & CLANRING_AUTOSTATS)
	{
		sprint(self, "\n");
		sprint(self, "\bclanring match statisticsŸ\n");
		sprint(self, "\n");
		stats_show_summary ();
		sprint(self, "\n");

		if (!(clanring_playmode & CLANRING_NO_QUAD))//R00k -added-
		{
			stats_show_quadstats ();
			sprint(self, "\n");
		}
/*
		if (!(clanring_playmode & CLANRING_NO_PENT))//R00k -TODO-
		{
			stats_show_pentstats ();
			sprint(self, "\n");
		}
*/
		if ((clanring_playmode & CLANRING_MATCH_MODE) && (teamplay == 2))
		{
			stats_show_badstats();
			sprint(self, "\n");
		}

		stats_show_efficiency();
		sprint(self, "\n");

		stats_show_killstats();
		sprint(self, "\n");

		if (teamplay)
		{
			stats_show_teamstats();
			sprint(self, "\n");
		}

		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		{
			stats_show_fstats();
			sprint(self, "\n");
		}
	}
};

//
//  H E L P
//
void () stats_help =
{
	sprint(self, "Statistics commands:\n");
	sprint(self, " stats      - summarize statistics\n");
	sprint(self, " killstats  - list player kill stats\n");
	sprint(self, " efficiency - list player efficiency\n");
	sprint(self, " quadstats  - list player quad stats\n");
	sprint(self, " badstats   - team game blunders\n");
	sprint(self, " teamstats  - various team statistics\n");
	sprint(self, " autostats  - automatically dump stats\n");
	sprint(self, "              at the end of matches\n");
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
		case 172: stats_show_summary();		break;
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