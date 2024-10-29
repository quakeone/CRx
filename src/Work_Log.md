# Work_Log
# --------------------------------------------
# BUGS:
[ ] in ra if I am observing after match it still says observering  and eyecam yet in walk
--------------------------------------------
# FEATURES:
[x] disallow colors 14/15
[x] chat 1/2 support 
[ ] trainer mode that tells how much h they had to learn 
[ ] team x has 3 or 4 weapons announce
[ ] Make eyes for observers transparent model
[ ] shootable/breakable lights that respawn in 20 seconds, die or go to flickering state
[ ] breakable walls replace doors; health of door to open by damage.
[x ] Automatic switching of weapons, after depleted ammo, via the SmartWeapon setting; disabled if using w_switch.
[x] add player counts to clanarena join-menu
[x] req 20 min timeset, but it is already 20
[x] centerprint war with join and vote menu
[x] force deathmatchmode reset
[x] print to everyone if someone goes obs
[x] Increase fly speed from 500 to 1000
[x] when vote passes, verbose, woods voted yes for -------
[x] player dropped rl/lg (observer commentary)
[x] spawn timers for observers
[x] reduced vote time (from 50 to 20 seconds)
[x] Recalculate votes when someone disconnects.
--- 
Spoike _—_ Today at 9:15 PM
 `stuffcmdflags(world, STUFFCMD_BROADCAST, "//it Timeout X Y Z Radius 0xRRGGBB \"Timername\" Entnum\n");`

[ ] add team .fctimes to the stats for total time the team carried the flag
[ ] stat that shows which weapon in hand when a player died
    hook 0  axe  2   sg   7    ssg  0    ng   0    sng  1    gl   0    rl   5    lg   0     total deaths: 15
[ ] ADD CTF TEAMSTATS!
[ ] create spawnPoint[] array to use instead of the slow 
    `find(world, classname ...)` route. 

[ ] votable/admin option to read external ent files
    loading of secondary .ent2 files instead of the .ent 
    or the map entities ( clanring_gameconfig & CLANRING_SECONDARY_ENTS )

[ ] makeitem x y z classname 
    Command so, an admin can just /makeitem spot "health25" 
    to spawn a health pack at their location; as an observer.
[ ] saveents to save out a mapname.ents file.  
[ ] new weapon system to replace w_setcurrentammo etc.
[ ] Test avenger awards. .enemy gets overwritten when a player gets shot?
    .enemy is the person shooting you or you are shooting??
[ ] teamkills doesnt account for discharging
      utils_print_int3(player.mangle_y);
      utils_print_int3(player.mangle_z);

[ ] localcmd (sprintf("extended_ents_dir %s\n",ca_getMode(clanring_playmode)));
[ ] blowout = ((winningscore - losingscore)>(timeleft - avgFragsPerMinute)) ? TRUE : FALSE;
[ ] fix a vote to change to a mode we are already in
[ ] Hook trails in pub mode colored by team instead of the voreball spike trail.
[ ] pos_save, pos_move for prematch/practice modes
[ ] save_camfile to save a configs/camera/mapname.cam file

checkmate = winning_score (- 1sec + respawn_time_3)*((fpm)/time_left); basically the player can type kill, wait three seconds type kill again wait three seconds and have an enough of a lead, and less enough time that they will still win after the timelimit.
[ ] should overtime rules change dynamically based on team size?
[ ] allow clanarena players to type ready after joining a team to spawn in the map for practice



W_Attack:

	if ((self.weapon != IT_HOOK) && (self.weapon != IT_AXE))
	{
		if (self.currentammo < 1)
			return;
	}


W_weaponframe:

// check for attack
    // ELOHIM_MOD - don't fire unless ELOHIM_OK_TO_SHOOT is set
	if (self.button0)
	{
		if (self.style & CLANRING_OK_TO_SHOOT)
		{
			W_Attack ();			
			SuperDamageSound();		
			clear_afk_status(self);	//R00k:	
		}
	}
	else
	{
		W_CheckNoAmmo();
		self.style = self.style | CLANRING_OK_TO_SHOOT;
	}


	/*


	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1 ();
		self.attack_finished = time + 0.1;	//R00k not sure why iD decided to add this when player_light1 updates the nextthink to 0.2... ?
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}

	This code is from W_Attack, in weapons.qc; shoots the lightning bolt, then set the time for refire at time + 0.1
	BUT, in player_light1 it calls player_light2 at time + 0.2, repeating player_light1 (doing damage) -> player_light2 (doing damage)
	at this interval. 
	If the player, quickly tapped his +attack button then the firerate would get reset to time + 0.1 instead of time + 0.2
	there for a script could toggle +attack twice faster than time + 0.2 then damage could be buffed.

	*/




	main change is when you run out of ammo while holding down the fire button. single-fired shots have no change.