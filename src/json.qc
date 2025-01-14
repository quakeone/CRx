/*
    json.qc

	json functions
	
	Copyright (C) 2021-2023  
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
	
	See file, 'gnu_gpl.txt', for details.
*/

string () json_get_gametype_playmode =
{
	local string gtype = "", pmode = "";
    
	gtype = infokey(world, "gametype");
	pmode = infokey(world, "playmode");

	return (sprintf("%s %s", gtype, pmode));
};

void () json_encode_players =
{
	float i=0;
	filestream f;
	entity t, p;
	string sgtype;
	string date = strftime(TRUE, "%Y-%m-%d %H:%M:%S");

	f = fopen("json/test.json", FILE_WRITE);
	if (f<0)
	{
		dprint("*** ERROR creating json file!\n");
	}
	else
	{
		fputs(f,"{\"match\":{");
		fputs(f,sprintf("\"date\":\"%s\",",date));

		sgtype = json_get_gametype_playmode();
	
		fputs(f,sprintf("\"gamemode\":\"%s\",",sgtype)); //"CTF Match", "CA Match", "TDM Match", "FreezeTag Match", "Speedball Match"...		
		fputs(f,sprintf("\"match size\":\"%g\",",clanring_maxteams));
		fputs(f,sprintf("\"team size\":\"%g\",",stats_matchtype));
		fputs(f,sprintf("\"timelimit\":\"%g\",",stats_timelimit));

		fputs(f,"\"teams\":[");
		//if (mode_is_arena())t=boss.next_team;else
		t = clanring_sentinel.next_team;
		while (t)
		{
			fputs(f,"{");
			fputs(f, sprintf("\"name\":\"%s\",",t.netname));
			fputs(f, "\"players\":[");
			p = t.next_player;

			while (p)
			{
				fputs(f,"{");
				fputs(f, sprintf("\"name\":\"%s\","				, p.netname));											//  "name":"r00k",
				fputs(f, sprintf("\"team\":\"%s\","				, strings_get_colour(p.height)));						//	"team":"red",
				fputs(f, sprintf("\"score\":%g,"				, p.frags));											//	"frags":125,
				fputs(f, sprintf("\"kills\":%g,"				, p.true_kills));										//	"kills":125,
				fputs(f, sprintf("\"deaths\":%g,"				, p.mangle_z));											//  "deaths":20,

				if (p.mangle_z > 0)																		
					fputs(f, sprintf("\"kdr\":%2.2f,"			, (floor(p.true_kills / p.mangle_z))));	
				else if (p.mangle_z == 0 && p.true_kills == 0)
					fputs(f, "\"kdr\":0,");						// 0
				else
					fputs(f, sprintf("\"kdr\":%g,"				, p.true_kills));
				if (p.dest1_x > 0)
					fputs(f, sprintf("\"bullet eff\":%g,"		, (floor(100 * p.dest2_x / p.dest1_x))));
				else
					fputs(f, "\"bullet eff\":0,"); 				// 0
				if (p.dest1_y > 0)
					fputs(f, sprintf("\"nails eff\":%g,"		, (floor(100 * p.dest2_y / p.dest1_y))));
				else
					fputs(f, "\"nails eff\":0,"); 				// 0
				if (p.dest_x > 0)
					fputs(f, sprintf("\"rockets eff\":%g,"		, (floor(100 * p.dest_y / p.dest_x))));
				else
					fputs(f, "\"rockets eff\":0,"); 			// 0
				if (p.dest1_z > 0)
					fputs(f, sprintf("\"lightning eff\":%g,"	, (floor(100 * p.dest2_z / p.dest1_z))));
				else
					fputs(f, "\"lightning eff\":0,");			// 0
				if ((p.dest1_x + p.dest1_y + p.dest1_z + p.dest_x) > 0)
					fputs(f, sprintf("\"total eff\":%g,"		, (floor(100 *(p.dest2_x + p.dest2_y + p.dest2_z + p.dest_y) / (p.dest1_x + p.dest1_y + p.dest1_z + p.dest_x)))));
				else
					fputs(f, "\"total eff\":0,"); 				// 0

				fputs(f, sprintf("\"quads\":%g,"				, p.clanring_qdwep_z));									//	"quads":10,
				fputs(f, sprintf("\"quad enemy kills\":%g,"		, p.clanring_qdkill_x));								//	"quad enemy kills":10,
				fputs(f, sprintf("\"quad self kills\":%g,"		, p.clanring_qdkill_z));								//	"quad self kills":10,
				fputs(f, sprintf("\"quad team kills\":%g,"		, p.clanring_qdkill_y));								//	"quad team kills":10,
	//TODO:			fputs(f, sprintf(p.clanring_badstats
				fputs(f, sprintf("\"damage taken\":%g,"			,p.dmg_taken));
				fputs(f, sprintf("\"damage given\":%g,"			,p.dmg_given));

				if (clanring_playmode & CLANRING_CAPTURE_THE_FLAG)
				{
					fputs(f, sprintf("\"flag taken\":%g,"			,p.fpickups));
					fputs(f, sprintf("\"flag captures\":%g,"		,p.fcaptures));
					fputs(f, sprintf("\"flag defenses\":%g,"		,p.fdefenses));
					fputs(f, sprintf("\"flag returns\":%g,"			,p.freturns));
					fputs(f, sprintf("\"flag assists\":%g,"			,p.fcassists));
					fputs(f, sprintf("\"flag carrier kills\":%g"	,p.fcfrags));
					//TODO: fputs(f, sprintf(p.captime
				}

				if (p.next_player != world) //check if we are at the end of the list
					fputs(f, "},");
				else
					fputs(f, "}");
				p = p.next_player;
			}
			fputs(f,"]");//closing player array
			if (t.next_team != world)
				fputs(f,"},");
			else
			fputs(f,"}");
			t = t.next_team;
		}
		fputs(f, "]}}");
		fclose(f);
	}
}

