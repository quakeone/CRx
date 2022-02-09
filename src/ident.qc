

string (entity e) ident_get_weapon =
{
	if (e.weapon == 32) 	return "rl";
	if (e.weapon == 64) 	return "lg";
	if (e.weapon == 16) 	return "gl";
	if (e.weapon == 8) 		return "sng";
	if (e.weapon == 2) 		return "ssg";
	if (e.weapon == 4) 		return "ng";
	if (e.weapon == 1) 		return "sg";
	if (e.weapon == 4096) 	return "Axe";
							return "";
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
	local string aval,hval,rtype, weap, ammo; 
	local string line1 = "", line2 = "";
	
	armour	= ident_get_armor_type(trace_ent);
	aval	= sprintf("%03g", trace_ent.armorvalue);
	hval	= ftos(trace_ent.health);                  
	rtype	= ident_get_rune_type(trace_ent);
	weap 	= ident_get_weapon(trace_ent);
	ammo	= ftos(trace_ent.currentammo);
	
	line1 = sprintf("\n\b[\b%s%s\.%s%s\b]",armour,aval,hval,rtype);
	line2 = sprintf("\[%s\.%s\]",weap,ammo);

	centerprint(self, trace_ent.netname, line1, line2);
};

void() ident_get_target =
{
	makevectors (self.v_angle);
	
	traceline (self.origin, self.origin + v_forward * 1200, FALSE, self);
	
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
