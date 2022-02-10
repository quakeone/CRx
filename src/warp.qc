//
// W A R P . Q C
//
// Server supported maps menu used for voting changelevel
//

float (string s1, string s2, void() accept) vote_init;
void(optional string requestmap) votables_request_change_level;
void() client_select_warp;

void() warp_menu_top =
{
	local float index = 0;
	local string number;
	
	sprint(self,"Ÿ\n");
	for (index = 0 ; index < 9 ; index += 1)
	{
		number = strings_ftos_gold(index+1);
		if (warpmenutop[index] != "")
		{
			sprint(self,(sprintf(" %s %s\n", number, warpmenutop[index])));
		}
	}
	sprint(self,"Ÿ\n");
	sprint(self," ’ \bEXIT\n");
	sprint(self, "\n");
	sprint(self, " select map category\n");
};

void() warp_show_map_menu =
{
	local float index = 0;
	local float n = 0;
	local string number, name;
	
	sprint(self,"Ÿ\n");
	for (index = 1 ; index < 10 ; index += 1)
	{
		n = (self.warp_episode * 10) + index;
		number = strings_ftos_gold(index);
		if (warpmap[n].name != "")
		{
			name = strconv(0,2,2,warpmap[n].name);
			sprint(self,(sprintf(" %s %-24s %-8s %-24s\n",number, warpmap[n].title, name, warpmap[n].author)));
		}
	}
	sprint(self,"Ÿ\n");
	sprint(self," ’ \bEXIT\n");
	sprint(self, "\n");
	sprint(self, "select map\n");
};

void() select_map =
{
	if (!(self.impulse >= 230) && (self.impulse <= 245)) return;

	if ((self.finaldest_z==0)&&(self.warp_map==0))
	{
		sprint(self,"\bCanceled\n");
		self.use=SUB_Null;
		self.warp_map=0;
		self.warp_episode=0;
	}
	else
	{
		self.use = SUB_Null;
		self.warp_map = self.finaldest_z;
		client_select_warp();// go back here just to check if the match started
	}
};

void() select_episode =
{
	if ((self.finaldest_z==0)&&(self.warp_episode==0))
	{
		sprint(self,"\bCanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}
	else
	{
		self.warp_episode = self.finaldest_z;
		self.use = select_map;
		warp_show_map_menu();
	}
};

void() client_select_warp =
{
	if (clanring_levelcount != -1)
	{
		sprint(self, "Wait for map to initialize\n");
		sprint(self,"\bcanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}

	if (clanring_state & CLANRING_MATCH_STARTED)
	{
		sprint(self, "Cannot change level while match is in progress.\n");
		sprint(self,"\bcanceled\n");
		self.use=SUB_Null;
		self.warp_episode=0;
		self.warp_map=0;
		return;
	}

	if (!self.warp_episode)
	{
		warp_menu_top();
		self.use=select_episode;
	}

	if (self.warp_map)
	{
		votables_request_change_level();
	}
};
