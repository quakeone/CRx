float (float numdeaths) get_wipeout_respawn =
{
	switch (numdeaths)
	{
		case 1:
			return 5;
		case 2:
			return 20;
		case 3:
			return 40;
		case 4:
			return 60;
		default:
			return 80;
	}
}

float (entity team1) wipeout_teammates_left =
{
	local entity e, tmp;
	local float n = 0;

	e = team1;

	while (e.chain_gang)
	{
        if (e.chain_gang.deadflag == DEAD_NO && (IS_CA_OBSERVER(e.chain_gang) == FALSE) && ((e.chain_gang.style & CLANRING_CONNECTED)))
		{
			n = n + 1;
		}
		else if ((e.chain_gang.deadflag != DEAD_NO) && (e.chain_gang.style & CLANRING_CONNECTED))
		{
			if ((time >= e.chain_gang.respawntime) && (boss.wait == 0))
			{
				tmp = self;
				self = e.chain_gang;
				observer_end ();
                bprint2(self.netname, " has respawned\n");
				self = tmp;
			}
		}
		e = e.chain_gang;
	}
	return n;
};

float () teams_not_wipedout =
{
	local float tn = 0, n = 0;
	local entity e;

	e = boss.next_team;

	while (e)
	{
		n = wipeout_teammates_left(e);
		if (n)
			tn = tn + 1;
		e.teamalive = n;
		e = e.next_team;
	}

	return tn;
};

void () wipeout_init_teamalive =
{
	local entity e;

	e = boss.next_team;

	while (e)
	{
		e.teamalive = number_teammates(e);
		e = e.next_team;
	}
};

entity (entity e, float spawnradius) FindSpawnpointByOrigin =
{
	local entity head;
	head = findradius (e.origin, spawnradius);					
	while (head)
	{
		if (head.classname == "info_player_deathmatch")
		{
			return head;
		}
	}
	return world;
};

entity () SelectWipeoutSpawnPoint =
{
	local entity e, tmp = world, localspawn = world;
	local float spawnradius = 0;

	if (self.next_team == world)
		return world;

	e = boss.next_team;

	while (e)
	{
		if (e.team2 == self.next_team.team2)
		{
			while (e.chain_gang)
			{
				if (e.chain_gang.deadflag == DEAD_NO && (IS_CA_OBSERVER(e.chain_gang) == FALSE) && ((e.chain_gang.style & CLANRING_CONNECTED)))
				{
					tmp = e.chain_gang;
					break;
				}
				e = e.chain_gang;
			}
		}
		if (tmp)
			break;
		e = e.next_team;
	}

	if (tmp)
	{
		while ((spawnradius < 1000) && !(localspawn))
		{
			spawnradius += 128;
			localspawn = FindSpawnpointByOrigin(tmp, spawnradius);
		}
	}

	if (localspawn)
		return localspawn;

	return world;
};