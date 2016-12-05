#install.packages("edeaR")
library(edeaR)
library(lubridate)

# csv format for disco
write.table(logs_google_filtered,
            "logsEventGoogleBot.csv",
            sep=";",
            col.names = FALSE,
            row.names = FALSE
)

# xes format for proM
#load : 
#eventlog <- eventlog_from_xes()

data("csv_example", package = "edeaR")

head(csv_example)

csv_example$ACTIVITY_INSTANCE <- 1:nrow(csv_example)

head(csv_example)

library(tidyr)
csv_example <- gather(csv_example, LIFECYCLE, TIMESTAMP, -CASE, -ACTIVITY, -ACTIVITY_INSTANCE)

head(csv_example)

csv_example$LIFECYCLE <- factor(csv_example$LIFECYCLE, labels = c("start","complete"))

head(csv_example)

csv_example$TIMESTAMP <- ymd_hms(csv_example$TIMESTAMP)

csv_example$RESSOURCE <- "RE"


log_xes <- eventlog(eventlog = csv_example,
                case_id = "CASE",
                activity_id = "ACTIVITY",
                activity_instance_id = "ACTIVITY_INSTANCE",
                lifecycle_id = "LIFECYCLE",
                timestamp = "TIMESTAMP",
                resource_id = "RESSOURCE")



# import prom
#write_xes(log_xes, file = "test.xes")



