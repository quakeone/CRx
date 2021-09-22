void() ident_update_display =
{
	local string armour;
	local string aval,hval,rtype; 
	
	armour = strings_get_armor_type(trace_ent);
	aval   = strings_get_armor_val(trace_ent);      
	hval   = ftos(trace_ent.health);                  
	rtype  = strings_get_rune_type(trace_ent);
	
	centerprint(self, trace_ent.netname, armour, aval,"ù",hval,rtype,"\n\n\n\n");         
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
