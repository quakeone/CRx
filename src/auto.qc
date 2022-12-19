//
// auto.qc
//
// This is the autocam handling code for CRMod++.
//
// All code by J.P. Grossman unless otherwise commented.  :p
//
// // Global variables used:
//
// entity crmod_best_chase_target;    // best chase target in terms of score alone
// entity crmod_current_chase_target; // current chase target 
// float crmod_chase_delay;           // delay before we can switch to best chasetarget
// entity crmod_best_camera;          // best camera in terms of score alone
// entity crmod_current_camera;       // current QUAKETV camera
// float crmod_camera_delay;          // delay before we can switch to best camera
//

// // Client fields used:
//
// .attack_finished				used to tell when a person last fired a weapon
// .super_damage_finished		findperson with quad
// .crmod_autotime				time change targets
//
// Prototypes:
void() observer_chase_start;
void() observer_camera_start;
void() observer_demo_start;

// CRMOD
// A U T O  C O M P U T E  S C O R E
//
//  Renamed and revamped by J.P. Grossman
//
//  Based on specified criteria, rates the player to see if they are the best player to watch.
//  Called once every second
//
void() auto_compute_score =
{
	local float score, temp;

	// score starts off with health, armor, frags, last time they fired their gun, 
	// and last time they hurt someone.
	score = self.health + self.armorvalue + self.frags;
	temp = self.clanring_did_damage + 15 - time;
	if (temp > 0)
		score = score + temp * 40;

	temp = self.attack_finished + 10 - time;
	if (temp > 0)
		score = score + temp * 20;

	// weapon related stuff
	if (self.items & IT_GLRLLG)
	{
		// 200 + # of rockets if they have RL		
		if (self.items & IT_ROCKET_LAUNCHER)
		{
			score = score + 200 + self.ammo_rockets;
			// bonus if it's the only one on the team
			if (teamplay && (clanring_state & CLANRING_MATCH_STARTED))
			{
				if (self.next_team.ammo_rockets == 1)
					score = score + auto_parm1;
			}
		}
		// or just # of rockets if they have GL
		else if (self.items & IT_GRENADE_LAUNCHER)
				score = score + self.ammo_rockets;

		// and # of cells if they have LG
		if (self.items & IT_LIGHTNING)
			score = score + self.ammo_cells;
	}

	// powerups 300 ea. for quad or pent, 50 for eyes
	if (self.items & IT_QINVISINVUL)
	{
		if (self.items & IT_QUAD)
			score = score + 300;

		if (self.items & IT_INVULNERABILITY)
			score = score + 300;

		if (self.items & IT_INVISIBILITY)
			score = score + 50;
	}
	//R00k ADDED
	if (self.flag_carrier)
		score = score + 400;//(FIXME: lower this?)
	
	// powerup potential?
	if ((clanring_pent != world) && (time > clanring_pent.nextthink - 15))
		score = score + auto_parm2 * 300 / (vlen(self.origin - clanring_pent.origin) + 300);

	if ((clanring_quad != world) && (time > clanring_quad.nextthink - 10))
		score = score + auto_parm3 * 300 / (vlen(self.origin - clanring_quad.origin) + 300);

	// now store their score for later
	self.clanring_chase_score = score;

	if (score > clanring_best_chase_target.clanring_chase_score || clanring_best_chase_target == world)
		clanring_best_chase_target = self;

	if (score > clanring_best_camera.clanring_chase_score || clanring_best_camera == world)
		clanring_best_camera = self;
};

// CRMOD
// A U T O  C A M E R A  T H I N K
//
// Called once every second for cameras that can see the best chase target
//
//   JP - added self.count to compute a 'visible player' score
//	 JP - got rid of 'best'; used self.movetarget throughout
//
void() auto_camera_think =
{
	local float score, seeable, temp;
	local entity player;
	local float check;//R00k, sometimes the linklist gets corrupted, this is here to contain the error :(

	self.movetarget = clanring_sentinel;
	score = 0;		// JP - added this
	self.count = 0;	// JP - added this
	player = clanring_sentinel.next_player;
	check = 1;
	
	while ((player != world) && (check < 17))//fixme set to sv_maxplayers
	{
		check = check + 1;
		seeable = utils_new_visible (self, player);
		if (seeable)
		{
			self.count = self.count + seeable;
			score = score + player.clanring_chase_score;

			if (seeable == 4)
			{
				// Bonus points for proximity
				temp = 600 - vlen(self.origin - player.origin);
				if (temp > 0)
					score = score + temp / 3;
				if (player.clanring_chase_score > self.movetarget.clanring_chase_score)
					self.movetarget = player;
			}
		}
		player = player.next_player;
	}

	self.clanring_cam_delay = time + 4;

	// now store their score for later
	self.clanring_chase_score = score;

	if (self.movetarget == clanring_sentinel)
	{
		self.movetarget = world;
		if (clanring_best_camera == self)
			clanring_best_camera = clanring_best_chase_target;
		if (clanring_current_camera == self)
		{
			clanring_current_camera = clanring_best_camera;
			clanring_camera_delay = time + 4;
		}
	}
	else if (self.count >= 8)
	{
		if (self.clanring_chase_score > clanring_best_camera.clanring_chase_score || clanring_best_camera == world)
			clanring_best_camera = self;
	}
};

