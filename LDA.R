library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
library(tm)
library(topicmodels)
library(tidytext)
library(textstem)


#load tramp and obama tweet data

tweets_trump <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/TrumpTweets1.csv",header = TRUE
  ) %>% select(text)

tweets_obama <-
  read.csv(
    "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/ObamaTweets1.csv",header = TRUE
  ) %>% select(text)


trump_corpus <- VCorpus(VectorSource(tweets_trump$text))
obama_corpus <- VCorpus(VectorSource(tweets_obama$text))

trump_corpus_clean <- tm_map(trump_corpus,content_transformer(tolower))
trump_corpus_clean <- lemmatize_words(trump_corpus_clean)
trump_corpus_clean <- tm_map(trump_corpus_clean, removeNumbers)
trump_corpus_clean <- tm_map(trump_corpus_clean,removeWords, c(stopwords(),"president","obama","trump","great","will","just","amp","now","thank","good","much","many","one","get"))
trump_corpus_clean <- tm_map(trump_corpus_clean, removePunctuation)
trump_corpus_clean <- tm_map(trump_corpus_clean, stripWhitespace)


obama_corpus_clean <- tm_map(obama_corpus,content_transformer(tolower))
obama_corpus_clean <- lemmatize_words(obama_corpus_clean)
obama_corpus_clean <- tm_map(obama_corpus_clean, removeNumbers)
obama_corpus_clean <- tm_map(trump_corpus_clean,removeWords, c(stopwords(),"president","obama","trump","great","will","just","amp","now","thank","good","much","many","one","get"))
obama_corpus_clean <- tm_map(obama_corpus_clean, removePunctuation)
obama_corpus_clean <- tm_map(obama_corpus_clean, stripWhitespace)

trump_dtm <- DocumentTermMatrix(trump_corpus_clean)
obama_dtm <- DocumentTermMatrix(obama_corpus_clean)

rowTotals <- apply(trump_dtm , 1, sum) #Find the sum of words in each Document
trump_dtm   <- trump_dtm[rowTotals> 0, ]
rowTotals <- apply(obama_dtm , 1, sum) #Find the sum of words in each Document
obama_dtm   <- obama_dtm[rowTotals> 0, ]

trump_lda <- LDA(trump_dtm, k = 10, control = list(seed = 1234))
trump_topics <- tidy(trump_lda, matrix = "beta")

trump_top_terms <- trump_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

trump_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
ggsave("trump_lda.jpg")


obama_lda <- LDA(obama_dtm, k = 10, control = list(seed = 1234))
obama_topics <- tidy(obama_lda, matrix = "beta")

obama_top_terms <- obama_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

obama_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
ggsave("obama_lda.jpg")









