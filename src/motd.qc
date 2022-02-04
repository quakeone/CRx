//
// Motd.qc
//
// Message of the day code.  I created a whole new file so that it would
// be easier to beef up the motd.
//
// All code by J.P. Grossman unless otherwise commented.
//
string motd_top1;
string motd_top2;

//
//  I N I T  W O R L D
//
//  Initialize the motd strings
//

void() motd_init_world =
{
	motd_top1   = "Ÿ\nClanRing Mod\n\nClanRing Multiplayer Server\n\noriginal works by \nJ.P. Grossman & Dave 'Zoid' Kirsch\n\n\n";
	motd_top2   = "Welcome to Jur4ss1c\n\badmins\b: Moof and Infiniti\nŸ";
};

void() motd_think =
{	
	if (self.count == 0)
	{
		if (self.owner.style & CLANRING_MOTD)
		{
			remove(self);
			return;
		}
		self.owner.button0 = 0;
	}

	self.owner.style = self.owner.style | CLANRING_MOTD;
	// remove the MOTD on fire or jump;	(R00k) or paused
	if ((self.owner.button0) || (self.owner.button2) || (clanring_state & CLANRING_MATCH_PAUSED))
	{
		centerprint(self.owner, "\btype \bred\b or \bblue\b in console to join");
		self.owner.style = self.owner.style - (self.owner.style & CLANRING_MOTD);
		remove(self);
		return;	
	}
	else if ((clanring_state & CLANRING_TIMER_STARTED) && !(clanring_state & CLANRING_MATCH_STARTED))
	{
		//remove motd if pre-match rules are being printed
		self.owner.style = self.owner.style - (self.owner.style & CLANRING_MOTD);
		remove(self);
		return;
	}

	if (self.count < 240)
	{
//		if (self.count == 0)		//outdated, old bots used to detect this phrase then exit.
//		{			
//			centerprint(self.owner, "no bots");
//		}
//		else
		{
			centerprint(self.owner, motd_top1,motd_top2);
		}
	
		self.nextthink = time + 0.1;
		self.count = self.count + 1;
	}
	else
	{
		centerprint(self.owner, "\btype \bred\b or \bblue\b in console to join");
		self.owner.style = self.owner.style - (self.owner.style & CLANRING_MOTD);
		remove(self);
	}

};

//
//  C R E A T E
//
//  Create an entity to display the MOTD for 5 seconds (plus a bit).
//
void() motd_create =
{
	local entity intro;

	if (clanring_state & CLANRING_MATCH_PAUSED)
	return;

	intro = utils_make_scheduled_event(motd_think, 0.5);
	intro.count = 0;
	intro.cnt = 0;
	intro.lip = 0;
};