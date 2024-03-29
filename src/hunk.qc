/*  $Id: hunk.qc,v 1.38 2004/12/27 02:13:56 slotzero Exp $

    Copyright (C) 2003  David 'Slot Zero' Roberts.

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
*/

/*	HUNK CONTEXT ALLOCATION [quake: 4096 / proquake: 16384]

	%0 - %9		= [DO NOT USE]

	// server_time(), update_server_time()
	%10		= float time

	// Log_Client_Disconnect(), Client_Disconnect_Log()
	%100 - %103	= string netname	%104	= float elapsed
	%105 - %108	= string netname	%109	= float elapsed
	%110 - %113	= string netname	%114	= float elapsed
	%115 - %118	= string netname	%119	= float elapsed
	%120 - %123	= string netname	%124	= float elapsed
	%125 - %128	= string netname	%129	= float elapsed
	%130 - %133	= string netname	%134	= float elapsed
	%135 - %138	= string netname	%139	= float elapsed
	%140 - %143	= string netname	%144	= float elapsed
	%145 - %148	= string netname	%149	= float elapsed
	// 10
	%150 - %153	= string netname	%154	= float elapsed
	%155 - %158	= string netname	%159	= float elapsed
	%160 - %163	= string netname	%164	= float elapsed
	%165 - %168	= string netname	%169	= float elapsed
	%170 - %173	= string netname	%174	= float elapsed
	%175 - %178	= string netname	%179	= float elapsed
	%180 - %183	= string netname	%184	= float elapsed
	%185 - %188	= string netname	%189	= float elapsed
	%190 - %193	= string netname	%194	= float elapsed
	%195 - %198	= string netname	%199	= float elapsed
	// 20

	// custom_hunk_pos()
	%200 - %298	= float details about small levels
	%299		= float float small levels left in map rotation
	%300 - %398	= float details about medium levels
	%399		= float medium levels left in map rotation
	%400 - %498	= float details about large levels
	%499		= float large levels left in map rotation

	// standard levels (reserved)
	%500 - %548	= float (reserved)
	%549		= float ()
	%550 - %598	= float ()
	%549		= float ()
	%600 - %648	= float ()
	%649		= float (reserved)

	%799		= float number of denied maps

	%1000-?		= hunk settings

	// strman.qc
	%3000 - %4000	= memory for string manipulation functions
*/

//-------------------------------------------------------------------
// HUNK MANIPULATION FUNCTIONS
//-------------------------------------------------------------------

entity (float type, float offset)
Get_Hunk =
{
	local entity hunk;

	if (!*HUNK_CONTEXT)
		return world;

	hunk = *AddInt(AddInt(&progs, %-16), type);

	return *AddInt(&hunk, 4 * offset);
};

//-------------------------------------------------------------------
// READ HUNK
//-------------------------------------------------------------------

// requires 3 dwords (offset + 2)
vector (float type, float offset)
Read_Hunk_Vector =
{
	local entity hunk;
	local vector v;

	hunk = Get_Hunk (type, offset);
	if (!hunk)
	{
		dprint ("Read_Hunk_Vector: hunk is null\n");
		return VEC_ORIGIN;
	}

	// XXX hunk^[0]	dies in frikqcc
	v_x = hunk[%0];
	v_y = hunk[%1];
	v_z = hunk[%2];

	return v;
};

float (float type, float offset)
Read_Hunk_Float =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);
	if (!hunk)
	{
		dprint ("Read_Hunk_Float: hunk is null\n");
		return 0;
	}

	return hunk[%0];
};

// This is the fastest way to read string data from the hunk, but it is also the most
// dangerous.  If you try to read strings that are too large, the engine will crash.
string (entity hunk)
Read_Hunk_String_e =
{
	if (!hunk)
	{
		dprint ("Read_Hunk_String_e: hunk is null\n");
		return string_null;
	}

	return @AddInt(&hunk, PQUAKEC_TO_PSTRING);
};

// This is the fastest way to read string data from the hunk, but it is also the most
// dangerous.  If you try to read strings that are too large, the engine will crash.
string (float type, float offset)
Read_Hunk_String =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);

	return Read_Hunk_String_e (hunk);
};

