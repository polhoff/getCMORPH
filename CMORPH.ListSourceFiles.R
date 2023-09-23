

#url_address <- 'ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/3-hourly_025deg/'

CMORPH.ListSourceFiles <- function ( url_address )
	{

	library(RCurl)

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
	
	names <- getURL(url_address, ftp.use.epsv = FALSE, dirlistonly = TRUE)
	files <- strsplit(names, "\r*\n")[[1]]
	
	complete_files  <- paste(url_address, files, sep = "")
	return( complete_files )
	}

#file_list <- get.CMORPH.list (url_address = 'ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/3-hourly_025deg/')
#file_list_ndx <- grep("\\/2011", file_list)
#file_list1 <- file_list[file_list_ndx]
