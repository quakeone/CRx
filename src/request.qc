/*
	request.qc

	polling functions - by R00k

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	See file, 'gnu_gpl.txt', for details.
*/

.float vote;    //client flag that holds their vote

void() Request_Poll_Cleanup =
{
	local entity trash_disco;	

	if (clanring_request)
	{
		// Reset these for completeness.
		clanring_request.owner = world;
        strunzone(clanring_request.noise1);
        clanring_request.noise1 = "";
        strunzone(clanring_request.noise2);
        clanring_request.noise2 = "";
		clanring_request.classname = "";
		clanring_request.nextthink = -99;
		clanring_request.think = SUB_Null;
		clanring_request.touch = SUB_Null;
		remove(clanring_request);
		clanring_request = world;
	}

	//Clear out the votes for this request.
	trash_disco = find(world, classname, "player");
	while (trash_disco)
	{
		trash_disco.vote = 0;
		trash_disco = find(trash_disco, classname, "player");
	}
};

float(float ballot) Request_Poll_Votes_Needed =
{
	local entity bingo;
	local float	vcount = 0, pcount = 0, votes_needed = 99;

	bingo = find(world, classname, "player");

	// What we are doing here is tallying up the votes pragmatically.
	// The vote will pass if there is a majority for yes, or no, immediately.
	// This way, we don't have to sit around for 45 seconds waiting for
	// the request to timeout if there is already a majority vote.
	// Although, it doesn't give players much time to change their vote...

	if (ballot == 1)		// yes vote
	{
		while (bingo)
		{
			if (bingo.style & CLANRING_CONNECTED)
			{
				if (bingo.style & CLANRING_AFK_CLIENT)
				{
					if (bingo.vote)	//count players that are afk and already voted 
					{
						pcount += 1;

						if ((bingo.vote == ballot) || (bingo == clanring_request.owner))
							vcount += 1;
					}
				}
				else
				{
					pcount += 1;

					if ((bingo.vote == ballot) || (bingo == clanring_request.owner))
						vcount += 1;
				}
			}
			bingo = find(bingo, classname, "player");
		}
		votes_needed = ceil((pcount * 0.51) - vcount);
	}
	else
	{
		if (ballot == 2)	// no vote
		{
			while (bingo)
			{
				if (bingo.style & CLANRING_CONNECTED)
				{
					if (bingo.style & CLANRING_AFK_CLIENT)
					{
						if (bingo.vote)	//count players that are afk and already voted 
						{
							pcount += 1;
	
							if (bingo.vote == ballot)
								vcount += 1;
						}
					}
					else
					{
						pcount += 1;
	
						if (bingo.vote == ballot)
							vcount += 1;
					}
				}
				bingo = find(bingo, classname, "player");
			}
	 		votes_needed = ceil((pcount * 0.51) - vcount);
	 	}
	 	else
	 		bprint("Request_Poll_Votes_Needed: Invalid Ballot\n");
	 }
	if (votes_needed < 1)
		return 0;
	else
		return votes_needed;
};

