//
// Defs2.qc                                   (Elodefs.qc)
//
// Constants and global variables used in the Elohim mod.
//
// All code by J.P. Grossman unless otherwise commented.
//
// See Elohim.qc for a list of standard fields used.
//

// constants
float CLANRING_SUICIDE_OK    		= 0;
float CLANRING_TOO_MANY_SUICIDES 	= 1;
float CLANRING_NEGINF    			= -9999999;

// client styles
float CLANRING_NEW_CLIENT    	= 1;			// set when a client first connects
float CLANRING_ADMINISTRATOR    = 2;			// set if the client is an admin
float CLANRING_AFK_CLIENT    	= 4;
float CLANRING_MUTED			= 8;
float CLANRING_READY 			= 16;           // ready to play in match
float CLANRING_YES 				= 32;           // used for voting
float CLANRING_HEADS_UP 		= 64;          	// enable heads up display
float CLANRING_SETTING_OPTIONS 	= 128;  		// set when setting options
float CLANRING_MOTD 			= 256;          // showing MOTD
float CLANRING_OK_TO_SHOOT 		= 512;      	// don't fire after options/respawn
float CLANRING_KICK_CONFIRM 	= 1024;    		// used to confirm a kick
float CLANRING_CONFIRM_LEAVE 	= 2048;   		// confirmation for leaving match
float CLANRING_CONNECTED 		= 4096;       	// client has been put in server
float CLANRING_FOUND_BINDINGS 	= 8192; 		// used to check for bindings
float CLANRING_SMART_WEAPON    	= 16384;		// whether or not to use `smart' weapon switching
float CLANRING_OBSERVER    		= 32768;		// set if the client is an observer
float CLANRING_AUTOID    		= 65536;
float CLANRING_SCOREBOARD 		= 131072;		// player is looking at teamscores
float CLANRING_NO_POST_THINK 	= 262144;		// don't do post think (optimization)
float CLANRING_WINQUAKE 		= 524288;     	// player is using winquake
float CLANRING_GLQUAKE 			= 1048576;     	// player is using glquake
float CLANRING_AUTOSTATS    	= 2097152;
float CLANRING_RED_TEAM			= 4194304;
float CLANRING_BLUE_TEAM		= 8388608;

// observer flags
float OBSERVER_WALK             = 1;            // set in walk mode
float OBSERVER_FLY              = 2;            // set in fly mode
float OBSERVER_CHASE            = 4;            // set in chase mode
float OBSERVER_DEMO             = 8;            // see through chasetargets eyes
float OBSERVER_CAMERA           = 16;		    // set to camera mode
float OBSERVER_AUTO             = 32;	        // view autoswitching
float OBSERVER_TOURNEY          = 64;	        // set tournement mode for chasecam
float OBSERVER_GO_AUTO          = 128;          // player entering an auto mode
float OBSERVER_COMMENTARY       = 256;          // see running commentary
float OBSERVER_POP_FORWARD    	= 512;
float OBSERVER_QUAKETV 			= 2048;		    // Sputnik: added this for streaming via quaketv

/*
// CRMOD qsmack variables
.float qsmack_level;
.float qsmack_trylevel;
float qsmack_statusokay;
*/

// server mode - stored in cvar 'samelevel' and preserved across levels
float CLANRING_NORMAL_MODE    		= 1;            //R00k:changed
float CLANRING_MATCH_MODE    		= 2;
float CLANRING_PRACTICE_MODE    	= 4;
float CLANRING_SERVER_INITIALIZED   = 8;
float CLANRING_NO_GIBS    		    = 16;
float CLANRING_LOW_GIBS    		    = 32;
float CLANRING_NO_QUAD    		    = 64;
float CLANRING_NO_PENT    		    = 128;
float CLANRING_NO_RING    		    = 256;
float CLANRING_MODE_VOTE    		= 512;
float CLANRING_CAPTURE_THE_FLAG		= 1024;
float CLANRING_NO_SPOOGE    		= 2048;
float CLANRING_RUNES			    = 4096;
float CLANRING_EXTENDED_OBITS    	= 8192;
float CLANRING_CONSOLE_INITIALIZED  = 16384;
float CLANRING_FAST_START    		= 32768;
float CLANRING_FRESH_SPAWNS         = 65536;//used?
float CLANRING_AUTO_PAUSE    		= 131072;
float CLANRING_RUNETOSS    		    = 262144;
float CLANRING_NO_HOOK			    = 524288;
//float UNUSED			= 1048576;
float CLANRING_CONSOLE_STATS   		= 2097152;//Used to dump stats to the server console (FIXME:TODO: use this flag to save stats out to a file instead of condebug.log)

