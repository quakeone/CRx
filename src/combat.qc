/*  Copyright (C) 1996-1997  Id Software, Inc.

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

    See file, 'COPYING', for details.
*/

.entity oldenemy;
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void(entity who) ResistanceSound;
/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
//float(entity targ, entity inflictor) CanDamage =
float(entity targ, entity inflictor, string dtype) CanDamage =	// 1998-10-04 Hit outside water by a discharge fix by Maddes
{
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);

	// 1998-10-04 Hit outside water by a discharge fix by Maddes  start
	// this fix only damages players in the water/slime.

	if (dtype == "discharge")
	{		
		if (clanring_playmode & CLANRING_NO_SPOOGE)//Admin option set to safe DC for pmode.
		{
			if (targ.waterlevel < 1) //Not in the water.
				return FALSE;	     
			
			if (trace_inopen && trace_inwater)
				return FALSE;			// only entities in the SAME liquid are hit

			// it doesn't matter if water changes into slime as long as they are connected
			if (trace_fraction == 1)//cant hurt thru walls		
				return TRUE;
		}
	}
	// 1998-10-04 Hit outside water by a discharge fix by Maddes  end

	if (trace_fraction == 1)
		return TRUE;

	// 1998-09-16 CanDamage fix by Maddes/Kryten start
	local vector	dif;

	// testing middle of half-size bounding box
	dif_z = 0;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	//	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	// 1998-09-16 CanDamage fix by Maddes/Kryten end

	if (trace_fraction == 1)
	return TRUE;

	// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...front left
	dif_x = targ.mins_x * 0.5;
	//	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
	return TRUE;

	// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back left
	dif_y = targ.mins_y * 0.5;
	//	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
	return TRUE;

	// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back right
	dif_x = targ.maxs_x * 0.5;
	//	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
	return TRUE;

	// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// testing top of half-sized bounding box
	dif_z = targ.maxs_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// testing bottom of half-sized bounding box
	dif_z = targ.mins_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
	return TRUE;
	// 1998-09-16 CanDamage fix by Maddes/Kryten end

	return FALSE;
};

