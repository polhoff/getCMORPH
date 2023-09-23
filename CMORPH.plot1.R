
CMORPH.plot <- function ( file_list, path.dest, data_type = "prec" )
	{

	#file_list <- "D:/sp/buyt/CMORPH/CMORPH_20091012.Rdata" ; path.dest <- dirdmp1 ; l_hardcopy = T

	data_type <- data_type

	l_png <- TRUE
	orig_dir = getwd()

	AsNum <- function ( x)	{
		x = as.character(x)
		x = as.numeric(x)
		return(x)
		}
	
	#each file has eight images associated with it
	image_files  <- rep ( NA, length(file_list) * 8)
	n_ctr <- 1

	for ( selected_file in file_list )
		{
		c_file <- basename(selected_file)
		#c_file <- splitstr (c_file, ".")
		c_file <- strsplit (c_file, "[.]")
		c_file <- c_file[[1]][1]

		#inpath <- paste (dirtop, "buyt/CMORPH/	", sep  = "")
		#filename <- "CMORPH_20050825"
		
		#load ( selected_file, .GlobalEnv)
		load ( selected_file )
		
		data_sub <- get (c_file)
		
		data_sub$latitude  <- AsNum (data_sub$latitude)
		data_sub$longitude  <- AsNum (data_sub$longitude)
			
		
		for ( t_times in c ( "00", "03", "06", "09", "12", "15", "18", "21"))
			{
			data_sub1 <- data_sub[data_sub$data_type== data_type & data_sub$UTC == t_times,]
			
			xx = tapply ( data_sub1$data, data_sub1[, c("longitude","latitude")], sum )
			
			xx1 = list ( as.numeric ( rownames ( xx ) ), as.numeric ( colnames ( xx ) ), xx )
			names ( xx1 ) = c ( "x", "y", "z" )

			#contour(xx1, xlim = range(xx1$x), ylim = range(xx1$y))
			setwd(path.dest)
			
			if (l_png) {
				png(filename = paste (c_file, "_UTC", t_times, ".png", sep = ""), width = (1060 * 1), height = (660 * 1), 
						units = "px", pointsize = 15, bg = "white", res = NA)
			
				image(xx1, col = topo.colors(12))

				dev.off()
				}
			
			image_files[n_ctr] <- paste (path.dest, "/", c_file, "_UTC", t_times, ".png", sep = "")
			n_ctr <- n_ctr + 1

			
			rm(data_sub1)
			gc()
			}
		rm(data_sub)
		rm (list = c_file)
		gc()
		}
	#rm (list = c_file, envir = .GlobalEnv)
	
	setwd(orig_dir)
	gc()

	image_files <- image_files [!is.na(image_files)]
	
	return (image_files)

	}


#indir <- paste (dirtop, "buyt/CMORPH/	", sep  = "")


#plot.CMORPH.filelist ( file_list = x6[1], path.dest = dirdmp2,  l_hardcopy = TRUE)
#plot.CMORPH.filelist ( file_list = x6[2], path.dest = dirdmp2,  l_hardcopy = TRUE)
#plot.CMORPH.filelist ( file_list = x6[3:15], path.dest = dirdmp2,  l_hardcopy = TRUE)
#plot.CMORPH.filelist ( file_list = x6[4:15], path.dest = dirdmp2,  l_hardcopy = TRUE)
