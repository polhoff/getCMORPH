
CMORPH.download <- function ( file_list, path.dest )
	{

	library(RCurl)
	library(RNetCDF)

	##when testing
	#path.download <-  "D:/sp/dump16/"
	#file_list <- file_list2

	orig_dir = getwd()

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

	##remove any files in destination directory
	file.remove (list.files(tempdir(), full.names = TRUE))

	setwd( tempdir() )
	
	for (i in 1:length(file_list))
		{
		try(download.file(url = file_list[i], destfile = paste(c_filenames[i]), mode="wb"), silent = FALSE)  
		}

	copy_from <- list.files (tempdir(), full.names = TRUE )
	copy_to <-  paste ( path.dest, "/", list.files (tempdir(), full.names = FALSE ), sep = "")
	
	file.copy (copy_from, copy_to)
	
	setwd(orig_dir)
	
	return (copy_to)
}


#file_list <- file_list[1]
#file_list1 <- file_list[985:1015]
#file_list2 <- file_list1[6:31]
#x <- get.CMORPH.download ( path.download = "D:/sp/dump16/", file_list1)
#path.download = "D:/sp/dump16/"

