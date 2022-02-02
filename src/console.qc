//
// Console.qc
//
// This file contains code to implement server console directives.
//
// All code by J.P. Grossman unless otherwise commented.
//

string (void() function) fnstrings_function;
// constants
float CONSOLE_ENT_YAW   = 1;
float CONSOLE_ENT_PITCH = 2;
float CONSOLE_ENT_ROLL  = 4;

// global variables
vector console_origin;

//
//  S E T  A L I A S E S
//
//  Called once when the server is initialized.
//
void() StartRuneSpawn;
void() DropRune;
void() info_player_team1;
void() info_player_team2;
void() console_set_aliases =
{
    // set local aliases (server console commands)

	// immediate mode commands
	localcmd("alias sping temp1 1\n");
	localcmd("alias time temp1 2\n");
	localcmd("alias s temp1 3\n");
	localcmd("alias debug temp1 4\n");
	localcmd("alias score temp1 5\n");
	localcmd("alias ghostlist temp1 6\n");
	localcmd("alias killstats temp1 7\n");
	localcmd("alias efficiency temp1 8\n");
	localcmd("alias eff temp1 8\n");
	localcmd("alias stats temp1 9\n");
	localcmd("alias commands temp1 10\n");
	localcmd("alias vinfo temp1 11\n");
	localcmd("alias normal temp1 12\n");
	localcmd("alias practice temp1 13\n");
	localcmd("alias match temp1 14\n");
//	localcmd("alias crmod temp1 15\n");
	localcmd("alias quadstats temp1 16\n");
	localcmd("alias badstats temp1 18\n");
	localcmd("alias teamstats temp1 19\n");
	localcmd("alias admins temp1 90\n");
	localcmd("alias settings temp1 17\n");

	// config file commands 
	localcmd("alias safepracticeon \"temp1 20\"\n");
	localcmd("alias safepracticeoff \"temp1 21\"\n");
	localcmd("alias nogibs \"temp1 22\"\n");
	localcmd("alias lowgibs \"temp1 23\"\n");
	localcmd("alias highgibs \"temp1 24\"\n");
	localcmd("alias quadon \"temp1 25\"\n");
	localcmd("alias quadoff \"temp1 26\"\n");
	localcmd("alias penton \"temp1 27\"\n");
	localcmd("alias pentoff \"temp1 28\"\n");
	localcmd("alias ringon \"temp1 29\"\n");
	localcmd("alias ringoff \"temp1 30\"\n");
	localcmd("alias modevoteon \"temp1 31\"\n");
	localcmd("alias modevoteoff \"temp1 32\"\n");
	localcmd("alias obitson \"temp1 33\"\n");
	localcmd("alias obitsoff \"temp1 34\"\n");
	localcmd("alias setovertime \"temp1 36\"\n");
	localcmd("alias maxteams \"temp1 37\"\n");//??
	localcmd("alias faststarton \"temp1 38\"\n");
	localcmd("alias faststartoff \"temp1 39\"\n");
	localcmd("alias freshspawnson \"temp1 40\"\n");
	localcmd("alias freshspawnsoff \"temp1 41\"\n");
	localcmd("alias nopractice \"temp1 42\"\n");
	localcmd("alias autopauseon \"temp1 43\"\n");
	localcmd("alias autopauseoff \"temp1 44\"\n");
	localcmd("alias autostatson \"temp1 45\"\n");
	localcmd("alias autostatsoff \"temp1 46\"\n");
	localcmd("alias runeson \"temp1 47\"\n");
	localcmd("alias runesoff \"temp1 48\"\n");
	
	// entity file commands
	localcmd("alias newspawn \"temp1 50\"\n");
	localcmd("alias newstart \"temp1 51\"\n");
	localcmd("alias killspawn \"temp1 52\"\n");
	localcmd("alias makecam \"temp1 53\"\n");
	localcmd("alias killitem \"temp1 54\"\n");
	localcmd("alias makeitem \"temp1 55\"\n");
	localcmd("alias changeitem \"temp1 56\"\n");
  	
  	localcmd(";alias setafk \"temp1 57\"\n");//Set the amount of time in minutes before a player is marked as 'afk'
  	localcmd(";alias kickafk \"temp1 58\"\n");//Set the amount of time in minutes before an afk player is kicked

	// control commands	  
	localcmd("alias [init] \"temp1 60\"\n");
	localcmd("alias [normal] \"temp1 61\"\n");
	localcmd("alias [practice] \"temp1 62\"\n");
	localcmd("alias [match] \"temp1 63\"\n");
	localcmd("alias [ctf] \"temp1 64\"\n");
	localcmd("alias [done] \"temp1 65\"\n");

	localcmd(";alias dynamichookoff \"temp1 66\"\n");
	localcmd(";alias dynamichookon \"temp1 67\"\n");//speed cap for bunnyhops on landing to mimic 1997s 0.1 ticrate

	localcmd(";alias safedischargeon \"temp1 68\"\n");
	localcmd(";alias safedischargeoff \"temp1 69\"\n");

	localcmd(";alias tossruneoff \"temp1 78\"\n");//78
	localcmd(";alias tossruneon \"temp1 79\"\n");//79

	// undocumented debug commands
	localcmd("alias debugclient temp1 70\n");
	localcmd("alias debugoff temp1 71\n");
	localcmd("alias stuffimpulse temp1 72\n");
	localcmd("alias stuffcolor temp1 73\n");
	localcmd("alias debugcflags temp1 74\n");
	localcmd("alias debugsflags temp1 75\n");
	localcmd("alias debugcinfo temp1 76\n");
	localcmd("alias debughelp temp1 77\n");

	// admin passwords (R00k: FTE has a reserved word 'setpass', changed to setadmin)
	localcmd("alias setadmin \"temp1 80\"\n");
	localcmd("alias setadmin1 \"temp1 81\"\n");
	localcmd("alias setadmin2 \"temp1 82\"\n");
	localcmd("alias setadmin3 \"temp1 83\"\n");
	localcmd("alias setadmin4 \"temp1 84\"\n");
	localcmd("alias setadmin5 \"temp1 85\"\n");
	localcmd("alias setadmin6 \"temp1 86\"\n");
	localcmd("alias setadmin7 \"temp1 87\"\n");
	localcmd("alias setadmin8 \"temp1 88\"\n");
	localcmd("alias setadmin9 \"temp1 89\"\n");
	localcmd(";alias banned \"temp1 91\"\n");
	localcmd("alias modes \"temp1 92\"\n");
	localcmd("alias gameplay \"temp1 93\"\n");
	localcmd("alias watch \"temp1 94\"\n");
	localcmd("alias stat \"temp1 95\"\n");
	localcmd("alias misc \"temp1 96\"\n");
	localcmd("alias modhelp \"temp1 97\"\n");
	localcmd("alias shortcuts \"temp1 98\"\n");
  	//localcmd(";alias * \"temp1 1256;wait\"\n");
};

//
//  P R I N T  P I N G
// 
void(entity player) console_print_ping =
{
	local float p;

	p = floor(stof(infokey(self, INFOKEY_P_PING)));
	if (p < 1000)
		cprint(" ");
	if (p < 100)
		cprint(" ");
	if (p < 10)
		cprint(" ");
	cprint(ftos(p));
};