// server .state - not preserved across level changes
float CLANRING_TIMER_STARTED  		= 1;
float CLANRING_MATCH_STARTED    	= 2;
float CLANRING_MATCH_PAUSED    		= 4;
float CLANRING_MATCH_OVER    		= 8;
float CLANRING_MATCH_WAIT  	    	= 16;// 5 second delay after match ends
float CLANRING_KICKING    		    = 32;
float CLANRING_IGNORE_CONSOLE		= 64;
// muddle counts :)
float CLANRING_SETQUAD_COUNT    	= 128;
float CLANRING_SETPENT_COUNT    	= 1024;
float CLANRING_SETRING_COUNT    	= 8192;
// end muddle (eats bits up to 65536)
float CLANRING_NO_PRACTICE    		= 131072;
float CLANRING_TEAM_CAPTURE_CUSTOM	= 262144;
float CLANRING_UNPAUSING    		= 524288;
float CLANRING_AUTO_PAUSED    		= 1048576;
float CLANRING_DELAYED_AUTOSS    	= 2097152;
float CLANRING_TAKING_AUTOSS    	= 4194304;
float CLANRING_NULL_FLAG		    = 8388608;//R00k: added, used to make the flags untouchable during match start countdown, ie "Match begins in T minus"...

// admin constants
float ADMIN_NORMAL_MODE    	= 0;
float ADMIN_PRACTICE_MODE   = 1;
float ADMIN_MATCH_MODE    	= 2;
float ADMIN_CTF_MODE    	= 3;

// entity constants
float CLANRING_MANUAL_SPAWN = 1;

// global variables
//float   clanring_player_ids;        // used for assigning unique player ID's
float   clanring_devparam;          // used for development
float   clanring_playmode;          // current play mode (non volatile flags)
float   clanring_state;             // server state (volatile flags)
float   clanring_timelimit;         // timelimit for matches (default 20 minutes)
float   default_timelimit;          // reset timelimit between matches in case of overtime or interrupted match abort
float   clanring_overtime;          // length of auto-overtime; 0 if none
float   clanring_nextcheck;         // used for periodic checks
float   clanring_nextcheck2;	    // used for frequent periodic checks
entity  clanring_request;           // used to control voting
float   clanring_level;             // number of current level in user level order
float   clanring_levelcount;        // used to scan through list in levels.cfg
float   clanring_lastcount;         // used to detect end-of-file in levels.cfg
string  clanring_firstlevel;        // used to remember the name of the first level in levels.cfg
float   dm_num_spawns;              // number of deathmatch spawn points (as opposed to ctf spawn points)
float   clanring_num_starts;        // number of match extra start points
float   clanring_num_cameras;       // number of cameras
string  clanring_version;           // used for motd and help-server
string  clanring_version_info;      // text info including rev. and compile time
string  clanring_version_number;    // text info storing version number (ie "4.0")
entity  clanring_debug_client;      // used for debugging
entity  clanring_quad;		        // pointer to quad for quick reference
entity  clanring_pent;		        // pointer to pent for quick reference

// match global variables
float   clanring_match_pause_time;  // records time that match was paused
float   clanring_maxteams;			// maximum number of teams
float   clanring_numteams;			// number of teams
float   clanring_maxsize;           // maximum allowed team size
entity  clanring_match_timer;       // used to time match
entity  clanring_sentinel;			// head of linked lists
string  clanring_szthe;			    // hack - = "The " for teamplay, "" for individual
string  clanring_szteam;			// hack - = "team" for teamplay, "player" for individual

// score global variables
string  clanring_winning_teamname;	// name of winning team (as returned by strings_get_teamname)
float   clanring_score_number;		// either difference in score or tied score
string 	CLANRING_STRING_TIED;       // initialized to "   Tied at "
float   clanring_score_count;	    // number of clients looking at score
entity 	clanring_first_place;
entity 	clanring_second_place;

// console global variables
float 	console_deathmatch;
float 	console_timelimit;
float 	console_fraglimit;
float 	console_pausable;
float 	console_noexit;

