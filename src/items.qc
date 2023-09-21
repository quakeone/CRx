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

/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

float ITEM_RESPAWNDM = 16384;

.vector particles_offset;

void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	if (deathmatch || (self.spawnflags & ITEM_RESPAWNDM))	// Respawn with DM effects
		sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	else
		spawn_tfog (self.origin + self.particles_offset);	// play teleport sound and display particles
	setorigin(self, self.origin);
};

// Supa, Quoth respawning items support Respawn item like in DM if 'ritem' TRUE,
// override respawn time with 'respawndelay' if set, inc 'cnt' with each respawn
// and if 'respawncount' is set we'll remove the item if cnt > respawncount
// remember that SUB_Regen is already set on every item that can respawn, all we
// need to do is give a nextthink time in order to trigger it
.float	ritem,
		respawndelay,
		respawncount;

void(entity whatitem, float defaultdelay) CheckItemRespawn =
{
	if (!whatitem.ritem)	// respawn item if true, otherwise abort
		return;

	whatitem.cnt = whatitem.cnt + 1;	// inc before check to account for zero indexing

	if (whatitem.respawncount)	// limited respawns
	if (whatitem.respawncount < whatitem.cnt)
		return;

	// okay, we're clear to set up a respawn

	if (whatitem.respawndelay)	// custom respawn delay?
		whatitem.nextthink = time + whatitem.respawndelay;
	else
		whatitem.nextthink = time + defaultdelay;
};

/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove(self);
};

// ELOHIM_MOD - need these prototypes
void() weapon_touch;
void() ammo_touch;
// END_MOD

/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
	local float oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;

	// Transparent weapons and ammo spawns in practice mode
	if (clanring_playmode & CLANRING_PRACTICE_MODE)
	{
		if (self.touch == weapon_touch || self.touch == ammo_touch)
		{
			self.solid = SOLID_NOT;
			self.alpha = 0.33;
			return;
		}
	}
	
	if (!droptofloor())
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove(self);
		return;
	}

    // ELOHIM_MOD - check for noquad, nopent, and noring
	if (self.classname == "item_artifact_super_damage")
	{
		if (clanring_playmode & CLANRING_NO_QUAD)
			votables_disable_item();
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		if (clanring_playmode & CLANRING_NO_PENT)
			votables_disable_item();
	}
	if (self.classname == "item_artifact_invisibility")
	{
		if (clanring_playmode & CLANRING_NO_RING)
			votables_disable_item();
	}
    // END_MOD
};

float() CheckValidTouch;
void() SUB_UseAndForgetTargets;

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
    // // ELOHIM_MOD - no weapons or ammo in practice mode
	// if (clanring_playmode & CLANRING_PRACTICE_MODE)
    // {
    //     if (self.touch == weapon_touch || self.touch == ammo_touch)
    //     {
    //         remove(self);
    //         return;
    //     }
    // }
    // END_MOD
	/*else*/
	if (clanring_playmode & CLANRING_WIPEOUT_MODE)
	{
		if (self.touch == weapon_touch)
		{
			self.effects = 0;
			self.model = string_null;
			self.solid = SOLID_NOT;
			self.nextthink = 9999999; // must be really big for quaketv
		}
		else
		{
			remove(self);
		}
		return;
	}
	else if ((clanring_playmode & CLANRING_CA_MODE) || (clanring_playmode & CLANRING_RA_MODE))
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//

