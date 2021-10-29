float (string s1, string s2, void() accept) vote_init;
void() votables_request_change_level;
void() client_select_warp;

void() warp_menu_top =
{
	sprint(self, "Ÿ\n");
	sprint(self, " 1 Doomed Dimension      \bepisode 1\n");
	sprint(self, " 2 Realm of Black Magic  \bepisode 2\n");
	sprint(self, " 3 Netherworld           \bepisode 3\n");
	sprint(self, " 4 Elder World           \bepisode 4\n");
	sprint(self, " 5 id Deathmatch Arenas\n");
	sprint(self, " 6 Threewave CTF Levels Pak 1\n");
	sprint(self, " 7 Threewave CTF Levels Pak 2\n");
	sprint(self, " 8 League Of Capture\n");
	sprint(self, " 9 Jur4ss1c Map Pak\n");
	sprint(self, "10 CTF Gold Pak\n");
	sprint(self, "11 Custom Maps\n");	
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map category\n");
};

void() warp_menu_one =
{
	sprint(self, "Ÿ\n");
	sprint(self, "  Slipgate Complex      \be1m1\n");
	sprint(self, "  Castle of the Damned  \be1m2\n");
	sprint(self, "  Necropolis            \be1m3\n");
	sprint(self, "  Grisly Grotto         \be1m4\n");
	sprint(self, "  Gloom Keep            \be1m5\n");
	sprint(self, "  Door To Chthon        \be1m6\n");
	sprint(self, "  House of Chthon       \be1m7\n");
	sprint(self, "  Ziggurat Vertigo      \be1m8\n");
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_two=
{
	sprint(self, "Ÿ\n");
	sprint(self, "  Installation          \be2m1\n");
	sprint(self, "  Ogre Citadel          \be2m2\n");
	sprint(self, "  Crypt of Decay        \be2m3\n");
	sprint(self, "  Ebon Fortress         \be2m4\n");
	sprint(self, "  Wizard's Manse        \be2m5\n");
	sprint(self, "  Dismal Oubliette      \be2m6\n");
	sprint(self, "  Underearth            \be2m7\n");
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_three=
{
	sprint(self, "Ÿ\n");
	sprint(self, "  Termination Central   \be3m1\n");
	sprint(self, "  Vaults of Zin         \be3m2\n");
	sprint(self, "  Tomb of Terror        \be3m3\n");
	sprint(self, "  Satan's Dark Delight  \be3m4\n");
	sprint(self, "  Wind Tunnels          \be3m5\n");
	sprint(self, "  Chambers of Torment   \be3m6\n");
	sprint(self, "  Haunted Halls         \be3m7\n");
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_four=
{
	sprint(self, "Ÿ\n");
	sprint(self, "  Sewage System         \be4m1\n");
	sprint(self, "  Tower of Despair      \be4m2\n");
	sprint(self, "  Elder God Shrine      \be4m3\n");
	sprint(self, "  Palace of Hate        \be4m4\n");
	sprint(self, "  Hell's Atrium         \be4m5\n");
	sprint(self, "  Pain Maze             \be4m6\n");
	sprint(self, "  Azure Agony           \be4m7\n");
	sprint(self, "  Nameless City         \be4m8\n");
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_five=
{
	sprint(self, "Ÿ\n");
	sprint(self, "  Place of Two Deaths   \bdm1\n");
	sprint(self, "  Claustrophobopolis    \bdm2\n");
	sprint(self, "  Abandoned Base        \bdm3\n");
	sprint(self, "  Bad Place             \bdm4\n");
	sprint(self, "  Cistern               \bdm5\n");
	sprint(self, "  Dark Zone             \bdm6\n");
	sprint(self, " ™ Start                 \bstart\n");
	sprint(self, " ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_six =
{
	sprint(self, "Ÿ\n");
	sprint(self," “ McKinley Base          \bctf1\n");
	sprint(self," ” The Kiln               \bctf2\n");
	sprint(self," • DySpHoRiA              \bctf3\n");
	sprint(self," – The Forgotten Mines    \bctf4\n");
	sprint(self," — Da Ancient War Grounds \bctf5\n");
	sprint(self," ˜ Vertigo Dale           \bctf6\n");
	sprint(self," ™ Tale of Two Cities     \bctf7\n");
	sprint(self," š The StrongBox          \bctf8\n");
	//sprint(self," › \n");
	sprint(self," ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self," select map\n");
};

void() warp_menu_seven=
{
	sprint(self,"Ÿ\n");
	sprint(self," “ McKinley Station     \bctf2m1\n");
	sprint(self," ” The Warzone          \bctf2m2\n");
	sprint(self," • Spill the Blood      \bctf2m3\n");
	sprint(self," – Ruins of NeoMinonk   \bctf2m4\n");
	sprint(self," — Disciple War Grounds \bcft2m5\n");
	sprint(self," ˜ The Two Towers       \bctf2m6\n");
	sprint(self," ™ Gloom Castles        \bctf2m7\n");
	sprint(self," š Capturephobolis      \bctf2m8\n");
	//sprint(self," › \n");
	sprint(self," ’ \bEXIT\n");
	sprint(self,"Ÿ\n");
	sprint(self," select map\n");
};

void() warp_menu_eight=
{
	sprint(self, "Ÿ\n");
	sprint(self," “ Remix                  \bctf3m1\n");
	sprint(self," ” Red Alert              \bctf3m2\n");
	sprint(self," • Stop the Flow          \bctf3m3\n");
	sprint(self," – Nameless Mines         \bctf3m4\n");
	sprint(self," — Egyptian Pig Factory   \bctf3m5\n");
	sprint(self," ˜ Terra Firma            \bctf3m6\n");
	sprint(self," ™ The Dark Age           \bctf3m7\n");
	sprint(self," š The Place of Two Bases \bctf3m8\n");
	sprint(self," › The CHEAT Complex 2:   \bctf3m9\n");
	sprint(self," ’ \bEXIT\n");
	sprint(self, "Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_nine=
{
	sprint(self,"Ÿ\n");
	sprint(self," “ Ba-Boom!                \bboom\n");
	sprint(self," ” Ka-Boom!                \bkaboom\n");
	sprint(self," • CTF9                    \bctf9\n");
	sprint(self," – McKinley Revival        \bq2ctf12\n");
	sprint(self," — The Forgotten Outpost   \bfgoutpost\n");
	sprint(self," ˜ The Mystic Shrine       \belder\n");
	sprint(self," ™ Strongholds in the Hale \bctf_desert\n");
	sprint(self," š U.S.S. Starbridge       \bctf_space\n");
	sprint(self," › Pig Remix               \bpigremix\n");
	sprint(self," ’ \bEXIT\n");
	sprint(self,"Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_ten=
{
	sprint(self,"Ÿ\n");
	sprint(self," “ The Mess Hall          \bCtfgold1\n");
	sprint(self," ” Badical Bunkers        \bCtfgold2\n");
	sprint(self," • Arax                   \bCtfgold3\n");
	sprint(self," – Installaflagus         \bCtfgold4\n");
	sprint(self," – Elder Quad Shrine      \bCtfgold5\n");
	sprint(self," – The Capture Zone       \bCtfgold6\n");
	sprint(self," ™ Flags n' Frags         \bCtfgold7\n");
	sprint(self," š Abandoned Dungeon      \bCtfgold8\n");
	sprint(self," ’ \bEXIT\n");
	sprint(self,"Ÿ\n");
	sprint(self, " select map\n");
};

void() warp_menu_eleven=
{
	local float index;
	local string name,number;

	sprint(self,"\n");
	index = 0;
	while ((index < 10))
	{
		name = array_user_map[index];
		number = strings_ftos_gold((index+1));
		if ((name != ""))
		{
			//sprint3(self, " ", name, "\n");
			sprint3(self," ",number," ",name,"\n");
		}
		index = (index + 1);
	}

	sprint(self," ’ \bEXIT\n");
	sprint(self, "\n");
	sprint(self, "select map\n");
};

/*
void() warp_menu_ten=
{
sprint(self,"\n");
sprint(self," “ \n");
sprint(self," ” \n");
sprint(self," • \n");
sprint(self," – \n");
sprint(self," — \n");
sprint(self," ˜ \n");
sprint(self," ™ \n");
sprint(self," š \n");
sprint(self," › \n");
sprint(self," ’ \bEXIT\n");
sprint(self, "\n");
sprint(self, "select map\n");
};

void() warp_menu_eleven=
{
sprint(self,"\n");
sprint(self," “ \n");
sprint(self," ” \n");
sprint(self," • \n");
sprint(self," – \n");
sprint(self," — \n");
sprint(self," ˜ \n");
sprint(self," ™ \n");
sprint(self," š \n");
sprint(self," › \n");
sprint(self," ’ \bEXIT\n");
sprint(self, "\n");
sprint(self, "select map\n");
};
*/

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
		if (self.finaldest_z==1)
		{
			self.warp_map=1;
			client_select_warp();
		}
		else
		{
			if (self.finaldest_z==2)
			{
				self.warp_map=2;
				client_select_warp();
			}
			else
			{
				if (self.finaldest_z==3)
				{
					self.warp_map=3;
					client_select_warp();
				}
				else
				{
					if (self.finaldest_z==4)
					{
						self.warp_map=4;
						client_select_warp();
					}
					else
					{
						if (self.finaldest_z==5)
						{
							self.warp_map=5;
							client_select_warp();
						}
						else
						{
							if (self.finaldest_z==6)
							{
								self.warp_map=6;
								client_select_warp();
							}
							else
							{
								if (self.finaldest_z==7)
								{
									self.warp_map=7;
									client_select_warp();
								}
								else
								{
									if (self.finaldest_z==8)
									{
										self.warp_map=8;
										client_select_warp();
									}
									else
									{
										if (self.finaldest_z==9)
										{
											self.warp_map=9;
											client_select_warp();
										}
										else
										{
											if (self.finaldest_z==10)
											{
												self.warp_map=10;
												client_select_warp();
											}
											else
											{
												if (self.finaldest_z==11)
												{
													self.warp_map=11;
													client_select_warp();
												}
												else
												{
													sprint(self,"\bcanceled\n");
													self.use=SUB_Null;
													self.warp_map=0;
													self.warp_episode=0;
												}
											}//11
										}//10
									}//9
								}//8
							}//7
						}//6
					}//5
				}//4
			}//3
		}//2
	}//1
	self.use=SUB_Null;
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
		if (self.finaldest_z==1)
		{
			warp_menu_one();
			self.warp_episode=1;
			self.use=select_map;
		}

		else
		{
			if (self.finaldest_z==2)
			{
				warp_menu_two();
				self.warp_episode=2;
				self.use=select_map;
			}

			else
			{
				if (self.finaldest_z==3)
				{
					warp_menu_three();
					self.warp_episode=3;
					self.use=select_map;
				}

				else
				{
					if (self.finaldest_z==4)
					{
						warp_menu_four();
						self.warp_episode=4;
						self.use=select_map;
					}

					else
					{
						if (self.finaldest_z==5)
						{
							warp_menu_five();
							self.warp_episode=5;
							self.use=select_map;
						}

						else
						{
							if (self.finaldest_z==6)
							{
								warp_menu_six();
								self.warp_episode=6;
								self.use=select_map;
							}
							else
							{
								if (self.finaldest_z==7)
								{
									warp_menu_seven();
									self.warp_episode=7;
									self.use=select_map;
								}
								else
								{
									if (self.finaldest_z==8)
									{
										warp_menu_eight();
										self.warp_episode=8;
										self.use=select_map;
									}
									else
									{
										if (self.finaldest_z==9)
										{
											warp_menu_nine();
											self.warp_episode=9;
											self.use=select_map;
										}
										else
										{
											if (self.finaldest_z==10)
											{
												warp_menu_ten();
												self.warp_episode=10;
												self.use=select_map;
											}
											else
											{
												if (self.finaldest_z==11)
												{
													warp_menu_eleven();
													self.warp_episode=11;
													self.use=select_map;
												}
												else
												{	
													sprint(self,"canceled\n");
													self.use=SUB_Null;
													self.warp_episode=0;
													return;
												}
											}
										}
									}//1
								}//2
							}//3
						}//4
					}//5
				}//6
			}//7
		}//8
	}//9
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
		self.warp_map=(self.finaldest_z);
		votables_request_change_level();
	}
};

/*
ctf3m1  Remix                           Eben 'dungo' Gulick <dungo@buckeyeweb.com>
ctf3m2  Red Alert                       Jason 'Evil G' Boyadjian <evilg@shaw.wave.ca>
ctf3m3  Stop the Flow                   Curtis 'Lord Kalvin' Smith <curtis@winternet.com>
ctf3m4  Nameless Mines                  Bob 'Forrest' Forrest <rcoulomb@total.net>
ctf3m5  Egyptian Pig Factory            Andrew 'Ziggurat' Knight <sleak@bconnex.net>
ctf3m6  Terra Firma                     Repo <crm@xxist.com>
ctf3m7  The Dark Age                    Jason 'Evil G' Boyadjian <evilg@shaw.wave.ca>
ctf3m8  The Place of Two Bases          Tapio 'Tapz' Haaja <tapio.haaja@mbnet.fi>
ctf3m9  The CHEAT Complex 2: Barkfalls  Eben 'dungo' Gulick <dungo@buckeyeweb.com>

ctf1 - McKinley Base Dave "Zoid" Kirsch
ctf2 - The Kiln Brian Wight
ctf3 - DySpHoRiA Chris "b0rt" Thibodeaux
ctf4 - The Forgotten Mines Brian Wight
cft5 - Da Ancient War Grounds Matthew "DaBug" Hopper
ctf6 - Vertigo Dale "Midiguy" Bertheola
ctf7 - Tale of Two Cities Jamie MacTaggart
ctf8 - The StrongBox Brent "[Drizzt" McLeod

ctf2m1 - McKinley Station Dave "Zoid" Kirsch
ctf2m2 - The Warzone John "Tattoo" Schultz
ctf2m3 - Spill the Blood Dale "Midiguy" Bertheola
ctf2m4 - Ruins of NeoMinonk Ogre "El_Ergo" De Latoya
cft2m5 - Disciple War Grounds Hexadecimal
ctf2m6 - The Two Towers Alexander Bernecker
ctf2m7 - Gloom Castles Tim Willits
ctf2m8 - Capturephobolis American McGee
*/


