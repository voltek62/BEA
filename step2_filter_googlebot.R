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

logs_google_filtered <- merge(logs_google, logs_ip, by = "ip") %>%
                 filter(isGoogle == TRUE) %>%
                 select(-isGoogle)


# Here is the new Googlebot smartphone user-agent that kicks in on April 18, 2016:
#   
#   Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
# 
# Here is the current smartphone user-agent for Googlebot that we have today:
#   
#   Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12F70 Safari/600.1.4 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)

# logs_google_2$useragent2 <- factor(logs_google_2$useragent)