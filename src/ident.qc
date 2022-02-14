
string (entity e) ident_get_weapon_in_hand =
{
	if (e.weapon == IT_ROCKET_LAUNCHER) 	return "rl";
	if (e.weapon == IT_LIGHTNING) 			return "lg";
	if (e.weapon == IT_GRENADE_LAUNCHER) 	return "gl";
	if (e.weapon == IT_SUPER_NAILGUN) 		return "sng";
	if (e.weapon == IT_SUPER_SHOTGUN) 		return "ssg";
	if (e.weapon == IT_NAILGUN) 			return "ng";
	if (e.weapon == IT_SHOTGUN) 			return "sg";
	if (e.weapon == IT_AXE) 				return "axe";
	if (e.weapon == IT_HOOK)				return "hook";
											return "fist";
}

string (entity e) ident_get_other_weapons =
{
	local string t = "";

	if ((e.items & IT_ROCKET_LAUNCHER) 	&& (e.weapon != IT_ROCKET_LAUNCHER))	t = sprintf("%s%s", t, "\.rl");
	if ((e.items & IT_LIGHTNING) 		&& (e.weapon != IT_LIGHTNING))			t = sprintf("%s%s", t, "\.lg");
	else
	if ((e.items & IT_GRENADE_LAUNCHER) && (e.weapon != IT_GRENADE_LAUNCHER))	t = sprintf("%s%s", t, "\.gl");
	else
	if ((e.items & IT_SUPER_NAILGUN) 	&& (e.weapon != IT_SUPER_NAILGUN))		t = sprintf("%s%s", t, "\.sng");
	else
	if ((e.items & IT_SUPER_SHOTGUN)	&& (e.weapon != IT_SUPER_SHOTGUN))		t = sprintf("%s%s", t, "\.ssg");
	else
	if ((e.items & IT_NAILGUN)			&& (e.weapon != IT_NAILGUN))			t = sprintf("%s%s", t, "\.ng");

	return t;
}

string (entity e) ident_get_rune_type =
{
	if (e.player_flag & ITEM_RUNE1_FLAG)//Rune 1 - Earth Magic(resistance)
	   return "\.resistance";	
	if (e.player_flag & ITEM_RUNE2_FLAG)//Rune 2 - Black Magic(strength)
	   return "\.strength";
	if (e.player_flag & ITEM_RUNE3_FLAG)//Rune 3 - Hell Magic(haste)
	   return "\.haste";
	if (e.player_flag & ITEM_RUNE4_FLAG)//Rune 4 - Elder Magic(regeneration)
	   return "\.regeneration";
	   
	return "";
};

string (entity e) ident_get_armor_type =
{	
   	if (e.items & IT_ARMOR3)	return "r";    	
   	if (e.items & IT_ARMOR2)	return "y";   	
   	if (e.items & IT_ARMOR1) 	return "g";
   	  
	return "";
};

void() ident_update_display =
{
	local string armour;
	local string aval, hval, rtype, weap, ammo, it; 
	local string line1 = "", line2 = "";
	
	armour	= ident_get_armor_type(trace_ent);

	aval 	= strings_ftos_gold(trace_ent.armorvalue);
	hval	= ftos(trace_ent.health);                  
	rtype	= ident_get_rune_type(trace_ent);
	weap 	= ident_get_weapon_in_hand(trace_ent);
	ammo 	= ftos(trace_ent.currentammo);
	it		= ident_get_other_weapons(trace_ent);
	
	line1 = sprintf("\n\b[\b%s%s\.%s%s\b]", armour, aval, hval, rtype);

	if (trace_ent.currentammo)
		line2 = sprintf("\[%s\.%s\]%s", weap, ammo, it);
	else
		line2 = sprintf("\[%s\]%s", weap, it);

	centerprint(self, trace_ent.netname, line1, line2, "\n\n\n\n\n");//fixme move the position down or up?
};

void() ident_get_target =
{
	makevectors (self.v_angle);

	traceline (self.origin, self.origin + v_forward * 1200 + '0 0 16', FALSE, self);
	
	if (trace_fraction < 1) 
	{
		if ((trace_ent.classname == "player") && (trace_ent.style & CLANRING_CONNECTED)) 
		{
			if (trace_ent.team == self.team)
			{
				ident_update_display();
			}			        			
		}		
	}
};