float (entity e, float amount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;

	if ((!ignore) && (e.health >= other.max_health))
		return 0;

	amount = ceil(amount);

	e.health = e.health + amount;

	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
		
	if (e.health > 250)
		e.health = 250;

	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then
rot you down to your maximum health limit,
one point per second.
*/

float 	H_ROTTEN    = 1;
float 	H_MEGA 		= 2;

void() health_touch;
void() item_megahealth_rot;

void() item_health =
{
	self.touch = health_touch;
	
	if (self.spawnflags & H_ROTTEN)
	{
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
		if !(self.particles_offset)
			self.particles_offset = '16 16 8'; // dumptruck_ds custom health models and sounds END
	}
	else
	{
		if (self.spawnflags & H_MEGA)
		{
			setmodel(self, "maps/b_bh100.bsp");
			self.noise = "items/r_item2.wav";
			self.healamount = 100;
			self.healtype = H_MEGA;
			if !(self.particles_offset)
				self.particles_offset = '16 16 16';
		}
		else
		{
			setmodel(self, "maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = H_ROTTEN;
			if !(self.particles_offset)
				self.particles_offset = '16 16 8'; // dumptruck_ds custom health models and sounds END
		}
	}
	
	setsize(self, '0 0 0', '32 32 56');
	
	StartItem ();
};

void(entity rotowner, entity mega) MakeHealthRot =
{
	local entity rot;
	rot = spawn();
	rot.classname = "health_rot";
	rot.nextthink = time + 5;
	rot.think = item_megahealth_rot;
	rot.owner = mega;	
	rot.enemy = rotowner;
	rot.enemy.rotthink = time + 5;//delay
};

void() item_health_vial =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.touch = health_touch;

	if (!self.mdl_body && world.h_vial_mdl)
	{
	  self.mdl_body = world.h_vial_mdl;
	}

	precache_body_model ("progs/h_mdls/pd_vial.mdl"); // model from Hexen 2 -- dumptruck_ds
	body_model("progs/h_mdls/pd_vial.mdl");
	precache_sound_misc("items/r_item1.wav");
	if !(self.snd_misc) //set the custom noise in editor -- dumptruck_ds
	self.snd_misc = "items/r_item1.wav";
	self.noise = self.snd_misc;

	self.healamount = 5;
	self.healtype = 2; // over heal and count down like mega health -- dumptruck_ds
	setsize (self, '-16 -16 0', '16 16 56');
	if !(self.particles_offset)
	self.particles_offset = '0 0 0';
	StartItem ();
};

void() health_touch =
{
	local float	donttake = 0;
//	local string 	s;

// ELOHIM_MOD
	if (!(items_are_ready()))
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	if (other.classname != "player")
		return;

	if (self.healtype == H_MEGA)
	{
		if (other.health >= 250)
			donttake = 1;

		if (!T_Heal (other, self.healamount, H_ROTTEN))
			donttake = 1;
		if (other.next_team != world)
		{
			other.next_team.pos1_z = (other.next_team.pos1_z + 1);
		}
	}
	else
	{
		if (!T_Heal (other, self.healamount, 0))
			donttake = 1;
	}
	
	if (donttake == 0)
	{
		//sprint(other, "You receive ");
		//s = ftos(self.healamount);
		//sprint(other, s);
		//sprint(other, " health\n");
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	//	stuffcmd(other, "bf\n");
		self.model = string_null;
		self.solid = SOLID_NOT;
		self.owner = other;
	
		//MEGAHEALTH FIX
		if (self.healtype == H_MEGA)
		{
			MakeHealthRot(other,self);// create rot entity R00k: fixed
	
			other.items = other.items | IT_SUPERHEALTH;
	
			//Set this megahealth's respawn to default 125 seconds.
			if (deathmatch != 2 && deathmatch != 4 && deathmatch != 5)	// deathmatch 2 is silly old rules
			{
				self.nextthink = time + self.healamount + 25;	// delay (5) + health + respawn wait (20)
				self.think = SUB_regen;
			}
			else if (deathmatch == 4 && mapname == "ctf8dmm4")
			{
				self.nextthink = time + 25;	//bucksh0t: trying this out
				self.think = SUB_regen;
			}
		}
		else
		{
			if (deathmatch != 2 && deathmatch != 4 && deathmatch != 5)
			{
				self.nextthink = time + 20;
				self.think = SUB_regen;
			}
		}
	}
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


//R00k had to change the rules for megahealth with runes enabled. Regen altered respawn timing.

void() item_megahealth_rot =
{
	other = self.enemy;
	
// ELOHIM_MOD - check for disconnected players and observers!!
	if ((((other.health > other.max_health) && (other.style & CLANRING_CONNECTED)) && !(other.style & CLANRING_OBSERVER)))
	{
		if (other.player_flag & ITEM_RUNE4_FLAG)//REGEN
		{			
			if (other.rotthink < (time - 100))//respawn megahealth after 100 seconds, which will wait 20 more, a total of 2 minutes since mega was taken. 
			{
				if (deathmatch != 2)
				{
					self.owner.nextthink = time + 20;
					self.owner.think = SUB_regen;
				}
				remove(self);
			}
		}
		self.think = item_megahealth_rot;
		self.nextthink = time + 1;
		return;
	}

	//R00k: must still respawn mega 20 seconds AFTER other.health < other.max_health
	if (deathmatch != 2)
	{
		self.owner.nextthink = time + 20;
		self.owner.think = SUB_regen;
	}

	remove(self);
};

/*
===============================================================================

ARMOR

===============================================================================
*/
void() shard_touch = // this from RMQ shard_touch
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	local	float	bit;

	if ((other.items & IT_ARMOR1)	||
	(other.items & IT_ARMOR2)	||
	(other.items & IT_ARMOR3)	)	// has armor
	{
		// Supa, check bounds, original armourvalue + 25
		if (other.items & IT_ARMOR1 && other.armorvalue >= 125)	return;
		if (other.items & IT_ARMOR2 && other.armorvalue >= 175)	return;
		if (other.items & IT_ARMOR3 && other.armorvalue >= 225)	return;

		other.armorvalue = other.armorvalue + 5;	// was 2, RMQ team

		// Supa, now cap armourvalue to bounds
		if		(other.items & IT_ARMOR1 && other.armorvalue >= 125)	other.armorvalue = 125;
		else if (other.items & IT_ARMOR2 && other.armorvalue >= 175)	other.armorvalue = 175;
		else if (other.items & IT_ARMOR3 && other.armorvalue >= 225)	other.armorvalue = 225;
	}
	else
	{
		other.armortype = 0.3;	// shard = Green armor level
		other.armorvalue = 5;
		bit = IT_ARMOR1;
		other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	}
	self.solid = SOLID_NOT;
	self.model = string_null;

	// Supa, SP respawning items support
	if (!deathmatch)
	CheckItemRespawn(self, 30);
	else if (deathmatch == 1)  // doesn't respawn in "deathmatch 2"
	self.nextthink = time + 20;
	self.think = SUB_regen;

	// if (self.obit_name != "")
	// {
	// 	sprint (other, "You got ");
	// 	sprint (other, self.obit_name); // custom armor name
	// 	sprint (other, "\n");
	// }
	// else
	if (self.armorvalue > 5) //bucksh0t: dont print text for shards
	sprint(other, "You got armor\n");
	// armor touch sound
	// sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM); // dumptruck_ds custom models and sounds START
	if (self.snd_misc != "")
	sound_misc(other, CHAN_AUTO, self.snd_misc, 1, ATTN_NORM);
	else
	sound_misc(other, CHAN_AUTO,"items/ashardpkup.wav", 1, ATTN_NORM); // dumptruck_ds custom models and sounds END
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() armor_touch =
{
	local	float	type=0, value=0, bit=0;
	local vector v = '0 0 0'; // ELOHIM_MOD - for stats

	local float		donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

    // ELOHIM_MOD
	if (!(items_are_ready()))
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;
    // END_MOD

	if (other.health <= 0)
		return;

	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
		v = '0 0 1';
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
		v = '0 1 0';
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
		v = '1 0 0';
	}
	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
	if (other.armortype*other.armorvalue >= type*value)
		donttake = 1;

	if (!donttake)
	{
		if (other.next_team != world)
		{
			other.next_team.dest = (other.next_team.dest + v);
		}

		other.armortype 	= type;
		other.armorvalue 	= value;
		other.items 		= other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
		self.solid 			= SOLID_NOT;
		self.model 			= string_null;

		if (deathmatch != 2 && deathmatch != 4 && deathmatch != 5)
			self.nextthink = time + 20;
		
		self.think= SUB_regen;
//		sprint(other, "You got armor\n");
// armor touch sound
		sound (other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
//		stuffcmd(other, "bf\n");
	}
	activator = other;
	SUB_UseTargets();
};

void() item_armor_shard =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.mdl_body && world.a_shr_mdl)
	{
		self.mdl_body = world.a_shr_mdl;
	}

	self.touch = shard_touch;
	precache_model ("progs/armshr.mdl"); // dumptruck_ds custom models and sounds START
	//precache_body_model ("progs/armshr.mdl");
	// setmodel (self, "progs/armor.mdl");
	body_model ("progs/armshr.mdl");
	precache_sound_misc ("items/ashardpkup.wav"); // R00k
	if !(self.skin) // dumptruck_ds custom models and sounds END
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armor1 =
{
	self.touch = armor_touch;
	// precache_model ("progs/armor.mdl");  CLANRING_MOD - moved to world.qc
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armor2 =
{
	self.touch = armor_touch;
	// precache_model ("progs/armor.mdl");  CLANRING_MOD - moved to world.qc
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armorInv =
{
	self.touch = armor_touch;
	// precache_model ("progs/armor.mdl");  CLANRING_MOD - moved to world.qc
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
	if (other.ammo_shells > 100)
		other.ammo_shells = 100;

	if (other.ammo_nails > 200)
		other.ammo_nails = 200;

	if (other.ammo_rockets > 100)
		other.ammo_rockets = 100;

	if (other.ammo_cells > 100)
		other.ammo_cells = 100;
};


float(entity ent, float w) RankForWeapon =
{
	if (w == IT_LIGHTNING && ent.waterlevel <= 2)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	return 7;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
void(entity ent, float new) Deathmatch_Weapon =
{
	local float or, nr;

	if ((ent.weapon == IT_HOOK) || (ent.button0)) return;

	or = RankForWeapon (ent, ent.weapon);
	nr = RankForWeapon (ent, new);
	if ( nr < or )
	{
		if (nr == 1)
		{
			if (self.waterlevel > 2)// CLANRING_MOD - if underwater, don't switch to LG
			return;
		}
		ent.weapon = new;
	}
};

/*
=============
weapon_touch
=============
*/
float () W_BestWeapon;

void() weapon_touch =
{
	local entity stemp;
	local float  best, leave, donttake;

	if (!(items_are_ready()))
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	if (!(other.flags & FL_CLIENT))
		return;

	if (other.health < 1)
		return;
	
	// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

    if (deathmatch > 1) // CLANRING_MOD '|| coop' removed, changed to > 1
		leave = 1;
	else
		leave = 0;

	donttake = 0;
	
	if (leave && (other.items & self.weapon))// weapons stay = no ammo check
	{
		donttake = 1;
	}
	else
	{
		if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN)
		{
			other.ammo_shells = other.ammo_shells + 5;
		}
		else
		{
			if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN)
			{
				other.ammo_nails = other.ammo_nails + 30;
				if (other.next_team != world)
				{
					if (self.weapon == IT_NAILGUN)
					{
						other.next_team.pos1_y = other.next_team.pos1_y + 1;
					}
					else
					{
						other.next_team.pos1_x = other.next_team.pos1_x + 1;
					}
				}
			}
			else
			{
				if (self.weapon == IT_ROCKET_LAUNCHER || self.weapon == IT_GRENADE_LAUNCHER)
				{
					other.ammo_rockets = other.ammo_rockets + 5;
					
					if (!(other.items & IT_ROCKET_LAUNCHER))// CLANRING_MOD - keep track of rocket launchers
					{
						quaketv_obtained_rl(other);
					}
					if (other.next_team != world)
					{
						if (self.weapon == IT_ROCKET_LAUNCHER)
						{
							other.next_team.dest1_x = other.next_team.dest1_x + 1;
						}
						else
						{
							other.next_team.dest1_z = other.next_team.dest1_z + 1;
						}
					}
				}
				else
				{
					if (self.weapon == IT_LIGHTNING)
					{
						other.ammo_cells = other.ammo_cells + 15;
						if (other.next_team != world)
						{
							other.next_team.dest1_y = other.next_team.dest1_y + 1;
						}
					}
					else
					{
						objerror ("weapon_touch: unknown classname");
					}
				}
			}
		}
	}

	if (!donttake)
	{
//		sprint(other, "You got the ");
//		sprint(other, self.netname);
//		sprint(other, "\n");

// weapon touch sound
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
//		stuffcmd(other, "bf\n");

		bound_other_ammo ();

// change to the weapon
		if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
		{
			if (!(other.items & self.weapon))
			{
				if (other.weapon != IT_HOOK)
				{
					Deathmatch_Weapon (other, self.weapon);
				}
			}
		}
		other.items = other.items | self.weapon;

		stemp = self;
		self = other;

		if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
		{
			if (( other.weapon == best ) && (other.weapon != IT_HOOK))
			{
				self.weapon = W_BestWeapon();
			}
		}
		if (other.weapon != IT_HOOK)
			W_SetCurrentAmmo();

		self = stemp;

		if (!leave)
		{
			self.model = string_null;
			self.solid = SOLID_NOT;

			if (deathmatch == 1)
			{
				self.nextthink = time + 30;
			}
			else if (deathmatch == 4)
			{
				self.nextthink = -1;//time + 15;
			}

			self.think = SUB_regen;
		}
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supershotgun =
{
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 33';
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_nailgun =
{
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 31';
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supernailgun =
{
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 34';
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_grenadelauncher =
{
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = IT_GRENADE_LAUNCHER;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 28';
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_rocketlauncher =
{
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = IT_ROCKET_LAUNCHER;	//R00k
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 32';
	StartItem ();
};

/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_lightning =
{
	setmodel (self, "progs/g_light.mdl");
	self.weapon = IT_LIGHTNING;	//R00k
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	self.particles_offset = '0 0 31';
	StartItem ();
};

/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
	local entity stemp;
	local float best;
	local float	donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

    // CLANRING_MOD
    if (!(items_are_ready()))
        return;
	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;
    // END_MOD

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
		donttake = 1;
		else
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	else if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
		donttake = 1;
		else
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//	rockets
	else if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
		donttake = 1;
		else
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//	cells
	else if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
		donttake = 1;
		else
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	if (!donttake)
	{
		bound_other_ammo ();

//		sprint(other, "You got the ");
//		sprint(other, self.netname);
//		sprint(other, "\n");
// ammo touch sound
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
//		stuffcmd(other, "bf\n");

// change to a better weapon if appropriate
		stemp = self;
		self = other;

		if (( other.weapon == best ) && ( other.weapon != IT_HOOK ))
		{
			if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
				self.weapon = W_BestWeapon();
		}
		
		if (other.weapon != IT_HOOK)
		W_SetCurrentAmmo();
		self = stemp;

		self.model = string_null;
		self.solid = SOLID_NOT;

		if (deathmatch == 3)
		{
			self.nextthink = time + 15;
		}
		else if (deathmatch == 1)
		{
			self.nextthink = time + 30;
		}

		self.think = SUB_regen;

	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_shells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		// precache_model ("maps/b_shell1.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_shell1.bsp");
		if !(self.particles_offset)
			self.particles_offset = '16 16 16';
		self.aflag = 40;
	}
	else
	{
		// precache_model ("maps/b_shell0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_shell0.bsp");
		if !(self.particles_offset)
			self.particles_offset = '12 12 12';
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_spikes =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		// precache_model ("maps/b_nail1.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_nail1.bsp");
		if !(self.particles_offset)
			self.particles_offset = '16 16 16';
		self.aflag = 50;
	}
	else
	{
		// precache_model ("maps/b_nail0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_nail0.bsp");
		if !(self.particles_offset)
			self.particles_offset = '12 12 12';
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_rockets =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		// precache_model ("maps/b_rock1.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_rock1.bsp");
		self.particles_offset = '16 8 16';
		self.aflag = 10;
	}
	else
	{
		// precache_model ("maps/b_rock0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_rock0.bsp");
		if !(self.particles_offset)
			self.particles_offset = '8 8 16';
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/
void() item_cells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		// precache_model ("maps/b_batt1.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_batt1.bsp");
		if !(self.particles_offset)
			self.particles_offset = '16 16 16';
		self.aflag = 12;
	}
	else
	{
		// precache_model ("maps/b_batt0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	if !(self.particles_offset)
		self.particles_offset = '12 12 12';
	StartItem ();
};

/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/
float WEAPON_SHOTGUN    = 1;
float WEAPON_ROCKET    	= 2;
float WEAPON_SPIKES    	= 4;
float WEAPON_BIG    	= 8;

void() item_weapon =
{
	// 1999-07-10 Enhanced item_weapon function by Athos  start
	//            *** This is a total rewrite ***
	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		self.spawnflags = self.spawnflags - WEAPON_SHOTGUN;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//remove old flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_shells";
		item_shells();
	}
	else if (self.spawnflags & WEAPON_ROCKET)
	{
		self.spawnflags = self.spawnflags - WEAPON_ROCKET;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//remove old flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_rockets";
		item_rockets();
	}
	else if (self.spawnflags & WEAPON_SPIKES)
	{
		self.spawnflags = self.spawnflags - WEAPON_SPIKES;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//removeold flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_spikes";
		item_spikes();
	}
	// 1999-07-10 Enhanced item_weapon function by Athos  end
};
/*
===============================================================================

KEYS

===============================================================================
*/

/*
===============================================================================

KEYS

===============================================================================
*/


void() key_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

// support for item_key_custom -- iw
	if (HasKeys (other, self.items, self.customkeys))
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// support for item_key_custom -- iw
	GiveKeys (other, self.items, self.customkeys);

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
// fix key items firing their targets multiple times in coop -- iw
//	SUB_UseTargets();				// fire all targets / killtargets
	SUB_UseAndForgetTargets();
};


void() key_setsounds =
{
// support for item_key_custom -- iw
	if (self.noise != "")
	{
		precache_sound (self.noise);
		return;
	}

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};


/*
============
key_start

Finish initializing self as a key item.  -- iw
============
*/
void() key_start =
{
	key_setsounds ();
	self.particles_offset = '0 0 18';
	self.touch = key_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32) X X X X X SPAWN_SILENT TRIGGER_SPAWNED SUSPENDED_IN_AIR NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model("progs/w_s_key.mdl");	}
SILVER key
In order for keys to work you MUST set your map's worldtype to one of the following:
0: medieval
1: metal
2: base
*/

void() item_key1 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_body_model ("progs/w_s_key.mdl");
		body_model ("progs/w_s_key.mdl");
	}
	else if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_body_model ("progs/m_s_key.mdl");
		body_model ("progs/m_s_key.mdl");
	}
	else if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_body_model2 ("progs/b_s_key.mdl");
		body_model ("progs/b_s_key.mdl");
	}

	if (self.keyname != "") self.netname = self.keyname;
	else self.netname = SilverKeyName ();

	self.items = IT_KEY1;

// support for item_key_custom -- iw
	self.customkeys = 0;  // ignore any mapper-set value
	self.noise = "";  // ignore any mapper-set value

	key_start ();
};


/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32) X X X X X SPAWN_SILENT TRIGGER_SPAWNED SUSPENDED_IN_AIR NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/w_g_key.mdl");
}
GOLD key
In order for keys to work you MUST set your map's worldtype to one of the following:
0: medieval
1: metal
2: base
*/

