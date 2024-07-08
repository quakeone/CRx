/*
    ---------------------------------------------------
    G A M E O V E R   N E X T M A P   V O T E   M E N U
    ---------------------------------------------------
*/

string (float n) VoteMenu_get_map_by_number =
{
	if ((n != 0) && ((strlen(warpmap[n].name) != 0)) && (n <= (WARP_CATEGORY_SIZE * WARP_MAPLIST_SIZE)))
	{
		return (sprintf("%s %s",warpmap[n].name, substring(warpmap[n].title, 0, 20)));
	}	
	return (sprintf("%s %s",warpmap[n - 5].name, warpmap[n - 5].title));//go back a few if we are at the end...
};

float (string maparg) VoteMenu_get_index_for_map =
{
	for (float index = 1 ; index <= (WARP_CATEGORY_SIZE * WARP_MAPLIST_SIZE) ; index += 1)
	{
		if (warpmap[index].name != "" && warpmap[index].name == maparg)
			return index;
	}	
	return 0;
};

//
// V o t e M e n u  G e t  M a p   b y   N a m e
//
// returns a string with mapname and title from the warpmap array, ex: "DM3 The Abandoned Base"
//
string (string maparg) VoteMenu_get_map_by_name =
{
	for (float index = 1 ; index <= (WARP_CATEGORY_SIZE * WARP_MAPLIST_SIZE) ; index += 1)
	{
		if (warpmap[index].name != "" && warpmap[index].name == maparg)
		{
			return (sprintf("%s %s",substring(warpmap[index].name, 0, 16), substring(warpmap[index].title, 0, 19)));
		}
	}	
	return "Invalid (VoteMenu_get_map_by_name)";
};

string VOTE_MENU_TEXTLINE[12];

void () VoteMenu_Cleanup = 
{
	strunzone(vote_map_choices[0]);
	strunzone(vote_map_choices[1]);
	strunzone(vote_map_choices[2]);
	strunzone(vote_map_choices[3]);
	strunzone(vote_map_choices[4]);
	strunzone(vote_map_choices[5]);

	strunzone(VOTE_MENU_TEXTLINE[1]);
	strunzone(VOTE_MENU_TEXTLINE[2]);
	strunzone(VOTE_MENU_TEXTLINE[3]);
	strunzone(VOTE_MENU_TEXTLINE[4]);
	strunzone(VOTE_MENU_TEXTLINE[5]);

	strunzone(VOTE_MENU_TEXTLINE[7]);
	strunzone(VOTE_MENU_TEXTLINE[8]);
	strunzone(VOTE_MENU_TEXTLINE[9]);
	strunzone(VOTE_MENU_TEXTLINE[10]);
	strunzone(VOTE_MENU_TEXTLINE[11]);
}

