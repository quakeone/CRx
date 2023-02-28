void() TeamCaptureCheckUpdate =
{
	local entity p;

	if ((lastteamscrtime > time))
	{
		return;
	}
	
	lastteamscrtime = (time + TEAMSCRTIME);
	teamscr2 = 0;
	teamscr1 = 0;
	
	p = find(world, classname, "player");
	
	while ((p != world) && (p.style & CLANRING_CONNECTED))
	{
		if ((p.team == RED) && (!(p.style & CLANRING_OBSERVER)))
		{
			teamscr1 = (teamscr1 + p.frags);
		}
		else
		{
			if ((p.team == BLUE) && (!(p.style & CLANRING_OBSERVER)))
			{
				teamscr2 = (teamscr2 + p.frags);
			}
		}
		p = find(p, classname, "player");
	}
};

void() TeamCaptureResetUpdate =
{
	lastteamscrtime = 0;
	TeamCaptureCheckUpdate ();
};

string(entity who) TeamSetStatRes =
{
	if (who.statstate > 7) // 768
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 7) // 600
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 6) // 480
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 5) // 400
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 4) // 384
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 3) // 350
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 2) // 300
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 1) // 240
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	// 200
	return "\n\n\n\n\n\n\n\n\n\n\n\n";
};

string(entity who) TeamSetStatRes2 =
{
	if (who.statstate > 7) // 768
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 7) // 600
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 6) // 480
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 5) // 400
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 4) // 384
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 3) // 350
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 2) // 300
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	else if (who.statstate == 1) // 240
	return "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	// 200
	return "\n\n\n\n\n\n\n\n\n\n\n";
};

string (float t_teamcolor) get_team_letter =
{
	if (t_teamcolor == TEAM_BLUE)
		return "\bB\b";
	if (t_teamcolor == TEAM_RED)
		return "\bR\b";
	return " ";
};

string() TeamCaptureFlagStatusString =
{
	local entity e;
	local string s2="";
	local string s3="";

	e = find(world, classname, "item_flag_team1");
	if ((e.cnt == FLAG_AT_BASE))
	{
		s2 = "\x80 \x81";
	}
	else
	{
		if ((e.cnt == FLAG_CARRIED))
		{
			s2 = "\x80R\x81";
		}
		else
		{
			s2 = "\x80\bR\x81";//dropped
		}
	}
	e = find(world, classname, "item_flag_team2");
	if ((e.cnt == FLAG_AT_BASE))
	{
		s3 = " \x82";
	}
	else
	{
		if ((e.cnt == FLAG_CARRIED))
		{
			s3 = "B\x82";
		}
		else
		{
			s3 = "\bB\x82";//Dropped
		}
	}

	return sprintf("%s%s", s2, s3);
};

string() TeamCaptureScoreString =
{
	local string t="",n="";

	if (((teamscr1 == 0) && (teamscr2 == 0)))
	{
		return "                              ";
	}

	if ((teamscr1 > teamscr2))
	{
		if ((teamscr1 - teamscr2) > 99)
			t = "                   עוה ";
		else
			t = "                    עוה ";
		n = ftos((teamscr1 - teamscr2));
	}
	else
	{
		if ((teamscr1 < teamscr2))
		{
			if ((teamscr2 - teamscr1) > 99)
				t = "                  גלץו ";
			else
				t = "                   גלץו ";
			n = ftos((teamscr2 - teamscr1));
		}
		else
		{
			t = "                   tied ";
			n = "";
		}
	}

	return sprintf("%s%s", t, n);
};