void() item_key2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_body_model ("progs/w_g_key.mdl");
		body_model ("progs/w_g_key.mdl");
	}
	if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_body_model ("progs/m_g_key.mdl");
		body_model ("progs/m_g_key.mdl");
	}
	if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_body_model2 ("progs/b_g_key.mdl");
		body_model ("progs/b_g_key.mdl");
	}

	if (self.keyname != "") self.keyname = "";
	else self.netname = GoldKeyName ();

	self.items = IT_KEY2;

// support for item_key_custom -- iw
	self.customkeys = 0;  // ignore any mapper-set value
	self.noise = "";  // ignore any mapper-set value

	key_start ();
};


// item_key_custom is a brand-spanking-new entity class created for
// progs_dump -- iw

/*QUAKED item_key_custom (0 .5 .8) (-16 -16 -24) (16 16 32) X X X X X SPAWN_SILENT TRIGGER_SPAWNED SUSPENDED_IN_AIR NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path" : "progs/pd_w_key.mdl", "skin" : 1});
}
A customizable key item.

"keyname"  name of the key, e.g. "bronze key" (required)
"mdl"      model file (required)
"noise"    sound file for the pickup sound (default is per worldtype)
"skin"     skin index (default 0)

The "keyname" value is used both for the pickup message and to associate
the key with the entity that it unlocks.

To make a func_door or trigger_usekey require this key, set the
"keyname" value of that entity so that it matches the "keyname" value of
the key.

If different item_key_custom entities have the same "keyname" value,
they will be treated as different copies of the same key and may be used
interchangeably.

A map may have a maximum of 23 unique "keyname" values across all
entities.

The behavior of an item_key_custom should be as the player expects
(based on the behavior of the silver and gold keys), except for the fact
that it will not appear as an icon in the player's status bar when
picked up.  This is a limitation of the engine.
*/

