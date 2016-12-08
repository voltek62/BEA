library(dplyr)
library(chron)
library(data.table)
library(stringr)

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

logs_bing <- filter(logs,grepl("bingbot",useragent))  
 
logs_baidu <- filter(logs,grepl("Baiduspider",useragent))  

logs_yandex <- filter(logs,grepl("YandexBot",useragent))  

logs_majestic <- filter(logs,grepl("MJ12bot",useragent))


