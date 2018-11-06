library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
library(tidytext)
library(stringr)
library(tidyr)

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


tweets_trump <- mutate(tweets_trump, person = "Trump") %>%
  mutate(tnumber = row_number()) %>%
  mutate(created = ymd_hms(created))

tweets_obama <- mutate(tweets_obama, person = "Obama") %>%
  mutate(tnumber = row_number()) %>%
  mutate(created = ymd_hms(created))

#clean the data a little bit
remove_reg <- "&amp;|&lt;|&gt;|#"
tidy_tweets_trump <- tweets_trump %>%
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(
    !word %in% stop_words$word,!word %in% str_remove_all(stop_words$word, "'"),!str_detect(word, "president"),!str_detect(word, "trump"),!str_detect(word, "obama"),
    str_detect(word, "[a-z]")
  )

tidy_tweets_obama <- tweets_obama %>%
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(
    !word %in% stop_words$word,!word %in% str_remove_all(stop_words$word, "'"),!str_detect(word, "president"),!str_detect(word, "trump"),!str_detect(word, "obama"),
    str_detect(word, "[a-z]")
  )

tidy_tweets <- tweets %>%
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(
    !word %in% stop_words$word,!word %in% str_remove_all(stop_words$word, "'"),!str_detect(word, "president"),!str_detect(word, "trump"),!str_detect(word, "obama"),
    str_detect(word, "[a-z]")
  )



tidy_tweets_nrc <- tidy_tweets %>%
  inner_join(get_sentiments("nrc"))


#Comparing the sentiment of the tweets of Trump and Obama
ggplot(tidy_tweets_nrc, aes(x = sentiment, fill = person)) +
  geom_bar(position = "dodge")
ggsave("nrc_sentiment.jpg")


afinn_t <- tidy_tweets_trump %>% 
  inner_join(get_sentiments("afinn")) %>% 
  group_by(index = tnumber %/% 80) %>% 
  summarise(sentiment = sum(score)) %>% 
  mutate(method = "AFINN")

bing_and_nrc_t <- bind_rows(tidy_tweets_trump %>% 
                            inner_join(get_sentiments("bing")) %>%
                            mutate(method = "Bing"),
                          tidy_tweets_trump %>% 
                            inner_join(get_sentiments("nrc") %>% 
                                         filter(sentiment %in% c("positive", 
                                                                 "negative"))) %>%
                            mutate(method = "NRC")) %>%
  count(method, index = tnumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

bind_rows(afinn_t, 
          bing_and_nrc_t) %>%
  ggplot(aes(index, sentiment, fill = method)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~method, ncol = 1, scales = "free_y")
ggsave("trumpsentiment.jpg")


afinn_o <- tidy_tweets_obama %>% 
  inner_join(get_sentiments("afinn")) %>% 
  group_by(index = tnumber %/% 80) %>% 
  summarise(sentiment = sum(score)) %>% 
  mutate(method = "AFINN")

bing_and_nrc_o <- bind_rows(tidy_tweets_obama %>% 
                              inner_join(get_sentiments("bing")) %>%
                              mutate(method = "Bing"),
                            tidy_tweets_obama %>% 
                              inner_join(get_sentiments("nrc") %>% 
                                           filter(sentiment %in% c("positive", 
                                                                   "negative"))) %>%
                              mutate(method = "NRC")) %>%
  count(method, index = tnumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

bind_rows(afinn_o, 
          bing_and_nrc_o) %>%
  ggplot(aes(index, sentiment, fill = method)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~method, ncol = 1, scales = "free_y")
ggsave("obamasentiment.jpg")


