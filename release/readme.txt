
Title    	: ClanRingMod (beta)
Filename 	: crmod36.zip
Version  	: 3.6
Date     	: 09/01/2021
Author(s)  	: R00k, JP Grossman, Zoid 
Email    	: 
URL      	: 
Description	: Competition Team Deathmatch and Capture The Flag mod for Quake 1.
		  Based on original works by Dave 'Zoid' Kirsch and JP Grossman. 
		  **REQUIRES FTEsv or QSS.
____________________________________________________________________________

New Features
____________________________________________________________________________

v3.5

+ Added: AFK status, players who dont jump or shoot within a given time become AFK. 
	AFK players who dont jump or shot for a certain time get kick.
	
+ Added: setafk console command, to set the time player become afk.

+ Added: kickafk console command, to set the duration of time before the player is kicked.

+ Added: CRMOD mode, to set the server in TEAM DEATHMATCH mode.	Use "DM" command for DM and "ctf" for CTF!

+ Fixed: Switch to new camera if the camera's target is blocked by a wall.

+ Added faststarts as a voteable option.

+ Fixed: Update pings on scoreboard when players are 'READY'.

+ Fixed: Optimized the ban routines.

____________________________________________________________________________
--v3.4
+ Added: Death Match Mode 4. Weapons and Ammo respawn times are 15 seconds, and if a player already has a weapon, they cannot retake.
+ Changed: Smoother 'tournament' camera angle interpolation.
+ Added : Break away hook. The hook breaks if the difference of velocity of the two players hooked together is greater 640.
+ Added : Proquake's PQ_TEAMSCORES command to show teamscores in statusbar.
+ Added	: tossruneoff command for crctf.cfg, disables rune tossing (impulse 19), runetoss is on by default.
+ Added	: dischargeoff/dischargeon commands to crctf.cfg Default is dischargeoff.
	____________________________________________________________________________
	dischargeoff: 	turns OFF lightning gun discharging in practice mode completely. 
			Limits discharging to affect only players in liquid, not out of water, for match mode and normal mode.
			Also biosuit protects 80% from discharging. (Think of it as a temporary "Red Armor" for underwater only)
	
	dischargeon: 	uses normal discharging rules.	
	
	Can also toggle via admin options 'no spooge'.
	____________________________________________________________________________
+ Fixed: hook select is 1/2 time weapon select.
+ Added: Proquake's pqc_ values to pass matchtime and teamscores from CRCTF to a proquake's Client.
	This properly shows to all clients the true pq_timer values especially to clients
	who connect after the match has started. Also updates the pq_teamscores properly.
+ fixed: Automatic request to unpause the match when it is not paused.
+ Changed: In classic mode, apon connecting you are automatically put on a team.
+ fixed: Players connecting during intermission didnt get aliases bound properly.
+ fixed: If player lost flag in prematch, the statusbar still showed flag icon.
+ modified: REGEN & MEGAHEALTH CHANGE
	Megahealth respawns normally 20 seconds after the player's health drops back down to 100 or less.
	Regen will prolong this respawn time to the extent that megahealth is no longer effective, for gameplay.
	So, if a player with regen gets megahealth, and their health hasn't dropped below 100 for over 105 seconds,
	(same as 5 second pause + 100 health points [default time]), then it respawns 20 seconds afterwards.
	Logically, if a player took megahealth without regen and just stood there without getting shot, 
	it would take 105 seconds for megahealth to wear off.	

+ fixed: Proper handling of doors, plats, and trains during match paused, and unpausing. 
+ changed: Sethook now is used to control the pullspeed of the hook: slow (800), fast (1000 default), or 
	   diasble the hook all together.
+ changed: Death sounds are no longer GLOBAL, instead when a player dies, its only heard, in proximity.
	   This is good in a few ways. 
	   1.) Easier on the ears while playing 
	   2.) You dont actually know when your teammates dies, unless you read the obits
	   3.) If someone dies nearby, you now can hear in what direction, 
	   	ie. you heard death, read obit, know who/where death occured...