//
//  P I N G
//
void() console_ping =
{
	local entity player;

	cprint("Client ping times:\n");
	player = find(world, classname, "player");
	while (player)
	{
		if (player.style & CLANRING_CONNECTED)
		{
			console_print_ping(player);
			cprint(" ", player.netname, "\n");
		}
		player = find(player, classname, "player");
	}
};

//
//  S H O W  T I M E
//
//  Show the elapsed time on the server console.
//
void() console_show_time = 
{
    local float h, m, s, t;
    local string temp;

    h = floor(time / 3600);
    t = time - h * 3600;
    m = floor(t / 60);
    t = t - m * 60;
    s = rint(t);

    cprint("\"time = ");
    if (h > 0)
    {
        temp = ftos(h);
        localcmd2(temp, ":");
        if (m < 10)
            localcmd("0");
    }
    temp = ftos(m);
    localcmd2(temp, ":");
    if (s < 10)
        localcmd("0");
    temp = ftos(s);
    localcmd2(temp, "\"\n");
};

//
//  S H O W  S T A T U S
//
//  Show the elapsed time and status on the server console.
//
void() console_show_status = 
{
    local float mode;
    local string szmode;

    cprint("\n");
    mode = options_get_mode();
    szmode = strings_get_mode(mode);
    cprint2(szmode, " mode\n");
    console_show_time();
    localcmd("status;echo\n");
	cprint("\n");
};

//
//  S H O W  D E B U G  I N F O
//
//  Used for development.  Similar to clanring_debug_info, but prints to the
//  server console.
//
void() console_show_debug_info =
{
	local entity e;

	cprint("clients:\n");
	e = find(world, classname, "player");
	while (e)
	{
		local string temp;
		temp = ftos(e.colormap);
		if (e.style & CLANRING_CONNECTED)
			cprint4(temp, " \"", e.netname, "\" - Connected\n");
		else
			cprint4(temp, " \"", e.netname, "\" - Disconnected\n");
		e = find(e, classname, "player");
	}
};

//
//  S H O W  S C O R E
//
//  Print the time remaining and the score.
//
void() console_show_score =
{
	local string temp;//R00k moved up here

	if (!(clanring_playmode & CLANRING_MATCH_MODE))
	{
		cprint("Command valid in match mode only\n");
		return;
	}
	if (!(clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER)))
	{
		if (clanring_state & CLANRING_TIMER_STARTED)
		{
			local string s, pl;
			s = ftos(clanring_match_timer.count);
			pl = strings_szplural(clanring_match_timer.count);
			cprint5("Match begins in ", s, " second", pl, "\n");
		}
		else
			cprint3("Waiting for ", clanring_szteam, "s\n");
		return;
	}
	cprint("\n");
	if (clanring_state & CLANRING_MATCH_OVER)
		cprint("Match over\n");
	else
	{
		if (clanring_match_timer.lip < 0)
			cprint("Sudden death overtime\n");
		else
		{
//			local string temp;
			temp = ftos(clanring_match_timer.lip);
			cprint3("\"Time remaining:  ", temp, ":");
			temp = ftos(clanring_match_timer.count);
			if (clanring_match_timer.count < 10)
			{
				localcmd("0");
			}
			localcmd2(temp, "\"\n");
		}
	}

	if (clanring_first_place != clanring_sentinel)
	{
		local string score;
		score = ftos(clanring_first_place.frags);
		temp = strings_szplural(clanring_first_place.frags);
		cprint8("\"", clanring_szthe, clanring_first_place.netname, "\" has ", score, " frag", temp, "\n");
	}
	if (clanring_second_place != clanring_sentinel)
	{
		score = ftos(clanring_second_place.frags);
		temp = strings_szplural(clanring_second_place.frags);
		cprint8("\"", clanring_szthe, clanring_second_place.netname, "\" has ", score, " frag", temp, "\n");
	}
	cprint("\n");
};

//
//  L I S T  G H O S T S
//
void() console_list_ghosts =
{
	local entity e;
	e = find(world, classname, "clanring_ghost");
   if (!e)
    {
        cprint("There are no ghosts\n");
        return;
    }
    cprint("\n");
	if (teamplay)
		cprint("\" code |    team    | frags |      name\"\n");
	else
		cprint("\" code |   colour   | frags |      name\"\n");
    cprint("------+------------+-------+-----------------\n");
    while (e)
    {
        local string num, szTeam, pad;
        local float frag;
        num = ftos(e.count);
        cprint3("\"  ", num, "  | ");
    
        szTeam = strings_get_teamname2(e.height);
        if (e.owner.owner == e)
            frag = e.owner.frags;
        else
            frag = e.frags;
        if (frag < -99)
            pad = " | ";
        else if (frag < -9)
            pad = " |  ";
        else if (frag < 0)
            pad = " |   ";
        else if (frag < 10)
            pad = " |    ";
        else if (frag < 100)
            pad = " |   ";
        else
            pad = " |  ";
        num = ftos(frag);
        if (e.owner.owner == e)
            localcmd6(szTeam, pad, num, "  | ", e.owner.netname, "\"\n");
        else
            localcmd4(szTeam, pad, num, "  | Disconnected\"\n");
    
        e = find(e, classname, "clanring_ghost");
    }
    cprint("\n");
};

//
//  S H O W  K I L L S T A T S
//
void() console_show_killstats =
{
	local entity player;
	local float c;

	c = 16;//Workaround for lagout players corrupting the link list...
	
	cprint("\"------------\"\n");
	cprint("\" Kill Stats \"\n");
	cprint("\"------------\"\n");
	cprint("\" frags | enemies | self | teammates | killed | dtk | dgv |     name\"\n");
	cprint(  "-------+---------+------+-----------+--------+-----+-----+-----------------\n");
	player = clanring_sentinel.next_player;
	while (player)
	{
		if (c < 1)
			break;
		cprint("\"  ");
		utils_cprint_int3(player.frags);
		localcmd("  |   ");
		utils_cprint_int3(((player.true_kills + player.mangle_x) + player.mangle_y));
		localcmd("   | ");
		utils_cprint_int3(player.mangle_x);
		localcmd("  |    ");
		utils_cprint_int3(player.mangle_y);
		localcmd("    |  ");
		utils_cprint_int3(player.mangle_z);
		localcmd("   |");
		utils_cprint_damage(player.dmg_taken);   
		localcmd("|");
		utils_cprint_damage(player.dmg_given);      		
		localcmd3("| ", player.netname, "\"\n");
		player = player.next_player;
		c = c - 1;
	}
	cprint("\n");
};

//
//  P R I N T  P E R C E N T 4
//
//  Helper function for console_show_efficiency.  Prints the percentage
//  100 * (frac / tot) as a 4 character integer, or N/A if tot = 0.
//
void(float frac, float tot) console_print_percent4 =
{
    if (tot)
    {
        local float n;
        local string temp;

        n = floor(100 * frac / tot);
        if (n < 100)
            localcmd(" ");
        if (n < 10)
            localcmd(" ");
        temp = ftos(n);
        localcmd2(temp, "%");
    }
    else
        localcmd("N/A ");
};