void() item_key_custom =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.keyname == "")
	{
		objerror ("no keyname specified");
		return;
	}

	if (self.mdl == "")
	{
		objerror ("no mdl specified");
		return;
	}

	precache_model (self.mdl);
	setmodel (self, self.mdl);
	self.mdl = "";  // this should not be referenced again

	self.netname = self.keyname;
	self.keyname = "";  // this should not be referenced again

	self.items = 0;  // ignore any mapper-set value
	self.customkeys = CustomKeyFlag (self.netname);

	key_start ();
};

/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/
void() item_sigil =
{
	remove(self);
};

/*
===============================================================================

POWERUPS

===============================================================================
*/
void () powerup_denied =
{
    local entity e;

	e = findradius(other.origin, 128);

	while (e)
	{
        if ( (e != other) && (e.health > 0) && (e.classname == "player") && (!(e.style & CLANRING_OBSERVER)) && (e.team != other.team) )	// Don't jeer your teammates
        {
			centerprint (e, "\bdenied!\n");
			sound(other, CHAN_BODY, "ra/laugh.wav", 1, ATTN_NORM);
		}
        e = e.chain;		
    }
};

//=====================================================
void () powerup_pickup =
{
	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	if (other.style & CLANRING_OBSERVER)
		return;
    
	if (other.classname != "player")
		return;

	if (other.health < 1)
		return;

	if (self == world) return;	// R00k: just in the slight chance SUB_Remove was called when it was picked up.

	// how much time remains NOW; we cannot just give them the amount of time unused, as there's another quad going to spawn at nextthink + 30...
	float timeleft = floor(self.nextthink - time); 		// R00k: We use the .nexthink here not timeleft[i] because match_pause_item updates the entity's nextthink 
		
	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	other.items = other.items | self.items; 

	switch (self.items)
	{
		case IT_QUAD:
		{
			other.super_time = 1;
			other.effects = other.effects | EF_DIMLIGHT | EF_BLUE;
			if (other.super_damage_finished > time)
			{
				other.super_damage_finished = (min((other.super_damage_finished + timeleft), time + 30));
				sprint(other, "You got the ", self.netname, ".\ntime remaining: \[ ", ftos(floor(other.super_damage_finished - time)), " \] seconds.\n");
			}
			else
			{
				other.super_damage_finished = self.nextthink;
				sprint(other, "You got the ", self.netname, " with ", ftos(timeleft), " seconds remaining.\n");
			}
			break;
		}
		case IT_INVISIBILITY:
		{
			other.invisible_time = 1;	
			other.invisible_finished = (other.invisible_finished <= time) ? (self.nextthink) : (min((other.invisible_finished + timeleft), time + 30));
			break;
		}
		case IT_SUIT:
		{
			other.rad_time = 1;
			other.radsuit_finished = (other.radsuit_finished <= time) ? (self.nextthink) : (min((other.radsuit_finished + timeleft), time + 30));
			break;
		}
		case IT_INVULNERABILITY:
		{
			other.invincible_time = 1;		
			other.effects = other.effects | EF_DIMLIGHT | EF_RED;
			other.invincible_finished = (other.invincible_finished <= time) ? (self.nextthink) : (min((other.invincible_finished + timeleft), time + 30));
			break;
		}
	}
	powerup_denied(); //laugh at anyone who is nearby...
	activator = other;
	SUB_UseTargets ();
	remove(self);
};

