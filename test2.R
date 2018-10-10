library(rtweet)
library(tidyverse)

install.packages("devtools")
devtools::install_github("mkearney/rtweet")
library(rtweet)

twitter_tokens <- create_token(app = "my_app",
                               consumer_key <- "nVLuvx94X4DD78GondxHWhamk",
                               consumer_secret <- "GBrmzr2F0scFl4t1yh6g3tEBMRWuMOkZUpyNmZdB6Hq3mLNAIL"
)



sen_df <- get_timeline("SenateFloor", 300)

tw <- search_tweets("rstats")
head(tw)