//
//  C O N F I G . qc
//
// Used for loading and parsing configuration files.
//
// This is pretty much just recoded from console.qc to have more control/simplicity with config files.
// console.qc doesnt read config files anymore, but can still be used to rcon/exec server console commands.
//

void(string command, string value) config_command =
{
	switch(command)
	{
		case "ctfticrate":
		{
			clanring_ctf_ticrate = stof(value);
			break;
		}
		case "tdmticrate":
		{
			clanring_tdm_ticrate = stof(value);
			break;
		}
		case "setadmin":
		{
			array_password[0] = stof(value);
			break;
		}
		case "setadmin1":
		{
			array_password[1] = stof(value);
			break;
		}
		case "setadmin2":
		{
			array_password[2] = stof(value);
			break;
		}
		case "setadmin3":
		{
			array_password[3] = stof(value);
			break;
		}
		case "setadmin4":
		{
			array_password[4] = stof(value);
			break;
		}
		case "setadmin5":
		{
			array_password[5] = stof(value);
			break;
		}
		case "setadmin6":
		{
			array_password[6] = stof(value);
			break;
		}
		case "setadmin7":
		{
			array_password[7] = stof(value);
			break;
		}
		case "setadmin8":
		{
			array_password[8] = stof(value);
			break;
		}
		case "setadmin9":
		{
			array_password[9] = stof(value);
			break;
		}
		case "setafk":
		{
			clanring_afk_check = (stof(value) * 60);//in seconds			
			break;
		}
		case "kickafk":
		{
			clanring_afk_timeout = (stof(value) * 60);
			break;
		}
		case "safepracticeon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;

			if (!(clanring_playmode & CLANRING_NO_SPOOGE))
				utils_toggle_sflag (CLANRING_NO_SPOOGE, "Safe practice mode");
			break;
		}
		case "safepracticeoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;

			if (clanring_playmode & CLANRING_NO_SPOOGE)
				utils_toggle_sflag (CLANRING_NO_SPOOGE, "Safe practice mode");
			break;
		}
		case "nogibs":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			votables_request_set_gibs(0);
			break;
		}
		case "lowgibs":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			votables_request_set_gibs(1);
			break;
		}
		case "highgibs":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			votables_request_set_gibs(2);
			break;
		}
		case "quadon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_NO_QUAD)
				votables_set_quad ();
			break;
		}
		case "quadoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_NO_QUAD))
				votables_set_quad ();
			break;
		}
		case "penton":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_NO_PENT)
				votables_set_pent ();
			break;			
		}
		case "pentoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_NO_PENT))
				votables_set_pent ();
			break;
		}
		case "ringon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_NO_RING)
				votables_set_ring ();
			break;
		}
		case "ringoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_NO_RING))
				votables_set_ring ();
			break;
		}
		case "modevoteon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_MODE_VOTE))
				utils_toggle_sflag (CLANRING_MODE_VOTE, "Mode voting");
			break;
		}
		case "modevoteoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_MODE_VOTE)
				utils_toggle_sflag (CLANRING_MODE_VOTE, "Mode voting");
			break;
		}