//
// CRMOD
//  S H O W  Q U A D S T A T S
//		by Paul Baker
//
void() console_show_quadstats =
{
	local entity player, pteam;
	local float useteams;
//	local string teamname;

	if ((clanring_state & (CLANRING_MATCH_STARTED | CLANRING_MATCH_OVER)) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;

	cprint("\"------------\"\n");
	cprint("\" Quad Stats \"\n");
	cprint("\"------------\"\n");

	cprint("\" quads | efficiency | enemy | self  | teammates |      name\"\n");
	cprint("-------+------------+-------+-------+-----------+-----------------\n");
	player = clanring_sentinel.next_player;
	pteam = player.next_team;

	while (player)
	{
		cprint("\"  ");
		utils_cprint_int3 (player.clanring_qdwep_z);
		localcmd("  |    ");
		console_print_percent4 (player.clanring_qdwep_x, player.clanring_qdwep_y);
		localcmd("    |  ");
		utils_cprint_int3 (player.clanring_qdkill_x);
		localcmd("  |  ");
		utils_cprint_int3 (player.clanring_qdkill_z);
		localcmd("  |    ");
		utils_cprint_int3 (player.clanring_qdkill_y);
		localcmd3("    | ", player.netname, "\"\n");
		player = player.next_player;
		if ((useteams && (player.next_team != pteam)))
		{
			cprint("\" [");
			utils_cprint_int3 (pteam.dest2_x);
			localcmd3("] |            |       |       |           | ", pteam.netname, "\"\n");
			pteam = player.next_team;
		}
	}
	cprint("\n");
};

//
//  S H O W  B A D S T A T S
//
void() console_show_badstats =
{
	local entity player;
	local float tot_enemy;
	local float tot_done;

	if (!(clanring_playmode & CLANRING_MATCH_MODE) || !teamplay)
	{
		cprint("badstats valid in match mode only\n");
		return;
	}

	cprint("\"------------\"\n");
	cprint("\" Bad Stats \"\n");
	cprint("\"------------\"\n");

	cprint("\" paks | self | team |      name\"\n");
	cprint("\"------+------+------+----------------\"\n");
	player = clanring_sentinel.next_player;
	while (player)
	{
		tot_enemy = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		tot_done = tot_enemy + player.clanring_badstats_y + player.clanring_badstats_z;
		cprint("\"  ");
		utils_cprint_int3(player.clanring_badstats_x);
		localcmd(" | ");
		console_print_percent4(player.clanring_badstats_y, tot_done);
		localcmd(" | ");
		console_print_percent4(player.clanring_badstats_z, tot_done);
		localcmd(" | ");
		localcmd2(player.netname, "\"\n");
		player = player.next_player;
	}
	cprint("\n");
};

//
//  S H O W  E F F I C I E N C Y
//
void() console_show_efficiency =
{
	local entity player;
	local float tot_fired, tot_done;
	
	cprint("\"------------------\"\n");
	cprint("\" Efficiency Stats \"\n");
	cprint("\"------------------\"\n");


	cprint("\" bullets | nails | rockets | lightning | total |      name\"\n");
	cprint("---------+-------+---------+-----------+-------+-----------------\n");
	player = clanring_sentinel.next_player;
	while (player)
	{
		cprint("\"   ");
		console_print_percent4(player.dest2_x, player.dest1_x);
		localcmd("  |  ");
		console_print_percent4(player.dest2_y, player.dest1_y);
		localcmd(" |   ");
		console_print_percent4(player.dest_y, player.dest_x);
		localcmd("  |    ");
		console_print_percent4(player.dest2_z, player.dest1_z);
		localcmd("   |  ");
		tot_fired = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
		tot_done = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		console_print_percent4(tot_done, tot_fired);
		localcmd3(" | ", player.netname, "\"\n");
		player = player.next_player;
	}
	cprint("\n");
};

//
//  S H O W  F L A G S T A T S
//
void() console_show_fstats =
{
	local entity player;

	player = find(world, classname, "player");//flagstats in normal mode too
	
	cprint("\"------------\"\n");
	cprint("\" Flag Stats \"\n");
	cprint("\"------------------------------------------------------\"\n");
	cprint("\"flag |cap|def|rtn|fcd|fca|fck|  time  |     name      \"\n");
	cprint("\"-----+---+---+---+---+---+---+--------+---------------\"\n");

	while (player)
	{
		if (!(player.style & CLANRING_OBSERVER))
		{
			cprint("\" ");
			utils_cprint_int3(player.fpickups);
			localcmd(" |");
			utils_cprint_int3(player.fcaptures);
			localcmd("|");
			utils_cprint_int3(player.fdefenses);
			localcmd("|");
			utils_cprint_int3(player.freturns);
			localcmd("|");
			utils_cprint_int3(player.fcdefenses);
			localcmd("|");
			utils_cprint_int3(player.fcassists);
			localcmd("|");
			utils_cprint_int3(player.fcfrags);
			localcmd("|");
			utils_cprint_time(player.captime);
			localcmd3("| ", player.netname, "\"\n");
		}
		player = find(player, classname, "player");
	}
	cprint("\n");
};

//
//  S H O W  S T A T S
//
//  Summary: show kill and weapon efficiency for each player.
//
void() console_show_stats =
{
	local entity player;
	local float wfrac, wtot, kfrac, ktot, useteams;
	local string teamname;

	if ((clanring_state & CLANRING_MATCH_STARTED) && teamplay)
		useteams = TRUE;
	else
		useteams = FALSE;
	
	cprint("\"------------\"\n");
	cprint("\" Skill Stats \"\n");
	cprint("\"------------\"\n");

	if (useteams)
	{
		cprint("\"    team    | kill | weapon |      name\"\n");
		cprint("------------+------+--------+-----------------\n");
	}
	else
	{
		cprint("\" kill | weapon |      name\"\n");
		cprint("------+--------+-----------------\n");
	}
	player = clanring_sentinel.next_player;

	while (player)
	{
		if (useteams)
		{
			teamname = strings_get_teamname2 (player.height);
			cprint3("\" ", teamname, " | ");
		}
		else
			cprint("\" ");

		kfrac = player.frags + player.mangle_x + player.mangle_y;
		ktot = kfrac + player.mangle_x + player.mangle_y + player.mangle_z;
		wtot = player.dest1_x + player.dest1_y + player.dest1_z + player.dest_x;
		wfrac = player.dest2_x + player.dest2_y + player.dest2_z + player.dest_y;
		console_print_percent4(kfrac, ktot);
		localcmd(" |  ");
		console_print_percent4(wfrac, wtot);
		localcmd3("  | ", player.netname, "\"\n");
		player = player.next_player;
	}
	cprint("\n");
};

//
//  F O R M A T  V E C T O R
//
//  prints xx:yy:zz to self
//
void(vector v) console_format_vector =
{
	local string s;

	localcmd("| ");
	if (v_x < 10)
		localcmd(" ");
	s = ftos(v_x);
	localcmd2(s, " : ");
	if (v_y < 10)
		localcmd(" ");
	s = ftos(v_y);
	localcmd2(s, " : ");
	if (v_z < 10)
		localcmd(" ");
	s = ftos(v_z);
	localcmd2(s, " ");
};

//
//  S H O W  T E A M  S T A T S
//
void() console_show_teamstats =
{
	local entity pteam;
	local string s;

	if (!(teamplay && (clanring_playmode & CLANRING_MATCH_MODE)))
	{
		cprint("Teamstats valid in match mode only\n");
		return;
	}
	if (!clanring_sentinel.next_team)
	{
		cprint("No teams\n");
		return;
	}

	cprint("\"------------\"\n");
	cprint("\" Team Stats \"\n");
	cprint("\"------------\"\n");

	cprint("\"               ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		s = strings_get_teamname2(pteam.height);
		localcmd3("|  ", s, "  ");
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"---------------");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		localcmd("+--------------");
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"Q : 666 : Ring ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		console_format_vector(pteam.dest2);
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"RL : LG : GL   ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		console_format_vector (pteam.dest1);
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"SNG : NG : MH  ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		console_format_vector(pteam.pos1);
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"RA : YA : GA   ");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		console_format_vector(pteam.dest);
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"+RLPak : -RLPak");
	pteam = clanring_sentinel.next_team;
	while (pteam)
	{
		localcmd("|  ");
		s = ftos(pteam.mangle_y);
		if (pteam.mangle_y < 10)
			localcmd(" ");
		localcmd3("+", s, "   ");
		s = ftos(pteam.mangle_z);
		if (pteam.mangle_z < 10)
			localcmd(" ");
		localcmd3("-", s, "   ");
		pteam = pteam.next_team;
	}
	localcmd("\"\n");
	cprint("\"Control        ");
	pteam = clanring_sentinel.next_team;

	while (pteam)
	{
		local float f;
		local float control;
		control = 100 * pteam.mangle_x / clanring_sentinel.cnt;
		f = floor(control);
		s = ftos(f);
		localcmd2("ü  %", s);
		f = floor((control - f) * 10);
		s = ftos(f);
		localcmd3(".", s, " ");
		if (control < 10)
			localcmd(" ");
		pteam = pteam.next_team;
	}

	localcmd("\"\n");
	cprint("\n");
};

