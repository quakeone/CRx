//
// quaketag.qc
//
// This file contains code for the Quake Tag egg :)
//

void() respawn;
void() GibPlayer;

entity crmod_qtag_it;

//
//  I N I T  W O R L D
//
void() quaketag_init_world =
{
	crmod_qtag_it = world;
};

//
//  I N I T
//
void() quaketag_init = 
{
	local float temp;

	temp = 1;
	self.use = SUB_Null;
	if (elohim_state & ELOHIM_MATCH_STARTED)
		temp = 0;
	if (elohim_state & ELOHIM_TIMER_STARTED)
	{
		if (elohim_match_timer.count <= 10)
			temp = 0;
	}
	if (!(elohim_playmode & ELOHIM_MATCH_MODE) || !teamplay)
		temp = 0;
	if ((crmod_qtag_it != world) || (self.finaldest_z != 15) || (elohim_sentinel.next_player == world))
		temp = 0;

	if (temp)
	{
		if (self.style & ELOHIM_OBSERVER)
			crmod_qtag_it = elohim_sentinel.next_player;
		else
			crmod_qtag_it = self;
		bprint("Ñõáëå Ôáç Áãôéöáôåä¡¡Ÿ\n");
		bprint(crmod_qtag_it.netname, " is it\n");
		crmod_qtag_it.effects = crmod_qtag_it.effects | EF_BRIGHTFIELD;

		local float r;
		r = random();
		if (r < 0.16)
			sound(self, CHAN_AUTO, "demon/sight2.wav", 1, ATTN_NONE);
		else if (r < 0.33)
			sound(self, CHAN_AUTO, "dog/dsight.wav", 1, ATTN_NONE);
		else if (r < 0.5)
			sound(self, CHAN_AUTO, "knight/ksight.wav", 1, ATTN_NONE);
		else if (r < 0.66)
			sound(self, CHAN_AUTO, "ogre/ogwake.wav", 1, ATTN_NONE);
		else if (r < 0.84)
			sound(self, CHAN_AUTO, "shambler/ssight.wav", 1, ATTN_NONE);
		else
			sound(self, CHAN_AUTO, "soldier/sight1.wav", 1, ATTN_NONE);
	}
	else
	{
		r = random();
		if (r < 0.25)
			sprint(self, "Preach on, brother!\n");
		else if (r < 0.5)
			sprint(self, "You got that right!\n");
		else if (r < 0.75)
			sprint(self, "BIG TIME!!!\n");
		else 
			sprint(self, "You listening Zoid!?\n");
	}
};

//
//  C L E A R
//
void() quaketag_clear = 
{
	if (crmod_qtag_it)
	{
		crmod_qtag_it.effects = crmod_qtag_it.effects - (crmod_qtag_it.effects & EF_BRIGHTFIELD);
		bprint("Ñõáëå Ôáç Ïöåò¡  Ðìáù áçáéî¿  ¨Ù¯Î©\n");
	}
	crmod_qtag_it = world;
};

//
//  D I S C O N N E C T  N O T I F Y 
//
void(entity player) quaketag_disconnect_notify =
{
	if (crmod_qtag_it == player)
		quaketag_clear();
};

//
//  R E S P A W N
//
void() quaketag_respawn = 
{
	local float ready;

	ready = self.style & ELOHIM_READY;
	self.style = self.style | ELOHIM_READY;
	respawn();
	self.style = (self.style - ELOHIM_READY) | ready;
	self.effects = self.effects | EF_BRIGHTFIELD;
};

//
//  S T A R T  F R A M E
//
void() quaketag_start_frame = 
{
	local entity oself;

	if (crmod_qtag_it.deadflag)
		return;

	other = find(world, classname, "player");
	while (other)
	{
		if (!(other.style & ELOHIM_OBSERVER) && (other.style & ELOHIM_CONNECTED))
		{
			if (other != crmod_qtag_it)
			{
				local vector v;
				v = other.origin - crmod_qtag_it.origin;
				if (vlen(v) < 64)
				{
					oself = self;
					self = other;
					crmod_qtag_it.effects = crmod_qtag_it.effects - (crmod_qtag_it.effects & EF_BRIGHTFIELD);
					crmod_qtag_it = self;
			        self.health = -99;

					local float gibs;
					gibs = elohim_playmode & (ELOHIM_NO_GIBS | ELOHIM_LOW_GIBS);
					elohim_playmode = elohim_playmode - gibs;
					GibPlayer();
					elohim_playmode = elohim_playmode | gibs;

					self.deadflag = DEAD_DYING;
					self.think = quaketag_respawn;
					self.nextthink = time + 1;
					bprint(crmod_qtag_it.netname, " is it\n");
					self = oself;
					return;
				}
			}
		}
		other = find(other, classname, "player");
	}
};