
CMORPH.SaveAsRdata <- function ( file_list, path.dest )

	{

	library (zoo)
	library (reshape)

	left <- function (string, n_chars) 
		{
		x = substr(string, 1, n_chars)
		return(x)
		}


	
	## read in the uncompressed data and format
	#pathname = "D:/sp/dump16/uncompress/"
	#inpath = paste ( dirbuyt, "CMORPH/", sep = "")
	#outpath = dirdmp1
	#filename =  "20050817_3hr-025deg_cpc+comb.Z"

	orig_dir = getwd()
	try (dir.create (path.dest))

	#CMORPH data available at 3 hourly timestep
	# and 0.25 degree latitude and 0.25 degree longitude
	# 360 degrees longitude. Therefore sampling every 0.25 degree gives 360 / 0.25 = 1440 longitude coordinates
	
	#coverage information from here:
	#http://rda.ucar.edu/datasets/ds502.0/
	#Longitude Range: Westernmost=180W Easternmost=180E
	#Latitude Range: Southernmost=59.875S Northernmost=59.875N
	
	nvar  = 2                                     
	ntim  = 8
	nlat  = 480                                
	nlon  = 1440
	

	#http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.CPC/.CMORPH/.daily_calculated/.dataset_documentation.html
	#Each record contains a 1440 x 480 REAL*4 array of data which is oriented
	#from 0.125E EASTward and from 59.875N SOUTHward, with a grid increment
	#of 0.25 degrees of latitude and longitude.
	#For example 	(1,1) is 0.125E, 59.875N 
	#						(2,2) is 0.375E, 59.625N, etc.
	
	
	#......therefore.......
	col_order_from_binary  <-  seq ( 59.875, length = nlat, by = -0.25 )
	row_order_from_binary  <-  seq ( 0.125, length = nlon, by = 0.25 )
	

	col_order_from_binary  <-  as.factor(col_order_from_binary)
	row_order_from_binary  <-  as.factor(row_order_from_binary)

	#readBin transforms each array into a single vector
	#by column first
	#therefore the first elements will be latitudes
	#so the first 480 elements of the dataset will be all latitudes at longitude 0.125E
	#no!!!!!! the first 1440 elements of the dataset will be all longitudes at latitude 59.875N
	#...and the next 1440 elements of the dataset will be all longitudes at latitude 59.625N
	#until element (nlat*nlon) + 1
	#which is precipitation at 00 UTC at (59.875N, 0.125E)
		
	#therefore
	longitude_vector <- rep (row_order_from_binary, ( nlat * ntim * nvar ) )
	latitude_vector <- rep (rep (col_order_from_binary, each = nlon), ntim * nvar )
	
	
	#to reduce memory size
	#latitude_vector <- as.factor (latitude_vector)
	#longitude_vector <- as.factor (longitude_vector)
	
	
	longitude_vector[nlat-1]
	longitude_vector[nlat]
	longitude_vector[nlat + 1]


	latitude_vector[nlon-1]
	latitude_vector[nlon]
	latitude_vector[nlon + 1]

	length(latitude_vector)

	print (head(longitude_vector))
	print (head(latitude_vector))

	times <- c ( "00", "03","06","09","12","15","18","21")
	data_type <- c ( "mic", "prec" )
	
	times_repeated  <-  rep ( times, each  = 2 * nlon * nlat)
	data_type_repeated  <-  rep (rep ( data_type, each = nlon * nlat), ntim)
	
	times_repeated <- as.factor (times_repeated)
	data_type_repeated <- as.factor (data_type_repeated)
	
	
	#stopifnot ( length (times) == length (indata) )
	#stopifnot ( length (data_type) == length (indata) )
	#stopifnot ( length (latitude_vector) == length (indata) )
	#stopifnot ( length (longitude_vector) == length (indata) )

	files_saved <- rep ( NA, length(file_list))
	n_ctr <- 1
	
	for ( i in file_list )
		{
	
		
	
		read_file <- i
		
		base_filename <- basename (read_file)
	
		indata        <- readBin(read_file, what = double(), size = 4, n = nvar * ntim * nlat * nlon, endian = "big")
		indata[indata < 0] <- NA

		stopifnot ( length (times_repeated) == length (indata), length (data_type_repeated) == length (indata), length (latitude_vector) == length (indata), length (longitude_vector) == length (indata) )
		
		data_df <- data.frame ( indata, times_repeated, data_type_repeated, latitude_vector, longitude_vector )
		
		head(data_df)
		names(data_df) <-  c ("data",  "UTC", "data_type", "latitude", "longitude")

		assign ( paste ("CMORPH_", left(base_filename, 8), sep = ""), data_df)

		save_obj <- which (ls() == paste ("CMORPH_", left(base_filename, 8), sep = ""))
		
		setwd(path.dest)
		
		save ( list = ls()[save_obj], file = paste ("CMORPH_", left(base_filename, 8), ".Rdata", sep = "") )
		
		files_saved[n_ctr] <- paste (path.dest, paste ("CMORPH_", left(base_filename, 8), ".Rdata", sep = ""),  sep = "/")
		
		n_ctr <- n_ctr + 1
		
		rm ( list = ls()[save_obj])
		rm (data_df)
		
		gc()
		}
	setwd (orig_dir)
	
	files_saved <- files_saved [!is.na(files_saved)]
	return (files_saved)
	
}
