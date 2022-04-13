void() powerup_touch;

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

entity (float wnum) check_weapon_spot =
{
	local entity spot = world;
	if (wnum == 11)
	{
		spot = find(spot, classname, "weapon_supershotgun");
	}
	else if (wnum == 10)
	{
		spot = find(spot, classname, "weapon_nailgun");
	}
	else if (wnum == 9)
	{
		spot = find(spot, classname, "weapon_supernailgun");
	}
	else if (wnum == 8)
	{
		spot = find(spot, classname, "weapon_grenadelauncher");
	}
	else if (wnum == 7)
	{
		spot = find(spot, classname, "weapon_rocketlauncher");
	}
	else
	{
		spot = find(spot, classname, "weapon_lightning");
	}
	return spot;
};

float (entity team1) wipeout_teammates_left =
{
	local entity e, tmp, item, spot = world;
	local float n = 0, ttl = 0, loop_count = 64;
	local float	pcount;	

	e = team1;

	while (e.chain_gang)
	{
		ttl = ttl + 1;
        if (e.chain_gang.ca_player_flag != PF_DEAD && (IS_CA_OBSERVER(e.chain_gang) == FALSE) && ((e.chain_gang.style & CLANRING_CONNECTED)))
		{
			n = n + 1;
		}
		else if ((e.chain_gang.ca_player_flag == PF_DEAD) && (e.chain_gang.style & CLANRING_CONNECTED) && (e.chain_gang.respawntime > 0))
		{
			if ((time >= e.chain_gang.respawntime) && (boss.wait == 0))
			{
				tmp = self;
				self = e.chain_gang;
				observer_end ();
                bprint2(self.netname, " has respawned\n");
				self = tmp;

				n = n + 1;
			}
		}
		e = e.chain_gang;
	}

	if ((n == 1) && (ttl > 1) && (boss.wait == 0))
	{
		if (boss.quadtime == 0)
		{
			boss.quadtime = time + 5;
		}
		else if (time > boss.quadtime)
		{
			pcount = random() * (13 - 0.001);
			pcount = floor(pcount);
			if (pcount > 7)
			{
				spot = check_weapon_spot(pcount);
			}

			if (spot == world)
			{
				pcount = random() * (dm_num_spawns - 0.001);
				pcount = floor(pcount);
				spot = find(world, classname, "info_player_deathmatch");
				while (pcount > 0)
				{
					spot = find(spot, classname, "info_player_deathmatch");
					if (spot != world)
						pcount = pcount - 1;
				}
				if (spot == world)
					spot = find(spot, classname, "info_player_deathmatch");
			}

			if (spot != world)
			{
				local entity quadent = world;
				quadent = find(world, classname, "ca_quad_drop");
				if (quadent)
				{
					bprint("ca_quad_drop entity found; not creating new entity.\n");
					item = quadent;
				}
				else
					item = spawn ();

				item.origin = spot.origin;
				item.velocity = '0 0 0';
				item.noise = "items/damage.wav";
				item.mdl = "progs/quaddama.mdl";
				setmodel (item, item.mdl);
				item.netname = "Quad Damage";
				item.items = IT_QUAD;
				item.classname = "ca_quad_drop";
				setsize (item, '-16 -16 -24', '16 16 32');

				item.count = item.cnt = 0;
				item.owner = world;
				item.height = 0;
				item.flags = FL_ITEM;
				item.solid = SOLID_TRIGGER;
				item.movetype = MOVETYPE_TOSS;

				item.touch = powerup_touch;
				// item.nextthink = -1;
				// item.think = SUB_Remove;
			}
			boss.quadtime = time + 999;
		}
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

entity (entity e, float spawnradius) find_spawn_point =
{
	local entity head;
	head = findradius (e.origin, spawnradius);					
	while (head)
	{
		if (head.classname == "info_player_deathmatch")
		{
			return head;
		}
		head = head.chain;
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
			localspawn = find_spawn_point(tmp, spawnradius);
		}
	}

	if (localspawn)
		return localspawn;

	return world;
};