/*Json Example Output
{
    "match": 
    {
		"date": "2023-02-09 12:23:09",
		"gamemode": "CTF Match",
		"match size": 2,
		"teams size": 4,
		"match type": "4 v 4",
		"timelimit": 20,
        "teams": 
        [
            {
                "name": "Team A",
                "players": 
                [
                    {
                        "name": "Player 1",
                        "position": "Forward",
                        "goals": 5,
                        "assists": 2,
                        "shots": 12,
                        "shots_on_goal": 8,
                        "yellow_cards": 1,
                        "red_cards": 0,
                        "fouls_committed": 4,
                        "fouls_suffered": 3,
                        "offside": 2,
                        "corner_kicks": 7,
                        "free_kicks": 5,
                        "penalties": 0
                    },
                    {
                        "name": "Player 2",
                        "position": "Midfielder",
                        "goals": 3,
                        "assists": 4,
                        "shots": 10,
                        "shots_on_goal": 6,
                        "yellow_cards": 2,
                        "red_cards": 1,
                        "fouls_committed": 5,
                        "fouls_suffered": 4,
                        "offside": 1,
                        "corner_kicks": 8,
                        "free_kicks": 6,
                        "penalties": 1
                    }
                ]
            },
	        {
                "name": "Team B",
                "players": 
                [
                    {
                        "name": "Player 1",
                        "position": "Forward",
                        "goals": 4,
                        "assists": 3,
                        "shots": 9,
                        "shots_on_goal": 6,
                        "yellow_cards": 1,
                        "red_cards": 0,
                        "fouls_committed": 3,
                        "fouls_suffered": 2,
                        "offside": 1,
                        "corner_kicks": 4,
                        "free_kicks": 3,
                        "penalties": 0
                    },
                    {
                        "name": "Player 2",
                        "position": "Midfielder",
                        "goals": 2,
                        "assists": 4,
                        "shots": 7,
                        "shots_on_goal": 5,
                        "yellow_cards": 0,
                        "red_cards": 0,
                        "fouls_committed": 2,
                        "fouls_suffered": 1,
                        "offside": 0,
                        "corner_kicks": 3,
                        "free_kicks": 2,
                        "penalties": 0
                    }
                ]
            }
        ]
    }
}
*/