library(ggplot2)
library(utils)

mydir <- "C:/Users/Brent/Downloads" #you will need to change this line
setwd(mydir) 

# Get zip file
if (!file.exists("./startrek/tng")){
     dir.create("./startrek/tng")
}
download.file("http://www.st-minutiae.com/resources/scripts/scripts_tng.zip", destfile = "./startrek/tng/scripts_tng.zip")
unzip("startrek/tng/scripts_tng.zip", exdir = "startrek/tng")
setwd(paste(mydir, "/startrek/tng/Scripts - TNG", sep=""))

episode <- list()
for (i in 1:length(list.files())){
     con <- file(list.files()[i])
     episode[[i]] <- readLines(con)
     episode[[i]]$episode.num <- as.numeric(substr(list.files()[i], 1,3))
     close(con)
     
     episode[[i]]$picard.lines <- length(grep("\\t\\t\\t\\tPICARD", unlist(episode[[i]])))
     episode[[i]]$data.android.lines <- length(grep("\\t\\t\\t\\tDATA", unlist(episode[[i]])))
     episode[[i]]$troi.lines <- length(grep("\\t\\t\\t\\tTROI", unlist(episode[[i]])))
     episode[[i]]$riker.lines <- length(grep("\\t\\t\\t\\tRIKER", unlist(episode[[i]])))
     episode[[i]]$worf.lines <- length(grep("\\t\\t\\t\\tWORF", unlist(episode[[i]])))
}

picard <- numeric()
data.android <- numeric()
troi <- numeric()
riker <- numeric()
worf <- numeric()

for (i in 1:length(list.files())){
     picard[i] <- episode[[i]]$picard.lines
     data.android[i] <- episode[[i]]$data.android.lines
     troi[i] <- episode[[i]]$troi.lines
     riker[i] <- episode[[i]]$riker.lines
     worf[i] <- episode[[i]]$worf.lines
}

episode.num <- as.numeric(unname(sapply(list.files(), function(x) substr(x, 1,3))))

tng.character.lines <- data.frame(episode.num = episode.num, 
                                  picard.lines = picard, 
                                  data.lines = data.android, 
                                  troi.lines = troi, 
                                  worf.lines = worf)

ggplot(tng.picard.lines, aes(episode.num, picard.lines)) + 
     geom_point() + 
     geom_smooth() + 
     ggtitle("Number of lines by Captain Picard, Star Trek TNG")
