(*Rebecca Murphy*)
fun getnearbylist(center, threshold, ziplist) = 
	let
		open TextIO;
		exception InvalidZip
		exception ThresholdOutOfRange of string*real*string list;

		fun distance_away((lat1, long1), (lat2, long2)) = Math.acos( Math.sin((90.0 -lat1)*2.0 *Math.pi/360.0) *Math.sin((90.0-lat2)*2.0 *Math.pi/360.0) * Math.cos((long1*2.0 *Math.pi/360.0) - (long2*2.0 *Math.pi/360.0))  + (Math.cos((90.0-lat1)*2.0 *Math.pi/360.0) * Math.cos((90.0-lat2)*2.0 *Math.pi/360.0)) ) *3960.0;
		(* This functions calcualtes the distance away the two zips are. it takes in two tuples of the latitude and longitude*)
		
		fun get_zip(zip,file) =
		let 
			val line = inputLine(file);
			fun get_latlong(line) =
		    (valOf(Real.fromString((substring(valOf(line),16,10)))), valOf(Real.fromString(substring(valOf(line),30,10))));
		in
	
		if line =  NONE then raise InvalidZip
		else if (zip = substring(valOf(line),1,5)) then get_latlong(line)
		else get_zip(zip,file) 
		end;
		(* This function goes through the file line by line. When it finds the line with the zip in it, it calls get_latlong, which returns the lat and long of the zip asa tuple, by finding the substring in the line for lat and long, which is then converted to a tuple of two real numbers*)
		
		fun openfile(zip) =
		let
			val file =openIn("zips.csv")
			
		in 
			get_zip(zip, file)
		end;
		
		(*Opens the file every time get_zip is called so the token starts at the beginning of the file and doesn't miss any zips.*)
		
		fun test_threshold(center,threshold,nil) =nil
		|   test_threshold(center,threshold,x::xs) =
		if (threshold <0.0) then raise ThresholdOutOfRange(center,threshold,x::xs) 
		else if distance_away(openfile(center),openfile(x)) < threshold 
				then x :: test_threshold(center,threshold,xs)
		else
			test_threshold(center,threshold,xs);
		(*This function tests if the zips in ziplist are in the threshold. It opensIn the file every time it is recursively called, making the file start at the beginning when searching for the new zip. *)
			
		fun ziphandle(center,threshold,x::xs)= 
			test_threshold(center,threshold,x::xs)
			handle ThresholdOutOfRange(center,threshold,x::xs) => (
					print "Error: Negative Threshold \n";
					[]
					);
		(*This function handles the negative Threshold error. *)
	in
		ziphandle(center,threshold,ziplist)
		(*Calls the handler and returns the list of zips in the threshold.*)
		end;
			