/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}
	
	self.enemy = attacker;
	
	if (self.enemy.classname == "player")
		targ.killed = TRUE;//R00k
	
	ClientObituary (self, attacker);
	
	self.takedamage = DAMAGE_NO;
	
	self.touch = SUB_Null;
	
	self.th_die ();		

	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage =
{
	local	vector	dir;
	local 	entity 	oldself;
	local 	float 	save, overkill, take, teamdamage;
	local 	string 	temp;//R00k moved here (combat.qc:509: error: Type mismatch on redeclaration of temp. string, should be __variant)

	if (!targ.takedamage)
		return;
	
	if (clanring_state & CLANRING_MATCH_PAUSED) return;

	if ((targ.plag)&&(attacker.classname=="player"))
	{
		centerprint(attacker,"\bClanring\b Lag Protection \bActivated");
		return;
	}
	
	// ELOHIM_MOD - stats
	if (attacker.classname == "player")
	{
		if ((targ != attacker) && (targ.classname == "player"))
		{
			attacker.clanring_inflicted = targ;  // CRMOD - to see who attacker attacked
			attacker.clanring_did_damage = time;  // CRMOD keep track of last time they hurt someone
						
			if (targ.classname != "player" || attacker.team != targ.team || !teamplay)
			{
				if (inflictor == attacker)
				{
					if (attacker.weapon == IT_SHOTGUN || attacker.weapon == IT_SUPER_SHOTGUN)
					{
						if (!(clanring_playmode & CLANRING_MATCH_MODE) || (clanring_state & CLANRING_MATCH_STARTED))
						{
							if (targ.classname != "button")					//R00k: dont count button damage in stats.
								attacker.dest2_x = attacker.dest2_x + damage;
							else
								attacker.dest1_x = attacker.dest1_x - damage;
						}
					}
					else
					{
						if (attacker.weapon == IT_LIGHTNING)
						{
							if ((attacker.waterlevel <= 1)	// don't count discharges
								&& (targ.classname != "button"))					//R00k: dont count button damage in stats.
								attacker.dest2_z = attacker.dest2_z + damage;
							else
								attacker.dest1_z = attacker.dest1_z - damage;
						}
					}
				}
				else
				{
					if (inflictor.classname == "missile" && targ.classname == "player")
					{
						attacker.dest_y = attacker.dest_y + damage;
						inflictor.dmg = TRUE; // flag missile as having done damage
					}
					else
					{
						if (inflictor.classname == "spike")
							attacker.dest2_y = attacker.dest2_y + damage;
					}
				}
			}
			else
			{
				if (attacker.team == targ.team && teamplay)
				{
					if (inflictor == attacker)
					{
						if (attacker.weapon == IT_SHOTGUN || attacker.weapon == IT_SUPER_SHOTGUN)
						{
							if (!(clanring_playmode & CLANRING_MATCH_MODE) || (clanring_state & CLANRING_MATCH_STARTED))
								attacker.clanring_badstats_z = attacker.clanring_badstats_z + damage;
						}
						else
						{
							if (attacker.weapon == IT_LIGHTNING)
							{
								if (attacker.waterlevel <= 1)
									attacker.clanring_badstats_z = attacker.clanring_badstats_z + damage;
							}
						}
					}
					else
					{
						if (inflictor.classname == "missile")
						{
							attacker.clanring_badstats_z = attacker.clanring_badstats_z + damage;
							inflictor.dmg = TRUE; // flag missile as having done damage
						}
						else
						{
							if (inflictor.classname == "spike")
								attacker.clanring_badstats_z = attacker.clanring_badstats_z + damage;
						}
					}
				}
			}
		}
		else
		{
			// store damage in the rocket until we know it's not a RJ
			if (inflictor.classname == "missile")
				inflictor.clanring_badstats_y = inflictor.clanring_badstats_y + damage;
		}
	}
	// END_CRMOD  

	// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;
	
	if ((attacker.classname == "player") && (targ.classname == "player"))
		targ.enemy = attacker;//R00k: OOPS! We forgot this!! used for cameras
	
	teamdamage = TRUE;
	
	if ((teamplay == 1) && (targ.team == attacker.team))
	{
		if (targ != attacker)
		{
			if (attacker.classname == "player")
			{
				if (inflictor.classname != "door") 	// because squishing a teammate is still possible
				{
					teamdamage = FALSE;
					if (attacker.weapon == IT_LIGHTNING)//Always damage teammates if discharging.
					{
						if ((attacker.waterlevel > 1)&&(targ.waterlevel > 1))//fixed
							teamdamage = TRUE;
					}
				}
			}
		}
	}
	
	if (attacker.player_flag & ITEM_RUNE2_FLAG)
	{
		damage = (damage * 2);
	}

	//Placing Resistance Checking here protects Health and Armor
	if (targ.player_flag & ITEM_RUNE1_FLAG)
	{
		damage = (damage / 2);
		ResistanceSound (targ);
	}

	if ((attacker.super_damage_finished > time) && (inflictor.classname != "door"))	//R00k - doors no quad power fix
	{
		damage = (damage * 4);
		if ((((attacker.classname == "player") && (targ != attacker)) && (inflictor.classname != "grenade")))
		{
			if ((((targ.classname != "player") || (attacker.team != targ.team)) || !teamplay))
			{
				attacker.clanring_qdwep_x = (attacker.clanring_qdwep_x + damage);
			}
		}
	}

	save = 0;
	
	if ((teamdamage)&&(!(match_prewar())))
	{
		if ((targ.deathtype != "drowning") || (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG)))
		{			
			// save damage based on the target's armor level
			save = ceil(targ.armortype * damage);
			if (save >= targ.armorvalue)
			{
				save = targ.armorvalue;// no negative armor values please!
				targ.armortype = 0;
				targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
			}
			targ.armorvalue = targ.armorvalue - save;
		}
	}

	take = ceil(damage - save);
	
	/*Placing Resistance Checking here protects only Health, not Armor.
	if (targ.player_flag & ITEM_RUNE1_FLAG)
	{
		take = (take / 2);
		ResistanceSound (targ);
	}
	*/

	if (take >= targ.health)//R00k: Overkill is used to cap the damage given/taken stats so we dont get overloaded quad damage, discharging, or telefrag values
	{
		overkill=(ceil(targ.health));
	}
	else
	{
		overkill=(ceil(take));
	}

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if (((inflictor != world) && (targ.movetype == MOVETYPE_WALK) && (targ.deathtype !="hook")))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

	// *XXX* EXPERT CTF mark players who hurt the flag carrier, so they are worth more points for a while.
	if ((attacker.classname == "player") && (targ.flag_carrier) && (attacker.team != targ.team))
	{
		attacker.last_hurt_carrier = time;
	}

	// ELOHIM_MOD - print info for practice mode; check for pre-match
	if (clanring_playmode & CLANRING_PRACTICE_MODE)
	{
		if (targ.classname == "player" && attacker.classname == "player" && targ != attacker)
		{
			temp = ftos(floor(damage));//R00k: round down
			centerprint4 (attacker, targ.netname, ": ", temp, "\n\n\n\n\n\n\n\n");
		}
	}

	if (clanring_playmode & CLANRING_MATCH_MODE)
	{
		if (!(clanring_state & CLANRING_MATCH_STARTED))
			return;
	}
	// END_MOD

