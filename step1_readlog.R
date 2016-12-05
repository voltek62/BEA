library(dplyr)
library(chron)
library(data.table)
library(stringr)

##logs
# 81.64.224.39 10.322 - [19/Oct/2016:22:00:15 +0200] data-seo.fr "POST /wp-admin/admin-ajax.php HTTP/2.0" 200 366 "https://data-seo.fr/wp-admin/post.php?post=1227&action=edit" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:49.0) Gecko/20100101 Firefox/49.0"



## This will give NA(s) in some locales; setting the C locale
## as in the commented lines will overcome this on most systems.
lct <- Sys.getlocale("LC_TIME"); 
Sys.setlocale("LC_TIME", "C")

# function to import logs
importLogs <- function(name) {
  
  if (grepl(".gz",name))
    logs <- read.table(gzfile(name), stringsAsFactors=FALSE)  
  else 
    logs <- read.table(name, stringsAsFactors=FALSE)
  
  logs <- mutate(logs,V4=paste(V4,V5,sep=""))
  logs$V5 <- NULL
  
  logs <- select(logs,V1,V4,V7,V8,V11)
  
  colnames(logs) <- c("ip","date","url","rescode","useragent")

  #logs$date_init <- logs$date
  
  #logs$date <- str_replace_all(logs$date, c("\\+0100","\\+0200"), c("",""))
  #logs$date <- str_replace_all(logs$date, "\\+0100", "")
  
  # fix +0100
  logs$date <- as.chron(logs$date,format="[%d/%b/%Y:%H:%M:%S%z]")
  
  logs$date <- format(logs$date,"%d/%m/%Y %H:%M:%S")
  
  return(logs)
  
}

# combine all csv
url_path <- "./logs/"
all.the.files <- list.files(url_path,full=TRUE)
logs <- rbindlist(lapply(all.the.files,  importLogs))

# get google useragent
logs_google <- filter(logs,grepl("Googlebot",useragent))  





