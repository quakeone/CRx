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

void() TeamCapturePlayerUpdate =
{
	local entity e;
	local string n;
	local string t;
	local string s1;
	local string s2;
	local string s3;
	local string res;

	if (clanring_playmode & CLANRING_PRACTICE_MODE)
		return;
		
	if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
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

	TeamCaptureCheckUpdate ();

	self.laststattime = (time + PLAYERSTATTIME);
	res = TeamSetStatRes (self);

	if ((self.player_flag & ITEM_RUNE1_FLAG))
	{
		s1 = "ÚÂÛÈÛÙ   ù";
	}
	else
	{
		if ((self.player_flag & ITEM_RUNE2_FLAG))
		{
			s1 = "ÛÙÚÂÓÁÙË ù";
		}
		else
		{
			if ((self.player_flag & ITEM_RUNE3_FLAG))
			{
				s1 = "Ë·ÛÙÂ    ù";
			}
			else
			{
				if ((self.player_flag & ITEM_RUNE4_FLAG))
				{
					s1 = "ÚÂÁÂÓ    ù";
				}
				else
				{
					s1 = "         ù";
				}
			}
		}
	}
	e = find(world, classname, "item_flag_team1");
	if ((e.cnt == FLAG_AT_BASE))
	{
		s2 = " û";
	}
	else
	{
		if ((e.cnt == FLAG_CARRIED))
		{
			s2 = "rû";
		}
		else
		{
			s2 = "Úû";
		}
	}
	e = find(world, classname, "item_flag_team2");
	if ((e.cnt == FLAG_AT_BASE))
	{
		s3 = " ü";
	}
	else
	{
		if ((e.cnt == FLAG_CARRIED))
		{
			s3 = "bü";
		}
		else
		{
			s3 = "‚ü";
		}
	}
	if (((teamscr1 == 0) && (teamscr2 == 0)))
	{
		centerprint (self, res, s1, s2, s3, "                              ");
		return;
	}

	if ((teamscr1 > teamscr2))
	{
		if ((teamscr1 - teamscr2) > 99)
			t = "                   ÚÂ‰ ";
		else
			t = "                    ÚÂ‰ ";
		n = ftos((teamscr1 - teamscr2));
	}
	else
	{
		if ((teamscr1 < teamscr2))
		{
			if ((teamscr2 - teamscr1) > 99)
				t = "                  ‚ÏıÂ ";
			else
				t = "                   ‚ÏıÂ ";
			n = ftos((teamscr2 - teamscr1));
		}
		else
		{
			t = "                   tied ";
			n = "";
		}
	}
	centerprint (self, res, s1, s2, s3, t, n);
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

	return sprintf("ù%s %s%sü                                \n", tname, talive, get_nextspawn_string(e.nextspawn));
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

	self.laststattime = (time + .2);

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