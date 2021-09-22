void(float p) net_hide_ip =
{
   	local float dotcount;
   	local float px;

	px = AddInt(&"xxx", PSTRING_TO_PQUAKEC);//stuff px with xxx
	p = AddInt(p, %-3);//p = -3

	&%116 = 0;

	for (dotcount = 0 ; dotcount < 3 ; p = AddInt(p, %1))
	{
		&%113 = (*p)[0];
		if (world[%5] == '.')
			dotcount = dotcount + 1;
	}
	p = AddInt(p, %3);
	(*p)[0] = (*px)[0];
};

float () net_connect =
{
   	local string ip,ip2;
   	local float p;   

	p = AddInt(&self.netconnection, QS_ADDRESS * 4);
	ip = @AddInt(p, PQUAKEC_TO_PSTRING);   	
	
	self.trueip = @AddInt(&ip, %32);	
	strcpy(self.trueip, ip);
	
   	ip2 = @AddInt(&ip, 0);
	cprint4(self.netname, " connected from ", self.trueip, "\n");   	
   	strcpy(ip2, ip);
  	net_hide_ip(p);
  	self.myip = ip2;  
	
   	return TRUE;
};
/*
void() net_kill_ip =
{
   	local float p;
   	local float px;
	local string ip;
	
	p = AddInt(&self.qs, QS_ADDRESS * 4);   
	px = AddInt(&"xxx.xxx.xxx.xxx", PSTRING_TO_PQUAKEC);//stuff px with xxx
	(*p)[0] = (*px)[0];
	ip = @AddInt(p, PQUAKEC_TO_PSTRING);	
	dprint(ip);
};
*/
