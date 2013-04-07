fun getnearbylist(zip, threshold, ziplist) = 
	let
		open TextIO;
		exception InvalidZip

		fun distance_away((lat1, long1), (lat2, long2)) = Math.acos( Math.sin((90.0 -lat1)*2.0 *Math.pi/360.0) *Math.sin((90.0-lat2)*2.0 *Math.pi/360.0) * Math.cos((long1*2.0 *Math.pi/360.0) - (long2*2.0 *Math.pi/360.0))  + (Math.cos((90.0-lat1)*2.0 *Math.pi/360.0) * Math.cos((90.0-lat2)*2.0 *Math.pi/360.0)) ) *3960.0;
	
		

		(*to convert string option, or input lint tostring, do valOf (SOME "jfdkn")*)
		(*to get zip do substring(valOf(inputLine(file)), 1, 5) *)
		(*Convert string to real valOf(Real.fromString("2342"))*)

		fun get_zip(zip,file) =
		let 
			val line = inputLine(file);
		in
	
		if line =  NONE then raise InvalidZip
		else if (zip = substring(valOf(line),1,5)) then line
		else get_zip(zip,file) 
		end;
		
		fun get_latlong(line) =
		(valOf(Real.fromString((substring(valOf(line),16,10)))), valOf(Real.fromString(substring(valOf(line),30,10))));
		
		fun test_threshold(threshold, zip, nil) =nil
		
		|   test_threshold(threshold, zip, ziplist as x::xs) =
		let
			val file = openIn("zips.csv");
		
		in
		if x> zip then 
			if distance_away(get_latlong(get_zip(zip,file)),get_latlong(get_zip(x,file))) < threshold 
				then x :: test_threshold(threshold, zip, xs)
			else test_threshold(threshold, zip, xs)
		else if x<zip then 
			if distance_away(get_latlong(get_zip(x,file)), get_latlong(get_zip(zip,file))) < threshold 
				then x :: test_threshold(threshold, zip, xs)
			else test_threshold(threshold, zip, xs)
		else
			x::test_threshold(threshold, zip, xs)
		end;
		
		
	in
		test_threshold(threshold, zip, ziplist)
	end;