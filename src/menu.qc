//
// Menu.qc
//
// Called when a player is in observer walk mode; prints the team options menu.

/*
	TODO: add player counters per team?
*/

float (entity team1) number_teammates;
entity (float whichteam) find_team_entity;

string menu_text[8];
/*
0 HEADER mod title/version
1 GAME MODE
2 prompt/ Description / Mode Info
3 Team Choices
4 Uncommit / Spectate / Warmup
5 Stat Info
6 Stat Info
7 FOOTER / vertical positioning / Server Info
*/

void ()menu_init_world =
{
	menu_text[0] = "\x80\x81\x81\x81\x81\x81 \bc\blan\br\bing\bx\b \x81\x81\x81\x81\x81\x82\n";
	menu_text[7] = "\n\n\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82\n\nWelcome to the test server!\n\badmins\b\n\x85BuckSh0t\x85Woods\x85R00k\x85Infiniti\x85\n\n";

	if (clanring_playmode & CLANRING_CA_MODE)
	{
		if (clanring_playmode & CLANRING_WIPEOUT_MODE)
			menu_text[1] = "\n\x85Clan Arena (Wipeout)\x85\n\n";
		else
			menu_text[1] = "\n\x85Clan Arena\x85\n\n";
		menu_text[2] = "\nchoose a team\n\n";
		menu_text[3] = "\x13 blue   \n\x14 red    \n\x15 yellow \n\x16 green  \n";
		menu_text[4] = "\n\x17 leave team\n";
	}
	else if (clanring_playmode & CLANRING_RA_MODE)
	{
		menu_text[1] = "\n\x85Rocket Arena\x85\n\n";
		menu_text[3] = "\n\x13 to join\n\n";
		menu_text[4] = "\n\x17 spectate\n";
	} 
	else if (clanring_playmode & CLANRING_DMM4_MODE)
	{
		menu_text[1] = "\n\x851v1 Duel\x85\n\n";
		menu_text[3] = "\n\x13 to join\n\n";
		menu_text[4] = "\n\x17 spectate\n";
	}
	else if (clanring_playmode & CLANRING_AIRSHOT_MODE)
	{
		menu_text[1] = "\n\x85Airshot Mode\x85\n\n";
		menu_text[2] = "You can only be damaged while in the air.\nThe higher off the ground, the more\ndamage you will take.\n";
		menu_text[3] = "\n\x13 blue   \n\x14 red    \n\x15 yellow \n\x16 green  \n";
		menu_text[4] = "\n\x17 spectate\n\n";

		if (playerrecord[0].statvalue > 0)
		menu_text[5] =	sprintf("\nAir Gib Streak: %s %s", ftos(rint(playerrecord[0].statvalue)), playerrecord[0].player);
		
		if (playerrecord2[0].statvalue > 0)
		menu_text[6] = sprintf("\nHighest Gib: %s %s", ftos(rint(playerrecord2[0].statvalue)), playerrecord2[0].player);
	}
	else if (clanring_playmode & CLANRING_MATCH_MODE)
	{
		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		{
			menu_text[1] = "\n\x85Competition Capture The Flag\x85\n\n";
			menu_text[2] = "\nchoose a team\n\n";
			menu_text[3] = "\n\x13 blue\n\n\x14 red \n";
			menu_text[4] = "\n\x17 leave team\n\n\x18 warm-up   \n";
		}
		else
		{
			menu_text[1] = "\n\x85Competition Team DeathMatch\x85\n\n";
			menu_text[2] = "\nchoose a team\n\n";
			menu_text[3] = "\x13 blue   \n\x14 red    \n\x15 yellow \n\x16 green  \n";
			menu_text[4] = "\n\x17 leave team\n\n\x18 warm-up   \n";
		}
	}
	else
	{
        if (clanring_playmode & CLANRING_PRACTICE_MODE)
		{
            menu_text[1] = "\n\x85Practice\x85\n\n";
			menu_text[3] = "\n\x13 to join\n\n\n\x17 spectate\n";	
		}
		else
		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		{
			menu_text[1] = "\n\x85PickUp Capture The Flag\x85\n\n";
			menu_text[2] = "\nchoose a team\n\n";
			menu_text[3] = "\x13 blue\n\n\x14 red \n\n\x17 spectate\n";	
		}
		else
        if (clanring_playmode & CLANRING_NORMAL_MODE)
		{
            menu_text[1] = "\n\x85Free For All Deathmatch\x85\n\n";
			menu_text[3] = "\n\x13 to join\n\n\n\x17 spectate\n";	
		}
	}
};

void ()menu_print =
{	
	if (self.style & CLANRING_AFK_CLIENT)
		return;

	if (!(self.style & CLANRING_CONNECTED))
		return;
	
	if (clanring_state & CLANRING_MATCH_PAUSED)//this deters buffer overflow errors
		return;
		
	if (intermission_running) // is the menu even posted in pub mode?
		return;

	if (self.ca_player_flag == PF_PLAYING) //R00k: 6/12/2017 9:50AM (airshot practice)
		return;

	if (prematch_rules()) // belay the menu when countdown is displayed
		return;

	if ((mode_is_arena()) && (boss.state != CA_MATCH_WAITING))	// Arena match in progress
	{
		//self.style = self.style - (self.style & CLANRING_MENU); //test if countdown started but stopped we wont see the menu
		return;
	}

	if (!(self.style & CLANRING_OBSERVER))
	{
		self.style = self.style - (self.style & CLANRING_MENU);
		return;
	}

	if (clanring_state & CLANRING_MATCH_STARTED)				// Competition Match in progress
	{
		self.style = self.style - (self.style & CLANRING_MENU);
		return;
	}

	if (self.next_team != world)
	{
		if (clanring_playmode & CLANRING_MATCH_MODE)
		{
			local string q = "", p = "", rg = "", rn = "", five = "", six = "";
			menu_text[5]= "";menu_text[6]= ""; menu_text[2]= "";

			if (self.style & CLANRING_READY)
			menu_text[2]= sprintf("\n\bready!\n\b\nghostcode %s\n\n",strings_ftos_gold(self.owner.count));

			five = strzone(sprintf("\n\nMatch TimeLimit: %s",strings_ftos_gold(clanring_timelimit)));

			if (clanring_playmode & CLANRING_NO_QUAD)
				q = "\bOFF\b"; else q ="ON";
			if (clanring_playmode & CLANRING_NO_PENT)
				p = "\bOFF\b"; else p ="ON";
			if (clanring_playmode & CLANRING_NO_RING)
				rg = "\bOFF\b"; else rg ="ON";
			if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
			{
				if (clanring_playmode & CLANRING_RUNES)
					rn = "ON"; else rn ="\bOFF\b";
				six = strzone(sprintf("\n\nQuad: %s Pent: %s Ring: %s Runes: %s",q,p,rg,rn));
			}
			else
				six = strzone(sprintf("\n\nQuad: %s Pent: %s Ring: %s",q,p,rg));
			menu_text[5]= five;
			menu_text[6]= six;
			centerprint6 (self, menu_text[0], menu_text[1], menu_text[2], menu_text[4], menu_text[5], menu_text[6]);//, menu_text[7]);
			strunzone(five);strunzone(six);
			menu_text[5]= "";menu_text[6]= ""; menu_text[2]= "";
		}
		else
			centerprint6 (self, menu_text[0], menu_text[1], menu_text[4], menu_text[5], menu_text[6], menu_text[7]);
	}
	else
		centerprint7 (self, menu_text[0], menu_text[1], menu_text[2], menu_text[3], menu_text[5], menu_text[6], menu_text[7]);
};