//
//  A U T O D U M P
//
//  Dump statistics if server has autostats enabled.
//
void() console_autodump =
{
	local string temp;
	
//	if ((clanring_playmode & CLANRING_CONSOLE_STATS))
	{
		cprint("\n");
//		cprint3("\"Clanring v", clanring_version_number, " -Match Statistics-\"\n");
		cprint("- CRMod Match Statistics - \n");		
		//Stats header for SQL parser
		/*
		Map: DM3
		Type: 4v4
		Timelimit: 20
		*/
		
		cprint3("\"Map: ",mapname,"\"\n");

		temp = ftos(stats_matchtype);
		cprint5("\"Type: ", temp, "v", temp,"\"\n");

		temp = ftos(stats_timelimit);
		cprint3("\"Timelimit: ", temp,"\"\n");
		
		cprint("\n");
		
		console_show_stats ();

		if (!(clanring_playmode & CLANRING_NO_QUAD))//R00k -added-
			console_show_quadstats ();

		if ((clanring_playmode & CLANRING_MATCH_MODE) && (teamplay == 2))
			console_show_badstats ();

		console_show_efficiency ();
		console_show_killstats ();		
		console_show_teamstats ();
		
		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
			console_show_fstats ();
	}
};

//
//  C O M M A N D S
//
//  Show a list of valid commands (dedicated only)
//
void() console_commands =
{
	cprint("\n");
	cprint3("\"Clanring v", clanring_version_number, " console commands:\"\n");
	cprint("\n");
	cprint("\"s      - view server status             settings  - view server settings      \"\n");
	cprint("\"vinfo  - version information            ghostlist - view list of ghosts       \"\n");
	cprint("\"sping  - approximate client pings       setadmin  - set admin password (use 'skill')\"\n");
	cprint("\"time   - time elapsed on current map    maxteams  - set maxteams (use 'skill')\"\n");
	cprint("\"score  - match score/time remaining     otset     - set overtime (use 'skill')\"\n");
	cprint("\"admins - list administrators\"\n");
	cprint("\n");
	cprint("\"stats     killstats     efficiency      quadstats     badstats     teamstats\"\n");
	cprint("\n");
	cprint("\"settings:\"\n");
	cprint("\n");
	cprint("\"normal              practice            match               deathmatch\"\n");
	cprint("\"nopractice          highgibs            lowgibs             nogibs\"\n");
	cprint("\"quadon              quadoff             penton              pentoff\"\n");
	cprint("\"ringon              ringoff             freshspawnon        freshspawnoff\"\n");
	cprint("\"faststarton         faststartoff        autopauseon         autopauseoff\"\n");
	cprint("\"modevoteon          modevoteoff         safepracticeon      safepracticeoff\"\n");
	cprint("\"obitson             obitsoff            autostatson         autostatsoff\"\n");
	cprint("\n");
};

//
//  D E B U G  C L I E N T
//
//  Enter debug mode for the client indicated by cvar 'skill'.
//
void() console_debug_client =
{
	local float id;
	local entity client;

	id = cvar ("skill");
	client = find(world, classname, "player");
	while (client)
	{
		if (client.colormap == id)
		{
			clanring_debug_client = client;
			cprint3("\"debugging ", client.netname, "\"\n");
			return;
		}
		client = find(client, classname, "player");
	}
	cprint("client not found\n");
};

//
//  S T U F F  I M P U L S E
//
//  Stuff an impulse into the console of the debug client.
//
void() console_stuff_impulse =
{
	local float temp;
	local string s;

	if (!clanring_debug_client)
	{
		cprint("No debug client\n");
		return;
	}
	temp = cvar ("skill");
	s = ftos(temp);
	stuffcmd(clanring_debug_client, "impulse ");
	stuffcmd(clanring_debug_client, s);
	stuffcmd(clanring_debug_client, "\n");
	cprint3("stuffing impulse ", s, "\n");
};

//
//  S T U F F  C O L O U R
//
//  Stuff a colour into the console of the debug client.
//
void() console_stuff_colour =
{
	local float temp;
	local string s;

	if (!clanring_debug_client)
	{
		cprint("No debug client\n");
		return;
	}
	temp = cvar ("skill");
	s = ftos(temp);
	stuffcmd(clanring_debug_client, "color ");
	stuffcmd(clanring_debug_client, s);
	stuffcmd(clanring_debug_client, "\n");
	cprint3("stuffing color ", s, "\n");
};