//
//  C H E C K  C U R R E N T  C A M E R A
//
//  Each frame, make sure that the current camera has a movetarget.
//
void() auto_check_current_camera =
{
	local float seeable;
	local entity temp;

	if (clanring_current_camera.classname == "clanring_camera")
	{
		seeable = 0;
		if (clanring_current_camera.movetarget)
			seeable = utils_new_visible (clanring_current_camera, clanring_current_camera.movetarget);
		if (seeable < 4)
		{
			temp = self;
			self = clanring_current_camera;
			self.nextthink = -1;
			auto_camera_think ();
			self = temp;
		}
	}
};

//
//  S C H E D U L E  C A M E R A S
//
//  Any cameras that can see the best chase target should be allowed to think
//
void() auto_schedule_cameras =
{
	local entity camera;

	if (!clanring_best_chase_target)
		return;

	camera = clanring_sentinel.next_camera;
	while (camera)
	{
		if (utils_visible (camera, clanring_best_chase_target))
			camera.nextthink = (time + 0.1) + random ();//R00k added time + 0.1  (random can return 0)
		else if (camera == clanring_current_camera)
			camera.nextthink = (time + 0.1) + random ();//R00k added time + 0.1  (random can return 0)
		else
			camera.clanring_chase_score = -1;
		camera = camera.next_camera;
	}
};

// CRMOD
//  A U T O  C A M E R A  S T A R T
//    by Paul Baker
//
//  start autocamera from anywhere
//
void() auto_camera_start =
{
	self.oflags = self.oflags | OBSERVER_QUAKETV;//R00k added OBSERVER_QUAKETV
	self.oflags = self.oflags | OBSERVER_GO_AUTO;
	observer_camera_start ();
};

// CRMOD
//  A U T O  C H A S E  S T A R T
//    by Paul Baker
//
//  start autochase from anywhere
void() auto_chase_start =
{
	self.oflags = self.oflags | OBSERVER_QUAKETV;//R00k added OBSERVER_QUAKETV
	self.oflags = self.oflags | OBSERVER_GO_AUTO;
	observer_chase_start ();
};

// CRMOD
//  A U T O  P O V  S T A R T
//    not by Paul Baker
//
//  start autoeyecam from anywhere
void() auto_pov_start =
{
	self.oflags = self.oflags | OBSERVER_QUAKETV;//R00k added OBSERVER_QUAKETV
	self.oflags = self.oflags | OBSERVER_GO_AUTO;
	observer_demo_start ();
};

// CRMOD
// A U T O  C H A S E
//
//   checks if it's time to switch to a new target.
//   scheduled from elohim_start_frame
//
void() auto_chase =
{
	//local float temp1, temp2;
	local entity inflictor;

	remove(self);// utils_make_scheduled_event's entity
	
	if (clanring_current_chase_target == clanring_best_chase_target)
		return;
	if (!clanring_best_chase_target)
		return;
	if (!clanring_current_chase_target)
	{
		clanring_current_chase_target = clanring_best_chase_target;
		clanring_chase_delay = time + 4;
		return;
	}
	// JP - added mandantory delays
	if (time < clanring_current_chase_target.clanring_cam_delay || time < clanring_chase_delay)
		return;
	if (time - clanring_current_chase_target.attack_finished < 2)
		return;
	inflictor = clanring_current_chase_target.dmg_inflictor;
	if (inflictor)
	{
		if (inflictor.clanring_inflicted == clanring_current_chase_target && time - inflictor.clanring_did_damage < 2)
			return;
	}
	if (clanring_best_chase_target.clanring_chase_score - clanring_current_chase_target.clanring_chase_score < 100)
		return;

	clanring_current_chase_target = clanring_best_chase_target;
	clanring_chase_delay = (time + 4);
};

// CRMOD
// A U T O  C A M E R A
//
// Runs autocam for observers
//
// Rewritten by J.P. Grossman
//
void() auto_camera =
{
	local entity inflictor;

	remove(self);

	if (!clanring_best_camera)
		return;

	if ((clanring_current_camera == clanring_best_camera))
		return;

	if (!clanring_current_camera)
	{
		clanring_current_camera = clanring_best_camera;
		clanring_camera_delay = time + 4;
		return;
	}

	if (clanring_current_camera.classname == "player") // chasecam mode
	{
		// mandantory delay
		if (time < clanring_camera_delay)
			return;

		if (clanring_best_camera.classname != "clanring_camera" || clanring_best_camera.movetarget != clanring_current_camera)
		{
			if (time - clanring_current_camera.attack_finished < 2)
				return;

			inflictor = clanring_current_camera.dmg_inflictor;
			if (inflictor)
			{
				if (inflictor.clanring_inflicted == clanring_current_camera && time - inflictor.clanring_did_damage < 2)
					return;
			}
			if (clanring_best_camera.clanring_chase_score - clanring_current_camera.clanring_chase_score < 100)
				return;
		}
	}
	else
	{
		local entity camera;

		camera = clanring_current_camera;

		// smaller mandantory delay
		if (time < clanring_camera_delay - 2)
			return;

		// switch if best camera has the same movetarget
		if (clanring_best_camera.classname != "clanring_camera" || clanring_best_camera.movetarget != camera.movetarget)
		{
			if (clanring_best_camera.clanring_chase_score - camera.clanring_chase_score < 100)
				return;
			if (time - camera.movetarget.attack_finished < 2)
				return;
		}
	}

	clanring_current_camera = clanring_best_camera;
	clanring_camera_delay = time + 4;
};
