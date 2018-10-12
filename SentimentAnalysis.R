library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)

#load tramp and obama tweet data

tweets_trump <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/TrumpTweets.csv"
  ) %>% select(text, created)
tweets_obama <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/ObamaTweets.csv"
  ) %>% select(text, created)

#bind two data together and assign name to each tweet, and chang the created time format
tweets <- bind_rows(tweets_trump %>%
                      mutate(person = "Trump"),
                    tweets_obama %>%
                      mutate(person = "Obama")) %>%
  mutate(created = ymd_hms(created))