//
//  C L I E N T  F L A G S
//
void() console_client_flags =
{
	if (!clanring_debug_client)
	{
		cprint("No debug client\n");
		return;
	}
	cprint("\n");
	cprint3("\"Client flags for ", clanring_debug_client.netname, ":\"\n");
	cprint("\n");
	if (clanring_debug_client.style & CLANRING_NEW_CLIENT)
		cprint("CLANRING_NEW_CLIENT\n");
	if (clanring_debug_client.style & CLANRING_ADMINISTRATOR)
		cprint("CLANRING_ADMINISTRATOR\n");
	if (clanring_debug_client.oflags & OBSERVER_POP_FORWARD)
		cprint("OBSERVER_POP_FORWARD\n");
	if (clanring_debug_client.style & CLANRING_READY)
		cprint("CLANRING_READY\n");
	if (clanring_debug_client.style & CLANRING_YES)
		cprint("CLANRING_YES\n");
	if (clanring_debug_client.style & CLANRING_HEADS_UP)
		cprint("CLANRING_HEADS_UP\n");
	if (clanring_debug_client.style & CLANRING_SETTING_OPTIONS)
		cprint("CLANRING_SETTING_OPTIONS\n");
	if (clanring_debug_client.style & CLANRING_MOTD)
		cprint("CLANRING_MOTD\n");
	if (clanring_debug_client.style & CLANRING_OK_TO_SHOOT)
		cprint("CLANRING_OK_TO_SHOOT\n");
	if (clanring_debug_client.style & CLANRING_KICK_CONFIRM)
		cprint("CLANRING_KICK_CONFIRM\n");
	if (clanring_debug_client.style & CLANRING_CONFIRM_LEAVE)
		cprint("CLANRING_CONFIRM_LEAVE\n");
	if (clanring_debug_client.style & CLANRING_CONNECTED)
		cprint("CLANRING_CONNECTED\n");
	if (clanring_debug_client.style & CLANRING_FOUND_BINDINGS)
		cprint("CLANRING_FOUND_BINDINGS\n");
	if (clanring_debug_client.style & CLANRING_SMART_WEAPON)
		cprint("CLANRING_SMART_WEAPON\n");
	if (clanring_debug_client.style & CLANRING_OBSERVER)
		cprint("CLANRING_OBSERVER\n");
	if (clanring_debug_client.style & CLANRING_SCOREBOARD)
		cprint("CLANRING_SCOREBOARD\n");
	if (clanring_debug_client.style & CLANRING_NO_POST_THINK)
		cprint("CLANRING_NO_POST_THINK\n");
	if (clanring_debug_client.style & CLANRING_WINQUAKE)
		cprint("CLANRING_WINQUAKE\n");
	if (clanring_debug_client.style & CLANRING_GLQUAKE)
		cprint("CLANRING_GLQUAKE\n");
	if (clanring_debug_client.style & CLANRING_CONSOLE_STATS)
		cprint("CLANRING_CONSOLE_STATS\n");

		// CRMOD - change to oflags	
	cprint("\n");
	cprint3("\"Client Observer Flags for ", clanring_debug_client.netname, ":\"\n");
	cprint("\n");
	if (clanring_debug_client.oflags & OBSERVER_WALK)
		cprint("OBSERVER_WALK\n");
	if (clanring_debug_client.oflags & OBSERVER_FLY)
		cprint("OBSERVER_FLY\n");
	if (clanring_debug_client.oflags & OBSERVER_CHASE)
		cprint("OBSERVER_CHASE\n");
	if (clanring_debug_client.oflags & OBSERVER_DEMO)
		cprint("OBSERVER_DEMO\n");
	if (clanring_debug_client.oflags & OBSERVER_CAMERA)
		cprint("OBSERVER_CAMERA\n");
	if (clanring_debug_client.oflags & OBSERVER_AUTO)
		cprint("OBSERVER_AUTO\n");
	if (clanring_debug_client.oflags & OBSERVER_TOURNEY)
		cprint("OBSERVER_TOURNEY\n");
	if (clanring_debug_client.oflags & OBSERVER_GO_AUTO)
		cprint("OBSERVER_GO_AUTO\n");
	if (clanring_debug_client.oflags & OBSERVER_COMMENTARY)
		cprint("OBSERVER_COMMENTARY\n");
	cprint("\n");
};

//
//  S E R V E R  F L A G S
//
void() console_server_flags =
{
    cprint("\n");
	cprint("Server flags:\n");
    cprint("\n");

	// playmode flags
	if (clanring_playmode & CLANRING_MATCH_MODE)
		cprint("CLANRING_MATCH_MODE\n");
	if (clanring_playmode & CLANRING_PRACTICE_MODE)
		cprint("CLANRING_PRACTICE_MODE\n");
	if (clanring_playmode & CLANRING_SERVER_INITIALIZED)
		cprint("CLANRING_SERVER_INITIALIZED\n");
	if (clanring_playmode & CLANRING_NO_GIBS)
		cprint("CLANRING_NO_GIBS\n");
	if (clanring_playmode & CLANRING_LOW_GIBS)
		cprint("CLANRING_LOW_GIBS\n");
	if (clanring_playmode & CLANRING_NO_QUAD)
		cprint("CLANRING_NO_QUAD\n");
	if (clanring_playmode & CLANRING_NO_PENT)
		cprint("CLANRING_NO_PENT\n");
	if (clanring_playmode & CLANRING_NO_RING)
		cprint("CLANRING_NO_RING\n");
	if (clanring_playmode & CLANRING_MODE_VOTE)
		cprint("CLANRING_MODE_VOTE\n");
	if (clanring_playmode & CLANRING_NO_SPOOGE)
		cprint("CLANRING_NO_SPOOGE\n");
	if (clanring_playmode & CLANRING_EXTENDED_OBITS)
		cprint("CLANRING_EXTENDED_OBITS\n");
	if (clanring_playmode & CLANRING_CONSOLE_INITIALIZED)
		cprint("CLANRING_CONSOLE_INITIALIZED\n");
	if (clanring_playmode & CLANRING_FAST_START)
		cprint("CLANRING_FAST_START\n");
	if (clanring_playmode & CLANRING_AUTO_PAUSE)
		cprint("CLANRING_AUTO_PAUSE\n");

    cprint("\n");

	// state flags
	if (clanring_state & CLANRING_TIMER_STARTED)
		cprint("CLANRING_TIMER_STARTED\n");
	if (clanring_state & CLANRING_MATCH_STARTED)
		cprint("CLANRING_MATCH_STARTED\n");
	if (clanring_state & CLANRING_MATCH_PAUSED)
		cprint("CLANRING_MATCH_PAUSED\n");
	if (clanring_state & CLANRING_MATCH_OVER)
		cprint("CLANRING_MATCH_OVER\n");
	if (clanring_state & CLANRING_MATCH_WAIT)
		cprint("CLANRING_MATCH_WAIT\n");
	if (clanring_state & CLANRING_KICKING)
		cprint("CLANRING_KICKING\n");
	if (clanring_state & CLANRING_NO_PRACTICE)
		cprint("CLANRING_NO_PRACTICE\n");
	if (clanring_state & CLANRING_UNPAUSING)
		cprint("CLANRING_UNPAUSING\n");
	if (clanring_state & CLANRING_AUTO_PAUSED)
		cprint("CLANRING_AUTO_PAUSED\n");
	if (clanring_state & CLANRING_DELAYED_AUTOSS)
		cprint("CLANRING_DELAYED_AUTOSS\n");

    cprint("\n");
};

//
//  D E B U G  H E L P 
//
void() console_debug_help =
{
	cprint("\n");
	cprint("\"debugclient  - select client (use 'skill')\"\n");
	cprint("\"debugoff     - deselect client\"\n");
	cprint("\"stuffimpulse - stuff impulse (use 'skill')\"\n");
	cprint("\"stuffcolor   - stuff colour (use 'skill')\"\n");
	cprint("\"debugcflags  - show client flags\"\n");
	cprint("\"debugcinfo   - show client info\"\n");
	cprint("\"debugsflags  - show server flags\"\n");
	cprint("\n");
};

//
//  C L I E N T  I N F O 
//
void() console_client_info =
{
	local string temp;

	if (!clanring_debug_client)
	{
		cprint("No debug client\n");
		return;
	}
	cprint("\n");
	temp = fnstrings_function (clanring_debug_client.think);
	cprint3("\"think     = ", temp, "\"\n");
	temp = ftos(clanring_debug_client.nextthink);
	cprint3("\"nextthink = ", temp, "\"\n");
	temp = ftos(time);
	cprint3("\"current time = ", temp, "\"\n");
	cprint("\n");
};

