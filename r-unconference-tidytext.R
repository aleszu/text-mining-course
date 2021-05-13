############################################
# Introducing tidytext
############################################

library(tidyverse)
library(tidytext)

# Text and tokenization
line <- c("The quick brown fox jumps over the lazy dog.") 
line 

line_tbl <- as_tibble(line) # get into Tidy format
line_tbl

line_tokenized <- line_tbl %>%
  unnest_tokens(word, value)  # tokenize!
line_tokenized

line_tokenized %>% count(word) # count
line_tokenized %>% count(word, sort=TRUE) # count and sort

line_clean <- line_tokenized %>% 
  anti_join(stop_words) # cut out stopwords 
line_clean 

glimpse(stop_words) # let's inspect stopwords. 

#  Are all of these stop words really worth cutting out? 
# Can you find one that you might want to include in your analysis?


############################################
# Introducing tokens and n-gram analysis
############################################

trump_speech <- read_file("https://raw.githubusercontent.com/aleszu/text-mining-course/master/trump2018.txt") # alternatively, use read_file(file.choose())
trump_speech

trump_speech_tbl <- as_tibble(trump_speech) # tidy the data
trump_speech_tbl

trump_counts <- trump_speech_tbl %>%
  unnest_tokens(word, value) # tokenize
trump_counts # 5,864 words

# Count unigrams
trump_counts <- trump_speech_tbl %>% 
  unnest_tokens(word, value) %>%
  count(word, sort = TRUE) %>% # count words
  glimpse()

trump_counts <- trump_speech_tbl %>%
  unnest_tokens(word, value) %>%
  anti_join(stop_words) %>% # remove stopwords
  count(word, sort=TRUE) %>%
  glimpse()
head(trump_counts)

# Count bigrams
bigrams <- trump_speech_tbl %>%
  unnest_tokens(bigram, value, token = "ngrams", n = 2) %>%
  count(bigram, sort=TRUE)
head(bigrams, n=20) # too many stopwords!

trump_bigrams <- trump_speech_tbl %>%
  unnest_tokens(bigram, value, token = "ngrams", n = 2) 

bigrams_separated <- trump_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ") # separate bigram by space

bigrams_filtered <- bigrams_separated %>% 
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) # filter out stopwords from word2 column

bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE) # count new bigrams
head(bigram_counts) 


########################################################
# Building visualizations with text data
########################################################

# Inspired by:
# https://buzzfeednews.github.io/2018-01-trump-state-of-the-union/

sou <- read_csv("https://raw.githubusercontent.com/aleszu/text-mining-course/master/sou.csv")
glimpse(sou)

length_of_sous <- sou %>%
  mutate(length = str_length(text)) # calculate length of speech
glimpse(length_of_sous)

# Plot it 
ggplot(length_of_sous, aes(date, length)) +
  geom_point()

# Search for a string with "str_detect"
speeches_w_keyword <- sou %>%
  group_by(text, date, president, message) %>%
  mutate(count = str_count(text, "health care")) # try "people" or "crime" 
speeches_w_keyword

# Plot it
ggplot(speeches_w_keyword, aes(date,count)) +
  geom_line(stat="identity")

# I build a whole Shiny app with this kind of Google n-grams-style functionality:
# https://lazerlab.shinyapps.io/covid-tweets/


############################################
# Lightning intro to sentiment analysis
############################################

# Import sentiment dictionaries
bing <- get_sentiments("bing")
glimpse(bing)

vader <- read.csv("https://raw.githubusercontent.com/aleszu/text-mining-course/master/vader_scores.csv")
glimpse(vader)

# Run bag of words scoring 
alexander <- c("Alexander and the terrible, horrible, no good, very bad day")
alexander <- as.tibble(alexander) 

alexander_scored <- alexander %>%
  unnest_tokens(word, value) %>%
  inner_join(vader, by="word") %>% 
  glimpse()

mean(alexander_scored$score)

# Run it on a speech 
sentiment_sou <- sou %>%
unnest_tokens(word, text) %>%
  inner_join(vader, by = "word") 
glimpse(sentiment_sou)

sentiment_by_president <- sentiment_sou %>%
  group_by(president) %>% 
  summarise(avgscore = mean(score)) %>%
  arrange(desc(avgscore)) %>%
  glimpse()

ggplot(sentiment_by_president, aes(reorder(president, avgscore), avgscore)) +
  geom_col() +
  coord_flip()

sentiment_sou_vader <- sentiment_sou %>%
  group_by(message, date) %>% # We "group by" speech and date instead of by president
  summarise(avgscore = mean(score)) %>% # Try using na.rm=T if you're having errors with another dataset 
  glimpse()

ggplot(sentiment_sou_vader, aes(date, avgscore)) +
  geom_point() + 
  geom_smooth(method="lm")
# Looks like SOTU's have gotten more negative over time. 



########################################################
# Let's user sentiment analysis on Trump tweets!
########################################################

# https://www.thetrumparchive.com/faq

