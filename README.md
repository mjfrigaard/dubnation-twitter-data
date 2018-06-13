README- \#DubNation Parade - streaming and plotting tweets in R
================

    ## [1] "2.5-dubnation_parade_tweets.Rmd"

# Motivation

This post will walk you through 1) collecting data from a Twitter API using the `rtweet` package, 2) creating a map with the tweets using the `ggmap`, `maps`, and `mapdata`, and 3) graphing the tweets with `ggplot2` and `gganimate`.

## Set up the twitter app (with `rtweet`)

You can find excellent documentation on the package [website](http://rtweet.info/), I am just going to go into more detail.

Install/load the package.

``` r
library(tidyverse)
library(rtweet)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(gganimate)
library(ggraph)
library(igraph)
library(hrbrthemes)
library(ggalt)
library(ggthemes)
```

This is the first step for collecting tweets based on location. See the vignette [here](http://rtweet.info/articles/auth.html). I’ve outlined this process in the link below.

![rtweet\_setup](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/rtweet_setup.png)

## collect a stream of tweets

We will start by collecting data on a certain hashtag occurrence. Today is June 12th, 2018, and they Golden State Warriors are celebrating their third NBA title ‘\#DubNation celebration’. I’ll be searching for the hashtags `#DubNation` and `#StrengthInNumbers`.

The function for collecting tweets is `rtweet::search_tweets()`, and it takes a query `q` (our term). Learn more about this function by typing:

``` r
# ?search_tweets
```

We will use all the default settings in this inital search. After the `rtweet::search_tweets()` function has run, I will take a look at this data frame with `dplyr::glimpse()`

``` r
# tweets containing #DubNation
DubTweets <- search_tweets("#DubNation")
```

``` r
DubTweets %>% glimpse(78)
```

    Observations: 100
    Variables: 87
    $ user_id                 <chr> "1003972298", "1005326384154185728", "100...
    $ status_id               <chr> "1007000921245716482", "10070033967196938...
    $ created_at              <dttm> 2018-06-13 20:45:03, 2018-06-13 20:54:53...
    $ screen_name             <chr> "iam_boa15", "AkhonaGladile1", "J0yuyDddm...
    $ text                    <chr> "RT @warriors: Back-to-back Championships...
    $ source                  <chr> "Twitter for iPhone", "Twitter for Androi...
    $ display_text_width      <dbl> 140, 140, 109, 139, 100, 91, 72, 140, 140...
    $ reply_to_status_id      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ reply_to_user_id        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ reply_to_screen_name    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ is_quote                <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, ...
    $ is_retweet              <lgl> TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALS...
    $ favorite_count          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
    $ retweet_count           <int> 362, 27, 92, 103, 0, 93, 0, 362, 362, 86,...
    $ hashtags                <list> [<"NBAFinals", "DubNation">, <"postmalon...
    $ symbols                 <list> [NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
    $ urls_url                <list> [NA, NA, NA, NA, "twitter.com/warriors/s...
    $ urls_t.co               <list> [NA, NA, NA, NA, "https://t.co/SBRSFZSSK...
    $ urls_expanded_url       <list> [NA, NA, NA, NA, "https://twitter.com/wa...
    $ media_url               <list> [NA, NA, "http://pbs.twimg.com/ext_tw_vi...
    $ media_t.co              <list> [NA, NA, "https://t.co/gKdEUjzEu5", NA, ...
    $ media_expanded_url      <list> [NA, NA, "https://twitter.com/DleeWill/s...
    $ media_type              <list> [NA, NA, "photo", NA, NA, "photo", NA, N...
    $ ext_media_url           <list> [NA, NA, "http://pbs.twimg.com/ext_tw_vi...
    $ ext_media_t.co          <list> [NA, NA, "https://t.co/gKdEUjzEu5", NA, ...
    $ ext_media_expanded_url  <list> [NA, NA, "https://twitter.com/DleeWill/s...
    $ ext_media_type          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ mentions_user_id        <list> ["26270913", "1000834131901730817", "261...
    $ mentions_screen_name    <list> ["warriors", "culture_strange", "DleeWil...
    $ lang                    <chr> "en", "en", "en", "en", "en", "en", "en",...
    $ quoted_status_id        <chr> NA, NA, NA, NA, "1006979740115324929", NA...
    $ quoted_text             <chr> NA, NA, NA, NA, "Back-to-back Championshi...
    $ quoted_created_at       <dttm> NA, NA, NA, NA, 2018-06-13 19:20:53, NA,...
    $ quoted_source           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_favorite_count   <int> NA, NA, NA, NA, 1962, NA, NA, NA, NA, NA,...
    $ quoted_retweet_count    <int> NA, NA, NA, NA, 362, NA, NA, NA, NA, NA, ...
    $ quoted_user_id          <chr> NA, NA, NA, NA, "26270913", NA, NA, NA, N...
    $ quoted_screen_name      <chr> NA, NA, NA, NA, "warriors", NA, NA, NA, N...
    $ quoted_name             <chr> NA, NA, NA, NA, "Golden State Warriors", ...
    $ quoted_followers_count  <int> NA, NA, NA, NA, 5873378, NA, NA, NA, NA, ...
    $ quoted_friends_count    <int> NA, NA, NA, NA, 986, NA, NA, NA, NA, NA, ...
    $ quoted_statuses_count   <int> NA, NA, NA, NA, 76517, NA, NA, NA, NA, NA...
    $ quoted_location         <chr> NA, NA, NA, NA, "Oakland, CA", NA, NA, NA...
    $ quoted_description      <chr> NA, NA, NA, NA, "\U0001f3c6\U0001f3c6\U00...
    $ quoted_verified         <lgl> NA, NA, NA, NA, TRUE, NA, NA, NA, NA, NA,...
    $ retweet_status_id       <chr> "1006979740115324929", "10055750809261547...
    $ retweet_text            <chr> "Back-to-back Championships. 3 titles in ...
    $ retweet_created_at      <dttm> 2018-06-13 19:20:53, 2018-06-09 22:19:16...
    $ retweet_source          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ retweet_favorite_count  <int> 1962, 64, 235, 203, NA, 234, NA, 1962, 19...
    $ retweet_retweet_count   <int> 362, 27, 92, 103, NA, 93, NA, 362, 362, 8...
    $ retweet_user_id         <chr> "26270913", "1000834131901730817", "26166...
    $ retweet_screen_name     <chr> "warriors", "culture_strange", "DleeWill"...
    $ retweet_name            <chr> "Golden State Warriors", "Strange Culture...
    $ retweet_followers_count <int> 5873378, 38, 106119, 106119, NA, 44478, N...
    $ retweet_friends_count   <int> 986, 175, 2, 2, NA, 3128, NA, 986, 986, 6...
    $ retweet_statuses_count  <int> 76517, 8, 1165, 1165, NA, 5290, NA, 76517...
    $ retweet_location        <chr> "Oakland, CA", "Montréal, Québec", "Bay A...
    $ retweet_description     <chr> "\U0001f3c6\U0001f3c6\U0001f3c6\U0001f3c6...
    $ retweet_verified        <lgl> TRUE, FALSE, FALSE, FALSE, NA, FALSE, NA,...
    $ place_url               <chr> NA, NA, NA, NA, NA, NA, "https://api.twit...
    $ place_name              <chr> NA, NA, NA, NA, NA, NA, "San Francisco", ...
    $ place_full_name         <chr> NA, NA, NA, NA, NA, NA, "San Francisco, C...
    $ place_type              <chr> NA, NA, NA, NA, NA, NA, "city", NA, NA, N...
    $ country                 <chr> NA, NA, NA, NA, NA, NA, "United States", ...
    $ country_code            <chr> NA, NA, NA, NA, NA, NA, "US", NA, NA, NA,...
    $ geo_coords              <list> [<NA, NA>, <NA, NA>, <NA, NA>, <NA, NA>,...
    $ coords_coords           <list> [<NA, NA>, <NA, NA>, <NA, NA>, <NA, NA>,...
    $ bbox_coords             <list> [<NA, NA, NA, NA, NA, NA, NA, NA>, <NA, ...
    $ name                    <chr> "Olayinka", "Akhona Gladile", "مُناضل", "...
    $ location                <chr> "lagos", "East London, South Africa", "",...
    $ description             <chr> "", "", "", "", "you know, falling in ill...
    $ url                     <chr> NA, NA, NA, NA, NA, "https://t.co/HFwxSDn...
    $ protected               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,...
    $ followers_count         <int> 795, 12, 0, 0, 79, 12821, 465, 1444, 304,...
    $ friends_count           <int> 885, 45, 0, 0, 129, 13135, 317, 1089, 394...
    $ listed_count            <int> 20, 0, 0, 0, 1, 15, 45, 10, 5, 1, 11, 4, ...
    $ statuses_count          <int> 35347, 16, 18, 23, 238, 11625, 1965, 8989...
    $ favourites_count        <int> 258, 2, 0, 0, 53, 698, 1645, 870, 5302, 2...
    $ account_created_at      <dttm> 2012-12-11 12:48:05, 2018-06-09 05:51:02...
    $ verified                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,...
    $ profile_url             <chr> NA, NA, NA, NA, NA, "https://t.co/HFwxSDn...
    $ profile_expanded_url    <chr> NA, NA, NA, NA, NA, "https://soundcloud.c...
    $ account_lang            <chr> "en", "en", "en", "en", "it", "fr", "en",...
    $ profile_banner_url      <chr> NA, "https://pbs.twimg.com/profile_banner...
    $ profile_background_url  <chr> "http://abs.twimg.com/images/themes/theme...
    $ profile_image_url       <chr> "http://pbs.twimg.com/profile_images/9825...

This data set contains `100` observations. If I want more tweets, I need to adjust the cap on the number of tweets I can collect with my API. I can do this by setting the `retryonratelimit` to `TRUE`.

See below from the manual:

> Logical indicating whether to wait and retry when rate limited. This argument is only relevant if the desired return (`n`) exceeds the remaining limit of available requests (assuming no other searches have been conducted in the past 15 minutes, this limit is 18,000 tweets).
> Defaults to false. Set to `TRUE` to automate process of conducting big searches (i.e., `n > 18000`). For many search queries, esp. specific or specialized searches, there won’t be more than 18,000 tweets to return. But for broad, generic, or popular topics, the total number of tweets within the `REST` window of time (7-10 days) can easily reach the millions.


## Collect data for `#DubNation` and `#StrengthInNumbers` with `rtweet::search_tweets2()`

The `rtweet::search_tweets2()` function works just like the `rtweet::search_tweets()`, but also “***returns data from one OR MORE search queries.***”

I’ll use `rtweet::search_tweets2()` to collect data for two hashtags now, `#DubNation` and `#StrengthInNumbers`, but set the `n` to `100000` and the `retryonratelimit` argument to `TRUE`.

``` r
## search using multilple queries
DubNtnStrngthNmbrs <- rtweet::search_tweets2(
            c("\"#DubNation\"",
              "#StrengthInNumbers"),
            n = 100000, retryonratelimit = TRUE)
```

The structure for this data frame is displayed below with `dplyr::glimpse()`.

``` r
DubNtnStrngthNmbrs %>% dplyr::glimpse(78)
```

    Observations: 60,035
    Variables: 88
    $ user_id                 <chr> "1000017900130861057", "10000595975274209...
    $ status_id               <chr> "1006490712362237952", "10065656585938247...
    $ created_at              <dttm> 2018-06-12 10:57:40, 2018-06-12 15:55:28...
    $ screen_name             <chr> "urqnminJFwPNlPb", "whoismanelabreu", "wh...
    $ text                    <chr> "RT @vwphotographer: My favourite #bus fr...
    $ source                  <chr> "Twitter for Android", "Twitter for Andro...
    $ display_text_width      <dbl> 140, 104, 84, 69, 144, 81, 61, 140, 104, ...
    $ reply_to_status_id      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ reply_to_user_id        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ reply_to_screen_name    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ is_quote                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,...
    $ is_retweet              <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,...
    $ favorite_count          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
    $ retweet_count           <int> 9, 1739, 137, 424, 302, 2161, 986, 486, 1...
    $ hashtags                <list> [<"bus", "VanLife", "Vintage", "Volkswag...
    $ symbols                 <list> [NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
    $ urls_url                <list> [NA, NA, NA, NA, NA, NA, NA, "warriors.c...
    $ urls_t.co               <list> [NA, NA, NA, NA, NA, NA, NA, "https://t....
    $ urls_expanded_url       <list> [NA, NA, NA, NA, NA, NA, NA, "http://war...
    $ media_url               <list> [NA, "http://pbs.twimg.com/tweet_video_t...
    $ media_t.co              <list> [NA, "https://t.co/CK2nFEB3KN", "https:/...
    $ media_expanded_url      <list> [NA, "https://twitter.com/warriors/statu...
    $ media_type              <list> [NA, "photo", "photo", "photo", NA, "pho...
    $ ext_media_url           <list> [NA, "http://pbs.twimg.com/tweet_video_t...
    $ ext_media_t.co          <list> [NA, "https://t.co/CK2nFEB3KN", "https:/...
    $ ext_media_expanded_url  <list> [NA, "https://twitter.com/warriors/statu...
    $ ext_media_type          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ mentions_user_id        <list> [<"913370450796871681", "1141181808">, "...
    $ mentions_screen_name    <list> [<"vwphotographer", "VdubAtThePub">, "wa...
    $ lang                    <chr> "en", "en", "en", "en", "en", "en", "en",...
    $ quoted_status_id        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_text             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_created_at       <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
    $ quoted_source           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_favorite_count   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_retweet_count    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_user_id          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_screen_name      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_name             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_followers_count  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_friends_count    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_statuses_count   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_location         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_description      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ quoted_verified         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ retweet_status_id       <chr> "1006299027040817152", "10065225244386181...
    $ retweet_text            <chr> "My favourite #bus from @VdubAtThePub in ...
    $ retweet_created_at      <dttm> 2018-06-11 22:15:58, 2018-06-12 13:04:04...
    $ retweet_source          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ retweet_favorite_count  <int> 29, 7532, 681, 1150, 2057, 11165, 5248, 2...
    $ retweet_retweet_count   <int> 9, 1739, 137, 424, 302, 2161, 986, 486, 1...
    $ retweet_user_id         <chr> "913370450796871681", "26270913", "199231...
    $ retweet_screen_name     <chr> "vwphotographer", "warriors", "NBA", "war...
    $ retweet_name            <chr> "vwphotographer", "Golden State Warriors"...
    $ retweet_followers_count <int> 317, 5871460, 27854711, 5871456, 1864037,...
    $ retweet_friends_count   <int> 25, 986, 1663, 986, 1599, 1663, 1663, 986...
    $ retweet_statuses_count  <int> 248, 76490, 201517, 76490, 14020, 201517,...
    $ retweet_location        <chr> "Poole, England", "Oakland, CA", "", "Oak...
    $ retweet_description     <chr> "Daily dose of Buses, Bugs & Vans. Pictur...
    $ retweet_verified        <lgl> FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE...
    $ place_url               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ place_name              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ place_full_name         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ place_type              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ country                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ country_code            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    $ geo_coords              <list> [<NA, NA>, <NA, NA>, <NA, NA>, <NA, NA>,...
    $ coords_coords           <list> [<NA, NA>, <NA, NA>, <NA, NA>, <NA, NA>,...
    $ bbox_coords             <list> [<NA, NA, NA, NA, NA, NA, NA, NA>, <NA, ...
    $ name                    <chr> "有栖川やい２号", "Manel Abreu", "Manel Abreu", ...
    $ location                <chr> "", "Manellândia", "Manellândia", "Boston...
    $ description             <chr> "", "Manenenenenenenellll", "Manenenenene...
    $ url                     <chr> NA, "https://t.co/4ZfUzV0DpO", "https://t...
    $ protected               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,...
    $ followers_count         <int> 90, 37, 37, 42, 1, 19, 15, 21, 15, 161, 1...
    $ friends_count           <int> 251, 39, 39, 122, 9, 135, 166, 72, 114, 1...
    $ listed_count            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
    $ statuses_count          <int> 1824, 454, 454, 272, 20, 35, 124, 755, 54...
    $ favourites_count        <int> 2558, 253, 253, 732, 30, 95, 2216, 2866, ...
    $ account_created_at      <dttm> 2018-05-25 14:17:01, 2018-05-25 17:02:43...
    $ verified                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,...
    $ profile_url             <chr> NA, "https://t.co/4ZfUzV0DpO", "https://t...
    $ profile_expanded_url    <chr> NA, "http://curiouscat.me/whoismanelabreu...
    $ account_lang            <chr> "ja", "pt", "pt", "en", "en", "en", "en",...
    $ profile_banner_url      <chr> "https://pbs.twimg.com/profile_banners/10...
    $ profile_background_url  <chr> NA, NA, NA, NA, NA, NA, NA, NA, "http://a...
    $ profile_image_url       <chr> "http://pbs.twimg.com/profile_images/1006...
    $ query                   <chr> "\"#DubNation\"", "\"#DubNation\"", "\"#D...

Before I export these data, I will create an `outfile` that pastes together four important pieces of information I want with any exported file:

1.  **File Path:** this is the folder destination of the data/object I will be saving
2.  **Data Object:** the actual name of the data frame/list being saved
3.  **A timestamp:** a date/time character string (I do this with my custom `timeStamper()` function).
4.  **A file extension:** this is either .csv, .rds, .RData or however the data object will be saved.



``` r
tweet_searches_file_path <- "Data/tweet_searches/"
DubNtnStrngthNmbrs_outfile <- paste0(tweet_searches_file_path, "DubNtnStrngthNmbrs",
                                                timeStamper(), ".rds")
DubNtnStrngthNmbrs_outfile
```

``` r
write_rds(x = DubNtnStrngthNmbrs, path = DubNtnStrngthNmbrs_outfile)
# verify
# dir(tweet_searches_file_path)
```

This data frame has `60,035` observations, and adds one additional variable. We can use the handy `base::setdiff()` to figure out what variables are in `DubNtnStrngthNmbrs` that aren’t in `DubTweetsGame3`.

``` r
base::setdiff(x = names(DubNtnStrngthNmbrs),
              y = names(DubTweets))
```

    [1] "query"

The `query` variable contains our two search terms.

``` r
DubNtnStrngthNmbrs %>% count(query)
```

    # A tibble: 2 x 2
      query                  n
      <chr>              <int>
    1 "\"#DubNation\""   38112
    2 #StrengthInNumbers 21923

### Get user data with `rtweet::users_data()`

The previous data frame had 87 variables in it, which includes the variables on users and tweets. We can use the `rtweet::users_data()` function to remove the users variables.

The `base::intersect()` function allows us to see what variables from `DubNtnStrngthNmbrs` will end up in the results from `rtweet::users_data()`.

*I added `tibble::as_tibble()` so the variables print nicely to the screen.*

``` r
tibble::as_tibble(base::intersect(x = base::names(DubNtnStrngthNmbrs),
                y = base::names(rtweet::users_data(DubNtnStrngthNmbrs))))
```

```
# A tibble: 20 x 1
   value
   <chr>
 1 user_id
 2 screen_name
 3 name
 4 location
 5 description
 6 url
 7 protected
 8 followers_count
 9 friends_count
10 listed_count
11 statuses_count
12 favourites_count
13 account_created_at
14 verified
15 profile_url
16 profile_expanded_url
17 account_lang
18 profile_banner_url
19 profile_background_url
20 profile_image_url
```

I’ll store the contents in a new data frame called `UsersDubNtnStrngthNmbrs`.

``` r
# get user data
UsersDubNtnStrngthNmbrs <- rtweet::users_data(DubNtnStrngthNmbrs)
UsersDubNtnStrngthNmbrs %>% glimpse(78)
```

    Observations: 60,035
    Variables: 20
    $ user_id                <chr> "1000017900130861057", "100005959752742093...
    $ screen_name            <chr> "urqnminJFwPNlPb", "whoismanelabreu", "who...
    $ name                   <chr> "有栖川やい２号", "Manel Abreu", "Manel Abreu", "...
    $ location               <chr> "", "Manellândia", "Manellândia", "Boston,...
    $ description            <chr> "", "Manenenenenenenellll", "Manenenenenen...
    $ url                    <chr> NA, "https://t.co/4ZfUzV0DpO", "https://t....
    $ protected              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    $ followers_count        <int> 90, 37, 37, 42, 1, 19, 15, 21, 15, 161, 11...
    $ friends_count          <int> 251, 39, 39, 122, 9, 135, 166, 72, 114, 17...
    $ listed_count           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
    $ statuses_count         <int> 1824, 454, 454, 272, 20, 35, 124, 755, 54,...
    $ favourites_count       <int> 2558, 253, 253, 732, 30, 95, 2216, 2866, 7...
    $ account_created_at     <dttm> 2018-05-25 14:17:01, 2018-05-25 17:02:43,...
    $ verified               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
    $ profile_url            <chr> NA, "https://t.co/4ZfUzV0DpO", "https://t....
    $ profile_expanded_url   <chr> NA, "http://curiouscat.me/whoismanelabreu"...
    $ account_lang           <chr> "ja", "pt", "pt", "en", "en", "en", "en", ...
    $ profile_banner_url     <chr> "https://pbs.twimg.com/profile_banners/100...
    $ profile_background_url <chr> NA, NA, NA, NA, NA, NA, NA, NA, "http://ab...
    $ profile_image_url      <chr> "http://pbs.twimg.com/profile_images/10063...

## Get tweet data with `rtweet::tweets_data()`

I can also create another data frame with the tweet information using the `rtweet::tweets_data()` function. Just like above, I will display the variables in this new data frame (but limit it to the top 20).

I will store these variables in the `TweetsDubNtnStrngthNmbrs` data frame.

``` r
tibble::as_tibble(
    intersect(x = base::names(DubNtnStrngthNmbrs),
          y = base::names(rtweet::tweets_data(DubNtnStrngthNmbrs)))) %>%
          utils::head(20)
```

```
# A tibble: 20 x 1
   value
   <chr>
 1 user_id
 2 status_id
 3 created_at
 4 screen_name
 5 text
 6 source
 7 display_text_width
 8 reply_to_status_id
 9 reply_to_user_id
10 reply_to_screen_name
11 is_quote
12 is_retweet
13 favorite_count
14 retweet_count
15 hashtags
16 symbols
17 urls_url
18 urls_t.co
19 urls_expanded_url
20 media_url
```

``` r
TweetsDubNtnStrngthNmbrs <- rtweet::tweets_data(DubNtnStrngthNmbrs)
```

### View the tweets in the `text` column

The tweets are stored in the column/variable called `text`. I can review the first 10 of these entries with `dplyr::select()` and `utils::head()`.


``` r
DubNtnStrngthNmbrs %>%
    dplyr::select(text) %>%
    utils::head(10)
```

    # A tibble: 10 x 1
       text
       <chr>
     1 RT @vwphotographer: My favourite #bus from @VdubAtThePub in a little p…
     2 "RT @warriors: 🗣️ IT'S #WARRIORSPARADE DAY!\n\nThe fun begins at 11 am…
     3 RT @NBA: Klay waves hello at the #WarriorsParade! #DubNation https://t…
     4 RT @warriors: 2018 NBA CHAMPIONS 🏆 #DubNation https://t.co/SJrGE7nSBQ
     5 RT @JimmyKimmelLive: Tonight on #Kimmel #NBAFinals #MVP Kevin Durant @…
     6 "RT @NBA: Championship Klay! \n\n#DubNation\n#ThisIsWhyWePlay https://…
     7 RT @NBA: Happy Parade Day! #DubNation https://t.co/3qpgbRihkD
     8 "RT @warriors: Can't wait to celebrate this Championship with #DubNati…
     9 "RT @warriors: 🗣️ IT'S #WARRIORSPARADE DAY!\n\nThe fun begins at 11 am…
    10 "RT @warriors: 🗣️ IT'S #WARRIORSPARADE DAY!\n\nThe fun begins at 11 am…

I will export these data frames using the methods described above.

``` r
# ls()
TweetsDubNtnStrngthNmbrs_outfile <- paste0(tweet_searches_file_path,
                                           "TweetsDubNtnStrngthNmbrs",
                                            timeStamper(), ".rds")
# TweetsDubNtnStrngthNmbrs_outfile
write_rds(x = TweetsDubNtnStrngthNmbrs, path = TweetsDubNtnStrngthNmbrs_outfile)
```

``` r
# ls()
UsersDubNtnStrngthNmbrs_outfile <- paste0(tweet_searches_file_path,
                                           "UsersDubNtnStrngthNmbrs",
                                            timeStamper(), ".rds")
# UsersDubNtnStrngthNmbrs_outfile
write_rds(x = UsersDubNtnStrngthNmbrs, path = UsersDubNtnStrngthNmbrs_outfile)
# verify
# fs::dir_ls(tweet_searches_file_path)
```

## Get streaming tweets with `rtweet::stream_tweets(()`

This function allows me to collect all tweets mentioning the `WarriorsParade` for a specified amount of time. I will start with `90` seconds.

``` r
WarriorsParadeStream <- rtweet::stream_tweets(q = "WarriorsParade", timeout = 90)
# WarriorsParadeStream %>% glimpse(78)
```

The `rtweet` package also comes with a handy function for plotting tweets over time with `rtweet::ts_plot()`.

``` r
rtweet::ts_plot(data = WarriorsParadeStream, by = "secs")
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-ts_plot_WarriorsParadeStream.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-ts_plot_WarriorsParadeStream.png", width = 6.5,height = 4, units = "in")
```

Just for comparison, I will also collect another stream of tweets mentioning `Warriors` for `120` seconds.

``` r
WarriorsStream <- rtweet::stream_tweets(q = "Warriors", timeout = 120)
# WarriorsStream %>% glimpse(78)
```

``` r
rtweet::ts_plot(data = WarriorsStream, by = "secs")
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-ts_plot_WarriorsStream.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-ts_plot_WarriorsStream.png", width = 6.5,height = 4, units = "in")
```

Now export these data frames so we can archive them.

``` r
# ls()
WarriorsParadeStream_outfile <- paste0(tweet_searches_file_path,
                                           "WarriorsParadeStream",
                                            timeStamper(), ".rds")
# WarriorsParadeStream_outfile
# ls()
WarriorsStream_outfile <- paste0(tweet_searches_file_path,
                                           "WarriorsStream",
                                            timeStamper(), ".rds")
# WarriorsStream_outfile
write_rds(x = WarriorsParadeStream, path = WarriorsParadeStream_outfile)
write_rds(x = WarriorsStream, path = WarriorsStream_outfile)
# verify
# fs::dir_ls("Data/tweet_searches") %>% writeLines()
```

## The timeline of tweets with `rtweet::ts_plot()`

I added the `ggthemes::theme_gdocs()` theme and made the title text bold with `ggplot2::theme(plot.title = ggplot2::element_text())`.

``` r
gg_ts_plot <- DubNtnStrngthNmbrs %>%
    rtweet::ts_plot(., by = "10 minutes") +
    ggthemes::theme_gdocs() +
    ggplot2::theme(plot.title =
                       ggplot2::element_text(face = "bold")) +
    ggplot2::labs(
            x = NULL,
            y = NULL,
            title = "#DubNation & #StrengthInNumbers tweets",
            caption = "\nSource: Counts aggregated using ten-minute intervals;
                        data collected using Twitter's REST API via rtweet")
gg_ts_plot
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-gg_ts_plot.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-gg_ts_plot.png", width = 6.5,height = 4, units = "in")
```

This graph shows an increase in tweets for these hashtags between `June 09, 09:21:44 UTC` to `June 12, 19:39:51 UTC`.

## Get longitude and lattitude for tweets in `DubTweets`

I can also add some geographic information to the twitter data (i.e. the latitude and longitude for each tweet) using the `rtweet::lat_lng()` function.

This function adds a `lat` and `lng` variable to the `DubNtnStrngthNmbrs` data frame.

*I verify this with `names()` and `tail()`*.

``` r
# get lattitude and longitude
DubNtnStrngthNmbrsLoc <- rtweet::lat_lng(DubNtnStrngthNmbrs)
DubNtnStrngthNmbrs %>% names() %>% tail(2)
```

```
[1] "profile_image_url" "query"
```

``` r
DubNtnStrngthNmbrsLoc %>% names() %>% tail(2)
```

    [1] "lat" "lng"

I will check how many of the tweets have latitude and longitude information using `dplyr::distinct()` and `base::nrow()`.

``` r
DubNtnStrngthNmbrsLoc %>% dplyr::distinct(lng) %>% base::nrow()
```

    [1] 164

``` r
DubNtnStrngthNmbrsLoc %>% dplyr::distinct(lat) %>% base::nrow()
```

    [1] 164

Not every tweet has geographic information associated with it, so we will not be graphing all 60,000+ observations. I’ll rename `lng` to `long` so it will be easier to join to the state-level data.

``` r
DubNtnStrngthNmbrsLoc <- DubNtnStrngthNmbrsLoc %>% dplyr::rename(long = lng)
```

## Create World Map of \#DubNation/\#StrengthInNumbers

I will use the `ggplot2::map_data()` function to get the `"world"` data I’ll build a map with (save this as `World`).

``` r
library(maps)
library(mapdata)
World <- ggplot2::map_data("world")
World %>% glimpse(78)
```

    Observations: 99,338
    Variables: 6
    $ long      <dbl> -69.90, -69.90, -69.94, -70.00, -70.07, -70.05, -70.04,...
    $ lat       <dbl> 12.45, 12.42, 12.44, 12.50, 12.55, 12.60, 12.61, 12.57,...
    $ group     <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2...
    $ order     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, ...
    $ region    <chr> "Aruba", "Aruba", "Aruba", "Aruba", "Aruba", "Aruba", "...
    $ subregion <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...

The `ggplot2::geom_polygon()` function will create a map with the `World` data. The variables that build the map are `long` and `lat` (you can see why I renamed the `lng` variable to `long` in `DubNtnStrngthNmbrsLoc`). I added the Warrior team colors with `fill` and `color`.

``` r
ggWorldMap <- ggplot2::ggplot() +
    ggplot2::geom_polygon(data = World,
                            aes(x = long,
                                y = lat,
                                group = group),
                                fill = "royalblue",
                                color = "gainsboro",
                                alpha = 0.5)
ggWorldMap +
     ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
     ggplot2::labs(title = "Basic World Map (geom_polygon)")
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-ggWorldMap.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-ggWorldMap.png", width = 6.5,height = 4, units = "in")
```

## Add the tweet data to the map

Now that I have a basic projection of the world, I can layer the twitter data onto the map with `ggplot2::geom_point()` by specifying the `long` and `lat` to `x` and `y`. The `data` argument also needs to be specified because we will be introducing a second data set (and will not be using the `World` data).

This is what’s referred to as the `mercator` projection. It is the default setting in `coord_quickmap()`. I also add the `ggthemes::theme_map()` for a cleaner print of the map (without ticks and axes)

``` r
gg_Merc_title <- "  Worldwide (Mercator) #DubNation and #StrengthInNumbers tweets"
gg_Merc_cap <- "tweets collected with rtweet; \nhashtags #DubNation and #StrengthInNumbers"
gg_mercator_dubstrngth <- ggWorldMap +
    ggplot2::coord_quickmap() +
        ggplot2::geom_point(data = DubNtnStrngthNmbrsLoc,
                        aes(x = long, y = lat),
                        size = 0.9, # reduce size of points
                        fill = "gainsboro",
                        color = "orangered1") +
    # add titles/labels
     ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
        ggplot2::labs(title = gg_Merc_title,
        caption = gg_Merc_cap) +
        ggthemes::theme_map()
gg_mercator_dubstrngth
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-gg_mercator_dubstrngth.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-gg_mercator_dubstrngth.png", width = 6.5,height = 4, units = "in")
```

The Mercator projection works well for navigation because the meridians are equally spaced (the grid lines that runs north and south), but the parallels (the lines that run east/west around) are not equally spaced. This causes a distortion in the land masses at both poles. The map above makes it look like Greenland is roughly 1/2 or 2/3 the size of Africa, when in reality Africa is 14x larger.

## Mapping with the Winkel tripel projection

An alternative to the Mercator projection is the [Winkel tripel](https://en.wikipedia.org/wiki/Winkel_tripel_projection) projection. This map attempts to correct the distortions in the Mercator map.

This map gets added via the `ggalt::coord_proj()` function, which takes a projection argument from the `proj4` [package.](https://cran.r-project.org/web/packages/proj4/index.html) I add the Winkel tripel layer with `ggplot2::coord_proj("+proj=wintri")` below.


``` r
# convert query to factor (you'll see why later)
DubNtnStrngthNmbrsLoc$query <- factor(DubNtnStrngthNmbrsLoc$query,
                          labels = c("#DubNation", "#StrengthInNumbers"))
# define titles
ggDubWT_title <- "Worldwide (Winkel tripel) #DubNation &\n#StrengthInNumbers tweets"
ggDubWT_cap <- "tweets collected with rtweet package; \nhashtags #DubNation and #StrengthInNumbers  "

#  create world map
ggWorld2 <- ggplot2::ggplot() +
    ggplot2::geom_map(data = World, map = World,
                    aes(x = long,
                        y = lat,
                        map_id = region),
                    size = 0.009,
                    fill = "royalblue",
                    alpha = 0.6)
        #  add the twiiter data layer
ggDubWinkelTrip <- ggWorld2 +
    ggplot2::geom_point(data = DubNtnStrngthNmbrsLoc,
            aes(x = long,
                y = lat),
                    color = "orangered1",
                    size = 0.9) +
        # add Winkel tripel layer
        ggalt::coord_proj("+proj=wintri") +
            ggplot2::theme(plot.title = ggplot2::element_text(
                                                face = "bold")) +
            ggplot2::labs(
            title = ggDubWT_title,
            caption = ggDubWT_cap)
ggDubWinkelTrip
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-ggDubWinkelTrip.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-ggDubWinkelTrip.png", width = 6.5,height = 4, units = "in")
```

This map is an ok start, but I want to add some additional customization:

  - I’ll start by adjusting the x axis manually with `ggplot2::scale_x_continuous()` (this gives a full ‘globe’ on the
    map),
  - I add the FiveThiryEight theme from `ggthemes::theme_fivethirtyeight()`,
  - Remove the `x` and `y` axis labels with two `ggplot2::theme()` statements,
  - Finally, facet these maps by the query type (`#DubNation` or `#StrengthInNumbers`)



``` r
ggDubWinkelTripFacet <- ggDubWinkelTrip +
    ggplot2::scale_x_continuous(limits = c(-200, 200)) +
     ggthemes::theme_fivethirtyeight() +
    ggplot2::theme(
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
    ggplot2::theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
    ggplot2::labs(title = ggDubWT_title,
        caption = ggDubWT_cap) +
    facet_wrap( ~ query)
ggDubWinkelTripFacet
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-ggDubWinkelTripFacet.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-ggDubWinkelTripFacet.png", width = 6.5,height = 4, units = "in")
```

To learn more about maps check out [this document](https://pubs.usgs.gov/pp/1453/report.pdf) put out by the U.S. Geological Survey on map projections. The description provided in the show [West Wing](https://www.youtube.com/watch?v=vVX-PrBRtTY) covers some of the distortions in the Mercator map, and this video from [Vox](https://www.youtube.com/watch?v=kIID5FDi2JQ) does a great job illustrating the difficulties in rendering a sphere or globe on a 2-d surface.

## Animate the timeline of tweets with `gganiamte`

`rtweet` can collect twitter data over a period of 7-10 days, but the data I have in `DubNtnStrngthNmbrsLoc` only ranges from `"2018-06-09 07:40:22 UTC"` until `"2018-06-10 02:36:31 UTC"`.

I want to see the spread of the `#DubNation` and `#StrengthInNumbers` tweets across the globe, but I want to use the point `size` in this this animated map to indicate the number of followers associated with each tweet. `gganimate` is the ideal package for this because it works well with `ggplot2`.

I can start by looking at the number of followers each twitter account had (`followers_count`) and the observations with location information (`long` and `lat`).

``` r
DubNtnStrngthNmbrsLoc %>%
    # identify observations with complete location information
        dplyr::filter(!is.na(long) |
                  !is.na(lat)) %>%
    # get the sorted count
    dplyr::select(followers_count, screen_name) %>%
    # arrange these descending
    dplyr::arrange(desc(followers_count))
```

    # A tibble: 605 x 2
       followers_count screen_name
                 <int> <chr>
     1        27854760 NBA
     2        27854705 NBA
     3          992680 united
     4          992679 united
     5          424626 realfredrosser
     6          424626 realfredrosser
     7          234350 mercnews
     8          234349 mercnews
     9          143512 LetsGoWarriors
    10          143510 LetsGoWarriors
    # ... with 595 more rows

This looks like there are a few `screen_name`s with \> 100,000 followers. I can get a quick view of the distribution of this variable with `qplot()`

``` r
gg_freqploy_title <- "Frequency of followers_count for #DubNation &\n#StrengthInNumbers tweets"
DubNtnStrngthNmbrsLoc %>%
        # identify observations with complete location information
        dplyr::filter(!is.na(long) |
                  !is.na(lat)) %>%
        ggplot2::qplot(x = followers_count,
                       data = .,
                       geom = "freqpoly") +
            ggplot2::theme(plot.title = ggplot2::element_text(
                                                face = "bold", size = 14)) +
            ggplot2::labs(
            title = gg_freqploy_title,
            caption = ggDubWT_cap)
```



![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-gg_freqpolyv1.1.png)<!-- -->

``` r
ggplot2::ggsave(filename = "Images/2.5-gg_freqpolyv1.1.png", width = 6.5,height = 4, units = "in")
```


This long tail tells me that these outliers are skewing the distribution. I want to see what the distribution looks like without these extremely high counts of retweets

``` r
DubNtnStrngthNmbrsLoc %>%
    # remove observations without location information
    dplyr::filter(!is.na(long) |
                  !is.na(lat)) %>%
    # arrange data
    dplyr::arrange(desc(followers_count)) %>%
    # remove the follower_count that are above 100000
    dplyr::filter(followers_count < 100000) %>%
        ggplot2::qplot(followers_count,
                       data = .,
                       geom = "freqpoly") +
            ggplot2::theme(plot.title = ggplot2::element_text(
                                                face = "bold", size = 12)) +
            ggplot2::labs(
            title = gg_freqploy_title,
            caption = ggDubWT_cap)
```



![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-gg_freqpolyv1.2.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-gg_freqpolyv1.2.png", width = 6.5,height = 4, units = "in")
```

    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

This still looks skewed, but now we can see more of a distribution of followers. The majority of the observations fall under 10 followers, with few reaching above 20, so I will remove the observations with more than 100 followers.

``` r
DubAnimateData <- DubNtnStrngthNmbrsLoc %>%
    # remove observations without location information
    dplyr::filter(!is.na(long) |
                  !is.na(lat)) %>%
    # arrange data descending
    dplyr::arrange(desc(retweet_count)) %>%
    # remove the follower_count that are above 100000
    dplyr::filter(retweet_count < 100000) %>%
    # select only the variables we will be visualizing
    dplyr::select(user_id,
                  status_id,
                  screen_name,
                  followers_count,
                  retweet_count,
                  created_at,
                  text,
                  long,
                  hashtags,
                  lat)
DubAnimateData %>% glimpse(78)
```

    Observations: 605
    Variables: 10
    $ user_id         <chr> "19923144", "19923144", "63814087", "821198788559...
    $ status_id       <chr> "1006550485501792258", "1006550485501792258", "10...
    $ screen_name     <chr> "NBA", "NBA", "liliankim7", "stephenzinho", "Lets...
    $ followers_count <int> 27854760, 27854705, 4372, 1388, 143510, 143512, 4...
    $ retweet_count   <int> 999, 981, 51, 35, 30, 30, 17, 17, 11, 11, 10, 10,...
    $ created_at      <dttm> 2018-06-12 14:55:11, 2018-06-12 14:55:11, 2018-0...
    $ text            <chr> "Happy Parade Day! #DubNation https://t.co/3qpgbR...
    $ long            <dbl> -122.23, -122.23, -122.23, -43.30, -122.44, -122....
    $ hashtags        <list> ["DubNation", "DubNation", <"WarriorsParade", "D...
    $ lat             <dbl> 37.79, 37.79, 37.79, -22.64, 37.62, 37.62, 34.09,...

Great\! Now I will create another static Winkel tripel map before animating it get an idea for what it will look like. I start with the `ggWorld2` base from above, then layer in the twitter data, this time specifying `size = followers_count` and `ggplot2::scale_size_continuous()`. The `range` is the number of different points, and the `breaks` are the cut-offs for each size.

I also remove the `x` and `y` axis labels, and add the `ggthemes::theme_hc()` for a crisp looking finish.

``` r
ggWorld2 +
  geom_point(aes(x = long,
                 y = lat,
                 size = followers_count),
             data = DubAnimateData,
             color = "magenta2", alpha = 0.4) +
  ggplot2::scale_size_continuous(range = c(1, 6),
                                breaks = c(1, 10, 20,
                                           30, 40, 50)) +
  labs(size = "Retweets") +
    ggalt::coord_proj("+proj=wintri") +
    ggthemes::theme_hc() +
    ggplot2::theme(
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
    ggplot2::theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
    ggplot2::theme(plot.title = ggplot2::element_text(
                                face = "bold", size = 12)) +
    ggplot2::labs(title = "#DubNation & #StrengthInNumbers",
                  subtitle = "tweets and followers")
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/2.5-gg_themehc_v1.0.png)

``` r
ggplot2::ggsave(filename = "Images/2.5-gg_themehc_v1.0.png", width = 6.5, height = 4, units = "in")
```

I learned a helpful tip from Daniela Vasquez over at [d4tagirl](https://d4tagirl.com/2017/05/how-to-plot-animated-maps-with-gganimate) to build two data frames to use for displaying the animation before and after the points start appearing. These are best built using dates just outside the range of the `created_at` field.

``` r
library(tibble)
library(lubridate)
# min(DubAnimateData$created_at) # "2018-06-09 09:22:21 UTC"
# max(DubAnimateData$created_at) # "2018-06-12 19:37:27 UTC"
# create data frame foe the beginning of the animation
EmptyAnimateDataBegin <- tibble(
        created_at = as_datetime("2018-06-09 09:21:21 UTC"),
        followers_count = 0,
        long = 0,
        lat = 0)
EmptyAnimateDataBegin
```

    # A tibble: 1 x 4
      created_at          followers_count  long   lat
      <dttm>                        <dbl> <dbl> <dbl>
    1 2018-06-09 09:21:21               0     0     0

``` r
# create data frame for the end of the animation
EmptyAnimateDataEnd <- tibble(
  created_at = seq(as_datetime("2018-06-12 19:50:00 UTC"),
                   as_datetime("2018-06-12 21:00:00 UTC"),
                   by = "min"),
                followers_count = 0,
                long = 0,
                lat = 0)
EmptyAnimateDataEnd
```

    # A tibble: 71 x 4
       created_at          followers_count  long   lat
       <dttm>                        <dbl> <dbl> <dbl>
     1 2018-06-12 19:50:00               0     0     0
     2 2018-06-12 19:51:00               0     0     0
     3 2018-06-12 19:52:00               0     0     0
     4 2018-06-12 19:53:00               0     0     0
     5 2018-06-12 19:54:00               0     0     0
     6 2018-06-12 19:55:00               0     0     0
     7 2018-06-12 19:56:00               0     0     0
     8 2018-06-12 19:57:00               0     0     0
     9 2018-06-12 19:58:00               0     0     0
    10 2018-06-12 19:59:00               0     0     0
    # ... with 61 more rows

Now I can use these two data frames to add additional layers to the animation. `gganimate` takes a `frame` argument, which is the value we want the `followers_count` to change over time (`created_at`).

The `cumulative = TRUE` tells R to leave the point on the map after its been plotted.

``` r
DubMap <- ggWorld2 +
  geom_point(aes(x = long,
                 y = lat,
                 size = followers_count,
                 frame = created_at,
                 cumulative = TRUE),
             data = DubAnimateData,
             color = "magenta2",
             alpha = 0.3) +
    # transparent frame 1
  geom_point(aes(x = long,
                y = lat,
                size = followers_count,
                frame = created_at,
                cumulative = TRUE),
                        data = EmptyAnimateDataBegin,
                        alpha = 0) +
    # transparent frame 2
  geom_point(aes(x = long,
                y = lat,
                size = followers_count,
                frame = created_at,
                cumulative = TRUE),
                        data = EmptyAnimateDataEnd,
                        alpha = 0) +
  ggplot2::scale_size_continuous(range = c(1, 6),
                                breaks = c(1, 10, 20,
                                           30, 40, 50)) +
  labs(size = 'Retweets') +
    ggalt::coord_proj("+proj=wintri") +
    ggthemes::theme_hc() +
    ggplot2::theme(
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
    ggplot2::theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
    ggplot2::labs(title = "#DubNation & #StrengthInNumbers",
                  subtitle = "tweets and followers")
library(gganimate)
gganimate(DubMap, interval = .2, "DubMapv2.0.gif")
```

![](https://raw.githubusercontent.com/mjfrigaard/dubnation_twitter_data/master/Images/DubMapv2.0.gif)

Now I have an animation that displays the tweets as they appeared in the two days following the NBA finals.

## Export the data

`rtweet` has a handy export function for these twitter data frames as .csv files.

``` r
# ls()
processed_data_file_path <- "Data/processed_data/"
# DubAnimateData
DubAnimateData_outfile <- paste0(processed_data_file_path, "DubAnimateData",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = DubAnimateData,
                 file_name = DubAnimateData_outfile)

# DubNtnStrngthNmbrs
DubNtnStrngthNmbrs_outfile <- paste0(processed_data_file_path, "DubNtnStrngthNmbrs",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = DubNtnStrngthNmbrs,
                 file_name = DubNtnStrngthNmbrs_outfile)

# DubNtnStrngthNmbrsLoc
DubNtnStrngthNmbrsLoc_outfile <- paste0(processed_data_file_path, "DubNtnStrngthNmbrsLoc",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = DubNtnStrngthNmbrsLoc,
                 file_name = DubNtnStrngthNmbrsLoc_outfile)

# UsersDubNtnStrngthNmbrs
UsersDubNtnStrngthNmbrs_outfile <- paste0(processed_data_file_path, "UsersDubNtnStrngthNmbrs",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = UsersDubNtnStrngthNmbrs,
                 file_name = UsersDubNtnStrngthNmbrs_outfile)

# TweetsDubNtnStrngthNmbrs
TweetsDubNtnStrngthNmbrs_outfile <- paste0(processed_data_file_path, "TweetsDubNtnStrngthNmbrs",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = TweetsDubNtnStrngthNmbrs,
                 file_name = TweetsDubNtnStrngthNmbrs_outfile)
# WarriorsParadeStream
WarriorsParadeStream_outfile <- paste0(processed_data_file_path, "WarriorsParadeStream",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = WarriorsParadeStream,
                 file_name = WarriorsParadeStream_outfile)
# WarriorsStream
WarriorsStream_outfile <- paste0(processed_data_file_path, "WarriorsStream",
                                                timeStamper(), ".csv")
# export
rtweet::write_as_csv(x = WarriorsStream,
                 file_name = WarriorsStream_outfile)
```

To learn more check out these awesome resources:

1.  [Computing for the Social Sciences](https://goo.gl/m7wA6r)
2.  [Making Maps with R](https://goo.gl/h4EszF)
3.  [socviz - chapter 7 - Draw maps](https://goo.gl/ibYJuJ)
4.  [gganimate package](https://github.com/dgrtwo/gganimate)
5.  [twitter api object
    definitions](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/intro-to-tweet-json)