+ added: Flags are reset at the t-minus 10 countdown in match mode, and cannot be touched until match start.
+ fixed: Reduced occurance of respawning at the origin of death.
+ fixed: allow players to connect during an intermission.
+ added: display message to show proquake versions of a client on connection.
	(unknown, if using pre 2.0 or NON proquake if using anything else)
		
+ added: flags to .ent files
+ fixed: damage momentum from blast radius 	 
+ fixed: Observers cannot change to team colors while a match is in progress, *if* the match is LOCKED.
	 This deters "coaching" by using mm2 and chasecam to talk to players.
+ fixed: Bug where prematch flag runs, would allow a player to type NOTREADY while holding the flag,
	 and then change teams. Thus, the player still had the flag, even in observer mode. After match
	 start, flag would fall on map and not respawn at base.

+ fixed: AUTOCHASE's "DEADCAM" SHAKE bug. 
+ added command to toggle auto teammate identifier, AUTOID
	Identifies when crosshair passes over teammate:	[name][health/armor]
+ disabled exploit that allowed observers to toss items while eyecamming/chasecamming (OOPS!)
+ no weapon dropping during paused match
+ fixed autochase bug (from 3.19j)
+ added bancode
+ fixed flags during match pause.
+ hook and runes are paused properly.
+ if match is aborted the timelimit is reset to the value the match started at.
+ fixed (.frags) assignment to world entity bug 
	server crash when someone connected at the same time a team had captured the flag.	
+ Fixed Observer's "up by" score.
	was not accounting for CTF score only kill frags.
+ If a flag falls on a trigger_hurt, it automatically returns to base.(requested)
+ ignored levels.cfg in match mode (quicker map loads)
+ Fixed flaw in vote disable rune code. 
	Rune entites were not removed only "disabled" (ie. no model, no touch, no respawn)
	When the vote to re-enable runes while on same map, it would create NEW entities.
	Now, disabled runes are truely removed.
+ Fixed Platfroms during paused match.
+ Fixed AutoStats to log files. Use cfg command AUTOSTATSON 
	All death messages are logged.
	CTF announcements are logged.
+ Observers cannot initiate votes during match.
+ Player's cannot suicide during a paused match.
+ Flags and runes are truely paused during match pause
____________________________________________________________________________
--v3.3-- 
+ Anticrossdressing code implemented. CUSTOM SHIRT COLORS ARE AVAILABLE!
  Though, you cannot xdress! This means, YES you can have (color 0, 13), or
  (color 5, 4) ETC... But NOT color (2, 4) OR (13, 4) OR (4 , 13)...

+ Increased delay before hook returns after player lets off fire button if 
  hook has not touched anything. (was 0.3 seconds, now its 1/2 a second)

+ No damage during paused matches.

+ Flag Carrier has primary time slice for AutoCam.

+ Voter's name added to vote request message, also to yes/no votes.

+ Hook damage normalized for all ticrates.
	At lower ticrate values, ie (0.05) damage encured was updated faster.

+ Added DYNAMICHOOKON and DYNAMICHOOKOFF commands.	
	Dynamic hook simulates the hook physics of 0.1 ticrate for all ticrates,
	off = ticrate determines hook physics (DEFAULT).
	**** This is used to actually limit the bunny-hopping speed, when landing from a hook. 
	Bunny-hop speed is limited to 576.
	
+ Fixed hooking in windtunnels, works at all ticrates.		

+ Support for fraglimit in matchmode.
	
+ Added console commands RUNESON and RUNESOFF for crctf.cfg.

+ added offhand hook for classic mode (only).
	bind a key to +hook (impulse 97/98).
	will fire hook while holding another weapon.
	fixed a bug in servermoules code that never reset the "backlash" physics
	of the hook, after first fire. Thereafter, made the hook's pull "saggy".
	