//
//  V E R S I O N  I N F O
//
void() console_version_info =
{
	cprint("\n");
	cprint3("\"", clanring_version_info, "\"\n");
	cprint("\n");
};

//
//  C H E C K  L E V E L
//
//  Check to see if we've found the next level in levels.cfg
//
void(float newlevel) console_check_level =
{
	local string s;
	
	s = strings_get_mapname (newlevel);

	// if clanring_levelcount == -1 then we haven't executed levels.cfg, so
	// change levels immediately.
	if (clanring_levelcount == -1)
	{
		changelevel (s);
		return;
	}
	if (clanring_levelcount == 1)
	{
		clanring_firstlevel = s;
		utils_set_cvar ("scratch1", 2);
	}
    // To choose the next level, we should set nextmap when
    // clanring_levelcount == clanring_level.  If the current level is the
    // last one in the list then this will never occur, so we should also
    // set nextmap when we see the first level in the list.
	if (clanring_levelcount == clanring_level)
	{
		nextmap = s;
		utils_set_cvar ("scratch1", clanring_levelcount + 1);
	}
	clanring_levelcount += 1;
};

//
//  G E T  U S E R  N E X T L E V E L
//
//  Check for a user-defined level sequence (dedicated only).
//
void() console_get_user_nextlevel =
{
	clanring_levelcount = 1;
	clanring_lastcount = -1;
	clanring_firstlevel = "";
	localcmd("exec levels.cfg\n");//FIXME
	clanring_nextcheck = 0;
	remove(self);
};

//
//  G E T  O R I G I N
//
//  Return the vector 'scr_ofsx scr_ofsy scr_ofsz'
//
vector () console_get_origin =
{
    local vector v;

    v_x = cvar("scr_ofsx");
    v_y = cvar("scr_ofsy");
    v_z = cvar("scr_ofsz");
    return v;
};

//
//  G E T  A N G L E S
//
//  Return the angles vector 'v_ipitch_level v_iyaw_level v_iroll_level'
//
vector () console_get_angles =
{
    local vector v;

    v_x = cvar("v_ipitch_level");
    v_y = cvar("v_iyaw_level");
    v_z = cvar("v_iroll_level");
    return v;
};

//
//  M A K E  E N T I T Y
//
//  Create a new entity using the origin and angle specified in a
//  configuration file.
//
void(string name, float angleflags) console_make_entity =
{
    local entity newent;
    local string temp;

    // create entity
    newent = spawn();
    newent.owner = world;
    newent.solid = SOLID_NOT;
    newent.movetype = MOVETYPE_NONE;
    newent.takedamage = DAMAGE_NO;
    newent.fixangle = TRUE;
    newent.classname = name;
    newent.origin = console_get_origin();
    newent.angles = console_get_angles();
	newent.style = CLANRING_MANUAL_SPAWN;
    if (!(angleflags & CONSOLE_ENT_PITCH))
        newent.angles_x = 0;
    if (!(angleflags & CONSOLE_ENT_YAW))
        newent.angles_y = 0;
    if (!(angleflags & CONSOLE_ENT_ROLL))
        newent.angles_z = 0;

    temp = vtos(newent.origin);
    cprint4(name, " created at ", temp, ", ");
    temp = vtos(newent.angles);
    localcmd2(temp, "\n");
    if (name == "clanring_camera")
    {
    	newent.nextthink = CLANRING_NEGINF;
    	newent.think = auto_camera_think;
		newent.next_camera = clanring_sentinel.next_camera;
		clanring_sentinel.next_camera = newent;
    }
};

//
//  K I L L  E N T I T Y
//
//  Search for the entity of the given type at origin specified in the
//  configuration file; kill it if it exists.
//
void(string name) console_kill_entity =
{
	local vector location;
	local entity e;
	local string temp;

	location = console_get_origin ();
	temp = vtos (location);

	e = find(world, classname, name);
	while (e)
	{
		if (e.style != CLANRING_MANUAL_SPAWN)
		{
			local vector v;
			v = e.origin - location;
			if (vlen(v) < 20)
			{
				cprint5("removed ", name, " at ", temp, ", ");
				temp = vtos(e.angles);
				localcmd2(temp, "\n");
				remove(e);
				return;
			}
		}
		e = find(e, classname, name);
	}
	cprint5("\"killentity: couldn't find", name, " at ", temp, "\"\n");
};

//
//  K I L L  I T E M
//
//  Kill any respawnable item at the specified location.
//
void() console_kill_item =
{
	local vector v;
	local float dz;

	if (self.style == CLANRING_MANUAL_SPAWN)
		return;

	v = (self.origin - console_origin);
	dz = fabs(v_z);
	v_z = 0;
	if (vlen(v) < 20 && dz < 100)
	{
		local string temp;
		temp = vtos(self.origin);
		cprint5("removed ", self.classname, " at ", temp, "\n");
		remove(self);
	}
};

//
//  M A K E  I T E M
//
//  Create a new item, specified by skill
//
void() console_make_item = 
{
	local float item;
	local entity oself;
    local string temp;

	item = cvar("skill");
	oself = self;

    // create entity
    self = spawn();
    self.owner = world;
    self.takedamage = DAMAGE_NO;
    self.fixangle = TRUE;
    self.origin = console_origin;
    self.angles = '0 0 0';
	self.style = CLANRING_MANUAL_SPAWN;

	if (item < 4)
	{
		self.classname = "item_health";
		if (item == 1)
			self.spawnflags = H_ROTTEN;
		else if (item == 3)
			self.spawnflags = H_MEGA;
		item_health();
	}
	else if (item == 4)
	{
		self.classname = "item_armor1";
		item_armor1();
	}
	else if (item == 5)
	{
		self.classname = "item_armor2";
		item_armor2();
	}
	else if (item == 6)
	{
		self.classname = "item_armorInv";
		item_armorInv();
	}
	else if (item >= 7 && item <= 14)
	{
		if (!(item & 1))
			self.spawnflags = WEAPON_BIG2;
		
		if (item < 9)
		{
			self.classname = "item_shells";
			item_shells();
		}
		else if (item < 11)
		{
			self.classname = "item_spikes";
			item_spikes();
		}
		else if (item < 13)
		{
			self.classname = "item_rockets";
			item_rockets();
		}
		else
		{
			self.classname = "item_cells";
			item_cells();
		}
	}
	else if (item == 15)
	{
		self.classname = "weapon_supershotgun";
		weapon_supershotgun();
	}
	else if (item == 16)
	{
		self.classname = "weapon_nailgun";
		weapon_nailgun();
	}
	else if (item == 17)
	{
		self.classname = "weapon_supernailgun";
		weapon_supernailgun();
	}
	else if (item == 18)
	{
		self.classname = "weapon_grenadelauncher";
		weapon_grenadelauncher();
	}
	else if (item == 19)
	{
		self.classname = "weapon_rocketlauncher";
		weapon_rocketlauncher();
	}
	else if (item == 20)
	{
		self.classname = "weapon_lightning";
		weapon_lightning();
	}
	else if (item == 21)
	{
		self.classname = "item_artifact_envirosuit";
		item_artifact_envirosuit();
	}
	else if (item == 22)
	{
		self.classname = "item_artifact_super_damage";
		item_artifact_super_damage();
	}
	else if (item == 23)
	{
		self.classname = "item_artifact_invulnerability";
		item_artifact_invulnerability();
	}
	else if (item == 24)
	{
		self.classname = "item_artifact_invisibility";
		item_artifact_invisibility();
	}
	else
	{
		remove(self);
		self = oself;
		return;
	}

    temp = vtos(self.origin);
    cprint4(self.classname, " created at ", temp, "\n");

	self = oself;
};