// auto parameters
float auto_parm1;	// 
float auto_parm2;	// 
float auto_parm3;	// 
float auto_parm4;	// 

// other global variables
string nextmap;                     // moved here from Client.qc
float timelimit;                    // this used to be local in CheckRules in Client.qc        
float fraglimit;                    // this used to be local in CheckRules in Client.qc        
float intermission_running;         // moved here from Client.qc
float intermission_exittime;        // moved here from Client.qc

entity 	clanring_best_chase_target;		// calculated every second who is the best target to chase // CRMOD - auto
entity 	clanring_current_chase_target;
float 	clanring_chase_delay;
entity 	clanring_best_camera;			// set after each camera's think
entity 	clanring_current_camera;
float 	clanring_camera_delay;

vector 	clanring_angle;					// used for both autoss and intermission

// client variables
.vector clanring_qdwep;             // vector to keep track of quad weapon stats	// CRMOD - stats
.vector clanring_qdkill;            // vector to keep track of quad kill stats	// CRMOD - stats
.vector clanring_badstats;          // keep track of RL paks and damage done to team
.entity clanring_othertarget;       // entity to focus on in tourneycam		// CRMOD - tourneycam
.entity clanring_inflicted;         // stores entity last attacked			// CRMOD - combat
.float  clanring_chase_score;       // same as above, also used by cameras
.float  clanring_did_damage;        // last time person did damage
.float  oflags;				        // CRMOD observer flags
.float  clanring_cam_delay;         // keep autocam from overswitching
.vector clanring_oldangle;          // set by angles_fixangle
.float  delayed_impulse;		    // saves self.impulse so it doesn't get nuked by a ping
.float  timeslot;			        // records which scoreboard slot is used for time
.entity next_player;		        // used to point to first/next player in team
.entity next_team;			        // used to point to next team
.entity next_camera;		        // used to point to next camera
.vector clanring_old_velocity;      // used for pausing/unpausing
.float  clanring_hack_count;	    // used to count admin hacking attempts

float 	CLANRING_ANGLE_SMOOTHING    = 0.6; // CRMOD use this instead of typing the number a billion times (actually 6 times in observer.qc ;) )


//-----------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------
void(string s1, ...) cprint;
void(string s1, string s2) cprint2;
void(string s1, string s2, string s3) cprint3;
void(string s1, string s2, string s3, string s4) cprint4;
.float 	rotthink;//megahealth think

.string name_ready;
.string oldname;
.string trueip;

.float 	plag;
.float  lagcheck;
.float	lagcount;

.float 	warp_episode;//chosen episode to warp
.float 	warp_map;//chosen map to warp

.float 	hook_out;

//ctf variables from ZOID's 3wave
float 	TEAM_CAPTURE_CAPTURE_BONUS    			    = 5;
float 	TEAM_CAPTURE_TEAM_BONUS    			        = 10;
float 	TEAM_CAPTURE_RECOVERY_BONUS    			    = 1;
float 	TEAM_CAPTURE_FLAG_BONUS    			        = 0;
float 	TEAM_CAPTURE_FRAG_CARRIER_BONUS    		    = 2;
float 	TEAM_CAPTURE_FLAG_RETURN_TIME    		    = 30;//was 40
float 	TEAM_CAPTURE_CARRIER_DANGER_PROTECT_BONUS 	= 2;
float 	TEAM_CAPTURE_CARRIER_PROTECT_BONUS    		= 1;
float 	TEAM_CAPTURE_FLAG_DEFENSE_BONUS    		    = 1;
float 	TEAM_CAPTURE_RETURN_FLAG_ASSIST_BONUS    	= 1;
float 	TEAM_CAPTURE_FRAG_CARRIER_ASSIST_BONUS    	= 2;
float 	TEAM_CAPTURE_TARGET_PROTECT_RADIUS    		= 550;
float 	TEAM_CAPTURE_ATTACKER_PROTECT_RADIUS    	= 550;
float 	TEAM_CAPTURE_CARRIER_DANGER_PROTECT_TIMEOUT	= 2;
float 	TEAM_CAPTURE_CARRIER_FLAG_SINCE_TIMEOUT   	= 2;
float 	TEAM_CAPTURE_FRAG_CARRIER_ASSIST_TIMEOUT   	= 6;
float 	TEAM_CAPTURE_RETURN_FLAG_ASSIST_TIMEOUT   	= 4;
float 	TEAM_CAPTURE_UPDATE_TIME  			        = 120;
float 	TEAM_UPDATE_DELAY  				            = 0.1;
//ctf variables--------------
float 	RED            		= 5;
float 	BLUE          		= 14;
float 	FLAG_AT_BASE  		= 0;
float 	FLAG_CARRIED  		= 1;
float 	FLAG_DROPPED  		= 2;
.float 	flag_carrier;
entity 	team1_lastspawn;
entity 	team2_lastspawn;