+ Added Runes, via request.
	Use SETRUNES to toggle runes.	
	added runes status to rules display.
____________________________________________________________________________
--v3.2--
+ Added SetHook command to toggle the hook on or off.
+ Enhanced display of power-ups in the RULES command.
+ Added READY to scoreboard in MATCH mode when player commits to a team. 
+ Added Best Capture Time to Flag Stats. 
+ Buttons/Triggers dont bleed. 
+ Added Damage Taken/Damage Given to KILLSTATS 
+ Smooth Weapon transitions while firing, (id bug) fixed. 
+ Smoother camera if a player walks between objects. 
+ Obituaries reflect watertype when discharging. (water/lava/slime) 
+ Enhanced WARP command supports userdefs.cfg
+ Added delay after VanishHook when hitting teammates with hook.
+ Added PreMatch Capture Time Practice.
+ Armor doesnt deplete while drowning.
____________________________________________________________________________
--v3.1--
+ Fixed E1M3 flag squish bug.
+ Skin errors on Ring of Shadows: (FIXED!)
	Eyes.mdl only has one skin.	
+ Skin errors on Gibs: (FIXED!)
	In old CRCTF 2.8, custom skins for blue team would cause skin errors on 	
	gibs because the skin value was 3 or 4, but the h_player.mdl only 
	has skins 0, 1, and 2.
+ 'Normal' mode is now working!  
	The look and rules are the same as a Classic ThreeWave 3.0 server,
	with all the features CR brings.
    	Non-custom models.
    	Improved check team code.  Players are put on the team with fewer 
    	members or if the team count is the same, they are put on the     	
    	losing team.    
+ When a flagcarrier disconnect/lagsout the flag drops at that origin to the 
  ground. If autopause is activated and the player reconnects and ghostcodes
  back into the game they will regain their old origin ontop of flag where
  they will regain posession when match is unpaused.  
____________________________________________________________________________  
----v3.0---
+ Fixed CR's Overtime timer reset bug.
+ All CTF stats are now saved to a clients ghost so they may be restored.  
+ Fixed the CR bug when using bullets or nails to shoot buttons
  your eff will increase.
+ Added powerups to the 'rules' display like in the newer versions of CR. 
+ Fixed automatic request to unpause the match when it is not paused. 
+ ThreeWave skins in match mode. 
+ Fixed all kill stats. 
+ Milliseconds now shown in capture time. 
+ Client's classname and health is now cleared on disconnect
+ Ghost eyes and hovering bodies fixed on client disconnect
+ Removed damage on changelevel_touch for ctf
+ Wrong obituary messages fixed
+ Powerups removed when voted off in "real-time"
+ Better performance in handling of powerups
+ Correct removal of the chain when passing through teammates
+ Enhanced item_weapon function
+ Improved weapon and powerup touch functions
+ Some weapon name corrections
+ Improved weapon switching on pickups
+ Multiple megahealth rot fixed: follows standard powerup rules for duration and respawn times.
+ Better performance in handling of powerups
+ Thunderbolt fix (never switches on pickup to thunderbolt while underwater)
+ Never switch to weapon pickup while hook is out.
+ Walkframe leak fixed
+ Improved bubble spawn
+ Bubblespawner remove fixed
+ Replaced id's plat_center_touch function with ThreeWave's.  
+ Flag captures are timed
+ Corrected sound channel for flag sounds
+ Double/Inverted telefrag fix
+ Pentagram telefrag fix
+ Fixed id's buggy teleport_touch function that would crash the server
+ hurt_touch fix
+ Backpacks are allowed to be pushed through wind tunnels.
________________________________________________________________________________
---------------------------------------------------------
---------------------------------------------------------
Title    : ClanRing CRMod++ v5.1 Quake Competition Server
Filename : crbeta51.zip
Version  : 5.1beta1
Date     : December 10, 1999
Authors  : J.P. Grossman (a.k.a. Mephistopheles)
Email    : jpg@ai.mit.edu
URL      : http://www.mpog.com/clanring/crmod