//
//  C H A N G E  I T E M
//
//  Kill any respawnable item at the specified location and make a new one
//  in its place.
//
void() console_change_item = 
{
	local vector v;
	local string temp;
	local float dz;

	if (self.style == CLANRING_MANUAL_SPAWN)
		return;

	v = self.origin - console_origin;
	dz = fabs(v_z);
	v_z = 0;
	if (vlen(v) < 20 && dz < 100)
	{
		console_origin = self.origin;
		temp = vtos(console_origin);
		cprint5("removed ", self.classname, " at ", temp, "\n");		
		remove(self);
		console_make_item();
	}
};

//
//  O N O F F
//
void(float val) console_onoff = 
{
	if (val)
		localcmd("on\n");
	else
		localcmd("off\n");
};

//
//  S H O W  S E T T I N G S
//
void() console_show_settings = 
{
	local float temp;
	local string sz;

	cprint("\n");

    temp = options_get_mode();
    sz = strings_get_mode(temp);
    cprint2(sz, " mode\n");

	localcmd("timelimit\n");
	localcmd("fraglimit\n");
	localcmd("teamplay\n");
	localcmd("deathmatch\n");
	localcmd("pausable\n");
	localcmd("sys_ticrate\n");

	cprint("overtime: ");
	if (clanring_overtime == -1)
		localcmd("sudden death\n");
	else if (clanring_overtime == 0)
		localcmd("disabled\n");
	else 
	{
		sz = ftos(clanring_overtime);
		localcmd(sz);
		sz = strings_szplural(clanring_overtime);
		localcmd2(" minute", sz);
	}

	sz = ftos(clanring_maxteams);
	cprint3("maxteams: ", sz, "\n");

	cprint("gibs: ");
	if (clanring_playmode & CLANRING_NO_GIBS)
		localcmd("off\n");
	else if (clanring_playmode & CLANRING_LOW_GIBS)
		localcmd("low\n");
	else
		localcmd("high\n");

	cprint("safe practice: ");
	console_onoff(clanring_playmode & CLANRING_NO_SPOOGE);

	cprint("quad: ");
	console_onoff(CLANRING_NO_QUAD - (clanring_playmode & CLANRING_NO_QUAD));
	cprint("pentagram: ");
	console_onoff(CLANRING_NO_PENT - (clanring_playmode & CLANRING_NO_PENT));
	cprint("ring: ");
	console_onoff(CLANRING_NO_RING - (clanring_playmode & CLANRING_NO_RING));

	cprint("mode voting: ");
	console_onoff(clanring_playmode & CLANRING_MODE_VOTE);
	cprint("extended obituaries: ");
	console_onoff(clanring_playmode & CLANRING_EXTENDED_OBITS);
	cprint("fast match starts: ");
	console_onoff(clanring_playmode & CLANRING_FAST_START);
	cprint("fresh spawns: ");
	console_onoff(clanring_playmode & CLANRING_FRESH_SPAWNS);
	cprint("autopausing: ");
	console_onoff(clanring_playmode & CLANRING_AUTO_PAUSE);

	cprint("\n");
};

//
//  S E T  M A X  T E A M S
//
//  Set the maximum number of teams.
//
void(float maxteams) console_set_max_teams = 
{
	maxteams = floor(maxteams);
	if (maxteams >= 2 && maxteams <= 8)
		admin_set_maxteams(maxteams);
};

//
//  A D M I N S
//
//  List the server admins and the codes they used
//
void() console_admins =
{
	local entity e;
	local string s;
	local float found;

	found = 0;
	e = find(world, classname, "player");
	while (e)
	{
		if (e.style & CLANRING_CONNECTED && e.style & CLANRING_ADMINISTRATOR)
			found = 1;
		e = find(e, classname, "player");
	}
	if (!found)
	{
		cprint("There are no administrators\n");
		return;
	}
	cprint("\n");
	cprint("\" Code |      Name\"\n");
	cprint("\"------+-----------------\"\n");
	e = find(world, classname, "player");
	while (e)
	{
		if (((e.style & CLANRING_CONNECTED) && (e.style & CLANRING_ADMINISTRATOR)))
		{
			s = ftos(e.clanring_hack_count);
			cprint5("\"   ", s, "  | ", e.netname, "\"\n");
		}
		e = find(e, classname, "player");
	}
	cprint("\n");
};

