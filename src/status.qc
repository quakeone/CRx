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

	TeamCaptureCheckUpdate ();

	self.laststattime = (time + PLAYERSTATTIME);
	res = TeamSetStatRes (self);

	if ((self.player_flag & ITEM_RUNE1_FLAG))
	{
		s1 = "“ÂÛÈÛÙ  ù";
	}
	else
	{
		if ((self.player_flag & ITEM_RUNE2_FLAG))
		{
			s1 = "”ÙÚÂÓÁÙËù";
		}
		else
		{
			if ((self.player_flag & ITEM_RUNE3_FLAG))
			{
				s1 = "»·ÛÙÂ   ù";
			}
			else
			{
				if ((self.player_flag & ITEM_RUNE4_FLAG))
				{
					s1 = "“ÂÁÂÓ   ù";
				}
				else
				{
					s1 = "        ù";
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
		centerprint (self, res, s1, s2, s3, "              ", clanring_version_red);
		return;
	}
	if ((time < (last_flag_capture + TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT)))
	{
		if ((last_capture_team == RED))
		{
			if ((teamscr1 > teamscr2))
			{
				t = "                    “≈ƒ ";
				n = ftos((teamscr1 - teamscr2));
			}
			else
			{
				if ((teamscr1 < teamscr2))
				{
					t = "                   ¬Ã’≈ ";
					n = ftos((teamscr2 - teamscr1));
				}
				else
				{
					t = "                   TIED ";
					n = "";
				}
			}
		}
		else
		{
			if ((teamscr1 > teamscr2))
			{
				t = "                    “≈ƒ ";
				n = ftos((teamscr1 - teamscr2));
			}
			else
			{
				if ((teamscr1 < teamscr2))
				{
					t = "                   ¬Ã’≈ ";
					n = ftos((teamscr2 - teamscr1));
				}
				else
				{
					t = "                   TIED ";
					n = "";
				}
			}
		}
	}
	else
	{
		if ((teamscr1 > teamscr2))
		{
			t = "                    “≈ƒ ";
			n = ftos((teamscr1 - teamscr2));
		}
		else
		{
			if ((teamscr1 < teamscr2))
			{
				t = "                   ¬Ã’≈ ";
				n = ftos((teamscr2 - teamscr1));
			}
			else
			{
				t = "                   TIED ";
				n = "";
			}
		}
	}
	centerprint (self, res, s1, s2, s3, t, n);
};
