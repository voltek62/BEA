library(edeaR)
library(lubridate)
library(dplyr)
library(ggplot2)

# https://cran.r-project.org/web/packages/edeaR/vignettes/selection.html

data(BPIC15_1)

filtered_log <- filter_activity_frequency(BPIC15_1, percentile_cut_off = 0.25, reverse = T)

activities(filtered_log) %>% select(absolute_frequency) %>% summary

case_throughput <- throughput_time(BPIC15_1, "case")


gg <- ggplot(case_throughput) +
  geom_histogram(aes(throughput_time), fill = "#0072B2", binwidth = 10) +
  xlab("Duration (in days)") +
  ylab("Number of cases")

print(gg)


#filtered_log <- filter_time_period(BPIC15_1, a, b, "trim")

start <- filtered_log %>% group_by(case_concept.name) %>% summarize(timestamp = min(event_time.timestamp)) %>% mutate(type = "start")

complete <- filtered_log %>% group_by(case_concept.name) %>% summarize(timestamp = max(event_time.timestamp)) %>% mutate(type = "end")

gg2 <- bind_rows(start, complete) %>%
  ggplot() +
  geom_histogram(aes(timestamp, fill = type), binwidth = 60*60*24*7) +
  facet_grid(type ~ .) +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none")

print(gg2)