//
// Userdefs.qc
//
// This file contains customizations for the Elohim mod.
// The strings are all buffers that are written to by crmake.
//
// All code by J.P. Grossman unless otherwise commented.
//

// Maximum number of suicides allowed per level in normal and match modes
float CLANRING_MAX_SUICIDES = 5;

//
//  I N I T  W O R L D
//
//  Create all string constants
//
void() userdefs_init_world =
{
	// User defined DM maps
	array_user_map[0] = "";
	array_user_map[1] = "";
	array_user_map[2] = "";
	array_user_map[3] = "";
	array_user_map[4] = "";
	array_user_map[5] = "";
	array_user_map[6] = "";
	array_user_map[7] = "";
	array_user_map[8] = "";
	array_user_map[9] = "";

	// User defined CTF maps
	array_user_ctf_map[0] = "";
	array_user_ctf_map[1] = "";
	array_user_ctf_map[2] = "";
	array_user_ctf_map[3] = "";
	array_user_ctf_map[4] = "";
	array_user_ctf_map[5] = "";
	array_user_ctf_map[6] = "";
	array_user_ctf_map[7] = "";
	array_user_ctf_map[8] = "";
	array_user_ctf_map[9] = "";
};
    