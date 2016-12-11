library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

testGoogleIP <- function(ip) {
  
  if(grepl("66.249.",ip)) return(TRUE)
  
  url <- paste("https://api.openresolve.com/reverse/",ip,sep="")
  
  req <-getURL(
    url
    #,httpheader = c(
    #  "accept-encoding" = "gzip"
    #) 
    #, verbose = TRUE
  );
  
  
  result <- fromJSON( req )
  
  if (is.null(result)) return(FALSE)
  if (length(result$AnswerSection)==0) return(FALSE)  
  if (length(result$AnswerSection[[1]]$Target)==0) return(FALSE)  
  
  result <- result$AnswerSection[[1]]$Target
  
  if (grepl("googlebot",result)) return(TRUE)
  else return(FALSE)
  
  
}

# FALSE IP
#test1 <- testGoogleIP("10.144.163.17")
# TRUE IP
#test2 <- testGoogleIP("66.249.75.196")


logs_ip <- group_by(logs_google,ip) %>%
  summarize(count=n())


for (row in 1:nrow(logs_ip)) { 
  ip <- toString(logs_ip$ip[row]) 
  cat('IP ',ip,' ')
  logs_ip$isGoogle[row] <- testGoogleIP(ip)
}

logs_ip$count <- NULL

logs_google_desktop <- merge(logs_google, logs_ip, by = "ip") %>%
                 filter(isGoogle == TRUE & !grepl("Mobile",useragent)) %>%
                 select(-isGoogle)

logs_robotstxt_shared <- filter(logs_google_desktop, grepl("robots.txt",url)) 