This is a Quake1 NETQUAKE mod.  It does not work with Quakeworld.  Do not send
us email asking us to make a Quakeworld version; we're not going to.


What's new?
=======================================
The following changes are introduced by CRMod++ v5.1:

New Features (major)
------------
- Support for up to 10 admin codes (so that you can give different codes to
  different people, and if a code leaks you know who leaked it!)
- 'admins' command (for clients and console) to list server administrators
  and which codes they used to become admin
- All announcements are echoed to a dedicated server's console, including:
	- obituaries
	- time remaining messages in matches	
	- match commentary (who got quad, who has control, etc.)
- Added teamstats command which keeps track of the following statistics:
	- Number of Q, 666, ring, RL, LG, GL, SNG, NG, Mega Health, RA, YA, GA
	- Number of RL paks dropped (including those not picked up)
	- Number of times a player with no RL picked up an enemy RL pack
	- Percentage of game for which a team had control
- Added autostatson/autostatsoff console commands

New Features (minor)
------------
- made voting easier to see:
	- voting messages are bronze
	- talk.wav is played when a voting message appears
- made suicides remaining regenerate slowly
- made observer/ready in normal/practice mode count as a suicide to
  prevent observer-spamming
- added "team lost control" to observer commentary

MAJOR BUG FIX
-------------
- eliminated can't jump/shoot/turn/change level bug!!!

This elusive bug has been around since version 4.0.  I finally tracked it
down to a subtle problem with the level-changing code combined with John
Carmack's flaky changlevel() routine.  Specifically, if changelevel()
is called with "" as an argument, then ALL FUTHER calls to changelevel will
fail, so that the only way to change levels is from the server console.
I therefore replaced the supplied changelevel routine with some quakeC
code that does some sanity checks and then uses localcmd to change levels.

Other Bug Fixes
---------------
- fixed listen server maxteams bug
- prevent can't-respawn if +attack is locked on death
- fixed quadstats team summary in console after match end

Description of crmod Files
=======================================
readme.txt       - This file
manual.txt       - Clanring CRMod++ v5.0 user's manual
autoexec.cfg     - Server startup config file
crmod.cfg        - Config file used to set the administrator password
levels.cfg       - Config file used to set the level order
userdefs.cfg     - Config file used to set the MOTD and custom levels
progs.dat        - Quake program data file run by the server
crmake.exe       - Utility to add the userdefs to progs.dat (Win32 build)
crmake.linux     - Utility to add the userdefs to progs.dat (linux build)
entities\*.ent   - Optional entity files
cameras\*.cam    - Optional camera files

Description of other files
=======================================
qstrings.exe     - Utility for editing strings with the quake character set
dequake.exe      - Utility for converting quake characters to text characters
                   (win32 build)
dequake.linux    - Utility for converting quake characters to text characters
                   (linux build)

Dequake is useful for "decoding" name scripts or console logs so that they
can be viewed as text files.


Setup and Installation
=======================================
1. Create a subdirectory in your Quake directory called 'crmod' or whatever
   else you feel like calling it.
   
2. Unzip the contents of crmod50.zip into this new subdirectory.  Make sure that
   whatever program you use to unzip the files preserves the directory structure
   contained in crmod50.zip.

3. Edit autoexec.cfg, crmod.cfg, levels.cfg and userdefs.cfg.  Each of these
   files is commented with editing instructions.  Make sure you change the
   passwords!

4. Run the crmake utility.  (crmake.exe in Win95/NT or crmake.linux in linux)

5. Start up your quake server with '-game crmod' in the command line replacing
   'crmod' with whatever name you gave your subdirectory.
   
Examples:  

  winquake.exe -condebug -zone 512 -game crmod -dedicated +hostname godzilla 
  unixded -condebug -zone 512 -game crmod -dedicated 16 +hostname bambi
  
