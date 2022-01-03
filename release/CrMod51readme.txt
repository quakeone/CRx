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