void() powerup_drop =
{
	float     it_flag[4] = { IT_QUAD, IT_INVISIBILITY, IT_SUIT, IT_INVULNERABILITY };
	string      sound[4] = { "items/damage.wav", "items/inv1.wav", "items/suit.wav", "items/protect.wav" };
	string   filename[4] = { "progs/quaddama.mdl", "progs/invisibl.mdl", "progs/suit.mdl", "progs/invulner.mdl" };
	string       text[4] = { "Quad", "Ring of Shadows", "Biosuit", "Pentagram of Protection" };
	string      cname[4] = { "item_artifact_super_damage", "item_artifact_invisibility", "item_artifact_envirosuit", "item_artifact_invulnerability"};
	float    timeleft[4] = { self.super_damage_finished, self.invisible_finished, self.radsuit_finished, self.invincible_finished };

	float i;

    for (i = 0; i < 4; i++)
    {
        if (self.items & it_flag[i])
        {
            entity drop = spawn();
            drop.noise = sound[i];
            drop.items = it_flag[i];
            setmodel(drop, filename[i]);
            drop.netname = text[i];
            drop.classname = cname[i]; // R00k: we need the classname so we can pause the entity
            drop.origin = self.origin + '0 0 16';
            drop.velocity = '0 0 30';
            drop.flags = FL_ITEM;
            drop.solid = SOLID_TRIGGER;
            drop.movetype = MOVETYPE_TOSS;
            setsize(drop, VEC_HULL_MIN, VEC_HULL_MAX);
            drop.touch = powerup_pickup;
			//drop.alpha = (timeleft[i] - time)/16;	// R00k: fade the quad model based on time remaining			
            drop.nextthink = timeleft[i];
			drop.think = SUB_Remove;
        }
    }
};

void() powerup_touch =
{
    // CLANRING_MOD
    if (!(items_are_ready()))
        return;
	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;
    // END_MOD

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other,"\n");
	stuffcmd(other, "bf\n");

	if (deathmatch != 2 && deathmatch != 4 && deathmatch != 5)	// R00k
	{
		self.mdl = self.model;
		
		if ((self.items == IT_INVULNERABILITY) || (self.items == IT_INVISIBILITY))
			self.nextthink = time + 300;
		else
			self.nextthink = time + 60;

		self.think = SUB_regen;
	}

// do the apropriate action	
	if (self.items == IT_SUIT)
	{
		sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		self.solid = SOLID_NOT;
		other.items = other.items | self.items;
		self.model = string_null;
	
//		other.effects = other.effects | EF_GREEN;	
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}
	else
		quaketv_powerup_obtained();// CRMOD

	if (self.items == IT_INVULNERABILITY)
	{
		if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
			sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		else
			sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);

		self.solid = SOLID_NOT;
		other.items = other.items | self.items;
		self.model = string_null;

		other.invincible_time = 1;
		other.invincible_finished = time + 30;
		other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes
		other.effects = other.effects | EF_RED;	

		other.clanring_ptwep_z = other.clanring_ptwep_z + 1; //pent stats
		if (other.next_team != world)
		{
			other.next_team.dest2_y = other.next_team.dest2_y + 1;
		}
	}

	if (self.items == IT_INVISIBILITY)
	{
		sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		self.solid = SOLID_NOT;
		other.items = other.items | self.items;
		self.model = string_null;
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
		
		// 1998-07-23 Better performance in handling of powerups by Maddes  start
		other.frame = 0;
		//other.modelindex = modelindex_eyes;
		// 1998-07-23 Better performance in handling of powerups by Maddes  end

		if (other.next_team != world)
		{
			other.next_team.dest2_z = other.next_team.dest2_z + 1;
		}
	}

	// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sm�agol  start
	if (self.items == IT_QUAD)
	{	// R00k: TODO: count number of quads on the map; if only one then use global attenuation.
		if ((clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
			sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		else
			sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);//R00k: most dm maps only have one quad, so announce it globally

		self.solid = SOLID_NOT;
		other.items = other.items | self.items;
		self.model = string_null;

		other.super_time = 1;
		other.super_damage_finished = time + 30;
		other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes
		other.effects = other.effects | EF_BLUE;

		// CRMOD - stats
		other.clanring_qdwep_z = other.clanring_qdwep_z + 1;
		other.quadtime = time;
		if (other.next_team != world)
		{
			other.next_team.dest2_x = other.next_team.dest2_x + 1;
		}
	}
	activator = other;
	SUB_UseTargets();// fire all targets / killtargets
};

/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	self.touch = powerup_touch;
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.mdl = "progs/invulner.mdl";	// ELOHIM_MOD - so disable/enable works
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	if !(self.particles_offset)  // t_fog fix for custom models dumptruck_ds
		self.particles_offset = '0 0 16';

	// ELOHIM_MOD - keep track of who got it
	self.noise3 = " got the pentagram";
	self.noise4 = " got the \b\<Pentagram\>\n";	
	self.count = self.cnt = 0;	
	self.owner = world;
	self.height = 0;	
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	self.touch = powerup_touch;
	// ELOHIM_MOD - precaches moved to world.qc
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.mdl = "progs/suit.mdl";	// ELOHIM_MOD - so disable/enable works
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	if !(self.particles_offset)  // t_fog fix for custom models dumptruck_ds
		self.particles_offset = '0 0 32';
	StartItem ();
};