/*TODO:
		case "allvoteoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_DISABLE_VOTE)
				utils_toggle_sflag (CLANRING_DISABLE_VOTE, "All voting");
			break;
		}
		case "allvoteon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_DISABLE_VOTE)
				utils_toggle_sflag (CLANRING_DISABLE_VOTE, "All voting");
			break;
		}
*/		
		case "obitson":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_EXTENDED_OBITS))
				utils_toggle_sflag (CLANRING_EXTENDED_OBITS, "Extended obituaries");
			break;
		}
		case "obitsoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_EXTENDED_OBITS)
				utils_toggle_sflag (CLANRING_EXTENDED_OBITS, "Extended obituaries");
			break;
		}
		case "setovertime":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			clanring_overtime = (stof(value));
			utils_set_cvar ("scratch2", clanring_overtime);		
			break;
		}
		case "maxteams":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			console_set_max_teams (stof(value));
			break;
		}
		case "faststarton":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			// if (!(clanring_playmode & CLANRING_FAST_START))
			// 	utils_toggle_sflag (CLANRING_FAST_START, "Fast match starts");
			break;
		}
		case "faststartoff": 
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			// if (clanring_playmode & CLANRING_FAST_START)
			// 	utils_toggle_sflag (CLANRING_FAST_START, "Fast match starts");
			break;
		}
		case "nopractice":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			clanring_state = (clanring_state | CLANRING_NO_PRACTICE);
			cprint("practice mode disabled\n");
			break;
		}
		case "autopauseon":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_AUTO_PAUSE))
			{
				utils_toggle_sflag (CLANRING_AUTO_PAUSE, "Automatic match pausing");
			}
			break;
		}
		case "autopauseoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_AUTO_PAUSE)
			{
				utils_toggle_sflag (CLANRING_AUTO_PAUSE, "Automatic match pausing");
			}
			break;
		}
		case "autostatson":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_CONSOLE_STATS))
			{
				utils_toggle_sflag (CLANRING_CONSOLE_STATS, "Console autostats");
			}
			break;
		}
		case "autostatsoff": 
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_CONSOLE_STATS)
			{
				utils_toggle_sflag (CLANRING_CONSOLE_STATS, "Console autostats");
			}
			break;
		}
		case "runeson":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (!(clanring_playmode & CLANRING_RUNES))
			{
				announce("Runes Enabled");
				clanring_playmode = (clanring_playmode | CLANRING_RUNES);
				utils_set_cvar("samelevel", clanring_playmode);
			}
			break;
		}
		case "runesoff":
		{
			if (clanring_state & CLANRING_IGNORE_CONSOLE) return;
			if (clanring_playmode & CLANRING_RUNES)
			{
				announce("Runes Disabled\n");
				clanring_playmode = (clanring_playmode - (clanring_playmode & CLANRING_RUNES));
				utils_set_cvar("samelevel", clanring_playmode);
			}
			break;
		}
// entity file commands
/*
		case "newspawn":
		{
			console_make_entity("info_player_deathmatch", 1);
			dm_num_spawns += 1;
			break;
		}
		case "newstart":
		{
			console_make_entity("clanring_start_point", 1);
			clanring_num_starts += 1;
			break;
		}
		case "killspawn": console_kill_entity ("info_player_deathmatch"); break;
		case "makecam":
		{
			console_make_entity("clanring_camera", (CONSOLE_ENT_PITCH | 1));
			clanring_num_cameras += 1;
			break;
		}
		case "killitem":
		{
			console_origin = console_get_origin();//FIXME
			utils_do_items(console_kill_item);
			break;
		}
		case "makeitem":
		{
			console_origin = console_get_origin();//FIXME
			console_make_item();
			break;
		}
		case "changeitem":
		{
			console_origin = console_get_origin();//FIXME
			utils_do_items(console_change_item);
			break;
		}
*/
// control commands
		case "-init-":
		case "-ffa-":		// basic normal dm
		case "-pub-ctf-":	// pickup team ctf
