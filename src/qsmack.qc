//
// qsmack.qc
//
// This is the qsmack handling code for CRMod++.
//
// QSmack developed by Joel Baxter of Clan9 (http://lemur.stanford.edu/clan9/qsmack/)
//
// All code by Paul Baker unless otherwise commented.
//
// Note on QSmack admin code security in CRMod++ 4.0:
// There are currently 231^5 different possible admin codes available for QSmack in CRMod++ 4.0
//
// Client fields used:
//
// .qsmack_level
// .qsmack_trylevel
//
// Prototypes:
void() admin_create;
void() elohim_bad_impulse;
void() observer_start;
void() elohim_observer_start_think;

// JP - changed bounds check to [20, 250]
void() qsmack_init_server =
{
	local float temp;
	if (QSMACK1 == 0)
	{
		localcmd("echo QSmack Disabled on this Server!  For more information \n");
		localcmd("echo on QSmack, point your favorite web broswer to: \n");
		localcmd("echo \"http://lemur.stanford.edu/clan9/qsmack/\"\n");
		localcmd("echo\n");
		return;
	}
	else if ((QSMACK1 < 20) || (QSMACK1 > 250))
		temp = 1;
	else if ((QSMACK2 < 20) || (QSMACK2 > 250))
		temp = 1;
	else if ((QSMACK3 < 20) || (QSMACK3 > 250))
		temp = 1;
	else if ((QSMACK4 < 20) || (QSMACK4 > 250))
		temp = 1;
	else if ((QSMACK5 < 20) || (QSMACK5 > 250))
		temp = 1;
	else
		temp = 0;
		
	if (temp)
	{		
		localcmd("echo You have not set up QSmack correctly! Please refer to server documentation\n");
		localcmd("echo for information on how to properly configure QSmack to work with CRMod++\n");
		localcmd("echo\n");
	}
	else
	{
		elohim_playmode = elohim_playmode | CRMOD_QSMACK_ON;
		localcmd("echo QSmack Initialized...\n");
		localcmd("echo Waiting for QSmack Bot connection...\n");
		localcmd("echo\n");
	}
};
	
// JP - fixed same-code bug (it would break if QSMACKi == QSMACKj)
void() qsmack_detecting =
{
	local float didAdmin;
	didAdmin = 0;

	self.finaldest_x = time;
    
    if ((self.impulse == QSMACK1) && (self.qsmack_level == 0))
    {
        localcmd("echo QSmack:  Init Passed!\n");
        self.qsmack_level = 1;
        self.qsmack_trylevel = 1;
        didAdmin = 1;
    }
    else if ((self.impulse == QSMACK2) && (self.qsmack_level == 1))
    {
		localcmd("echo QSmack:  Init1 Passed!\n");
        self.qsmack_level = 2;
		didAdmin = 1;
    }
    else if ((self.impulse == QSMACK3) && (self.qsmack_level == 2))
    {
		localcmd("echo QSmack:  Init2 Passed!\n");
        self.qsmack_level = 3;
		didAdmin = 1;
    }
    else if ((self.impulse == QSMACK4) && (self.qsmack_level == 3))
    {
        localcmd("echo QSmack:  Init3 Passed!\n");
        self.qsmack_level = 4;
        didAdmin = 1;
    }
    else if ((self.impulse == QSMACK5) && (self.qsmack_level == 4))
    {
        self.qsmack_level = 666;
        didAdmin = 1;
        localcmd("echo QSmack:  Init4 Passed!\n");
        self.style = self.style | CRMOD_QSMACK;
        admin_create();
        if (!(self.style & ELOHIM_OBSERVER))
        {
            observer_start();
        	utils_make_scheduled_event(elohim_observer_start_think, 0.6);
        }
    }
    
    if (didAdmin == 0) 
    {
        if (self.qsmack_level != 0) 
        {
            self.qsmack_level = 666;
        }
    }
    if (self.qsmack_trylevel != 0) 
    {
        if (self.qsmack_trylevel == 1) 
        {
			localcmd("echo QSmack:  Init1 --> ");
			localcmd(self.netname);
			localcmd("\n");
        	stuffcmd(self, "init01;\n");
            self.qsmack_trylevel = 2;
        }
	    else if (self.qsmack_trylevel == 2) 
    	{
			localcmd("echo QSmack:  Init2 --> ");
			localcmd(self.netname);
			localcmd("\n");
        	stuffcmd(self, "init02;\n");
	        self.qsmack_trylevel = 3;
    	}
        else if (self.qsmack_trylevel == 3) 
        {
			localcmd("echo QSmack:  Init3 --> ");
			localcmd(self.netname);
			localcmd("\n");
            stuffcmd(self, "init03;\n");
            self.qsmack_trylevel = 4;
        }
        else if (self.qsmack_trylevel == 4) 
        {
			localcmd("echo QSmack:  Init4 --> ");
			localcmd(self.netname);
			localcmd("\n");
            stuffcmd(self, "init04;\n");
            self.qsmack_trylevel = 5;
        }
        else 
        {
            self.qsmack_trylevel = 0;
            self.style = self.style - CRMOD_DETECTING_QSMACK;
        }
 	}
}; 

void() qsmack_times_up =
{
	if (self.owner.style & CRMOD_DETECTING_QSMACK)
		self.owner.style = self.owner.style	- CRMOD_DETECTING_QSMACK;
		
	remove(self);
};

void() qsmack_detect =
{
	local entity temp;
	temp = self;
	self = temp.owner;

	// JP - got rid of redundant admin check	
    self.style = self.style | CRMOD_DETECTING_QSMACK;
    localcmd("echo Sending QSmack Init...\n");
    stuffcmd(self, "init\n");
    utils_make_scheduled_event(qsmack_times_up, 1.5);    	
    
    self = temp;
    remove(self);
};

// JP - put one single admin check at the start, got rid of others
void() qsmack_impulse =
{
	local float tempf;
	local string temps;
	
	if ((self.impulse > 37) || (self.impulse < 20) || !(self.style & ELOHIM_ADMINISTRATOR))
	{
		elohim_bad_impulse();
		return;
	}
	else if (self.impulse == 20)
		qsmack_statusokay = 1;
	else if ((self.impulse > 20) && (self.impulse <= 36) &&(qsmack_statusokay == 1))
	{
		tempf = self.impulse - 20;
		utils_stuff_to_player(tempf, "echo You are banned on this server.\ndisconnect\n");
		temps = ftos(tempf);
		localcmd3("kick # ", temps, "\n");
    }
    else if (self.impulse == 37)
    {
    	local entity aa;
        aa = find(world, classname, "player");
        while (aa != world) 
        {
        	if (aa.style & ELOHIM_CONNECTED) 
        	{
            	if (aa.style & ELOHIM_ADMINISTRATOR) 
            	{
                	// You must use this format!
                    sprint(aa, "#qsmack_command# ");
                    sprint(aa, self.netname);
                    sprint(aa, "\n");
                }
            }
            aa = find(aa, classname, "player");
        }
    }

	// JP - got rid of the '-1'.  What the heck was it for?
	self.finaldest_x = time;
};
	
		
