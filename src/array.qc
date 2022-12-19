//
// Array.qc
//
//

//--------------------------------------------------------------------------
// USER MAPS

//
// Used to set names of user-defined levels
//
string array_user_map[10];		// 10
string array_user_ctf_map[10];	// R00k: custom usermaps just for ctf

//--------------------------------------------------------------------------
// KICKS

//
// Used to collect a list of players that can be kicked
//
entity array_kick[255];			// (.colormap) network precision allows 255 players. colourmap 0 is invalid in places, hence 255 instead of 256

//--------------------------------------------------------------------------
// PASSWORDS

//
// Used to set admin passcodes
//
float array_password[10];		// 10
