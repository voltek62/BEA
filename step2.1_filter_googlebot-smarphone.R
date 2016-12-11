library(dplyr)

logs_google_mobile <- merge(logs_google, logs_ip, by = "ip") %>%
  filter(isGoogle == TRUE & grepl("Mobile",useragent)) %>%
  select(-isGoogle)

logs_mobile_with_robotstxt <- rbind(logs_google_mobile, logs_robotstxt_shared) %>%
  arrange(ip, date)

logs_mobile_with_robotstxt <- arrange(logs_mobile_with_robotstxt, ip, date)

lastrobotstxt <- FALSE
lastip <- ""

logs_mobile_with_robotstxt$keep <- TRUE

for(i in 1:nrow(logs_mobile_with_robotstxt)) {
  
  if(!grepl("robots.txt",logs_mobile_with_robotstxt$url[i])) {
    lastrobotstxt <- FALSE
  }  
  
  # si decouvert robotstxt doublon, on retire
  if (lastrobotstxt==TRUE) {
    logs_mobile_with_robotstxt$keep[i] <- FALSE  
  }
    
  #print(logs_mobile_with_robotstxt$url[i])
  
  if (logs_mobile_with_robotstxt$ip[i] != lastip) {
    lastrobotstxt <- FALSE
    lastip <- logs_mobile_with_robotstxt$ip[i]
    print("new ip")
  }
  else {
    
    if(grepl("robots.txt",logs_mobile_with_robotstxt$url[i])) {
      print("robots.txt detected ")
      lastrobotstxt <- TRUE
      
      # if last url=robots.txt, we remove
      if (grepl("robots.txt",logs_mobile_with_robotstxt$url[i-1])) {
        logs_mobile_with_robotstxt$keep[i-1] <- FALSE 
      }
    }
    
  }
  
}


#delete lines where two same lines robots.txt follow
logs_google_mobile <- logs_mobile_with_robotstxt[logs_mobile_with_robotstxt$keep,] %>%
                select(-keep)

