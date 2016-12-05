library(dplyr)


#logs_google_filtered$isRobotTXT <- FALSE

# get all GET /robots.txt HTTP/1.1
#logs_google_filtered$isRobotTXT[which(grepl("/robots.txt", logs_google_filtered$url))] <- TRUE

# arrange by IP by Data
logs_google_filtered <- arrange(logs_google_filtered, ip, date)


# foreach IP
caseid <- 1
iptemp <- ""

for (row in 1:nrow(logs_google_filtered)) { 
  
  ip <- logs_google_filtered$ip[row]
  url <- logs_google_filtered$url[row] 
  
  print(ip)
  
  if (grepl("/robots.txt", url)) {
    caseid <- caseid + 1
  }
  
  # create caseid
  logs_google_filtered$caseid[row] <- caseid
  
  #dates <- which(grepl("/robots.txt", logs_google_filtered$url) & logs_google_filtered$ip == ip)
  
  # which( m IP et dateIP< )  
  #print(dates)
  
  if (ip!=iptemp) {
    iptemp <- ip
    caseid <- caseid + 1
  }
  
  
  
  
}