/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	self.touch = powerup_touch;
	// ELOHIM_MOD - precaches moved to world.qc
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.mdl = "progs/invisibl.mdl";	// ELOHIM_MOD - so disable/enable works
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	if !(self.particles_offset)  // t_fog fix for custom models dumptruck_ds
		self.particles_offset = '0 0 0';
	self.noise3 = " is invisible";			// ELOHIM_MOD
	self.noise4 = " is \b\<invisible\>\n";	// ELOHIM_MOD
	StartItem ();
};

/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	self.touch = powerup_touch;
	// ELOHIM_MOD - precaches moved to world.qc
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.mdl = "progs/quaddama.mdl";	// ELOHIM_MOD - so disable/enable works
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');
	if !(self.particles_offset)  // t_fog fix for custom models dumptruck_ds
		self.particles_offset = '0 0 16';

	// ELOHIM_MOD - keep track of who gets it
	self.noise3 = " got the quad";
	self.noise4 = " got the \b\<Quad\>\n";
	self.count = self.cnt = 0;		
	self.owner = world;				
	self.height = 0;				
	// END_MOD

	StartItem ();
};

/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/
void() BackpackTouch =
{
	local string s;
	local float best, new, acount;
	local entity stemp;

	if ((clanring_playmode & CLANRING_MATCH_MODE) && !(clanring_state & CLANRING_MATCH_STARTED))
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	if (clanring_playmode & CLANRING_AIRSHOT_MODE)
	{
		other.arena_packs += 1;
		if (other.arena_packs == 5)
		{
			other.arena_packs = 0;
			bprint(other.netname);
			bprint(" is invisible\n");
			stuffcmd(other, "bf\n");
			sound (other, CHAN_ITEM, "items/inv1.wav", 1, ATTN_NORM);
			other.invisible_time = 1;
			other.invisible_finished = time + 15;
			other.frame = 0;
			other.items = other.items | IT_INVISIBILITY;
		}
		else
		{
			sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
			other.health = other.health + 10;
			if (other.health > 300)
				other.health = 300;
		}
		// remove the backpack, change self to the player
		remove(self);
		self = other;
		return;
	}

	acount = 0;
	sprint(other, "You get ");
	if (self.items)
	{
		if ((other.items & self.items) == 0)
		{
			acount = 1;
			sprint(other, "the ");
			sprint(other, self.netname);
			if (self.items == IT_ROCKET_LAUNCHER)
			{
				if (other.team != self.owner.team)
				{
					quaketv_announce4(other.netname, " got ", self.owner.netname, "'s RL");
					quaketv_sound ("misc/talk.wav");
					self.owner.clanring_badstats_x = self.owner.clanring_badstats_x + 1;
					if (other.next_team != world)
					{
						other.next_team.mangle_y = other.next_team.mangle_y + 1;
					}
				}
				quaketv_obtained_rl (other);// ELOHIM_MOD - keep track of rocket launchers
			}
		}
	}
// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;
// change weapons
	other.ammo_shells = (other.ammo_shells + self.ammo_shells);
	other.ammo_nails = (other.ammo_nails + self.ammo_nails);
	other.ammo_rockets = (other.ammo_rockets + self.ammo_rockets);
	other.ammo_cells = (other.ammo_cells + self.ammo_cells);
	new = self.items;
	if (!new)
		new = other.weapon;

	//old = other.items;
	if (!(other.items & new))
	{
		if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
			Deathmatch_Weapon (other, new);
	}
	other.items = (other.items | new);
	bound_other_ammo ();
	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_shells);
		sprint(other, s);
		sprint(other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_nails);
		sprint(other, s);
		sprint(other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint(other, s);
		sprint(other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint(other, s);
		sprint(other, " cells");
	}
	sprint(other, "\n");
// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
// remove the backpack, change self to the player
	remove(self);
	self = other;

	if (( other.weapon == best ) && ( other.weapon != IT_HOOK ))
	{
		if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
			self.weapon = W_BestWeapon();
	}
	if (other.weapon != IT_HOOK)
		W_SetCurrentAmmo ();
};

void() DropBackpack =
{
	local entity item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it
	
	item = spawn();
	item.origin	= self.origin - '0 0 24';
    item.classname = "item_backpack";    // ELOHIM_MOD
	item.owner = self;	// ELOHIM_MOD
	item.items = self.weapon;

	if (item.items == IT_AXE)
		item.netname = "Axe";
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
	{
		item.netname = "Rocket Launcher";
		// ELOHIM_MOD - quaketv code
		if (other.next_team != world)
		{
			self.next_team.mangle_z = self.next_team.mangle_z + 1; // stats
		}
	}
	else if (item.items == IT_LIGHTNING)
			item.netname = "Thunderbolt";
		else
			item.netname = "";

	item.ammo_shells 	= self.ammo_shells;
	item.ammo_nails 	= self.ammo_nails;
	item.ammo_rockets 	= self.ammo_rockets;
	item.ammo_cells 	= self.ammo_cells;
	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random () * 200);
	item.velocity_y = -100 + (random () * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
		item.nextthink = time + 60;	//1 minute, ctf has a hook...
	else
		item.nextthink = time + 120;	//remove after 2 minutes
	item.think = SUB_Remove;
};