// check for godmode or invincibility
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
    // ELOHIM_MOD - nested the ifs
	if ((teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team))
	{
		if (targ != attacker)
		{
			if (attacker.classname == "player")
			{
				if (inflictor.classname != "door") 	// because squishing a teammate is still possible
				{
					if (!(attacker.weapon == IT_LIGHTNING && targ.waterlevel))//Always damage teammates if discharging.
					{
						return;
					}
				}
			}
		}
	}

	//R00k -stats-
	if ( ((targ.classname == "player") && (attacker.classname == "player")) && (targ != attacker) && ((!teamplay) || (targ.team != attacker.team)) )
	{
		targ.dmg_taken = targ.dmg_taken + save + overkill;
		attacker.dmg_given = attacker.dmg_given + save + overkill;
	}
	
	// do the damage
	targ.health = targ.health - take;

	if (targ.health <= 0)
	{
		// ELOHIM_MOD - print info for practice mode
		if (clanring_playmode & CLANRING_PRACTICE_MODE)
		{
			if (targ.classname == "player" && attacker.classname == "player" && targ != attacker)
			{
//				local string temp;
				temp = ftos(attacker.health);
				centerprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health");
				sprint5(targ, "\n\n\n\n", attacker.netname, " has ", temp, " health\n");
			}
		}
		// END_MOD
		Killed (targ, attacker);
		return;
	}
// react to the damage
	oldself = self;
	self = targ;
	if (self.th_pain)
	{
		self.th_pain();
	}
	self = oldself;
};


/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
	local 	float 	points, dist, radius;
	local 	entity 	head;
	local 	vector 	org;
	local	float	attacker_damaged = FALSE;
	local	float	attacker_points = FALSE;

	radius = damage + 40;
	
	head = findradius (inflictor.origin, radius);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				// ELOHIM_MOD - this has been optimized
				org = head.origin + (head.mins + head.maxs) * 0.5; //middle of the model				
				dist = vlen(inflictor.origin - org);
				points = 0.5 * dist;

				if (points < 0)
				{
					points = 0;
				}

				points = damage - points;

				if (points > 0)
				{
					if (CanDamage (head, inflictor, dtype))	// 1998-10-04 Hit outside water by a discharge fix by Maddes
					{
						head.deathtype = dtype;	// Wrong obituary messages fix

						if ((head.items & IT_SUIT) && (clanring_playmode & CLANRING_NO_SPOOGE) && (dtype == "discharge"))
							points = points * 0.20;//R00k if biosuit can protect the player by 1/5th against lava why not DC too??

						if (head != attacker)
						{
							T_Damage (head, inflictor, attacker, points);
						}
						else
						{
							attacker_damaged = TRUE;
							attacker_points = points * 0.5;
						}
					}
				}
			}
		}
		head = head.chain;
	}
	
	if (attacker_damaged)
		T_Damage (attacker, inflictor, attacker, attacker_points);
};
