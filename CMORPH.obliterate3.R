
CMORPH.obliterate <- function ( file_list, path.dest )
	{

	#dirCM <- "D:/sp/buyt/CMORPH/" ; x = list.files (dirCM, full.names = T) ; x1 = x[58:60] ; file_list = x1 ; file_list = file_list[1] ; path.dest = dirdmp3
	#dirCM <- "/home/sjp/CMORPH/Rdata/" ; x = list.files (dirCM, full.names = T) ; x1 = x[58:60] ; file_list = x1 ; file_list = file_list[1] ; path.dest = "/home/sjp/CMORPH/obliterate/"

	
	
	library (zoo)
	library (reshape)

	 
	mid <- function (string, start_chars, end_chars)
		{
		x <-  substr(string, start_chars, end_chars)
		return(x)
		}


	
	

	#see CMORPH.SaveAsRdata for some explanations
	nvar  = 2                                     
	ntim  = 8
	nlat  = 480                                
	nlon  = 1440
	
	col_order_from_binary  <-  seq ( 59.875, length = nlat, by = -0.25 )
	row_order_from_binary  <-  seq ( 0.125, length = nlon, by = 0.25 )
	
	#in CMORPH_yyyymmdd.Rdata all variables are factors, other than the single variable "data"
	col_order_from_binary  <-  as.factor(col_order_from_binary)
	row_order_from_binary  <-  as.factor(row_order_from_binary)
	
	#data_type <- c ( "prec" )
	UTC_times = c ( "00", "03", "06", "09", "12", "15", "18", "21")
	
	all_coords = expand.grid ( col_order_from_binary, 	row_order_from_binary )

	start_time = Sys.time()

	for ( i in file_list )
		{
		#i = file_list
		CMORPH_object_name <- load (i)
		CMORPH_date_string <- strsplit (CMORPH_object_name, "_")
		CMORPH_date_string <- CMORPH_date_string[[1]][2]
		CMORPH_year <- mid (CMORPH_date_string, 1,4)
		CMORPH_month <- mid (CMORPH_date_string, 5,6)
		CMORPH_day <- mid (CMORPH_date_string, 7,8)
		
		
		
		data_sub <- get (CMORPH_object_name)
		#data_sub <-  data_sub[ as.character(data_sub$data_type)=="prec", ]
		
		
		lat_list <- names (table (data_sub$latitude))
		lon_list <- names (table (data_sub$longitude))
		data_type_list <- names (table (data_sub$data_type))
		
		for ( a1 in data_type_list)
			{
			for ( a2 in lat_list)	
				{
				for ( a3 in lon_list)
					{
					
					data_sub1 <- data_sub [ as.character (data_sub$data_type) == a1 &
														as.character (data_sub$latitude) == a2 &
														as.character (data_sub$longitude) == a3, ]
														
					POSIX_string <-  paste (paste ( CMORPH_year, CMORPH_month, CMORPH_day, sep ="-"), "  ", paste ( as.character (data_sub1$UTC), "00", "00", sep = ":"), "GMT")
					
					data_sub1$POSIX_time <- as.POSIXct (POSIX_string)
					
					a2_num <- as.numeric(a2)
					a2_name <- paste (a2_num, "N", sep = "")
					#overwrite previous value if South
					if ( a2_num < 0 ){ a2_name <- paste (abs(a2_num), "S", sep = "")}
		
					data_sub2 <- data_sub1 [c ("data", "POSIX_time")]
					save ( data_sub2, file = paste ( path.dest, "/", "CMORPH_", a1, "_", a2_name, "_", a3, ".Rdata", sep = ""))
					
					}
				}
			}
		}
		
		
		rm ( list = CMORPH_object_name)
		rm ( data_sub)
		rm ( data_sub1)
		
		gc()
		
	}
