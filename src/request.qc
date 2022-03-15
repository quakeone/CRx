/*
	request.qc

	polling functions

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

void(float ballot) Request_Poll_Tally =
{
	local entity	bingo;
	local float	vcount = 0, pcount = 0;

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
			pcount += 1;

			if (bingo.vote == ballot)
				vcount += 1;

			bingo = find(bingo, classname, "player");
		}

		if (vcount >= (pcount * 0.51))
		{
			clanring_request.touch();
			sound(world, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_NONE);
			Request_Poll_Cleanup();
		}
	}
	else
	{
		if (ballot == 2)	// no vote
		{
			while (bingo)
			{
				pcount += 1;

				if (bingo.vote == ballot)
					vcount += 1;

				bingo = find(bingo, classname, "player");
			}

			if (vcount >= (pcount * 0.51))
			{
				clanring_request.nextthink = -99;
				clanring_request.think = SUB_Null;

				sound(world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
				bprint("The request was declined.\n");
				Request_Poll_Cleanup();
			}
		}
		else
			bprint("Request_Poll_Tally: Invalid Ballot\n");
	}
};

void(entity player, float cast) Request_Poll_Vote =
{
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
				clanring_request.nextthink = -99;
				clanring_request.think = SUB_Null;
				sound(world, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
				bprint("The request was cancelled.\n");
				Request_Poll_Cleanup();
				return;
			}
		}
		else
		{
			if (player != clanring_request.owner)
				sprint(player, "You already voted.\n");
			return;
		}
	}
	player.vote = cast;

	if (player != clanring_request.owner)
		bprint(player.netname, " voted.\n");

	Request_Poll_Tally(cast);
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

//this keeps it tied into crmod just fine...
float (string s1, string s2, void() accept) vote_init =
{
    clear_afk_status(self);	//R00k: (1/3/2022 12:54pm)

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
	clanring_request.noise1 = strzone(s1);
	clanring_request.noise2 = strzone(s2);
//	clanring_request.classname = pollname;			// We can use the classname to determine criteria for certain requests.
	clanring_request.nextthink = time + 10;			// Announce the request every 10 seconds.
	clanring_request.think = Request_Poll_Announce;
	clanring_request.health = 60;					// This will be the time-limit for how long to wait for everyone to cast a vote.
	clanring_request.touch = accept;				// Call this function if the poll is positive

	Request_Poll_Vote(self, 1);						// The person who starts the request votes yes. Let's tally votes now...
																			
	if (clanring_request)							// ...if there is only one player on the server then there is no need to announce the vote. The tally above would have passed and removed the clanring_request.
	{
		sound(world, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);
		bprint(clanring_request.owner.netname, " requests to ", clanring_request.noise1, clanring_request.noise2, "\n");
		bprint("\nType \byes\b or \bno\b in console to cast your vote.\n\n");
	}
	return TRUE;
};