Trump <- read.csv("https://raw.githubusercontent.com/aleszu/text-mining-course/master/trump_tweets_01-08-2021.csv")
Trump <- Trump %>%
  mutate(created_at = lubridate::ymd_hms(date))
glimpse(Trump)
summary(Trump$created_at) #May 4, 2009 to Jan 8, 2021

Trump_vader <- Trump %>%
  #filter(created_at > as.POSIXct("2020-07-11 20:00:00", tz="UTC")) %>%
  mutate(day = lubridate::floor_date(created_at, "day"),
         hour = lubridate::floor_date(created_at, "hour")) %>% 
  unnest_tokens(word, text) %>%
  inner_join(vader, by="word") %>%
  group_by(day 
           #hour
           ) %>%
  summarise(score = mean(score)) %>%
  ungroup()
glimpse(Trump_vader) 

Trump_vader %>%
  ggplot(aes(x=day, y=score)) + 
  geom_point() +
  geom_smooth() 

# Does Trump tend to mention Democrats in a more negative light?

Trump_vader_Rs <- Trump %>%
  filter(str_detect(text, "Republican")) %>%
  mutate(day = lubridate::floor_date(created_at, "day")) %>% 
  unnest_tokens(word, text) %>%
  inner_join(vader, by="word") %>%
  group_by(day) %>%
  summarise(score = mean(score)) %>%
  ungroup() %>% 
  mutate(mention="Republican")

Trump_vader_Ds <- Trump %>%
  filter(str_detect(text, "Democrat")) %>%
  mutate(day = lubridate::floor_date(created_at, "day")) %>% 
  unnest_tokens(word, text) %>%
  inner_join(vader, by="word") %>%
  group_by(day) %>%
  summarise(score = mean(score)) %>%
  ungroup()%>% 
  mutate(mention="Democrat")

Trump_mentions <- bind_rows(Trump_vader_Ds, Trump_vader_Rs)
glimpse(Trump_mentions)

Trump_mentions %>%
  ggplot(aes(x=day, y=score, color=mention)) + 
  geom_point() +
 # facet_wrap(~mention) +
  scale_color_manual(values=c("#1375b7", "#c93135")) + 
  geom_smooth() 


############################################
# Using bigrams analysis in the wild
############################################
# Code powering this analysis: 
# https://www.usatoday.com/in-depth/news/2021/02/01/civil-war-during-trumps-pre-riot-speech-parler-talk-grew-darker/4297165001/

all_parler_jan6_clean <- read.csv("all_parler_jan6_clean.csv")

parler_jan6_hr1 <- all_parler_jan6_clean %>%
  mutate(date = lubridate::ymd_hms(createdAtformatted), # fix date
        foo = as.numeric(format(date, "%H%M%S"))) %>% 
  filter(between(foo, 111500, 121500)) %>% 
  select(-foo) %>%
  unnest_tokens(bigram, body, token = "ngrams", n = 2)  %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>% # separate bigram by space
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) %>% # filter out stopwords from word2 column
  count(word1, word2, sort = TRUE) %>% # count new bigrams
  summarise(word1, word2, n, total = sum(n), hr1_prop = n/total) %>%
  mutate(type = "hr1", bigram = paste0(word1, " ", word2))%>%
  na.omit()

parler_jan6_hr2 <- all_parler_jan6_clean %>%
  mutate(date = lubridate::ymd_hms(createdAtformatted), # fix date
         foo = as.numeric(format(date, "%H%M%S"))) %>% 
  filter(between(foo, 121500, 131500)) %>% 
  select(-foo) %>%
  unnest_tokens(bigram, body, token = "ngrams", n = 2)  %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>% # separate bigram by space
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) %>% # filter out stopwords from word2 column
  count(word1, word2, sort = TRUE) %>% # count new bigrams
  summarise(word1, word2, n, total = sum(n), hr2_prop = n/total) %>%
  mutate(type = "hr2", bigram = paste0(word1, " ", word2))%>%
  na.omit()

parler_jan6_biggest_bigram_jumps <- parler_jan6_hr1 %>%
  left_join(parler_jan6_hr2, by="bigram") 
glimpse(parler_jan6_biggest_bigram_jumps)

parler_jan6_biggest_bigram_jumps <- parler_jan6_biggest_bigram_jumps %>%
  group_by(bigram, n.x, total.x, n.y, total.y, 
           hr1_prop, hr2_prop) %>%
  summarise(change_hr1_hr2 = hr2_prop-hr1_prop) %>%
  arrange(desc(change_hr1_hr2)) %>%
  na.omit() %>%
  ungroup()

glimpse(parler_jan6_biggest_bigram_jumps)


###################################
# Handy export to Google Sheets
###################################

library(googlesheets4)

ss <- gs4_create(
  "Parler_jan6_biggest_bigram_jumps",  # Name the sheet
  sheets = parler_jan6_biggest_bigram_jumps # Select object to export
)

# See Google Sheet here: 
# https://docs.google.com/spreadsheets/d/1_WRPZaGP9BRIipSCRKv9mJPIBn6vg_gK6ais-w46-iI/edit?usp=sharing