//		case "-pub-tdm-":	// pickup team deathmatch (teamplay 1) hmm todo
		case "-practice-":
		case "-match-tdm-":	// team deathmatch
		case "-match-ctf-":	// team CTF subsection
		case "-done-":		
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

			if (command == "-init-")
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

			if (command == "-ffa-")
			{
				if (!(clanring_playmode & CLANRING_NORMAL_MODE)) 
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
				if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}

			if (command == "-pub-ctf-")
			{
				if (!(clanring_playmode & CLANRING_NORMAL_MODE)) 
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
				if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}

			if (command == "-practice-")
			{
				if (!(clanring_playmode & CLANRING_PRACTICE_MODE))
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}

			if (command == "-match-tdm-")
			{
				if (!(clanring_playmode & CLANRING_MATCH_MODE)) 
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else 
				if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}

			if (command == "-match-ctf-")
			{
				if (!(clanring_playmode & CLANRING_MATCH_MODE))
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
				if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
					clanring_state = clanring_state | CLANRING_IGNORE_CONSOLE;
				else
					clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
			}

			if (command == "-done-")
			{
				clanring_state = clanring_state - (clanring_state & CLANRING_IGNORE_CONSOLE);
				admin_dmset(console_deathmatch);

				request_timelimit = console_timelimit;
				votables_set_timelimit();
				request_timelimit = 0;//R00k added.

				clanring_set_fraglimit(console_fraglimit);
				utils_set_cvar("pausable", console_pausable);//why again? we just set this 
				utils_set_cvar("noexit", console_noexit);
			}
			break;
		}

		case "safedischargeoff":
		{
			clanring_playmode = clanring_playmode - (clanring_playmode & CLANRING_NO_SPOOGE);
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}
		case "safedischargeon":
		{
			clanring_playmode = (clanring_playmode | CLANRING_NO_SPOOGE);
			utils_set_cvar ("samelevel", clanring_playmode);																											
			break;
		}
		case "tossruneoff":
		{
			clanring_playmode = clanring_playmode - (clanring_playmode & CLANRING_RUNETOSS);
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}
		case "tossruneon":
		{
			clanring_playmode = clanring_playmode | CLANRING_RUNETOSS;
			utils_set_cvar ("samelevel", clanring_playmode);
			break;
		}
		default: 
		{
			if (!(clanring_state & CLANRING_IGNORE_CONSOLE))
			{
				dprint("setting cvar: ",command," to ",value,"\n");
				cvar_set (command, value); break;
			}
		}
	}
};
//Todo: combine exec_warp_* functions to read the top portion of the file as the main menu
//find the "xxxxx" string then start parsing mapnames/info for the map menus.
void () exec_warp_main_menu =
{
	string line;
	float i = 0;

	filestream f = fopen("configs/warp_main_menu.cfg", FILE_READ);

	if (f < 0)
	{
		return;
	}

	while ((line = fgets(f)) && (i < 15))
	{
		float argc = tokenize(line);
		if (!argc)
			continue;		
		if (argv(0) == "//" || argv(0) == "#") continue;
		warpmenutop[i] = strzone(line);
		i++;
	}

	fclose(f);
}
//TODO: Maybe build the warp menu based on the gametype?
void() exec_warp_cfg =
{
	filestream f = fopen("configs/warp.cfg", FILE_READ);
	string line = "", mapfile = "";
	float menunum = 1, level = 0, mapnum = 0;//Ya, 0 - 15 are reserved. warpmap[16] == e1m1. (menu1, map1)
	
	if (f < 0)
	{
		return;
	}

	while ((line = fgets(f)))
	{
		float argc = tokenize(line);
		if (!argc)
			continue;		

		mapfile = argv(0);
		
		if (mapfile == "//" || mapfile == "#" ) continue;	// Skip comments
		if ((mapfile == "****") || (level > 15))
		{
			menunum += 1;
			level = 0;
			continue;
		}

		level += 1;
		mapnum = (menunum * 15) + level;

		warpmap[mapnum].name = strzone(mapfile);
		warpmap[mapnum].title = strzone(fgets(f));
		warpmap[mapnum].author = strzone(fgets(f));
		//dprint(sprintf("%02g (%s) (%s) (%s)\n", mapnum, (warpmap[mapnum].name), (warpmap[mapnum].title), (warpmap[mapnum].author)));
	}
	fclose(f);
}

//
//	N E X T  L E V E L   C O N F I G 
//
// 	Reading the levels.cfg file and setting the nextmap variable to the next map in the list.
//
//  clanring_level		- number of current level in user level order
//  clanring_levelcount	- This is used throughout to check that levels.cfg has been read...
//  clanring_lastcount	- used to count how many maps are listed in levels.cfg so we know when to recycle.

