#load library
library(twitteR)
library(rtweet)
library(tidytext)
library(dplyr)
library(ROAuth)
library(devtools)
# #----------------------------------------------------------------
# #
# #THIS PART JUST NEED RUN ONCE
#
#load credentials
#consumer_key <- "nVLuvx94X4DD78GondxHWhamk"
#consumer_secret <- "GBrmzr2F0scFl4t1yh6g3tEBMRWuMOkZUpyNmZdB6Hq3mLNAIL"
#access_token <- "863581245959262208-zC6KsBUlDO97CnitjA2yj4YJYiWDC6n"
#access_secret <- "I5CNvn5Mx0bPUqTw2715iiEuedMaMouUBbfo4ikzV9L3s"
#
# #
# #establish a secure connection between R and Twitter
# download.file(url= "http://curl.haxx.se/ca/cacert.pem", destfile= "cacert.pem")
# #Set the certification at Twitter by making a call to OAuthFactory function
# credentials <- OAuthFactory$new(consumerKey='nVLuvx94X4DD78GondxHWhamk',
#                                 consumerSecret='GBrmzr2F0scFl4t1yh6g3tEBMRWuMOkZUpyNmZdB6Hq3mLNAIL',
#                                 requestURL='https://api.twitter.com/oauth/request_token',
#                                 accessURL='https://api.twitter.com/oauth/access_token',
#                                 authURL='https://api.twitter.com/oauth/authorize')
# #Let’s now ask Twitter for access!
# credentials$handshake(cainfo="cacert.pem")
# #Save the credentials for later use
# save(credentials, file="TwitterAuthentication.Rdata")
# 
# #-------------------------------------------------------------

#Load Authentication Data
load("TwitterAuthentication.Rdata")

#Register Twitter Authentication
setup_twitter_oauth(credentials$consumerKey, credentials$consumerSecret, credentials$oauthKey, credentials$oauthSecret)

#Extract Tweets with concerned string(first argument), followed by number of tweets (n) and language (lang)
tweets <- userTimeline("realdonaldtrump", n=200, sinceID = NULL, includeRts = TRUE, excludeReplies = TRUE)

#strip retweets
tweets <- strip_retweets(tweets)

#save result in a data frame
tweets.df <-twListToDF(tweets)

#write the data to a csv file
write.csv(tweets.df, "C:/Users/taoya/OneDrive/Documents/Twitter-text-mining-project/tweets.csv") 

