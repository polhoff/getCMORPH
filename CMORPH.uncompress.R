
CMORPH.uncompress <- function ( file_list, path.dest )
	{
	
	library(uncompress)
	
	##when testing
	#path.download <-  "D:/sp/dump16/"
	#file_list <- file_list2
	#file_list <- file_list3
	#file_list <- list.files (dirdmp16, full.names = TRUE)
	#x2 <- unique (dirname (file_list))
	#path.dest <-  "D:/sp/dump17/"

	
	orig_dir = getwd()
	
	try (dir.create (path.dest))

	# DSET /export-2/sgi109/irstat/blended_tech/cpc/data/025deg/%y4%m2%d2_3hr-025deg_cpc+comb
	# OPTIONS template yrev big_endian
	# UNDEF  -9999
	# TITLE  Precipitation estimates
	# XDEF 1440 LINEAR    0.125  0.25
	# YDEF 480 LINEAR  -59.875  0.25
	# ZDEF  01 LEVELS 1 
	# TDEF 99000 LINEAR  0z01dec2002 3hr
	# VARS 2
	# comb  1   99 yyyyy combined microwave estimates (no advection) mm/hr
	# cpc   1   99 yyyyy advected precip. (mm/hr)
	# ENDVARS 

	####################################################################################################
	## see documentation: ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/README.cmorph.025deg_3-hourly
	## also; http://www.ncl.ucar.edu/Applications/Scripts/cmorph_3.ncl
	## http://www.ats.ucla.edu/stat/r/code/read_bin.htm
	## http://www.ncl.ucar.edu/Support/talk_archives/2009/0454.html

	c_filenames = basename(file_list)
	indir  <-  paste (unique (dirname (file_list)), "/", sep = "" )


	files_uncompressed <- rep ( NA, length(file_list))
	
	
	
	for (i in 1:length(file_list)) {
	#for (i in 1) {
	  #setwd(path.download)
	  size <- try(file.info(paste(file_list[i]))$size)
	  if (size > 100000) {
		handle <- try(file(paste(file_list[i]), "rb"))
		data   <- try(readBin(handle, "raw", 99999999))
		close(handle)
		uncomp_data <- try(uncompress(data))
		## check to see if the file is corrupted
		#  lines <- strsplit(rawToChar(uncomp_data), "\r\n")
		#  print(lines)
		
		setwd (path.dest)
		
		x1 <- try (writeBin (uncomp_data, paste(c_filenames[i])))
		
		if ( class(x1) != "try-error" ) {files_uncompressed[i] <- paste (path.dest, c_filenames[i], sep = "/")}
	
		
	  }
	  rm(data)
	  rm(handle)
	  rm(uncomp_data)
	  
	  gc()
	  
	}

	setwd(orig_dir)
	
	gc()
	
	print ("Uncompressed files were written to.........")
	print (path.dest)
	
	files_uncompressed <- files_uncompressed [!is.na(files_uncompressed)]
	
	return (files_uncompressed)
	
	#return (
}


#x1 <- list.files (dirdmp16, full.names = TRUE)
#x2 <- unique (dirname (x1))

#file_list <- file_list[1]
#file_list1 <- file_list[985:1015]
#file_list2 <- file_list1[6:31]
#file_list3 <- file_list2[16:26]
#x <- get.CMORPH.download ( path.download = "D:/sp/dump16/", file_list1)
#x <- get.CMORPH.uncompress ( file_list = x3, path.dest = "D:/sp/dump17/")

#path.download = "D:/sp/dump16/"