// This is a safe and fast way to read string data from the hunk, but it is not entirely
// accurate; the value of bytes is rounded up to the nearest dword.
string (entity hunk, float bytes)
Read_Hunk_String_Max_e =
{
	local float i, pdata, dword;
	local string data;

	if (!hunk)
	{
		dprint ("Read_Hunk_String_Max_e: hunk is null\n");
		return string_null;
	}

	dword	= ceil(bytes / 4) * %1;
	bytes	= (dword * 4) / %1;

	data	= allocate_string_size (bytes);
	if (!data)
	{
		dprint ("Read_Hunk_String_Max_e: bytes is too large\n");
		return string_null;
	}

	pdata	= AddInt (&data, PSTRING_TO_PQUAKEC);

	for (i = %0; i < dword; i = i + %1)
		(*pdata)[i] = hunk[i];

 	return (@AddInt (pdata, PQUAKEC_TO_PSTRING));
};

// This is a safe and fast way to read string data from the hunk, but it is not entirely
// accurate; the value of bytes is rounded up to the nearest dword.
string (float type, float offset, float bytes)
Read_Hunk_String_Max =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);

	return Read_Hunk_String_Max_e (hunk, bytes);
};

// This is the most accurate way to read string data from the hunk, but it is also the
// slowest.  Avoid calling this multiple times too quickly or you will generate a loop error.
string (entity hunk, float bytes)
Read_Hunk_String_Exact_e =
{
	local float i, pdata, dword;
	local string data;

	if (!hunk)
	{
		dprint ("Read_Hunk_String_Exact_e: hunk is null\n");
		return string_null;
	}

	data = allocate_string_size (bytes);
	if (!data)
	{
		dprint ("Read_Hunk_String_Exact_e: bytes is too large\n");
		return string_null;
	}

	pdata	= AddInt (&data, PSTRING_TO_PQUAKEC);
	dword	= floor(bytes / 4) * %1;

	//while (bytes > 3)
	//	bytes = bytes - 4;

	if (bytes > 3)
	{
		bytes = bytes / 4;
		bytes = bytes - floor(bytes);

		if (bytes == 0.25)
			bytes = 1;
		else if (bytes == 0.50)
			bytes = 2;
		else if (bytes == 0.75)
			bytes = 3;
		else
			bytes = 0;
	}

	for (i = %0; i < dword; i = i + %1)
		(*pdata)[i] = hunk[i];

 	if (bytes)
	{
		bytes = NegInt ((4 - bytes) * %1);
		hunk = *AddInt (&hunk, bytes);
		pdata = AddInt (pdata, bytes);
		(*pdata)[i] = hunk[i];
		bytes = NegInt (bytes);
		hunk = *AddInt (&hunk, bytes);
		pdata = AddInt (pdata, bytes);
 	}

	return (@AddInt (pdata, PQUAKEC_TO_PSTRING));
};

// This is the most accurate way to read string data from the hunk, but it is also the
// slowest.  Avoid calling this multiple times too quickly or you will generate a loop error.
string (float type, float offset, float bytes)
Read_Hunk_String_Exact =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);

	return Read_Hunk_String_Exact_e (hunk, bytes);
};

//-------------------------------------------------------------------
// WRITE HUNK
//-------------------------------------------------------------------

// requires 3 dwords (offset + 2)
void(float type, float offset, vector v)
Write_Hunk_Vector =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);
	if (!hunk)
		return dprint ("Write_Hunk_Vector: hunk is null\n");

	// XXX hunk^[0] dies in frikqcc
	hunk[%0] = v_x;
	hunk[%1] = v_y;
	hunk[%2] = v_z;
};

void(float type, float offset, float f)
Write_Hunk_Float =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);
	if (!hunk)
		return dprint ("Write_Hunk_Float: hunk is null\n");

	hunk[%0] = f;
};

