void() powerup_touch;

float (float numdeaths) wipeout_get_respawn =
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
	if (wnum == 13)
	{
		spot = find(spot, classname, "weapon_lightning");
	}
	else if (wnum == 12)
	{
		spot = find(spot, classname, "weapon_supershotgun");
	}
	else if (wnum == 11)
	{
		spot = find(spot, classname, "weapon_nailgun");
	}
	else if (wnum == 10)
	{
		spot = find(spot, classname, "weapon_supernailgun");
	}
	else if (wnum == 9)
	{
		spot = find(spot, classname, "weapon_grenadelauncher");
	}
	else if (wnum == 8)
	{
		spot = find(spot, classname, "weapon_rocketlauncher");
	}
	else
	{
		spot = find(spot, classname, "item_weapon");
	}
	return spot;
};

entity () find_item_spawn_spot =
{
	local entity spot = world;
	local float	pcount;

	pcount = random() * (16 - 0.001);
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
	return spot;
};

// void (vector vspot) do_spawn_quad =
// {
// 	local entity item;
// 	item = spawn ();
// 	item.origin = vspot;
// 	item.classname = "item_artifact_super_damage";
// 	item.velocity = '0 0 0';
// 	item.noise = "items/damage.wav";
// 	item.mdl = "progs/quaddama.mdl";
// 	setmodel (item, item.mdl);
// 	item.netname = "Quad Damage";
// 	item.items = IT_QUAD;
// 	setsize (item, '-16 -16 -24', '16 16 32');
// 	item.count = item.cnt = 0;
// 	item.owner = world;
// 	item.height = 0;
// 	item.flags = FL_ITEM;
// 	item.solid = SOLID_TRIGGER;
// 	item.movetype = MOVETYPE_TOSS;
// 	item.touch = powerup_touch;
// 	item.nextthink = time + 30;
// 	item.think = SUB_Remove;
// 	sound (item, CHAN_VOICE, "crx/itembk3.wav", 1, ATTN_NORM);
// };

