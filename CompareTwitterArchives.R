library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)

#load tramp and obama tweet data
tweets_trump <-read.csv("C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/TrumpTweets.csv") %>% select(text, created)
tweets_obama <-read.csv("C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/ObamaTweets.csv") %>% select(text, created)

#bind two data together and assign name to each tweet, and chang the created time format
tweets <- bind_rows(tweets_trump %>% 
                      mutate(person = "Trump"),
                    tweets_obama %>% 
                      mutate(person = "Obama")) %>%
  mutate(created = ymd_hms(created))

#plot the amount of tweets for each person based on the created time
ggplot(tweets, aes(x = created, fill = person)) +
  geom_histogram(position = "identity", bins = 20, show.legend = FALSE) +
  facet_wrap(~person, ncol = 1)
ggsave("TweetsAmountAndTimeDistribution.jpg")


# let's take a look about the word frequencies

library(tidytext)
library(stringr)

#clean the data a little bit
remove_reg <- "&amp;|&lt;|&gt;|#"
tidy_tweets <- tweets %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word,
         !word %in% str_remove_all(stop_words$word, "'"),
         !str_detect(word, "president"),
         !str_detect(word, "trump"),
         !str_detect(word, "obama"),
         str_detect(word, "[a-z]"))

#find ou the frequency of the word use
frequency <- tidy_tweets %>% 
  group_by(person) %>% 
  count(word, sort = TRUE) %>% 
  left_join(tidy_tweets %>% 
              group_by(person) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)

#make a different shaped data frame
library(tidyr)

frequency <- frequency %>% 
  select(person, word, freq) %>% 
  spread(person, freq) %>%
  arrange(Trump, Obama)

#Comparing the frequency of words used by Trump and Obama
library(scales)

ggplot(frequency, aes(Trump, Obama)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red")
ggsave("WordFrequency.jpg")


#compare word usage,just consider the passed year
tidy_tweets <- tidy_tweets %>%
  filter(created >= as.Date("2017-10-01"),
         created < as.Date("2018-10-01"))


word_ratios <- tidy_tweets %>%
  filter(!str_detect(word, "^@")) %>% #remove other people's account
  count(word, person) %>%
  group_by(word) %>%
  filter(sum(n) >= 10) %>%
  ungroup() %>%
  spread(person, n, fill = 0) %>%
  mutate_if(is.numeric, funs((. + 1) / (sum(.) + 1))) %>%
  mutate(logratio = log(Trump / Obama)) %>%
  arrange(desc(logratio))

word_ratios %>% 
  arrange(abs(logratio))

word_ratios %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  ylab("log odds ratio (Trump/Obama)") +
  scale_fill_discrete(name = "", labels = c("Trump", "Obama"))
ggsave("CompareWordUsage.jpg")
