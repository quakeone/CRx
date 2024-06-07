/*
    ---------------------------------------------------
    G A M E O V E R   N E X T M A P   V O T E   M E N U
    ---------------------------------------------------

	June 2024
*/

string (float n) VoteMenu_get_map_by_number =
{
	if ((n != 0) && ((strlen(warpmap[n].name) != 0)) && (n <= (WARP_CATEGORY_SIZE * WARP_MAPLIST_SIZE)))
	{
		return (sprintf("%s %s",warpmap[n].name, warpmap[n].title));
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
			return (sprintf("%s %s",warpmap[index].name, warpmap[index].title));
		}
	}	
	return "Invalid (VoteMenu_get_map_by_name)";
};

string VOTE_MENU_TEXTLINE[12];

//
//	V O T E   M E N U   I N I T 
//
//	Initialize all the wacky strings to construct the menu
//
void() VoteMenu_Init =
{
	string	nextmap_textline1 = VoteMenu_get_map_by_name(nextmap);						// Grab the filename and title for the `nextmap` of levels.cfg.
	float	nindex = VoteMenu_get_index_for_map(nextmap);								// Find it's placement in the warpmaps array.
	string 	nextmap_textline2 = (VoteMenu_get_map_by_number(nindex + 1));				// From the warpmap array, get the next entry in line
	string 	nextmap_textline3 = (VoteMenu_get_map_by_number(nindex + 2));			    // ...
	string 	nextmap_textline4 = (VoteMenu_get_map_by_number(nindex + 3));				// ...
	string 	nextmap_textline5 = (VoteMenu_get_map_by_number(nindex + 4));				// for the next four maps.

	map_choices[1] = 1;	//1 vote for default nextmap from levels.cfg

	vote_map_choices[0] = nextmap_textline1;//default
	vote_map_choices[1] = nextmap_textline1;
	vote_map_choices[2] = nextmap_textline2;
	vote_map_choices[3] = nextmap_textline3;
	vote_map_choices[4] = nextmap_textline4;
	vote_map_choices[5] = nextmap_textline5;

	VOTE_MENU_TEXTLINE[0] = "\(\=\=\=\=\=\= Vote for the Next Map \=\=\=\=\=\=\)\n\n\n";

	VOTE_MENU_TEXTLINE[1] = "  \1 A\n\n";
	VOTE_MENU_TEXTLINE[2] = "  \2 A\n\n";
	VOTE_MENU_TEXTLINE[3] = "  \3 A\n\n";
	VOTE_MENU_TEXTLINE[4] = "  \4 A\n\n";
	VOTE_MENU_TEXTLINE[5] = "  \5 A\n\n\n";

	VOTE_MENU_TEXTLINE[6] = "\n\nPress \6 to clear your vote\n\n\n\(\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\)\n";

	VOTE_MENU_TEXTLINE[1] = strreplace("A", (strpad(31, nextmap_textline1)), VOTE_MENU_TEXTLINE[1]);
	VOTE_MENU_TEXTLINE[7] = VOTE_MENU_TEXTLINE[1];
	VOTE_MENU_TEXTLINE[2] = strreplace("A", (strpad(31, nextmap_textline2)), VOTE_MENU_TEXTLINE[2]);
	VOTE_MENU_TEXTLINE[8] = VOTE_MENU_TEXTLINE[2];
	VOTE_MENU_TEXTLINE[3] = strreplace("A", (strpad(31, nextmap_textline3)), VOTE_MENU_TEXTLINE[3]);
	VOTE_MENU_TEXTLINE[9] = VOTE_MENU_TEXTLINE[3];
	VOTE_MENU_TEXTLINE[4] = strreplace("A", (strpad(31, nextmap_textline4)), VOTE_MENU_TEXTLINE[4]);
	VOTE_MENU_TEXTLINE[10] = VOTE_MENU_TEXTLINE[4];
	VOTE_MENU_TEXTLINE[5] = strreplace("A", (strpad(31, nextmap_textline5)), VOTE_MENU_TEXTLINE[5]);
	VOTE_MENU_TEXTLINE[11] = VOTE_MENU_TEXTLINE[5];
};

.float centerTime;

void() VoteMenu_Print =
{	
	if (self.style & CLANRING_AFK_CLIENT)
		return;

	if (!(self.style & CLANRING_CONNECTED))
		return;
	
	string tstring = "";

	if (self.centerTime < time)
	{
		float n = 0;

		n = floor(intermission_exittime - time);
		
		tstring = sprintf("time left : %g", n);

		VOTE_MENU_TEXTLINE[6] = strcat(tstring, "\n\nPress \6 to clear your vote\n\n\n\(\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\)\n");	

		centerprint(self, VOTE_MENU_TEXTLINE[0], VOTE_MENU_TEXTLINE[1], VOTE_MENU_TEXTLINE[2], VOTE_MENU_TEXTLINE[3], VOTE_MENU_TEXTLINE[4], VOTE_MENU_TEXTLINE[5], VOTE_MENU_TEXTLINE[6]);

		self.centerTime = time + 1;
	}
}

//eof