It is *strongly* recommended that you place '-zone 512' in the command line.
Otherwise the server may crash with a Z_Malloc error when it tries to read
some of the larger camera/entity files included with the mod.  It is also
recommended that you use -condebug.  This will create a console log called
Qconsole.log in your crmod directory.  It is useful for seeing what has 
happened on your server, and it can also help the debugging process if you
encounter problems running crmod.

6. READ THE MANUAL!!!

Copyright
=======================================
All files included with this modification are Copyright 1998,
Idle Communications, Inc.

Author Information
=======================================
J.P. Grossman is a third year graduate student at M.I.T. in the department 
of Electrical Engineering and Computer Science.  He has been hacking Quake 
since Oct. '97 when he began working on the Elohim Server.  J.P. have been 
hacking computers in general for 20 years.  He started in grade 1 writing 
BASIC programs for a VIC-20 and saving them on a tape drive, often 
accidentally erasing the end of the previous program.


Acknowledgements
=======================================
Thanks to Paul Baker, author of Clanring 3.0-3.1 and co-author of 
CRMod++ 4.0-4.2.  Paul innovated such features as tournament mode for
chasecams.

We would like to thank Ignatu (a.k.a. Frank Cabanski), who introduced Paul 
and J.P. to one another, for his patience and support throughout the early
stages of 4.0.  WE LOVE YOU FRANKY!  It would not have been possible to
create this server without the help of Tovi "Izra'il" Grossman, whose
suggestions, encouragement and bug reports, starting from the day the Elohim
Server was conceived, were invaluable.  Version 5.0 benefitted enormously
from the suggestions and bug reports of Mark "Turmoil" Santaniello and
Chris "Molotov" Ruvolo.  Thanks to Chris "ocor0ner" Van Wie from taking so
much pleasuer in making crmod crash - I owe you a drink.  Thanks also to 
Justin Hays and Dan "Nesta" at apci for their suggestions and their help 
with beta testing the Elohim Server versions 2.0 and up.  

A big thanks goes to everyone on EFNet IRC, especially those in #ClanRing, 
#ClanChat, and #Club_Bastardo.  Without those spur of the moment testers, 
who knows how long this would have taken.  Another big thanks to Lemurboy 
(a.k.a. Joel Baxtor) and the rest of Clan9 for QSmack 
(http://lemur.stanford.edu/clan9/qsmack/) and their great suggestions and 
constant help and testing.  

Finally, thanks to everyone who has ever mailed in a suggestion or bug report;
this mod's for you!

License Agreement
=======================================
This modification is free for public and private non-commercial
use.  To use this modification for commercial purposes or to promote
any commercial venture, you must contact Idle Communications at 
ignatu@idle.com.

No modifications can be made to this mod with the exception
of the necessary config files as specified in this readme.

The ClanRing CRMod++ v5.1 Competition Server may be used on any server
without prior written permission of Idle Communications provided that:

1. No persons shall be charged to play on any server running the mod.
2. It is not modified in any way except as stated in the
   installation section of this readme file.
3. It is not used in any way to promote commercial entities or ventures.
4. No llamas are harmed during the use of the server.

You may not distribute any of the files included with this modification!

If you would like to license the source code to this mod, please
contact ignatu@idle.com.

Decompiling the progs.dat violates copyright and other applicable laws.
Don't do it!

Technical Support
=======================================
Send all questions/bug reports/comments/suggestions to crbug@mpog.com

Legal Notice
=======================================
The contents of this file and may change at any time, so don't blink. As with
all other mods, this software is provided "as is".  We are not responsible
for any personal losses or damages caused by this software which include, but
are not limited to, lack of sleep, reduced sex drive, nausea and vomiting,
loss of sight, serious bodily harm, financial destitution, termination of
relationships, death of pets or family members or self, loss of friends,
repetitive strain injury, lowered intelligence, and the complete erasure of 
all hard drive contents.  Of course, you can't wipe a hard drive with 
QuakeC.

Or can you? ;)