//
//  C O M M A N D
//
//  Interpret a console command.  Called from clanring_start_frame.
//
void(float command) console_command =
{
	local float arg;

	if (command >= 20 && command <= 48)
	{
		arg = cvar("skill");
		cvar_set("skill", "0");
		if (clanring_state & CLANRING_IGNORE_CONSOLE)
		{
			return;
		}
	}

	if (command >= 100 && command < 200)
	{
		console_check_level(command - 100);
		return;
	}

	if (command >= 80 && command <= 89)
	{
		arg = cvar("skill");
		array_password[command - 80] = arg;
		cvar_set("skill", "0");
		return;
	}

	switch(command)
	{
		case 57:
		{
			arg = cvar("skill");
			clanring_afk_check = (arg * 60);//in seconds
			cvar_set("skill", "0");
			break;
		}
		case 58:
		{
			arg = cvar("skill");
			clanring_afk_timeout = (arg * 60);
			cvar_set("skill", "0");
			break;
		}
// immediate mode commands
		case  1: console_ping();			break;
		case  2: console_show_time();		break;
		case  3: console_show_status();		break;	
		case  4: console_show_debug_info();	break;
		case  5: console_show_score();		break;
		case  6: console_list_ghosts();		break;
		case  7: console_show_killstats();	break;
		case  8: console_show_efficiency();	break;
		case  9: console_show_stats();		break;
		case  10: console_commands();		break;
		case  11: console_version_info();	break;

		case 12:
		case 13:
		case 14:
		case 15:
		{
			votables_request_set_mode(command - 12);
			break;
		}
		case 16: console_show_quadstats();	break;
		case 17: console_show_settings();	break;
		case 18: console_show_badstats();	break;
		case 19: console_show_teamstats();	break;
// config file commands
		case 20:
		{
			if (!(clanring_playmode & CLANRING_NO_SPOOGE))
				utils_toggle_sflag (CLANRING_NO_SPOOGE, "Safe practice mode");
			break;
		}
		case 21:
		{
			if (clanring_playmode & CLANRING_NO_SPOOGE)
				utils_toggle_sflag (CLANRING_NO_SPOOGE, "Safe practice mode");
			break;
		}
		case 22:
		case 23:
		case 24:
		{
			votables_request_set_gibs(command - 22);
			break;
		}
		case 25:
		{
			if (clanring_playmode & CLANRING_NO_QUAD)
				votables_set_quad ();
			break;
		}
		case 26:		
		{
			if (!(clanring_playmode & CLANRING_NO_QUAD))
				votables_set_quad ();
			break;
		}
		case 27:
		{
			if (clanring_playmode & CLANRING_NO_PENT)
				votables_set_pent ();
			break;			
		}
		case 28:
		{
			if (!(clanring_playmode & CLANRING_NO_PENT))
				votables_set_pent ();
			break;
		}
		case 29:
		{
			if (clanring_playmode & CLANRING_NO_RING)
				votables_set_ring ();
			break;
		}
		case 30:
		{
			if (!(clanring_playmode & CLANRING_NO_RING))
				votables_set_ring ();
			break;
		}
		case 31:
		{
			if (!(clanring_playmode & CLANRING_MODE_VOTE))
				utils_toggle_sflag (CLANRING_MODE_VOTE, "Mode voting");
			break;
		}
		case 32:
		{
			if (clanring_playmode & CLANRING_MODE_VOTE)
				utils_toggle_sflag (CLANRING_MODE_VOTE, "Mode voting");
			break;
		}
		case 33:
		{
			if (!(clanring_playmode & CLANRING_EXTENDED_OBITS))
				utils_toggle_sflag (CLANRING_EXTENDED_OBITS, "Extended obituaries");
			break;
		}
		case 34:
		{
			if (clanring_playmode & CLANRING_EXTENDED_OBITS)
				utils_toggle_sflag (CLANRING_EXTENDED_OBITS, "Extended obituaries");
			break;
		}
		case 36:
		{
			votables_request_set_overtime (arg);
			break;
		}
		case 37:
		{
			console_set_max_teams (arg);
			break;
		}
		case 38:
		{
			if (!(clanring_playmode & CLANRING_FAST_START))
				utils_toggle_sflag (CLANRING_FAST_START, "Fast match starts");
			break;
		}
		case 39: 
		{
			if (clanring_playmode & CLANRING_FAST_START)
				utils_toggle_sflag (CLANRING_FAST_START, "Fast match starts");
			break;
		}
		case 40:
		case 41:
		{
			break;//console_fresh_spawns ((41 - command));
		}
		case 42:
		{
			clanring_state = (clanring_state | CLANRING_NO_PRACTICE);
			cprint("practice mode disabled\n");
			break;
		}
		case 43:
		{
			if (!(clanring_playmode & CLANRING_AUTO_PAUSE))
			{
				utils_toggle_sflag (CLANRING_AUTO_PAUSE, "Automatic match pausing");
			}
			break;
		}
		case 44:
		{
			if (clanring_playmode & CLANRING_AUTO_PAUSE)
			{
				utils_toggle_sflag (CLANRING_AUTO_PAUSE, "Automatic match pausing");
			}
			break;
		}
		case 45:
		{
			if (!(clanring_playmode & CLANRING_CONSOLE_STATS))
			{
				utils_toggle_sflag (CLANRING_CONSOLE_STATS, "Console autostats");
			}
			break;
		}
		case 46: 
		{
			if (clanring_playmode & CLANRING_CONSOLE_STATS)
			{
				utils_toggle_sflag (CLANRING_CONSOLE_STATS, "Console autostats");
			}
			break;
		}
		case 47:
		{
			if (!(clanring_playmode & CLANRING_RUNES))
			{
				StartRuneSpawn ();
				announce("Runes Enabled");
				clanring_playmode = (clanring_playmode | CLANRING_RUNES);
				utils_set_cvar("samelevel", clanring_playmode);
			}
			break;
		}
		case 48:
		{
			if (clanring_playmode & CLANRING_RUNES)
			{
				utils_do_players(DropRune);
				utils_do_item(SUB_Remove, "item_rune");
				announce("Runes Disabled\n");
				clanring_playmode = (clanring_playmode - (clanring_playmode & CLANRING_RUNES));
				utils_set_cvar("samelevel", clanring_playmode);
			}
			break;
		}
// entity file commands
		case 50:
		{
			console_make_entity("info_player_deathmatch", 1);
			dm_num_spawns += 1;
			break;
		}
		case 51:
		{
			console_make_entity("clanring_start_point", 1);
			clanring_num_starts += 1;
			break;
		}
		case 52: console_kill_entity ("info_player_deathmatch"); break;
		case 53:
		{
			console_make_entity("clanring_camera", (CONSOLE_ENT_PITCH | 1));
			clanring_num_cameras += 1;
			break;
		}
		case 54:
		case 55:
		case 56:
		{
			console_origin = console_get_origin();
			if (command == 54)
				utils_do_items(console_kill_item);
			else if (command == 55)
					console_make_item();
				else
				utils_do_items(console_change_item);
			break;
		}
// control commands
		case 60:
		case 61:
		case 62:
		case 63:
		case 64:
		case 65:		
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE)
			{
				utils_set_cvar("deathmatch"	, console_deathmatch);
				utils_set_cvar("timelimit"	, console_timelimit);
				utils_set_cvar("fraglimit"	, console_fraglimit);
				utils_set_cvar("pausable"	, console_pausable);
				utils_set_cvar("noexit"		, console_noexit);
			}
			else
			{
				console_deathmatch 	= cvar("deathmatch");
				console_timelimit 	= cvar("timelimit");
				console_fraglimit 	= cvar("fraglimit");
				console_pausable 	= cvar("pausable");
				console_noexit 		= cvar("noexit");
			}

			if (command == 60)
			{
				if (clanring_playmode & CLANRING_CONSOLE_INITIALIZED)
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
				{
					clanring_playmode = (clanring_playmode | CLANRING_CONSOLE_INITIALIZED);
					utils_set_cvar("samelevel", clanring_playmode);
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
				}
			}

			if (command >= 61 && command <= 64)
			{
				if (command - 61 != options_get_mode())
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}
			if (command == 65)//done		
			{
				cprint("'[done]'.\n");
				clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
				admin_dmset(console_deathmatch);
				votables_request_set_timelimit(console_timelimit);
				clanring_set_fraglimit(console_fraglimit);
				utils_set_cvar("pausable", console_pausable);
				utils_set_cvar("noexit", console_noexit);
			}
			break;
		}

		case 69:
		{
			clanring_playmode = clanring_playmode - (clanring_playmode & CLANRING_NO_SPOOGE);
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}
		case 68:
		{
			clanring_playmode = (clanring_playmode | CLANRING_NO_SPOOGE);
			utils_set_cvar ("samelevel", clanring_playmode);																											
			break;
		}
// undocumented debug commands
		case 70: console_debug_client(); break;
		case 71: 
		{
			cprint("debugging off\n");
			clanring_debug_client = world;
			break;
		}
		case 72: console_stuff_impulse();	break;
		case 73: console_stuff_colour();	break;
		case 74: console_client_flags();	break;
		case 75: console_server_flags();	break;
		case 76: console_client_info();		break;
		case 77: console_debug_help();		break;
		case 78:
		{
			clanring_playmode = clanring_playmode - (clanring_playmode & CLANRING_RUNETOSS);
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}
		case 79:
		{
			clanring_playmode = clanring_playmode | CLANRING_RUNETOSS;
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}

		case  90: console_admins (); break;
		default: cprint("unknown 'console_command'.\n"); break;
	}
};