void(entity player, float cast) Request_Poll_Vote =
{
	local float votes_needed = 99;
	clear_afk_status(player);	//R00k

	if (clanring_request == world)
	{
		sprint(player, "There is nothing to vote on.\n");
		return;
	}

	if (player.vote)
	{
		if (player.vote != cast)											// They changed their mind...
		{
			if (player == clanring_request.owner)							// This person, who changed their mind, also started the request, so just cancel it.
			{
				sound(world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
				bprint(player.netname," cancelled their request.\n");
				Request_Poll_Cleanup();
				return;
			}
			else
			{
				bprint(player.netname, " flipped their vote.\n");
			}
		}
		else
		{
//			if (player != clanring_request.owner)
			{
				if (player.style & CLANRING_ADMINISTRATOR)					// So, an admin already voted, and now wishes to affirm their vote
				{
					bprint("\x90\bAdmin Forced\b\x91 ");
					
					if (cast == 1)
					{
						bprint("vote passed.\n");
						clanring_request.touch();
						sound(world, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_NONE);
					}
					else
					{
						bprint("The request was declined.\n");
						sound(world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
					}
					Request_Poll_Cleanup();
					return;
				}
				else
				{
					sprint(player, "You already voted.\n");
					return;
				}
			}
		}
	}

	player.vote = cast;

	if (player != clanring_request.owner)
	{
		if (cast == 1)
			bprint(player.netname, " voted \byes\b.\n");
		else if (cast == 2)
			bprint(player.netname, " voted \bno\b.\n");
	}

	if (cast == 1)
	{
		votes_needed = Request_Poll_Votes_Needed(cast);

		if (votes_needed == 0)// majority YES
		{
			bprint("\n");
			clanring_request.touch();
			sound(world, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_NONE);
			Request_Poll_Cleanup();
		}
		else
		{			
			if (player != clanring_request.owner)
			{
				if (player.style & CLANRING_ADMINISTRATOR)
				{
					sprint(player,"\x90\bWarning\b\x91: You are an admin, type \byes\b again to force this vote.\n");
				}
				if (votes_needed == 1)
					bprint(" \1 vote needed to \bpass\b.\n");
				else
					bprint3(" ", strings_ftos_gold(votes_needed), " votes needed to \bpass\b.\n");
			}
			return;
		}
	}
	else
	{
		if (cast == 2)
		{
			votes_needed = Request_Poll_Votes_Needed(cast);
			if (votes_needed == 0) // majority NO
			{
				bprint("\n");
				sound(world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
				bprint("The request was declined.\n");
				Request_Poll_Cleanup();
			}
			else if (player.style & CLANRING_ADMINISTRATOR)
			{
				sprint(player,"\x90\bWarning\b\x91: You are an admin, type \bno\b again to cancel this vote.\n");
			}
		}
	}
	bprint("\n");
};

void() Request_Poll_Announce =
{
	//self is the clanring_request
	
	self.health -= 10;

	if (self.health <= 0)
	{
		self.nextthink = -99;
		self.think = SUB_Null;

		bprint("The request has expired.\n");
		Request_Poll_Cleanup();
	}
	else
	{
		sound(world, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);

		bprint(self.owner.netname, " requests to ", self.noise1, self.noise2, "\n");
		bprint("\nType \byes\b or \bno\b in console to cast your vote.\n\n");

		self.nextthink = time + 10;
		self.think = Request_Poll_Announce;										// Doubt we have to refresh this but...
	}
};

float (string captiona, string captionb, void() passfunc, string pollname = "") vote_init =
{
    clear_afk_status(self);	//R00k: (1/3/2022 12:54pm)

/*TODO:
	if (clanring_playmode & CLANRING_DISABLE_VOTE)
	{
		sprint(self, "Voting has been disabled.\n");
		return FALSE;
	}
*/

	if (clanring_request)
	{
		sound (world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
		sprint(self, "A vote is already in progress.\n");		
		return FALSE;
	}

   	if ((self.style & CLANRING_OBSERVER) && (clanring_state & CLANRING_MATCH_STARTED))//R00k
	{
		sprint(self, "Observers cannot initiate votes during match.\n");
		return FALSE;
	}
	
	clanring_request = spawn();
	clanring_request.owner = self;
	clanring_request.noise1 = strzone(captiona);
	clanring_request.noise2 = strzone(captionb);
	clanring_request.classname = pollname;			// We can use the classname to determine criteria for certain requests.
	clanring_request.nextthink = time + 10;			// Announce the request every 10 seconds.
	clanring_request.think = Request_Poll_Announce;
	clanring_request.health = 50;					// This will be the time-limit for how long to wait for everyone to cast a vote.
	clanring_request.touch = passfunc;				// Call this function if the poll is positive

	if ((Request_Poll_Votes_Needed(1) > 0))					// if there is only one player on the server then there is no need to announce the vote.
	{
		sound(world, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);
		bprint(clanring_request.owner.netname, " requests to ", clanring_request.noise1, clanring_request.noise2, "\n");
		bprint("\nType \byes\b or \bno\b in console to cast your vote.\n\n");
	}
	return TRUE;
};