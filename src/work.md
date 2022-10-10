![]() 
# Work.log

# ClanRing Quake 1 Competition Server 

	--------------------------------------------
	~ = should work, need test run to make 100%
	/ = sorta works, needs testing/tweaking
	_ = open ticket not assigned
	x = completed/tested move to `done` list.
	--------------------------------------------
# DONE

`~` can use `ready` to toggle ready/notready

`~` Added jump awareness to teleports; jumping (or off ground) while going through the teleport, will transition the jump at the destination.

`~` Changed `autoweapon` - if CLANRING_SMART_WEAPON is off then never switch weapons. Otherwise, never switch if underwater or firing.

`~` added `autopov` like autochase

`X` added visual markers for info_teleport_destination prior to match start

`~` resend `find_pqc_teamscore_teams` at countdown init and match start.

`x` fixed `pqc_ping_times`; correctly updates scoreboard.

`x` expanded the `fov` for autoid so you dont have to pin-point your teammate to see who they are. Displays teammates' name in `white` if in pov, `red` if they are nearby but not in pov.

`x` Replaced "exec levels.cfg" with a proper function to read the levels.cfg.

`x` added `nextmap` command to vote for non-matchmode map rotation.