//
//	V O T E   M E N U   I N I T 
//
//	Initialize all the wacky strings to construct the menu
//
void () VoteMenu_Init =
{
	string	nextmap_textline1 = VoteMenu_get_map_by_name(nextmap);						// Grab the filename and title for the `nextmap` of levels.cfg.
	float	nindex = VoteMenu_get_index_for_map(nextmap);								// Find it's placement in the warpmaps array.
	string 	nextmap_textline2 = (VoteMenu_get_map_by_number(nindex + 1));				// From the warpmap array, get the next entry in line
	string 	nextmap_textline3 = (VoteMenu_get_map_by_number(nindex + 2));			    // ...
	string 	nextmap_textline4 = (VoteMenu_get_map_by_number(nindex + 3));				// ...
	string 	nextmap_textline5 = (VoteMenu_get_map_by_number(nindex + 4));				// for the next four maps.

	vote_map_choices[0] = strzone(nextmap_textline1); //default
	vote_map_choices[1] = strzone(nextmap_textline1);
	vote_map_choices[2] = strzone(nextmap_textline2);
	vote_map_choices[3] = strzone(nextmap_textline3);
	vote_map_choices[4] = strzone(nextmap_textline4);
	vote_map_choices[5] = strzone(nextmap_textline5);

	VOTE_MENU_TEXTLINE[0] = "\(\=\=\=\=\=\= Vote for the Next Map \=\=\=\=\=\=\)\n\n\n";
	VOTE_MENU_TEXTLINE[1] = "  \1 A\n\n";
	VOTE_MENU_TEXTLINE[2] = "  \2 A\n\n";
	VOTE_MENU_TEXTLINE[3] = "  \3 A\n\n";
	VOTE_MENU_TEXTLINE[4] = "  \4 A\n\n";
	VOTE_MENU_TEXTLINE[5] = "  \5 A\n\n";
	VOTE_MENU_TEXTLINE[6] = "\n\n";

	VOTE_MENU_TEXTLINE[1] = strreplace("A", (strpad(31, nextmap_textline1)), VOTE_MENU_TEXTLINE[1]);
	VOTE_MENU_TEXTLINE[7] = redify(VOTE_MENU_TEXTLINE[1]);

	VOTE_MENU_TEXTLINE[2] = strreplace("A", (strpad(31, nextmap_textline2)), VOTE_MENU_TEXTLINE[2]);
	VOTE_MENU_TEXTLINE[8] = redify(VOTE_MENU_TEXTLINE[2]);

	VOTE_MENU_TEXTLINE[3] = strreplace("A", (strpad(31, nextmap_textline3)), VOTE_MENU_TEXTLINE[3]);
	VOTE_MENU_TEXTLINE[9] = redify(VOTE_MENU_TEXTLINE[3]);

	VOTE_MENU_TEXTLINE[4]  = strreplace("A", (strpad(31, nextmap_textline4)), VOTE_MENU_TEXTLINE[4]);
	VOTE_MENU_TEXTLINE[10] = redify(VOTE_MENU_TEXTLINE[4]);

	VOTE_MENU_TEXTLINE[5]  = strreplace("A", (strpad(31, nextmap_textline5)), VOTE_MENU_TEXTLINE[5]);
	VOTE_MENU_TEXTLINE[11] = redify(VOTE_MENU_TEXTLINE[5]);

	VOTE_MENU_TEXTLINE[1] = strzone(VOTE_MENU_TEXTLINE[1]);
	VOTE_MENU_TEXTLINE[2] = strzone(VOTE_MENU_TEXTLINE[2]);
	VOTE_MENU_TEXTLINE[3] = strzone(VOTE_MENU_TEXTLINE[3]);
	VOTE_MENU_TEXTLINE[4] = strzone(VOTE_MENU_TEXTLINE[4]);
	VOTE_MENU_TEXTLINE[5] = strzone(VOTE_MENU_TEXTLINE[5]);

	VOTE_MENU_TEXTLINE[7]  = strzone(VOTE_MENU_TEXTLINE[7]);
	VOTE_MENU_TEXTLINE[8]  = strzone(VOTE_MENU_TEXTLINE[8]);
	VOTE_MENU_TEXTLINE[9]  = strzone(VOTE_MENU_TEXTLINE[9]);
	VOTE_MENU_TEXTLINE[10] = strzone(VOTE_MENU_TEXTLINE[10]);
	VOTE_MENU_TEXTLINE[11] = strzone(VOTE_MENU_TEXTLINE[11]);
};

.float centerTime;

void () VoteMenu_Print =
{	
	if (self.style & CLANRING_AFK_CLIENT)
		return;

	if (!(self.style & CLANRING_CONNECTED))
		return;
	
	if (self.centerTime <= time)
	{
		pqc_match_time (0, (floor(intermission_exittime - time)));

		centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);

		switch (self.warp_map)
		{
			case 1: 
				centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[7], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);
				break;
			case 2: 
				centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[8], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);
				break;
			case 3: 
				centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[9], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);
				break;
			case 4: 
				centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[10], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);
				break;
			case 5: 
				centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[11], VOTE_MENU_TEXTLINE[6]);
				break;
		}
		self.centerTime = time + 1;
	}
}

//eof