// This is the fastest way to write string data to the hunk.  If you're not careful
// though, you can easily overwrite unrelated data by supplying too large of a
// string.  Termination is always present.
void(entity hunk, string s)
Write_Hunk_String_e =
{
	if (!hunk)
		return dprint ("Write_Hunk_String_e: hunk is null\n");
	strcpy (@AddInt(&hunk, PQUAKEC_TO_PSTRING), s);
};

// This is the fastest way to write string data to the hunk.  If you're not careful
// though, you can easily overwrite unrelated data by supplying too large of a
// string.  Termination is always present.
void(float type, float offset, string s)
Write_Hunk_String =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);
	Write_Hunk_String_e (hunk, s);
};

// This is a safe and speedy way to write string data to the hunk, but it's not entirely
// accurate; the value of bytes is rounded up to the nearest dword and if you supply a
// a value that is equal to the size of the string, no termination will be present.
void(float type, float offset, string data, float bytes)
Write_Hunk_String_Max =
{
	local entity hunk;
	local float i, pdata, dword;

	hunk = Get_Hunk (type, offset);
	if (!hunk)
		return dprint ("Write_Hunk_String_Max: hunk is null\n");

	dword = floor(bytes / 4) * %1;
	pdata = AddInt (&data, PSTRING_TO_PQUAKEC);

	for (i = %0; i < dword; i = i + %1)
		hunk[i] = (*pdata)[i];
};

// This is a slow but accurate way to write string data to the hunk.  The string
// will always include termination, so bytes will be equal to bytes + one.
void(entity hunk, string data, float bytes)
Write_Hunk_String_Exact_E =
{
	if (!hunk)
		return dprint ("Write_Hunk_String_Exact_E(): hunk is null\n");

	if (bytes < 1)
		return dprint ("Write_Hunk_String_Exact_E(): bytes < 1\n");

	data = substr (data, 0, (bytes));
	strcpy (@AddInt(&hunk, PQUAKEC_TO_PSTRING), data);
};

// This is a very slow but accurate way to write string data to the hunk.  When
// bytes is less than four, a null termination is written which increases the
// actual size of bytes by one (1=2, 2=3, 3=4, 4=4, 5=5).  If bytes is larger
// than data, only data (including termination) is written.  To write a string
// without termination, bytes must be equal to the length of data and over 3 bytes.
void(entity hunk, string data, float bytes)
Write_Hunk_String_Exact_e =
{
	local float i, pdata, dword;

	if (!hunk)
		return dprint ("Write_Hunk_String_Exact_e(): hunk is null\n");

	i = strlen (data);
	if (bytes > i)
		bytes = i + 1;

	dword	= floor(bytes / 4) * %1;
	if (!dword)
		return Write_Hunk_String_Exact_E (hunk, data, bytes);

	pdata = AddInt (&data, PSTRING_TO_PQUAKEC);

	//while (bytes > 3)
	//	bytes = bytes - 4;

	if (bytes > 3)
	{
		bytes = bytes / 4;
		bytes = bytes - floor(bytes);

		if (bytes == 0.25)
			bytes = 1;
		else if (bytes == 0.50)
			bytes = 2;
		else if (bytes == 0.75)
			bytes = 3;
		else
			bytes = 0;
	}

	for (i = %0; i < dword; i = i + %1)
		hunk[i] = (*pdata)[i];

 	if (bytes)
	{
		bytes = NegInt ((4 - bytes) * %1);
		hunk = *AddInt (&hunk, bytes);
		pdata = AddInt (pdata, bytes);
		hunk[i] = (*pdata)[i];
		bytes = NegInt (bytes);
		hunk = *AddInt (&hunk, bytes);
		pdata = AddInt (pdata, bytes);
 	}
};

// This is a very slow but accurate way to write string data to the hunk.  When
// bytes is less than four, a null termination is written which increases the
// actual size of bytes by one (1=2, 2=3, 3=4, 4=4, 5=5).  If bytes is larger
// than data, only data (including termination) is written.  To write a string
// without termination, bytes must be equal to the length of data and over 3 bytes.
void(float type, float offset, string data, float bytes)
Write_Hunk_String_Exact =
{
	local entity hunk;

	hunk = Get_Hunk (type, offset);
	Write_Hunk_String_Exact_e (hunk, data, bytes);
};