void() clanring_nextlevel_config =
{
	string 	line = "", mode ="";
	float 	i = 1, done = 0;
	
	nextmap = "";
	
	if (clanring_level < 1)
		clanring_level = 1;

	//Find the current mode we are in.
	if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		mode = "[ctf]";
	else if (clanring_playmode & CLANRING_CA_MODE)
		mode = "[ca]";
	else
		mode = "[dm]";

	filestream f = fopen("configs/levels.cfg", FILE_READ);
	cprint("Loading ClanRing Configuration File: \"configs/levels.cfg\"\n");

	if (f < 0)
	{
		nextmap = strzone(default_nextmap);
		clanring_levelcount	= -1;	// This is used throughout to check that levels.cfg has been read...
									// just disable nextlevel but allow the mod to run.
		cprint("levels.cfg not found.\n");								
		return;
	}

	// Count installed maps so we know when to recycle
	while ((line = fgets(f)))
	{
		float argc = tokenize(line);

		if (!argc) continue;		
		if (argv(0) == "//" || argv(0) == "#") continue;
		
		if (argv(0) == mode) 
		{
			while ((line = fgets(f)))
			{
				if ((line == "[ctf]")||(line == "[ca]")||(line == "[dm]"))
				{
					break;
				}
				if (found_in_warp_list(line))
				{
					if (mapname == line)
						continue;
					clanring_lastcount++;
				}
			}
			done = TRUE; // We've bumped into the next section or reached the EOF.
		}		
		else 
		{
			if (done == FALSE)
				continue;
		}
	}
	fclose(f);

	done = FALSE;

	f = fopen("configs/levels.cfg", FILE_READ);

	while ((line = fgets(f)))
	{
		argc = tokenize(line);

		if (!argc) continue;		
		if (argv(0) == "//" || argv(0) == "#") continue;

		if (argv(0) == mode) 
		{
			while ((line = fgets(f)))
			{
				if ((line == "[ctf]")||(line == "[ca]")||(line == "[dm]"))
				{
					break;
				}
				if (found_in_warp_list(line))
				{
					if (mapname == line)	//If the next map will be the same map we are on, just skip to the one after it.
					{
						i++;
						continue;
					}

					if (i >= clanring_level)
					{
						nextmap = strzone(line);//strzone is required for qss, not FTE ... (Nextmap is dm6. Host_Error: cannot find map maps/6.bsp)				
						break;
					}
					i++;
				}
			}
			done = TRUE;
		}		
		else 
		{
			if (done == FALSE)
				continue;
		}
	}
	fclose(f);

	if (nextmap == "")
	{
		//strunzone(nextmap);
		nextmap = strzone(mapname);	// Ugh, just reload the current map...
		bprint("Nextmap not found, reloading \b", nextmap, "\b.\n");
	}
	else
	{
		cprint(sprintf("Nextmap is %s.\n", nextmap));
		clanring_level++;
		if (clanring_level > clanring_lastcount)
			clanring_level = 1;
		utils_set_cvar ("scratch1", clanring_level);	// save out the next map to load.
	}

	if (!(clanring_playmode & CLANRING_MATCH_MODE) && (cvar("noexit") != 1))
		bprint("Exits activated\n");

	clanring_levelcount	= -1;	// This is used throughout to check that levels.cfg has been read...
}

void(string cfg) exec_clanring_cfg =
{
	filestream f = fopen(cfg, FILE_READ);
	string line;
	
	if (f < 0)
	{
		return;
	}

	while ((line = fgets(f)))
	{
		float argc = tokenize(line);
		if (!argc)
			continue;		
		string cmd = argv(0);
		if (cmd == "//" || cmd == "#" || cmd == "\n") continue; //Skip comments and blank lines.
		string val = argv(1);
		dprint(cmd," ",val,"\n");
		config_command(cmd, val);				//Parse the line.
	}
	fclose(f);
}

void() clanring_warp_config =
{
	cprint("Loading ClanRing Configuration File: \"configs/warp_main_menu.cfg\"\n");
	exec_warp_main_menu();
	cprint("Loading ClanRing Configuration File: \"configs/warp.cfg\"\n");
	exec_warp_cfg();
}

//desc = 0 descending false, so lowest is first
void (string filename, float desc = 0, float recordset = 0) read_player_stats =
{
	string line;
	string tt_player = "";
	float tt_statvalue = 0,tt_teamcolor=0;
	filestream f = fopen(sprintf("data/stats/%s", filename), FILE_READ);
	if (f < 0)
	{
		f = fopen(sprintf("stats/%s", filename), FILE_READ);
	}
	if (f < 0)
	{
		dprint(filename, " not found\n");
		return;
	}

	dprint("Loading ", filename, "...\n");
	while ((line = fgets(f)))
	{
		float argc = tokenize(line);
		if (!argc)
			continue;
		if (argv(0) == "//" || argv(0) == "#" ) continue;	// Skip comments
		tt_player 	 = strtrim(line);
		tt_teamcolor = stof(fgets(f));
		tt_statvalue = stof(fgets(f));
		if (tt_statvalue > 0)
		{
			if (desc == RECORD_LOW)
			{
				if (recordset == 2)
					check_player_low_record2(tt_statvalue, tt_teamcolor, tt_player);
				else
					check_player_low_record(tt_statvalue, tt_teamcolor, tt_player);
			}
			else
			{
				if (recordset == 2)
					check_player_high_record2(tt_statvalue, tt_teamcolor, tt_player);
				else
					check_player_high_record(tt_statvalue, tt_teamcolor, tt_player);
			}
		}
		tt_player = "";
		tt_statvalue = 0,tt_teamcolor = 0; //reset
	}

	fclose(f);
}
void () read_capture_stats =
{
	read_player_stats(sprintf("%s_captimes.crx", mapname), RECORD_LOW, 0);
	read_player_stats(sprintf("%s_captimes_match.crx", mapname), RECORD_LOW, 2);
};
void () read_longrange_stats =
{
	read_player_stats("longrange.crx", RECORD_HIGH, 2);
};
void () read_airshot_stats =
{
	read_player_stats("airshot_streak.crx", RECORD_HIGH, 0);
	//read_player_stats("airshot_gib.crx", RECORD_HIGH, 0);
	read_player_stats("airshot_height.crx", RECORD_HIGH, 2);
};

