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
	self.mangle = self.dest = self.dest2 = self.dest1 = self.clanring_badstats = '0 0 0';
	self.clanring_qdkill = self.clanring_qdwep = self.clanring_ptkill = self.clanring_ptwep = '0 0 0';
	self.stats_gl_frac	= 0;
	self.stats_gl_tot	= 0;
	self.dmg_taken	= 0;
	self.dmg_given	= 0;
	self.dmg_given_round = 0;
	self.ewep = 0;
	self.dmg_cache = 0;
	self.dmg_tally = 0;
	self.clanring_did_damage = 0; // CRMOD moved here from put_client_in_server
	self.fpickups = 0;
	self.fcaptures = 0;
	self.fdefenses = 0;
	self.freturns = 0;
	self.fcassists = 0;
	self.fcfrags = 0;
	self.fctime = 0;
	self.captime = 1200;//default time = matchtime;
	self.true_kills = 0;
	self.direct_hit = 0;
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
	sprint(self, " paks ��self � team �      name\n");
	sprint(self, "�������������������������������������\n");
	player = clanring_sentinel.next_player;
	while (player)
	{
		tot_enemy = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		tot_done = tot_enemy + player.clanring_badstats_y + player.clanring_badstats_z;
		if (player == self)
		{
			sprint(self, " \x90");
			utils_print_int3(player.clanring_badstats_x);
			sprint(self, "�� \x90");
			stats_print_percent3(player.clanring_badstats_y, tot_done);
			sprint(self, "�� \x90");
			stats_print_percent3(player.clanring_badstats_z, tot_done);
			sprint(self, "�� ");
		}
		else
		{
			sprint(self, "  ");
			utils_print_int3(player.clanring_badstats_x);
			sprint(self, " �  ");
			stats_print_percent3(player.clanring_badstats_y, tot_done);
			sprint(self, " �  ");
			stats_print_percent3(player.clanring_badstats_z, tot_done);
			sprint(self, " � ");
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
	sprint(self,   "quads�time�eff�opp�slf�tm �     name\n");
	sprint(self, "\b-----+----+---+---+---+---+---------------����\n");
	player = clanring_sentinel.next_player;
	pteam = player.next_team;
	while (player)
	{
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.clanring_qdwep_z);
			sprint(self, "�� ");
		}
		else
		{
			sprint(self, " ");
			utils_print_int3(player.clanring_qdwep_z);
			sprint(self, " � ");
		}
		utils_print_int3(player.totalquad);
		sprint(self, "�");
		stats_print_percent3(player.clanring_qdwep_x, player.clanring_qdwep_y);
		sprint(self, "�");
		utils_print_int3(player.clanring_qdkill_x);
		sprint(self, "�");
		utils_print_int3(player.clanring_qdkill_z);
		sprint(self, "�");
		utils_print_int3(player.clanring_qdkill_y);
		sprint3(self, "�", player.netname, "\n");
		player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint(self, " ");
			utils_print_int3_gold(pteam.dest2_x);
			sprint3(self, " �    �   �   �   �   �", pteam.mdl, "\n");
			pteam = player.next_team;
		}
	}
	sprint(self, "\n");
};

//
//  S H O W  P E N T S T A T S
//

