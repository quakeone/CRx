void () clan_arena_init_world =
{
	local entity oself;
			
	boss = spawn ();
    boss.max_rounds 	= 9;
    boss.max_players 	= 8;//R00k: changed v1.52
    boss.start_players	= 3;
    boss.max_teams  	= 4;
	boss.round			= 1;
	boss.count 			= 10;
	boss.state 			= CA_MATCH_WAITING;
	boss.wait 			= 0;
	boss.maprecycle		= 0;
	boss.armorvalue  	= 200;
	boss.armortype   	= 80.001;
    boss.health      	= 100;
    boss.ammo_shells 	= 100;
    boss.ammo_nails  	= 100;
    boss.ammo_rockets	= 50;
    boss.ammo_cells  	= 30;
    boss.items = ((((((((IT_SHOTGUN | IT_AXE) | IT_ROCKET_LAUNCHER) | IT_ARMOR3) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_LIGHTNING) | IT_SUPER_NAILGUN);

    oself = self;
    self = boss;
    self.weapon = IT_ROCKET_LAUNCHER;// W_BestWeapon();
    self = oself;	

	boss.timetofight 	= FALSE;
	boss.next_team 		= world;
	boss.busy			= FALSE;
	boss.aborted 		= FALSE;
	ca_mvp_entity		= world;
};