void (string filename, float recordset) write_player_stats =
{
	float i=0;
	filestream f = fopen(sprintf("stats/%s", filename), FILE_WRITE);
	if (f<0)
	{
		dprint("WARNING: Could not write to ", filename, "\n");
		f = fopen(sprintf("stats/%s", filename), FILE_APPEND);
	}
	if (f<0)
	{
		dprint("WARNING: Could not append to ", filename, "\n");
	}
	else
	{
		dprint("updating ", filename, "\n");
		while (i < PLAYER_RECORDS_MAX_COUNT)
		{
			if (recordset == 2)
			{
				if (playerrecord2[i].statvalue > 0)
				{
					fputs(f, playerrecord2[i].player);
					fputs(f, "\n");
					fputs(f, ftos(playerrecord2[i].teamcolor));
					fputs(f, "\n");
					fputs(f, ftos(playerrecord2[i].statvalue));
					fputs(f, "\n");
					i += 1;
				}
				else break;
			}
			else
			{
				if (playerrecord[i].statvalue > 0)
				{
					fputs(f, playerrecord[i].player);
					fputs(f, "\n");
					fputs(f, ftos(playerrecord[i].teamcolor));
					fputs(f, "\n");
					fputs(f, ftos(playerrecord[i].statvalue));
					fputs(f, "\n");
					i += 1;
				}
				else break;
			}
		}
		fclose(f);
	}
}
void () write_capture_stats =
{
	write_player_stats(sprintf("%s_captimes.crx", mapname), 0);
};
void () write_capture_stats_match =
{
	write_player_stats(sprintf("%s_captimes_match.crx", mapname), 2);
};
void () write_longrange_stats =
{
	write_player_stats("longrange.crx", 2);
};
void () write_airshot_height_stats =
{
	write_player_stats("airshot_height.crx", 2);
};
// void () write_airshot_gib_stats =
// {
// 	write_player_stats("airshot_gib.crx", 0);
// };
void () write_airshot_streak_stats =
{
	write_player_stats("airshot_streak.crx", 0);
};

//TODO: maybe combine these .ent .cam files together into per $mapname.cfg files with subsections for entity, camera, server settings for speed and ease?
void() clanring_ent_config =
{
	//Entity Files
	cprint("Loading Entities Configuration File: entities/", mapname, ".ent\"\n");
	cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
	exec_clanring_cfg((strcat("entities/", mapname, ".ent")));
};

void() clanring_cam_config =
{
	//Camera Files
	cprint("Loading Camera Configuration File: \"camera/", mapname, ".cam\"\n");
	cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
	exec_clanring_cfg((strcat("cameras/", mapname, ".cam")));
};

void() clanring_map_config =
{
	//Map specific settings
	cprint(sprintf("Loading Map Configuration File: \"configs/%s.cfg\n", mapname));
	cprint("\"It is OPTIONAL - there is nothing wrong if it can't be found.\"\n");
	exec_clanring_cfg((strcat("configs/", mapname, ".cfg")));
};

void() clanring_main_config =
{
	cprint("Loading ClanRing Configuration File: \"configs/clanring.cfg\"\n");
	exec_clanring_cfg("configs/clanring.cfg");
	config_command("-done-", ""); //finalize settings
	localcmd("sv_aim 1\n");	//forced, no vertical aim assist.
}