void() Team_weapon_touch =
{
	local float	new, best;
	local entity	stemp;
	
	if (!(items_are_ready()))
		return;
	
	if (pointcontents(self.origin) == CONTENT_LAVA)
	{
		remove(self);
		return;
	}

	if (!(other.flags & FL_CLIENT)) return;

	if (other.health <= 0) return;

	if (other.classname != "player") return;

	// Don't let the owner pick up his own weapon for a second.
	if ((other == self.owner) && ( (self.nextthink - time) > 19 ) )
	{
		activator = other;
		SUB_UseTargets();
		return;
	}

	if ((deathmatch == 2 || deathmatch == 3 || deathmatch == 4) && (other.items & self.weapon))
	{
		activator = other;
		SUB_UseTargets();
		return;
	}

	best = W_BestWeapon();

	if (self.weapon == IT_NAILGUN)
	{
		other.ammo_nails  = (other.ammo_nails + self.ammo_nails);
		new = IT_NAILGUN;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		other.ammo_nails  = (other.ammo_nails + self.ammo_nails);
		new = IT_SUPER_NAILGUN;
	}

	else if  (self.weapon == IT_SUPER_SHOTGUN)
	{
		other.ammo_shells = (other.ammo_shells + self.ammo_shells);
		new = IT_SUPER_SHOTGUN;
	}

	else if  (self.weapon == IT_ROCKET_LAUNCHER)
	{
		other.ammo_rockets= (other.ammo_rockets + self.ammo_rockets);
		new = IT_ROCKET_LAUNCHER;
	}

	else if  (self.weapon == IT_GRENADE_LAUNCHER)
	{
		other.ammo_rockets= (other.ammo_rockets + self.ammo_rockets);
		new = IT_GRENADE_LAUNCHER;
	}

	else if  (self.weapon == IT_LIGHTNING)
	{
		other.ammo_cells  = (other.ammo_cells + self.ammo_cells);
		new = IT_LIGHTNING;
	}
	else
	{
		remove(self);//remove the weapon
		activator = other;
		SUB_UseTargets();
		return;
	}
	other.toss_time = 0;
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	bound_other_ammo();

	if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
	{
		if (!(other.items & new))
		{
			if (other.weapon != IT_HOOK)
			{
				Deathmatch_Weapon (other, new);
			}
		}
	}

	other.items = other.items | new;

	stemp = self;
	self = other;

	if ((other.style & CLANRING_SMART_WEAPON)&&(!(infokeyf(other, "w_switch"))))
	{
		if (( other.weapon == best ) && (other.weapon != IT_HOOK))
		{
			self.weapon = W_BestWeapon();
		}
	}
	if (other.weapon != IT_HOOK)
		W_SetCurrentAmmo();

	self = stemp;

	remove(self);//remove the weapon
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() TossWeapon =
{
	local entity item;

	if (self.style & CLANRING_OBSERVER) 
		return; // no observer tossing items
	
	if (clanring_playmode & CLANRING_PRACTICE_MODE)
		return;
	
	if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
		return;

	if (((clanring_playmode & CLANRING_MATCH_MODE) && !(clanring_state & CLANRING_MATCH_STARTED)))
		return;
	
	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;
	
	if (self.health < 1)
		return;
	
	if ((self.weapon == IT_AXE)||(self.weapon == IT_SHOTGUN)||(self.weapon == IT_HOOK)) 
		return;
	
	if (deathmatch == 3)//*** Exploit: dmm3 = static weapons, so jerks just spam dropping weapons until the server crashes
	{
		if (self.toss_time > time)
		{
			sprint(self,"You can only drop each weapon, once, every 20 seconds.\n");// Dropped weapons vanish after 20 seconds.
			return;
		}
	}

	//===================================================================
	item = spawn();
	item.owner = self;
	makevectors(self.v_angle);
	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1);
	item.velocity = item.velocity * 320;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	item.weapon = item.owner.weapon;

	if( self.weapon == IT_LIGHTNING )
	{
		setmodel (item, "progs/g_light.mdl");
		item.netname = "Thunderbolt";		

		if (self.ammo_cells < 15)
		{
			item.ammo_cells = self.ammo_cells;
			self.ammo_cells = 0;
		}
		else
		{
			item.ammo_cells = 15;
			self.ammo_cells = (self.ammo_cells - 15);
		}
	}//end LG
	else
	{
		if( self.weapon == IT_ROCKET_LAUNCHER )
		{
			setmodel (item, "progs/g_rock2.mdl");
			item.netname = "Rocket Launcher";
			item.classname = "weapon";
			
			if (self.ammo_rockets < 5)
			{
				item.ammo_rockets = self.ammo_rockets;
				self.ammo_rockets = 0;
			}
			else
			{
				item.ammo_rockets = 5;
				self.ammo_rockets = (self.ammo_rockets - 5);
			}

		}//end RL
		else
		{
			if( self.weapon == IT_GRENADE_LAUNCHER)
			{
				setmodel (item, "progs/g_rock.mdl");
				item.netname = "Grenade Launcher";

				if (self.ammo_rockets <5)
				{
					item.ammo_rockets = self.ammo_rockets;
					self.ammo_rockets = 0;
				}
				else
				{
					item.ammo_rockets = 5;
					self.ammo_rockets = (self.ammo_rockets - 5);
				}

			}
			else
			{
				if( self.weapon == IT_SUPER_NAILGUN)
				{
					setmodel (item, "progs/g_nail2.mdl");
					item.netname   = "Super Nailgun";

					if (self.ammo_nails < 30)
					{
						item.ammo_nails = self.ammo_nails;
						self.ammo_nails = 0;
					}
					else
					{
						item.ammo_nails= 30;
						self.ammo_nails = (self.ammo_nails - 30);
					}

				}
				else
				{
					if( self.weapon == IT_NAILGUN )
					{
						setmodel (item, "progs/g_nail.mdl");
						item.netname = "nailgun";
						
						if (self.ammo_nails < 30)
						{
							item.ammo_nails = self.ammo_nails;
							self.ammo_nails = 0;
						}
						else
						{
							item.ammo_nails= 30;
							self.ammo_nails = (self.ammo_nails - 30);
						}
					}
					else
					{
						if (self.weapon == IT_SUPER_SHOTGUN)
						{
							setmodel (item, "progs/g_shot.mdl");
							item.netname = "Double-barrelled Shotgun";
							
							if (self.ammo_shells < 5)

							if (self.ammo_shells < 5)
							{
								item.ammo_shells = self.ammo_shells;
								self.ammo_shells = 0;
							}
							{
								item.ammo_shells = 5;
								self.ammo_shells = (self.ammo_shells - 5);
							}
						}
					}
				}
			}
		}
	}
	
	// R00k: "You There!" so my teammates will look at me when dropping items...
	if ((time > self.toss_time)||(self.toss_time == 0))
	{
		sound(self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
		self.toss_time = time + 5;
	}
	else self.toss_time = time + 2;//more spamming more duration
	
	if (deathmatch == 3)
		self.toss_time = time + 21;

	self.items = self.items - (self.items & (self.weapon));

	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();

	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = Team_weapon_touch;
	item.think = SUB_Remove;
	item.nextthink = time + 20;	
};

void() Team_Ammo_Touch=
{
	local entity etemp;
	local float  donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	if (((clanring_playmode & CLANRING_MATCH_MODE) && !(clanring_state & CLANRING_MATCH_STARTED)))
	{
		return;
	}

	if (pointcontents(self.origin) == CONTENT_LAVA)
	{
		remove(self);
		return;
	}

	if (other == self.owner)
	{
		if (deathmatch != 2)
		{
			if (self.nextthink - time > 19)
				return;
		}
	}

	if (other.classname != "player")
		return;

	if (other.health <= 0)	
		return;

	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	// shotgun
	if (self.classname=="item_shells")
	{
		if (other.ammo_shells >= 100)
		donttake = 1;
		else
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

	// spikes
	else if (self.classname=="item_spikes")
	{
		if (other.ammo_nails >= 200)
		donttake = 1;
		else
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

	//	rockets
	else if (self.classname == "item_rockets")
	{
		if (other.ammo_rockets >= 100)
		donttake = 1;
		else
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

	//	cells
	else if (self.classname == "item_cells")
	{
		if (other.ammo_cells >= 100)
		donttake = 1;
		else
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	if (!donttake)
	{
		bound_other_ammo ();
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
		etemp=self;
		self=other;
		if (other.weapon != IT_HOOK)
		W_SetCurrentAmmo();
		self=etemp;
		self.model = string_null;
		self.solid = SOLID_NOT;
		remove(self);
	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


//- code tosses the model of the ammo, not some silly backpack...

void() TossAmmo =
{
	local entity	item;
	local float		ammo = 0;
	local string	cname = "";
	local string	m = "";

	if (self.style & CLANRING_OBSERVER) 
	{
		return; // no observer tossing items *CHEAT*
	}

	if (clanring_playmode & CLANRING_PRACTICE_MODE)
	{
		return;
	}
	
	if (!(clanring_playmode & CLANRING_CAPTURE_THE_FLAG))
		return;

	if (((clanring_playmode & CLANRING_MATCH_MODE) && !(clanring_state & CLANRING_MATCH_STARTED)))
	{
		return;
	}
	
	if (clanring_state & CLANRING_MATCH_PAUSED)
	{
		return;
	}

	if ((self.weapon == IT_AXE)||(self.weapon == IT_HOOK)) return;

	if (!(self.flags & FL_CLIENT)) return;

	if (self.health < 1) return;

	if ((self.weapon == IT_SHOTGUN ) || (self.weapon == IT_SUPER_SHOTGUN ))
	{
		if (self.ammo_shells > 20)
		{
			self.ammo_shells = self.ammo_shells - 20;
			ammo = 20;
			cname= "item_shells";
			m="maps/b_shell0.bsp";
		}
		else
		{
			sprint(self,"not enough ammo.\n");
			return;
		}
	}
	else
	{
		if ((self.weapon == IT_NAILGUN ) || (self.weapon == IT_SUPER_NAILGUN))
		{
			if (self.ammo_nails > 25)
			{
				self.ammo_nails = self.ammo_nails - 25;
				ammo = 25;			
				cname = "item_spikes";
				m ="maps/b_nail0.bsp";
			}
			else
			{
				sprint(self,"not enough ammo.\n");
				return;
			}
		}
		else
		{
			if ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER))
			{
				if (self.ammo_rockets > 5)
				{
					self.ammo_rockets = self.ammo_rockets - 5;
					ammo = 5;			
					cname = "item_rockets";
					m ="maps/b_rock0.bsp";
				}
				else
				{
					sprint(self,"not enough ammo.\n");
					return;
				}
			}
			else
			{
				if (self.weapon == IT_LIGHTNING)
				{
					if (self.ammo_cells > 10)
					{
						self.ammo_cells = self.ammo_cells - 10;
						ammo = 10;
						cname = "item_cells";
						m ="maps/b_batt0.bsp";
					}
					else
					{
						sprint(self,"not enough ammo.\n");
						return;
					}
				}
				else
				{								
					return;//no other ammo to toss
				}
			}
		}
	}
	
	// R00k: "You There!" so my teammates will look at me when dropping items...
	if (time > self.toss_time)
	{
		sound(self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
		self.toss_time = time + 5;
	}
	
	item = spawn();
	item.owner = self;
	makevectors(self.v_angle);
	setorigin(item, self.origin + '0 0 16');
	item.velocity = v_forward;
	item.velocity = item.velocity * 320;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;

	item.aflag = ammo;
	item.classname = cname;
	setmodel (item, m);
	
	setsize (item, '0 0 0', '32 32 56');
	item.touch = Team_Ammo_Touch;

	item.nextthink = time + 20;//must remove or else we will run out of server entities

	item.think = SUB_Remove;
	W_SetCurrentAmmo();
};

/*
===============
DropStuff -- dumptruck_ds

set drops_item on a monster to a number:

1 = Silver Key
2 = Gold Key
3 = Health Vial
4 = Armor Shard
5 = Health Vial & Armor Shard
6 = random combination of 3 Vials and/or Shards
===============
*/

void() DropKey1 =
{
	local entity	item;

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (item, "progs/w_s_key.mdl");
		item.noise = "misc/medkey.wav";
	}
	else if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (item, "progs/m_s_key.mdl");
		item.noise = "misc/runekey.wav";
	}
	else if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (item, "progs/b_s_key.mdl");
		item.noise = "misc/basekey.wav";
	}
	item.netname = SilverKeyName ();
	item.effects = 8;
	item.flags = FL_ITEM;
	item.items = IT_KEY1;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = key_touch;
};

void() DropKey2 =
{
	local entity	item;

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (item, "progs/w_g_key.mdl");
		item.noise = "misc/medkey.wav";
	}
	else if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (item, "progs/m_g_key.mdl");
		item.noise = "misc/runekey.wav";
	}
	else if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_model ("progs/b_g_key.mdl");
		setmodel (item, "progs/b_g_key.mdl");
		item.noise = "misc/basekey.wav";
	}
	item.netname = GoldKeyName ();
	item.effects = 8;
	item.flags = FL_ITEM;
	item.items = IT_KEY2;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = key_touch;
};

