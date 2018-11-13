library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
library(tidytext)
library(stringr)
library(tidyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)


#load tramp and obama tweet data

tweets_trump <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/TrumpTweets.csv"
  ) %>% select(text)  %>% mutate(person = "Trump")
tweets_obama <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/ObamaTweets.csv"
  ) %>% select(text) %>% mutate(person = "Obama")


#clean the data a little bit
remove_reg <- "&amp;|&lt;|&gt;|#"
tweets_trump <- tweets_trump %>%
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(
    !word %in% stop_words$word,!word %in% str_remove_all(stop_words$word, "'"),
    !str_detect(word, "http"),
    !str_detect(word, "president"),
    !str_detect(word, "trump"),
    !str_detect(word, "obama"),
    !str_detect(word, "@"),
    !str_detect(word, "<u+"),
    str_detect(word, "[a-z]")
  )

tweets_obama <- tweets_obama %>%
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(
    !word %in% stop_words$word,!word %in% str_remove_all(stop_words$word, "'"),
    !str_detect(word, "http"),
    !str_detect(word, "president"),
    !str_detect(word, "trump"),
    !str_detect(word, "obama"),
    !str_detect(word, "@"),
    !str_detect(word, "<u+"),
    str_detect(word, "[a-z]")
  )


#find ou the frequency of the word use
frequency_Trump <- tweets_trump  %>%
  count(word, sort = TRUE)

frequency_Obama <- tweets_obama  %>%
  count(word, sort = TRUE)
  
  

#make a different shaped data frame

set.seed(1234)
wordcloud(words = frequency_Trump$word, freq = frequency_Trump$n, min.freq =50,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

set.seed(1234)
wordcloud(words = frequency_Obama$word, freq = frequency_Obama$n, min.freq =50,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
