
# tokens and api for rtweet -------------------------------------------
# http://rtweet.info/articles/auth.html

# packages ------
# install.packages("rtweet")
# devtools::install_github("mkearney/rtweet")
library(rtweet)
library(httr)
library(tidyverse)

## app name from api set-up
appname <- "newsandnumbers_twitter_app"


# Consumer Key (API Key) ----------------------------------------------
key <- "ZDZ4IJGc1iQDD7oAQrMUpJD49"

## Consumer Secret (API Secret) ---------------------------------------
secret <- "0TmHJCvsqwUPsfn4E9KvfOAe9n2ldnkO0QQYs9Zo7MLjwQuWjD"

## create token named "twitter_token"
twitter_token <- rtweet::create_token(app = appname,
                                    consumer_key = key,
                                    consumer_secret = secret)


## path of home directory -----
home_directory <- path.expand("~")

## combine with name for token -----
file_name <- file.path(home_directory,
                       "twitter_token.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)


## On my mac, the .Renviron text looks like this:
##     TWITTER_PAT=/Users/martinfrigaard/twitter_token.rds

## assuming you followed the procodures to create "file_name"
## from the previous code chunk, then the code below should
## create and save your environment variable.
cat(paste0("TWITTER_PAT=", file_name),
    file = file.path(home_directory, ".Renviron"),
    append = TRUE)