void() stats_show_pentstats =
{
    local entity player, pteam;
	local float useteams;

	if (teamplay && ((clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER)) || clanring_sentinel.owner != clanring_sentinel))
		useteams = TRUE;
	else
		useteams = FALSE;

	sprint(self, "\n");
	sprint(self, "\bpent protection\b\n");
	sprint(self, "\n");
	sprint(self, "pents�eff�opp�tm �     name\n");
	sprint(self, "���������������������������������\n");
	player = clanring_sentinel.next_player;
	pteam = player.next_team;
	while (player)
	{
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.clanring_ptwep_z);
			sprint(self, "��");
		}
		else
		{
			sprint(self, " ");
			utils_print_int3(player.clanring_ptwep_z);
			sprint(self, " �");
		}
		stats_print_percent3(player.clanring_ptwep_x, player.clanring_ptwep_y);
		sprint(self, "�");
		utils_print_int3(player.clanring_ptkill_x);
		sprint(self, "�");
		utils_print_int3(player.clanring_ptkill_y);
		sprint3(self, "�", player.netname, "\n");
		player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint(self, " ");
			utils_print_int3_gold(pteam.dest2_y);
			sprint3(self, " �   �   �   �", pteam.mdl, "\n");
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
	sprint(self, "frags�opp�slf�tm �kld� dtk � dgv � ewp �     name\n");
	sprint(self, "�������������������������������������������������\n");

	player = clanring_sentinel.next_player;

	while (player != world)
	{
		if (c < 1)
		break;
		if (player == self)
		{
			sprint(self, "\x90");
			utils_print_int3(player.frags);
			sprint(self, "��");
		}
		else
		{
			sprint(self, " ");
			utils_print_int3(player.frags);
			sprint(self, " �");
		}
		utils_print_int3(player.true_kills);
		sprint(self, "�");
		utils_print_int3(player.mangle_x);
		sprint(self, "�");
		utils_print_int3(player.mangle_y);
		sprint(self, "�");
		utils_print_int3(player.mangle_z);
		sprint(self, "�");
		utils_print_damage_gold(player.dmg_taken);
		sprint(self, "�");
		utils_print_damage_gold(player.dmg_given);
		sprint(self, "�");
		utils_print_damage_gold(player.ewep);
		sprint3(self, "�", player.netname, "\n");
		player = player.next_player;
		c -= 1;
	}
	sprint(self, "\n");
};

void (float f) stats_bprint_int3 =
{
	local float n;
	local string s = "";

	n = rint(f);
	if (n < -99)
		n = -99;
	s = ftos(n);
	s = strpad(-3, s);
	bprint(s);
};

//
//  B P R I N T  P E R C E N T 3
//
//  Helper function for stats_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 3 character integer, or N/A if tot = 0.
//
void (float frac, float tot) stats_bprint_percent3 =
{
	if (frac > tot)	//R00k
	{
		bprint ("100");
	}
	else
	{
		if (tot)
		{
			local float n;
			local string temp = "";

			n = floor(100 * frac / tot);
			if (n < 10)
				bprint(" ");
			temp = ftos(n);
			bprint(temp);
			if (n < 100)
				bprint("%");
		}
		else
			bprint("N/A");
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

	sprint(self, "\n");
	sprint(self, "bul�nls�rox�lg �total�     name\n");
	sprint(self, "�������������������������������������\n");
	player = find(world,classname, "player");
	while (player)
	{
		if (((mode_is_arena()) && (player.next_team != world)) ||
			(!(mode_is_arena()) && !(player.style & CLANRING_OBSERVER)))
		{
			stats_print_percent3(player.dest2_x, player.dest1_x);
			sprint(self, "�");
			stats_print_percent3(player.dest2_y, player.dest1_y);
			sprint(self, "�");
			stats_print_percent3(player.dest_y, player.dest_x);
			sprint(self, "�");
			stats_print_percent3(player.dest2_z, player.dest1_z);
			sprint(self, "�");
			tot_fired = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
			tot_done = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
			if (player == self)
			{
				sprint(self, " ");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, " �");
			}
			else
			{
				sprint(self, " ");
				stats_print_percent3(tot_done, tot_fired);
				sprint(self, " �");
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
	local string mtr = "";	//match-time record
	local string ttr = "";	//time-trial record	

	if (clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

	sprint(self, "\n");
	sprint(self, "\bctf related\b\n");
	sprint(self, "\n");
	sprint(self, "\bflag |  time  |cap|  best  |def|rtn|fcd|fca|fck|     name      \b\n");
	sprint(self, "\b-----+--------+---+--------+---+---+---+---+---+---------------\b\n");

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
				sprint(self, "\x91\b|");
			}
			else
			{
				sprint(self, " ");
				utils_print_int3(player.fpickups);
				sprint(self, " \b|");
			}
			utils_sprint_stat_time(self,(player.fctime));
			sprint(self, "\b|");
			utils_print_int3(player.fcaptures);
			sprint(self, "\b|");
			if (player.captime == 1200)
				utils_sprint_stat_time(self,(0));
			else
				utils_sprint_stat_time(self,(player.captime));
			sprint(self, "\b|");
			utils_print_int3(player.fdefenses);
			sprint(self, "\b|");
			utils_print_int3(player.freturns);
			sprint(self, "\b|");
			utils_print_int3(player.fcdefenses);
			sprint(self, "\b|");
			utils_print_int3(player.fcassists);
			sprint(self, "\b|");
			utils_print_int3(player.fcfrags);			
			if (player == self)
			{
				sprint(self, "\b|\b\x90");
				sprint(self, player.netname);
				sprint(self, "\x91\n");
			}
			else
			{
				sprint(self, "\b| ");
				sprint(self, player.netname);
				sprint(self, "\n");
			}

		}
		player = player.next_player;
		if (useteams && (player.next_team != pteam))
		{
			sprint3(self, "\b     |        |   |        |   |   |   |   |   |\b", pteam.mdl, "\n");
			pteam = player.next_team;
		}
	}
	sprint(self,"\n");
	mtr = sprintf("%s %s %-16s\n", utils_get_time(playerrecord2[0].statvalue), get_team_letter(playerrecord2[0].teamcolor), playerrecord2[0].player);
	sprint(self, mapname, " match capture-time record: ", mtr);
	ttr = sprintf("%s %s %-16s\n", utils_get_time(playerrecord[0].statvalue), get_team_letter(playerrecord[0].teamcolor), playerrecord[0].player);
	sprint(self, mapname, " trial capture-time record: ", ttr);
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
		sprint(self, "   team  �kill �weapn�     name\n");
		sprint(self, "�������������������������������������\n");
	}
	else
	{
		sprint(self, "kill �weapn�     name\n");
		sprint(self, "���������������������������\n");
	}

	if (mode_is_arena())
	{
		player = find(world,classname, "player");
	}
	else
	{
		player = clanring_sentinel.next_player;
	}

	while (player != world)
	{
		if (!(mode_is_arena()) || ((mode_is_arena()) && player.next_team != world))
		{
			if (useteams)
			{
				teamname = strings_get_teamname3(player.height);
				sprint2(self, teamname, " �");
			}
			kfrac = player.true_kills;
			ktot = kfrac + player.mangle_z;
			wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
			wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
			if (player == self)
			{
				sprint(self, "\x90");
				stats_print_percent3(kfrac, ktot);
				sprint(self, "��\x90");
				stats_print_percent3(wfrac, wtot);
				sprint(self, "��");
			}
			else
			{
				sprint(self, " ");
				stats_print_percent3(kfrac, ktot);
				sprint(self, " � ");
				stats_print_percent3(wfrac, wtot);
				sprint(self, " �");
			}
			sprint2(self, player.netname, "\n");
		}

		if (mode_is_arena())
		{
			player = find(player,classname, "player");
		}
		else
		{
			player = player.next_player;
		}
	}
	sprint(self, "\n");
};


