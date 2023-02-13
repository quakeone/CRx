//
// Motd.qc
//
// Message of the day code.  I created a whole new file so that it would
// be easier to beef up the motd.
//
// All code by J.P. Grossman unless otherwise commented.
//
float (entity team1) number_teammates;
entity (float whichteam) find_team_entity;

string motd_top1;
string motd_top2;
string motd_top3;
string motd_top4;
string motd_top5;
string motd_top6;
string motd_top7;

//
//  I N I T  W O R L D
//
//  Initialize the motd strings
//

void() motd_init_world =
{
	motd_top1   = "\n\n\n\n\x80\x81\x81\x81\x81\x81 \bc\blan\br\bing\bx\b \x81\x81\x81\x81\x81\x82\n\n\nClanRing Multiplayer Server\n\n\noriginal works by \nJ.P. Grossman & Dave 'Zoid' Kirsch";
	motd_top2   = "\n\n\n\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82\n\n\nWelcome to denver.quakeone.com\n\n\n\badmin\b\n\n\x85Woods\x85";
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
		if (clanring_playmode & CLANRING_MATCH_MODE)
			centerprint(self.owner, "\btype \bred\b or \bblue\b in console to join");
		else if (!(mode_is_arena()))
			centerprint(self.owner, "\btype \bready\b in console to join");
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
		if (clanring_playmode & CLANRING_MATCH_MODE)
			centerprint(self.owner, "\btype \bred\b or \bblue\b in console to join");
		else if (!(mode_is_arena()))
			centerprint(self.owner, "\btype \bready\b in console to join");
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

void () motd_end =
{
	self.owner.style = self.owner.style - (self.owner.style & CLANRING_MOTD);
	remove (self);
};

void ()motd_print =
{	
	if (self.style & CLANRING_AFK_CLIENT)
		return;//R00k v1.95 save some bandwidth...

	if ((!(self.style & CLANRING_CONNECTED)) || (clanring_state & CLANRING_MATCH_PAUSED))//this deters overflow buffer errors
		return;
		
	if (intermission_running)
		return;

	if (self.ca_player_flag == PF_PLAYING) //R00k: 6/12/2017 9:50AM (airshot practice)
		return;

	if (((!(self.oflags & OBSERVER_FLY))&&(!(self.oflags & OBSERVER_WALK))) || (self.next_team != world))
	{
		self.style = self.style - (self.style & CLANRING_MOTD);
		return;
	}
	
	centerprint7 (self, motd_top1, motd_top2, motd_top3, motd_top4, motd_top5, motd_top6, motd_top7);
};

void ()motd_arena_start =
{
	if (self.style & CLANRING_AFK_CLIENT)
		return;//R00k v1.95 save some bandwidth...
		
	if (self.style & CLANRING_MOTD || (!(self.style & CLANRING_CONNECTED)) || clanring_state & CLANRING_MATCH_PAUSED)
		return;	
	
	motd_top1 = "\x80\x81\x81\x81\x81\x81 ClanRing Mod \x81\x81\x81\x81\x81\x82\n";
	motd_top7 = "\n\n\n\n";

	if (clanring_playmode & CLANRING_CA_MODE)
	{
		if (clanring_playmode & CLANRING_WIPEOUT_MODE)
			motd_top2 = "\n\x85Clan Arena\x85\nWipeout\n";
		else
		if (clanring_playmode & CLANRING_FREEZETAG_MODE)
			motd_top2 = "\n\x85Clan Arena\x85\nFreezeTag\n";
		else motd_top2 = "\n\x85Clan Arena\x85\n\n";			
		motd_top3 = "\nchoose a team\n\n";
		motd_top4 = "\x13 blue   \n\x14 red    \n\x15 yellow \n\x16 green  \n\npress \x17 to uncommit from team\n";
	}
	else if (clanring_playmode & CLANRING_RA_MODE)
	{
		motd_top2 = "\n\x85Rocket Arena\x85\n\n";
		motd_top3 = "\n1 to join\n\n";
		motd_top4 = "\n2 to leave\n\n";
	}
	else if (clanring_playmode & CLANRING_DMM4_MODE)
	{
		motd_top2 = "\n\x851v1 Duel\x85\n\n";
		motd_top3 = "\n1 to join\n\n";
		motd_top4 = "\n2 to leave\n\n";
	}
	else if (clanring_playmode & CLANRING_AIRSHOT_MODE)
	{
		motd_top2 = "\n\x85Airshot Mode\x85\n\n";
		motd_top3 = "You can only be damaged while in the air.\nThe higher off the ground, the more\ndamage you will take.\n";
		motd_top4 = "\n1 to join\n\n\n2 to leave\n\n";

		if (playerrecord[0].statvalue > 0)
		motd_top5 =	sprintf("\nAir Gib Streak: %s %s", ftos(rint(playerrecord[0].statvalue)), playerrecord[0].player);
		
		if (playerrecord2[0].statvalue > 0)
		motd_top6 = sprintf("\nHighest Gib: %s %s", ftos(rint(playerrecord2[0].statvalue)), playerrecord2[0].player);
	}
	else
		return;

	self.style = self.style | CLANRING_MOTD;
};