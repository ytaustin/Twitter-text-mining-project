#load library
library (devtools)
library(rtweet)
library(tidyverse)

sen_df <- get_timeline("realdonaldtrump", n = 100, max_id = NULL, home = FALSE,
                       parse = TRUE, check = TRUE, token =NULL)

create_token(
  app = "my_twitter_research_app",
  consumer_key = "nVLuvx94X4DD78GondxHWhamk",
  consumer_secret = "GBrmzr2F0scFl4t1yh6g3tEBMRWuMOkZUpyNmZdB6Hq3mLNAIL",
  access_token = "63581245959262208-zC6KsBUlDO97CnitjA2yj4YJYiWDC6n",
  access_secret = "I5CNvn5Mx0bPUqTw2715iiEuedMaMouUBbfo4ikzV9L3s")


consumer_key <- "nVLuvx94X4DD78GondxHWhamk"
consumer_secret <- "GBrmzr2F0scFl4t1yh6g3tEBMRWuMOkZUpyNmZdB6Hq3mLNAIL"
access_token <- "863581245959262208-zC6KsBUlDO97CnitjA2yj4YJYiWDC6n"
access_secret <- "I5CNvn5Mx0bPUqTw2715iiEuedMaMouUBbfo4ikzV9L3s"
setup_twitter_oauth (consumer_key, consumer_secret, access_token, access_secret)  # authenticate

test <-get_timeline("realdonaldtrump",n=10,  tweet_mode = "extended")
test.df <-twListToDF(test)

#write the data to a csv file
write.csv(test.df, "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/test.csv") 