void () stats_final_summary =
{
	local entity	player;
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
			teamname = strings_get_teamname3 (player.next_team.team2);
			bprint2 ( teamname, " \b|\b");			
			stats_bprint_int3 (player.true_kills);
			bprint ( "\b|\b");
			stats_bprint_int3 (player.mangle_z);//killed
			bprint ( "\b|\b");

			//Kill % stats
			kfrac = (player.frags);
			ktot = (kfrac + player.mangle_z);
			//Weapon % stats
			wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x + player.stats_gl_tot;
			wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y + player.stats_gl_frac;

			bprint ( " ");
			stats_bprint_percent3 (kfrac, ktot);
			bprint ( " \b|\b ");
			stats_bprint_percent3 (wfrac, wtot);
			bprint ( " \b|\b");
			utils_bprint_damage_gold(player.dmg_taken);
			bprint ( "\b|\b");
			utils_bprint_damage_gold(player.dmg_given);
			bprint ("\b|\b");							
			bprint3 (" ",player.netname, "\n");
		}
		if (n > 16)
			break;
		player = find (player, classname, "player");
	}
/*
	bprint ("\n\n");
	bprint ( "bul \b-\b bullet \b\n");
	bprint ( "nls \b-\b nail   \n");
	bprint ( "rox \b-\b rocket \n");
	bprint ( "gl  \b-\b grenade\n");
	bprint ( "lg  \b-\b lightning gun \n");
	bprint ( "dhit\b-\b rl/gl direct hits\n");
*/
	bprint ( "\b-----------------------------------------------------------\n");
	bprint ( "  team   \b|\bbul\b|\bnls\b|\brox\b|\bgl \b|\blg \b|\bdhit \b|\btotal\b|\b     EFFICIENCY\n");
	bprint ( "\b---------+---+---+---+---+---+-----+-----+-----------------\n");

	n = 0;
	player = find (world,classname, "player");

	while (player != world)
	{
		n += 1;
		if ((player.style & CLANRING_CONNECTED) && (player.next_team != world))
		{			
			teamname = strings_get_teamname3 (player.next_team.team2);
			bprint2 ( teamname, " \b|\b");			
			stats_bprint_percent3(player.dest2_x, player.dest1_x);
			bprint ( "\b|\b");
			stats_bprint_percent3(player.dest2_y, player.dest1_y);
			bprint ( "\b|\b");
			stats_bprint_percent3 (player.dest_y, player.dest_x); // rox
			bprint ( "\b|\b");
			stats_bprint_percent3(player.stats_gl_frac, player.stats_gl_tot); // grenades
			bprint ( "\b|\b");
			stats_bprint_percent3 (player.dest2_z, player.dest1_z); // lg
			bprint ( "\b|\b");
			utils_bprint_damage_gold(player.direct_hit);
			bprint ( "\b|\b");

			tot_tot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x + player.stats_gl_tot;
			tot_frac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y + player.stats_gl_frac;

			bprint (" ");
			stats_bprint_percent3(tot_frac, tot_tot);
			bprint (" ");				
			bprint ("\b|\b");							
			bprint3 (" ",player.netname, "\n");
		}
		if (n >16)
			break;
		player = find (player, classname, "player");
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

	sprint(self, "�");
	if (v_x < 10)
		sprint(self, " ");
	s = ftos(v_x);
	sprint(self, s, "�");
	if (v_y < 10)
		sprint(self, " ");
	s = ftos(v_y);
	sprint(self, s, "�");
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
		sprint2(self, "�", s);
		pteam = pteam.next_team;
	}
	sprint(self, "\n����������");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		sprint(self, "���������");
		pteam = pteam.next_team;
	}
	sprint(self, "\nQ�����ring");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest2);
		pteam = pteam.next_team;
	}
	sprint(self, "\nRL�LG�GL  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nSNG�NG�MH ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.pos1);
		pteam = pteam.next_team;
	}
	sprint(self, "\nRA�YA�GA  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		stats_format_vector(pteam.dest);
		pteam = pteam.next_team;
	}
	sprint(self, "\nrlpak�+/- ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		sprint(self, "�");
		s = ftos(pteam.mangle_y);
		if (pteam.mangle_y < 10)
			sprint(self, " ");
		sprint3(self, "�", s, " ");
		s = ftos(pteam.mangle_z);
		if (pteam.mangle_z < 10)
			sprint(self, " ");
		sprint3(self, "�", s, " ");
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
		sprint2(self, "�  %", s);
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
		sprint(self, "�\bmatch statistics�\n");
		sprint(self, "\n");		
		sprint(self, sprintf("map: %s\n",mapname));
		string date = strftime(TRUE, "%m-%d-%Y %H:%M");
		local string hname = infokey(world,"hostname");
		sprint(self, sprintf("%s\n%s\n",date,hname));

		stats_show_summary ();
		//sprint(self, "\n");

		stats_show_efficiency();
		//sprint(self, "\n");

		stats_show_killstats();
		//sprint(self, "\n");

		if (!(clanring_playmode & CLANRING_NO_QUAD) && !(mode_is_arena()))//R00k -added-
		{
			stats_show_quadstats ();
			//sprint(self, "\n");
		}

		if (!(clanring_playmode & CLANRING_NO_PENT) && !(mode_is_arena()))
		{
			stats_show_pentstats ();
			//sprint(self, "\n");
		}

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
			if (clanring_new_record_player != "")
			{
				sprint(self,sprintf("%s set a new match capture record!\n", clanring_new_record_player));
			}
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
		case 169: stats_show_pentstats();	break;
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

//Check if a cap time is in the top records, then set it and return the rank or return 0 if not
//TODO:refactor all these into one, just check high/low and pass struct array? 
void (float t_statvalue, float t_teamcolor, string t_player) check_player_low_record =
{
	local float i=0,j=0, tmp = 0;
	while ((i < PLAYER_RECORDS_MAX_COUNT) && (tmp == 0))
	{
		if (playerrecord[i].statvalue == 0)
		{
			playerrecord[i].statvalue = t_statvalue;
			playerrecord[i].teamcolor = t_teamcolor;
			playerrecord[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		else if ((playerrecord[i].statvalue > 0) && (t_statvalue < playerrecord[i].statvalue))
		{
			j = (PLAYER_RECORDS_MAX_COUNT - 1);
			while (j > i)
			{
				playerrecord[j].statvalue = playerrecord[(j-1)].statvalue;
				playerrecord[j].teamcolor = playerrecord[(j-1)].teamcolor;
				playerrecord[j].player = playerrecord[(j-1)].player;
				j -= 1;
			}
			playerrecord[i].statvalue = t_statvalue;
			playerrecord[i].teamcolor = t_teamcolor;
			playerrecord[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		i += 1;
	}
	if (tmp > 0)
	{
		//strunzone(tt_netname);
	}
	new_player_record = tmp;
	//return tmp;
};
void (float t_statvalue, float t_teamcolor, string t_player) check_player_low_record2 =
{
	local float i=0,j=0, tmp = 0;
	while ((i < PLAYER_RECORDS_MAX_COUNT) && (tmp == 0))
	{
		if (playerrecord2[i].statvalue == 0)
		{
			playerrecord2[i].statvalue = t_statvalue;
			playerrecord2[i].teamcolor = t_teamcolor;
			playerrecord2[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		else if ((playerrecord2[i].statvalue > 0) && (t_statvalue < playerrecord2[i].statvalue))
		{
			j = (PLAYER_RECORDS_MAX_COUNT - 1);
			while (j > i)
			{
				playerrecord2[j].statvalue = playerrecord2[(j-1)].statvalue;
				playerrecord2[j].teamcolor = playerrecord2[(j-1)].teamcolor;
				playerrecord2[j].player = playerrecord2[(j-1)].player;
				j -= 1;
			}
			playerrecord2[i].statvalue = t_statvalue;
			playerrecord2[i].teamcolor = t_teamcolor;
			playerrecord2[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		i += 1;
	}
	if (tmp > 0)
	{
		//strunzone(tt_netname);
	}
	new_player_record = tmp;
	//return tmp;
};
void (float t_statvalue, float t_teamcolor, string t_player) check_player_high_record =
{
	local float i=0,j=0, tmp = 0;
	while ((i < PLAYER_RECORDS_MAX_COUNT) && (tmp == 0))
	{
		if (playerrecord[i].statvalue == 0)
		{
			playerrecord[i].statvalue = t_statvalue;
			playerrecord[i].teamcolor = t_teamcolor;
			playerrecord[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		else if ((playerrecord[i].statvalue > 0) && (t_statvalue > playerrecord[i].statvalue))
		{
			j = (PLAYER_RECORDS_MAX_COUNT - 1);
			while (j > i)
			{
				playerrecord[j].statvalue = playerrecord[(j-1)].statvalue;
				playerrecord[j].teamcolor = playerrecord[(j-1)].teamcolor;
				playerrecord[j].player = playerrecord[(j-1)].player;
				j -= 1;
			}
			playerrecord[i].statvalue = t_statvalue;
			playerrecord[i].teamcolor = t_teamcolor;
			playerrecord[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		i += 1;
	}
	if (tmp > 0)
	{
		//strunzone(tt_netname);
	}
	new_player_record = tmp;
	//return tmp;
};
void (float t_statvalue, float t_teamcolor, string t_player) check_player_high_record2 =
{
	local float i=0,j=0, tmp = 0;
	while ((i < PLAYER_RECORDS_MAX_COUNT) && (tmp == 0))
	{
		if (playerrecord2[i].statvalue == 0)
		{
			playerrecord2[i].statvalue = t_statvalue;
			playerrecord2[i].teamcolor = t_teamcolor;
			playerrecord2[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		else if ((playerrecord2[i].statvalue > 0) && (t_statvalue > playerrecord2[i].statvalue))
		{
			j = (PLAYER_RECORDS_MAX_COUNT - 1);
			while (j > i)
			{
				playerrecord2[j].statvalue = playerrecord2[(j-1)].statvalue;
				playerrecord2[j].teamcolor = playerrecord2[(j-1)].teamcolor;
				playerrecord2[j].player = playerrecord2[(j-1)].player;
				j -= 1;
			}
			playerrecord2[i].statvalue = t_statvalue;
			playerrecord2[i].teamcolor = t_teamcolor;
			playerrecord2[i].player = strzone(t_player);
			tmp = (i+1);
			break;
		}
		i += 1;
	}
	if (tmp > 0)
	{
		//strunzone(tt_netname);
	}
	new_player_record = tmp;
	//return tmp;
};