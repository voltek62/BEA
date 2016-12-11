library(dplyr)

prepareLogs <- function(logs,filename) {
  
  logs <- arrange(logs, ip, date)
  
  # foreach IP
  caseid <- 1
  iptemp <- ""
  
  for (row in 1:nrow(logs)) { 
    
    ip <- logs$ip[row]
    url <- logs$url[row] 
    
    print(ip)
    
    if (grepl("/robots.txt", url)) {
      caseid <- caseid + 1
    }
    
    # create caseid
    logs$caseid[row] <- caseid
    
    
    if (ip!=iptemp) {
      iptemp <- ip
      caseid <- caseid + 1
    }
    
    
  }
  
  write.csv2(logs,paste("./data/",filename,sep=""),row.names=FALSE)
  
  return(logs)
}


# no line with robots.txt 
logs_google_mobile <- prepareLogs(logs_google_mobile,"google_mobile.csv")

logs_google_desktop <- prepareLogs(logs_google_desktop,"google_desktop.csv")

logs_bing <-  prepareLogs(logs_bing,"bing.csv") 

logs_baidu <-  prepareLogs(logs_baidu,"baidu.csv") 
logs_yandex <- prepareLogs(logs_yandex,"yandex.csv")

logs_majestic <- prepareLogs(logs_majestic,"majestic.csv")