void() TeamCapturePlayerUpdate =
{
	local string s1="";
	local string s2="";
	local string s3="";
	local string res="";

	if (clanring_playmode & CLANRING_PRACTICE_MODE)
		return;
		
	if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
		return;

	if ((clanring_playmode & CLANRING_MATCH_MODE)&& (!(clanring_state & CLANRING_MATCH_STARTED)))
		return;
		
	if ((self.statstate < 0))
	{
		return;
	}

	if ((self.laststattime > time))
	{
		return;
	}

	if ((self.style & CLANRING_MOTD) && (time >= self.leaderboardtime)) //r00k v3.21
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	//avoid printing flag status while captimes are displayed with centerprint
	if (self.leaderboardtime > time)
	{
		if ((clanring_state & CLANRING_MATCH_STARTED) || (clanring_state & CLANRING_TIMER_STARTED))
		{
			self.leaderboardtime = 0;
		}
		else
		{	//TODO: update for higher PLAYER_RECORDS_MAX_COUNT?
			if (playerrecord[0].statvalue > 0)
			{
				s1 = sprintf("    \1  %s %s %-16s\n\n", utils_get_time(playerrecord[0].statvalue), get_team_letter(playerrecord[0].teamcolor), playerrecord[0].player);
				if (playerrecord[1].statvalue > 0)
				{
					s2 = sprintf("    \2  %s %s %-16s\n\n", utils_get_time(playerrecord[1].statvalue), get_team_letter(playerrecord[1].teamcolor), playerrecord[1].player);
					if (playerrecord[2].statvalue > 0)
					{
						s3 = sprintf("    \3  %s %s %-16s\n\n", utils_get_time(playerrecord[2].statvalue), get_team_letter(playerrecord[2].teamcolor), playerrecord[2].player);
					}
				}
			}
			else
			{
				s1 = "No capture times set";
			}
			centerprint(self, sprintf("\bTime Trial Leaders\b for %s:\n\n", mapname), s1, s2, s3);
			return;
		}
	}

	self.laststattime = (time + PLAYERSTATTIME);
	res = TeamSetStatRes (self);
	//Removed runes because they are on the hud.
	s1 = TeamCaptureFlagStatusString();
	if (clanring_playmode & CLANRING_NORMAL_MODE)	//R00k: no need to print the team up by score since in match mode we have hud scores.
	{
		TeamCaptureCheckUpdate ();
		s2 = TeamCaptureScoreString();
	}
	else
	{
		s2 = "                              ";		//Push the status to the left.
	}
	s3 = sprintf("\n%s",self.movetarget.netname);

	centerprint (self, res, s1, s2, s3);
};

string (float nexttime) get_nextspawn_string =
{
	if ((boss.wait != 0) || (nexttime <= 0))
	{
		return "   ";
	}

	local float timeleft;
	timeleft = ceil(nexttime - time);

	if (timeleft > 9)
	{
		return sprintf(" %s", ftos(timeleft));
	}
	else if (timeleft >= 0)
	{
		return sprintf("  %s", ftos(timeleft));
	}
	else
	{
		return "   ";
	}
};

string (entity e) wipeout_get_teamstatus =
{
	local string tname="", talive="";

	if (e.team2 == self.team2)
		tname = strings_get_teamname4(e.team2);
	else
		tname = strings_get_teamname4_red(e.team2);

	if (e.teamalive == e.teamtotal)
		talive = ftos(e.teamalive);
	else if (e.teamalive == 1)
		talive = "\b1\b";
	else if (e.teamalive < 1)
		talive = "\b0\b";
	else
		talive = strings_ftos_gold(e.teamalive);

	return sprintf("%s %s%s                                \n", tname, talive, get_nextspawn_string(e.nextspawn));
};

float (entity e) IS_CA_OBSERVER;
void () WipeoutModePlayerUpdate =
{
	local entity e;
	local string s1="";
	local string s2="";
	local string s3="";
	local string s4="";

	if (!(clanring_playmode & CLANRING_WIPEOUT_MODE))
		return;

	if (IS_CA_OBSERVER(self))
		return;

	if (boss.state != CA_MATCH_PLAYING)
		return;

	if ((self.statstate < 0))
	{
		return;
	}

	if ((self.laststattime > time))
	{
		return;
	}

	if (self.style & CLANRING_MOTD)//r00k v3.21
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	self.laststattime = (time + .5);

	e = boss.next_team;

	if (e)
	{
		s1 = wipeout_get_teamstatus(e);
		e = e.next_team;
		if (e)
		{
			s2 = wipeout_get_teamstatus(e);
			e = e.next_team;
			if (e)
			{
				s3 = wipeout_get_teamstatus(e);
				e = e.next_team;
				if (e)
				{
					s4 = wipeout_get_teamstatus(e);
				}
			}
		}
	}

	centerprint5 (self, "team alive                                         \n", s1, s2, s3, s4);
};