//
//  E X E C  C O N F I G S
//
void() clanring_exec_configs =
{
	if (cvar ("deathmatch") == 0)
		utils_set_cvar ("deathmatch", 1);

	console_timelimit 	= cvar ("timelimit");
	console_deathmatch 	= cvar ("deathmatch");
	console_fraglimit 	= cvar ("fraglimit");
	console_pausable 	= cvar ("pausable");
	console_noexit 		= cvar ("noexit");

	clanring_main_config();
	clanring_warp_config();
	clanring_map_config();
//	clanring_ent_config();//(FIXME)
//	clanring_cam_config();//(FIXME)
	if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
	{
		read_capture_stats();
	}
	else if (clanring_playmode & CLANRING_AIRSHOT_MODE)
	{
		read_airshot_stats();
	}
	// else
	// {
	// 	read_longrange_stats();
	// }

	if (!(clanring_playmode & CLANRING_MATCH_MODE))
	{
		clanring_nextlevel_config();
	}
	else
	{
		if ((clanring_playmode & CLANRING_MATCH_MODE) && (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG)))
		{
			cvar_set("teamplay","2");		
			clanring_set_teamplay(2);	
		}	
		clanring_levelcount = -1;
		nextmap = mapname;//just restart samelevel
	}

	//R00k: ticrate defaults for different modes :|
	if ((clanring_playmode & CLANRING_MATCH_MODE)&&(!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG)))
	{
		dprint(sprintf("setting sys_ticrate to %1.3f\n", clanring_tdm_ticrate));
		cvar_set("sys_ticrate", ftos(clanring_tdm_ticrate));
	}
	else
	{
		dprint(sprintf("setting sys_ticrate to %1.3f\n", clanring_ctf_ticrate));
		cvar_set("sys_ticrate", ftos(clanring_ctf_ticrate));
	}

	remove(self);//scheduled_event_entity
	sys_ready = TRUE;
};

// 0 - normal match end sounds
// 1 - rematch sounds
// 2 - blowout sounds
void (float soundtype) clanring_read_matchsounds =
{
	string line;
	filestream f;
	float i = 0;

	if (soundtype == 1)
		f = fopen("configs/matchsounds_rematch.cfg", FILE_READ);
	else if (soundtype == 2)
		f = fopen("configs/matchsounds_blowout.cfg", FILE_READ);
	else
		f = fopen("configs/matchsounds.cfg", FILE_READ);

	if (f < 0)
	{
		return;
	}

	while ((line = fgets(f)) && (i < MAX_CUSTOM_MATCH_SOUNDS))
	{
		float argc = tokenize(line);
		if (!argc)
			continue;		
		if (argv(0) == "//" || argv(0) == "#") continue;

		if (soundtype == 1)
			matchsound_rematch[i] = (line);
		else if (soundtype == 2)
			matchsound_blowout[i] = (line);
		else
			matchsound[i] = (line);
		i++;
	}
	fclose(f);

	if (soundtype == 1)
		clanring_matchsound_rematch_count = i;
	else if (soundtype == 2)
		clanring_matchsound_blowout_count = i;
	else
		clanring_matchsound_count = i;
};

void () clanring_precache_matchsounds =
{
	clanring_read_matchsounds(0);
	if (clanring_matchsound_count)
	{
		dprint("precaching ");
		dprint(ftos(clanring_matchsound_count));
		dprint(" match end sounds.\n");
		for (float i = 0; i < clanring_matchsound_count; i++)
		{
			// dprint("precache sound: ");
			// dprint(matchsound[i]);
			// dprint("\n");
			precache_sound(matchsound[i]);
		}
	}
	else
		dprint("no match end sounds found.\n");

	clanring_read_matchsounds(1);
	if (clanring_matchsound_rematch_count)
	{
		dprint("precaching ");
		dprint(ftos(clanring_matchsound_rematch_count));
		dprint(" reamtch sounds.\n");
		for (float i = 0; i < clanring_matchsound_rematch_count; i++)
		{
			precache_sound(matchsound_rematch[i]);
		}
	}
	else
		dprint("no rematch sounds found.\n");

	clanring_read_matchsounds(2);
	if (clanring_matchsound_blowout_count)
	{
		dprint("precaching ");
		dprint(ftos(clanring_matchsound_blowout_count));
		dprint(" blowout sounds.\n");
		for (float i = 0; i < clanring_matchsound_blowout_count; i++)
		{
			precache_sound(matchsound_blowout[i]);
		}
	}
	else
		dprint("no blowout sounds found.\n");
};