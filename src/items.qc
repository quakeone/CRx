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

void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin(self, self.origin);
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

// ELOHIM_MOD - need these prototypes
void() weapon_touch;
void() ammo_touch;
// END_MOD

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
    // ELOHIM_MOD - no weapons or ammo in practice mode
	if (clanring_playmode & CLANRING_PRACTICE_MODE)
    {
        if (self.touch == weapon_touch || self.touch == ammo_touch)
        {
            remove(self);
            return;
        }
    }
    // END_MOD
	else if (clanring_playmode & CLANRING_WIPEOUT_MODE)
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
	}
	else
	{
		if (self.spawnflags & H_MEGA)
		{
			setmodel(self, "maps/b_bh100.bsp");
			self.noise = "items/r_item2.wav";
			self.healamount = 100;
			self.healtype = H_MEGA;
		}
		else
		{
			setmodel(self, "maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = H_ROTTEN;
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
			if (deathmatch != 2 && deathmatch != 4)	// deathmatch 2 is silly old rules
			{
				self.nextthink = time + self.healamount + 25;	// delay (5) + health + respawn wait (20)
				self.think = SUB_regen;
			}
		}
		else
		{
			if (deathmatch != 2)
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

		if (deathmatch != 2 && deathmatch != 4)
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
	local float	best;
	local entity	stemp;
	local float	leave;
	local float	donttake;

	if (!(items_are_ready()))
		return;

	if (clanring_state & CLANRING_MATCH_PAUSED)
		return;

	if (!(other.flags & FL_CLIENT))
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

		if (!(other.items & self.weapon))
		{
			if (other.weapon != IT_HOOK)
			{
				Deathmatch_Weapon (other, self.weapon);
			}
		}

		other.items = other.items | self.weapon;

		stemp = self;
		self = other;
		// 1997-12-23 Thunderbolt fix by Maddes
		if (( other.weapon == best ) && (other.weapon != IT_HOOK))
		{
			if (self.style & CLANRING_SMART_WEAPON)
			self.weapon = W_BestWeapon();
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
			if (self.style & CLANRING_SMART_WEAPON)	// R00k from CRMOD... modified
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
		self.aflag = 40;
	}
	else
	{
		// precache_model ("maps/b_shell0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_shell0.bsp");
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
		self.aflag = 50;
	}
	else
	{
		// precache_model ("maps/b_nail0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_nail0.bsp");
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
		self.aflag = 10;
	}
	else
	{
		// precache_model ("maps/b_rock0.bsp");  CLANRING_MOD - moved to world.qc
		setmodel (self, "maps/b_rock0.bsp");
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

void() item_key1 =
{
	remove(self);
};

void() item_key2 =
{
	remove(self);
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

	if (clanring_playmode & CLANRING_WIPEOUT_MODE)
	{
		if ((self.items == IT_QUAD) && (boss.state == CA_MATCH_PLAYING) && (boss.wait == 0))
			boss.quadtime = time + 35;
		else
			return;
	}
	else if (deathmatch != 2 && deathmatch != 4)	// R00k
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

	// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
	if (self.items == IT_QUAD)
	{
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
	self.noise3 = " is invisible";			// ELOHIM_MOD
	self.noise4 = " is ŽInvisibleŽ\n";		// ELOHIM_MOD
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
	local float best, new, acount, rnd;
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
		rnd = floor((random() * 8) + 1);
		if (rnd == 5)
		{
			other.invincible_time = 1;
			other.invincible_finished = time + 15;
			other.effects = other.effects | EF_DIMLIGHT;
			other.effects = other.effects | EF_RED;
			other.items = other.items | IT_INVULNERABILITY;
			bprint(other.netname);
			bprint(" got pent protection\n");
			sound (other, CHAN_ITEM, "items/protect.wav", 1, ATTN_NORM);
		}
		else if (rnd > 5)
		{
			other.invisible_time = 1;
			other.invisible_finished = time + 15;
			other.frame = 0;
			other.items = other.items | IT_INVISIBILITY;
			bprint(other.netname);
			bprint(" is invisible\n");
			sound (other, CHAN_ITEM, "items/inv1.wav", 1, ATTN_NORM);
		}
		else
		{
			other.health = other.health + 10;
			if (other.health > 300)
				other.health = 300;
			sound (other, CHAN_ITEM, "weapons/lock4.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		//other.arenapacks += 1;
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
	sound (other, CHAN_ITEM, "weapons/lock4.wav", WEAPON_SHOTGUN, ATTN_NORM);
// remove the backpack, change self to the player
	remove(self);
	self = other;

	if (( other.weapon == best ) && ( other.weapon != IT_HOOK ))
	{
		if (self.style & CLANRING_SMART_WEAPON)	// R00k from clanring... modified
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
	item.origin 	= self.origin - '0 0 24';
    item.classname = "item_backpack";    // ELOHIM_MOD
	item.owner = self;	// ELOHIM_MOD
	item.items 	= self.weapon;
	
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

	if (other.weapon != IT_HOOK) Deathmatch_Weapon (other, self.weapon);

	other.items = other.items | self.weapon;

	if (( other.weapon == best ) && (other.weapon != IT_HOOK))
	{
		other.weapon = W_BestWeapon();
	}
	stemp=self;
	self=other;

	if (other.weapon != IT_HOOK)
	W_SetCurrentAmmo();

	self=stemp;

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
	
	item = spawn();
	item.owner = self;
	makevectors(self.v_angle);

	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 320);
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