//variables from expert ctf
.float 	last_hurt_carrier;
float  	last_flag_capture;
float  	last_capture_team;
.float 	flag_since;
.float 	last_returned_flag;
.float 	last_fragged_carrier;
.float 	lastteamupdate;

//flagstats

.float 	fdefenses;
.float 	freturns;
.float 	fpickups;
.float 	fdrops;
.float 	fcaptures;
.float 	fcdefenses;
.float 	fcassists;
.float	fcfrags;

//.float 	onteam;
.float	true_kills;
.float 	dmg_taken;
.float 	dmg_given;
.float 	captime;

//weapon toss times
.float toss_time;

//enhanced engine colored lighting support
float	EF_YELLOW 		    = 32;
float   EF_BLUE         	= 64;
float   EF_RED          	= 128;
//float   EF_GREEN          	= 256;

float  	sys_ticrate;
//float	sv_friction;
float clanring_ctf_ticrate;
float clanring_tdm_ticrate;

.float 	hurt_together_time;
.float 	hurt_nextthink;
.float	id_time;//delay autoidentify teammates

.float	killed;//used to determine base spawn points
//.float	gibbed;//time to explode player
float	modelindex_head;
.float	previous_weapon;

float(float start, float end, float stepsize) rnd_number;
//.vector norg;
float 	teamscr1;
float 	teamscr2;
.float 	statstate;
.float 	laststattime;		// time of last status update
float 	lastteamscrtime;
float 	TEAMSCRTIME    = 1;
float 	PLAYERSTATTIME    = 1.75;

entity  runespawn;
float   runespawned     = 0;
float   ITEM_RUNE1_FLAG = 1;
float   ITEM_RUNE2_FLAG = 2;
float   ITEM_RUNE3_FLAG = 4;
float   ITEM_RUNE4_FLAG = 8;
float   ITEM_RUNE_MASK  = 15;
.float  items2;
float   IT2_SIGIL1 = 32;
float	IT2_SIGIL2 = 64;
float   IT2_SIGIL3 = 128;
float   IT2_SIGIL4 = 256;
.float  rune_notice_time;
.float  player_flag;//rune value
.float  regen_time;
.float  regeneration_sound;
.float  haste_sound;
.float 	hookdmg;// damage collector for hook
float  	clanring_kick_mode;
float  	KICK_NONE  	= 0;
float  	KICK_KICK  	= 1;
float  	KICK_BAN   	= 2;
float	KICK_AFK	= 3;
float 	sys_ready;//hold on the server is loading!!
float 	debug = 0;
.float 	ctime;
string	clanring_version_red;
.entity hookentity;

//---custom 'server modules' off-hand hook added for pub mode. (FIXME: remove this shit)
.float 	hook_out;
.float 	hook2;
float 	HOOK_OUT 	= 1;
float 	HOOK_SWING	= 2;
//---
entity	intermission_pos;
//float	banlist;
entity	banent;
float 	hookspeedfire;
float 	hookspeedpull;
.float  delay;

.float 	alpha;//server must support this.
.float	ping_time;//client pings

.float 	hack_timeout;

// JPG - added ProQuake commands
float	PQC_NOP		    =	1;
float 	PQC_NEW_TEAM	=	2;
float	PQC_ERASE_TEAM	=	3;
float 	PQC_TEAM_FRAGS	=	4;
float	PQC_MATCH_TIME	=	5;
float 	PQC_MATCH_RESET	=	6;
float 	PQC_PING_TIMES	=	7;
// JPG - end mod

float	clanring_afk_check;
float	clanring_afk_timeout;
.float	afk_time;

float	stats_timelimit;
float	stats_matchtype;

.float  csqc_enabled;

typedef struct 
{
	string 	name;	// filename WITHOUT '.bsp'
	string 	title;	
	string	author; 
}servermap_t;

servermap_t warpmap[200];

string warpmenutop[11]; // Customizable map categories for the warp menu contents.