void() BackpackTouch;
void (vector vspot) do_spawn_pack =
{
	local float rammo = 0;
	local entity item;
	item = spawn();
	item.origin = vspot;
	item.origin_z = item.origin_z - 24;
    item.classname = "item_backpack";
	rammo = (random() * 2) + 1;
	if (rammo == 1)
	{
		item.items = IT_GRENADE_LAUNCHER;
		item.netname = "Grenade Launcher";
	}
	else
	{
		item.items = IT_LIGHTNING;
		item.netname = "Thunderbolt";
	}
	rammo = (random() * 20) + 1;
	item.ammo_shells = floor(rammo);
	rammo = (random() * 25) + 1;
	item.ammo_nails = floor(rammo);
	rammo = (random() * 8) + 1;
	item.ammo_rockets = floor(rammo);
	rammo = (random() * 12) + 1;
	item.ammo_cells = floor(rammo);
	item.velocity = '0 0 0';
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + 60;
	item.think = SUB_Remove;
	sound (item, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
};

//void() health_touch;
void (vector vspot) do_spawn_health =
{
	// local entity item;
	// item = spawn();
	// item.origin = vspot - '0 0 24';
    // item.classname = "item_health";
	// item.velocity = '0 0 0';
	// item.flags = FL_ITEM;
	// item.solid = SOLID_TRIGGER;
	// item.movetype = MOVETYPE_TOSS;
	// setmodel(item, "maps/b_bh100.bsp");
	// setsize (item, '0 0 0', '32 32 56');
	// item.noise = "items/r_item2.wav";
	// item.healamount = 100;
	// item.healtype = 2;
	// item.touch = health_touch;
	// item.nextthink = time + 20;
	// item.think = SUB_Remove;
	// sound (item, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
};

void () wipeout_try_spawn_item =
{
	local float prnd;
	local entity spot;

	prnd = random() * (90 - 0.001);
	prnd = floor(prnd);
	if ((prnd == 15) || (prnd == 30) || (prnd == 45))
	{
		spot = find_item_spawn_spot();
		if (spot != world)
		{
			// if (prnd == 30)
			// 	do_spawn_health(spot.origin);
			// else
				do_spawn_pack(spot.origin);
		}
	}
};

// void () wipeout_try_spawn_quad =
// {
// 	local float prnd;
// 	local entity spot;

// 	if (time > boss.quadtime)
// 	{
// 		prnd = random() * (5 - 0.001);
// 		prnd = floor(prnd);
// 		if (prnd == 3)
// 		{
// 			spot = find_item_spawn_spot();
// 			if (spot != world)
// 			{
// 				do_spawn_quad(spot.origin);
// 				boss.quadtime = time + 999;
// 			}
// 		}
// 		else
// 		{
// 			wipeout_try_spawn_item();
// 		}
// 	}
// };

void () wipeout_init_teams =
{
	local entity e;

	e = boss.next_team;

	while (e)
	{
		e.teamalive = number_teammates(e);
		e.teamtotal = e.teamalive;
		e.nextspawn = 0;
		e = e.next_team;
	}
};

// entity (entity e, float spawnradius) find_player_spawn_spot =
// {
// 	local entity head;
// 	head = findradius (e.origin, spawnradius);					
// 	while (head)
// 	{
// 		if (head.classname == "info_player_deathmatch")
// 		{
// 			return head;
// 		}
// 		head = head.chain;
// 	}
// 	return world;
// };

// entity () SelectWipeoutSpawnPoint =
// {
// 	local entity e, tmp = world, localspawn = world;
// 	local float spawnradius = 0;

// 	if (self.next_team == world)
// 		return world;

// 	e = boss.next_team;

// 	while (e)
// 	{
// 		if (e.team2 == self.next_team.team2)
// 		{
// 			while (e.chain_gang)
// 			{
// 				if (e.chain_gang.deadflag == DEAD_NO && (IS_CA_OBSERVER(e.chain_gang) == FALSE) && ((e.chain_gang.style & CLANRING_CONNECTED)))
// 				{
// 					tmp = e.chain_gang;
// 					break;
// 				}
// 				e = e.chain_gang;
// 			}
// 		}
// 		if (tmp)
// 			break;
// 		e = e.next_team;
// 	}

// 	if (tmp)
// 	{
// 		while ((spawnradius < 1000) && !(localspawn))
// 		{
// 			spawnradius += 128;
// 			localspawn = find_player_spawn_spot(tmp, spawnradius);
// 		}
// 	}

// 	if (localspawn)
// 		return localspawn;

// 	return world;
// };

void () powerup_denied =
{
    local entity e;
    local float dist;

    e = find (world, classname, "player");
    while (e)
    {
        if (e != other && e.health > 0)
        {
            dist = vlen (self.origin - e.origin);
            if (dist < 125)
                sprint (e, "{141} \bdenied!\n");
        }
        e = find (e, classname, "player");
    }
};

void () wipeout_drop_quad_touch =
{
	local float item_dropped, time_left;

	if (other.classname != "player")
		return;

	if ((boss.state != CA_MATCH_PLAYING) || ((boss.state == CA_MATCH_PLAYING) && (boss.wait > 0)))
		return;

	if (other.health <= 0)
		return;

	item_dropped = IT_QUAD;
	other.super_time = 1;

	if (other.super_damage_finished <= time)
	{
		other.super_damage_finished = self.cnt;
	}
	else
	{
		other.super_damage_finished= other.super_damage_finished + (self.cnt - time);
		if (other.super_damage_finished > time + 30)
			other.super_damage_finished = time + 30;
	}

	sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	other.items = other.items | item_dropped;
	self.model = string_null;

	time_left = ceil(self.cnt-time);
	bprint(other.netname);
	bprint(" recovered a ");
	bprint(self.netname);
	bprint(" with ");
	utils_bprint_float (time_left);
	bprint(" second");
	if (time_left != 1)
		bprint("s");
	bprint(" remaining!\n");

	powerup_denied ();

	other.effects = other.effects | EF_DIMLIGHT;
	other.effects = other.effects | EF_BLUE;

	activator = other;

	SUB_UseTargets ();
};

void (float finish_time) wipeout_drop_quad =
{
	local entity item;
	local float time_left;

	if ((boss.state != CA_MATCH_PLAYING) || ((boss.state == CA_MATCH_PLAYING) && (boss.wait > 0)))
		return;

	time_left = floor(finish_time);
	bprint(self.netname);
	bprint(" lost a Quad with ");
	utils_bprint_float (time_left);
	bprint(" second");
	if (time_left != 1)
		bprint("s");
	bprint(" remaining\n");

	item = spawn ();
	item.origin = self.origin;
	item.classname = "item_artifact_super_damage";
	item.velocity = '0 0 0';

	item.noise = "items/damage.wav";
	item.mdl = "progs/quaddama.mdl";
	setmodel (item, item.mdl);
	item.netname = "Quad Damage";
	item.items = IT_QUAD;
	setsize (item, '-16 -16 -24', '16 16 32');

	item.count = 0;
	item.owner = world;
	item.height = 0;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;

	item.cnt = time + finish_time;
	item.touch = wipeout_drop_quad_touch;
	item.nextthink = time + finish_time;
	item.think = SUB_Remove;
	//boss.quadtime = (item.nextthink + 5);
};