//
// angles.qc
//
// Functions for doing angle/vector calculations
//
// Fields used:
//
//
// All code by Paul Baker unless otherwise commented.
//

//
//   P I C K  A N G L E
//
//   Given two angles, and a percent, this function returns a new angle
//   that is some percent closer to angle2 from angle1.
//
//   example: angle1 is the current angle, angle2 is where you want to be,
//            based on the percent, the returned angle will be a new
//            angle inbetween angle1 and angle2.  The higher the percent,
//            the closer the returned angle will be to angle2.
//
//   JP - removed commented code and optimized slightly
//
float (float angle1, float angle2, float percent) angles_pick_angle =
{
	local float difference;
		
	difference = angle2 - angle1;			// how far apart angles are

	if (difference > 180)
		difference = difference - 360;
	else if (difference <= -180)
		difference = difference + 360;

	return angle1 + difference * percent; 
	
};

//
//  B E S T A I M
//     by Paul Baker
//  Returns desired aim 'from' one position 'to' another
//
//  Recommented and Recoded by JP
//
//  Dealing with pitch is a bit tricky.  vectoangles returns a pitch in [0, 360] where
//  0 is looking straight ahead, 45 looks up at 45° and 315 looks down at 45°.
//  However, the pitch in v_angle is in the range [-68, 78] where positive is *down*
//  and negative is up.
//

vector (vector from, vector to) angles_bestaim =
{
	local vector bestaim;
	bestaim = vectoangles(to - from);
	if (bestaim_x > 270)
	{
		// Looking down; convert angle for v_angle and clamp
		bestaim_x = 360 - bestaim_x;
		if (bestaim_x > 78)
			bestaim_x = 78;
	}
	else
	{
		// Looking up; convert angle for v_angle and clamp
		bestaim_x = 0 - bestaim_x;
		if (bestaim_x < -68)
			bestaim_x = -68;
	}

	return bestaim;
};

// CRMOD
//  F I X A N G L E
//    by Paul Baker
//
//  Sends new view angle to client and stores the value in .crmod_oldangle for use in angle smoothing
//
//R00k: changed to round angles by 1/16th towards nearest number...

void(vector v) angles_fixangle =
{
	self.clanring_oldangle = v;

	if (v_x >= 0)	
		self.v_angle_x = self.angles_x = (v_x + 0.0625);
	else
		self.v_angle_x = self.angles_x = (v_x - 0.0625);

	if (v_y >= 0)	
		self.v_angle_y = self.angles_y = (v_y + 0.0625);
	else
		self.v_angle_y = self.angles_y = (v_y - 0.0625);
		
	if (v_z >= 0)	
		self.v_angle_z = self.angles_z = (v_z + 0.0625);
	else
		self.v_angle_z = self.angles_z = (v_z - 0.0625);

	
	
	self.fixangle = TRUE;//forces client's angle to the above, using svc_setangle.
};