void() DropVial = //
{
	local entity	item;

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	precache_model("progs/h_mdls/pd_vial.mdl");
	setmodel(item, "progs/h_mdls/pd_vial.mdl");
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = health_touch;
	item.healamount = 5;
	item.healtype = 0;
	item.noise = "items/r_item1.wav";

	StartItem ();
};

void() DropShard = //
{
	local entity	item;

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	setmodel(item, "progs/armshr.mdl");
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = shard_touch;
	item.snd_misc = "dump/armsh1.wav";

	StartItem ();
};

void() DropStuff =
{
	local float	rand_drop;

	if (self.drop_item == 1)
		{
			DropKey1();
		}
	if (self.drop_item == 2)
		{
			DropKey2();
		}
	if (self.drop_item == 3)
		{
			DropVial();
		}
	if (self.drop_item == 4)
		{
			DropShard();
		}
	if (self.drop_item == 5)
		{
			DropVial();
			DropShard();
		}
	else if (self.drop_item == 6)
	{
		rand_drop = rint(random() * 3);
		if (rand_drop == 1)
			{
				DropShard();
				DropVial();
				DropVial();
			}
		else if (rand_drop == 2)
			{
				DropShard();
				DropShard();
				DropVial();
			}
		else if (rand_drop == 0)
			{
				DropShard();
				DropShard();
				DropShard();
			}
		else
			{
				DropVial();
				DropVial();
				DropVial();
			}
	}
	return;
};
