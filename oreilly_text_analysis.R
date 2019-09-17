# Text Mining and Sentiment Analysis in R
# Aleszu Bajak
# O'Reilly Training, Fall 2019


# Text analysis methods

### R packages and datasets

#install.packages("tidytext")
#install.packages("tidyverse")

### Tokenization

# Load packages
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


### N-gram analysis

trump_speech <- read_file("trump2018.txt") # alternatively, use read_file(file.choose())
trump_speech

trump_speech_tbl <- as_tibble(trump_speech) # tidy the data
trump_speech_tbl

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
head(trump_counts, n=15)


# Bigrams
bigrams <- trump_speech_tbl %>%
  unnest_tokens(bigram, value, token = "ngrams", n = 2) %>%
  count(bigram, sort=TRUE)
head(bigrams, n=20) # too many stopwords!

# Better bigrams
trump_bigrams <- trump_speech_tbl %>%
  unnest_tokens(bigram, value, token = "ngrams", n = 2) 

bigrams_separated <- trump_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ") # separate bigram by space

bigrams_filtered <- bigrams_separated %>% 
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) # filter out stopwords from word2 column

bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE) # count new bigrams

bigram_counts 

# Trigrams
trump_trigrams <- trump_speech_tbl %>%
  unnest_tokens(trigram, value, token = "ngrams", n = 3) 

trigrams_separated <- trump_trigrams %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") # separate bigram by space

trigrams_filtered <- trigrams_separated %>% 
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) %>% # filter out stopwords from word2 column
  filter(!word3 %in% stop_words$word) # filter out stopwords from word3 column

trigram_counts <- trigrams_filtered %>% 
  count(word1, word2, word3, sort = TRUE) # count new bigrams

trigram_counts 




# Stringr package

# Calculate length of strings with "str_length"
line <- c("The quick brown fox jumps over the lazy dog.") 
line 

#install.packages("stringr")
library(stringr)
str_length(line) 

sou <- read_csv("sou.csv")
glimpse(sou)

length_of_sous <- sou %>%
  mutate(length = str_length(text))

glimpse(length_of_sous)

# Plot it 
ggplot(length_of_sous, aes(date, length)) +
  geom_point()

# Search for a string with "str_detect"
speeches_w_keyword <- sou %>%
  mutate(count = str_count(text, "health care")) # try "people" or "crime" 
speeches_w_keyword

# Plot it
ggplot(speeches_w_keyword, aes(date,count)) +
  geom_line(stat="identity")


### Parts-of-speech analysis

Trump <- read_csv("Trump_tweets.csv")
glimpse(Trump)

Trump_tokenized_pos <- Trump %>%
  unnest_tokens(word, text) %>% # tokenize the headlines
  anti_join(stop_words) %>%
  inner_join(parts_of_speech) # join parts of speech dictionary

parts_of_speech

glimpse(Trump_tokenized_pos)

Trump_adj <- Trump_tokenized_pos %>%
  group_by(word) %>% 
  filter(pos == "Adjective") %>%  # filter for adjectives
  count(word, sort = TRUE) %>% 
  glimpse()

head(Trump_adj, n=10)

ggplot(head(Trump_adj, n=10), aes(reorder(word, n), n)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  xlab("")+ 
  coord_flip()






# Sentiment analysis methods

# Sentiment analysis dictionaries
afinn <- get_sentiments("afinn")
afinn 

bing <- get_sentiments("bing")
bing

nrc <- get_sentiments("nrc")
nrc

labMT<- read.csv("labMT.csv")
labMT


# Basic sentiment analysis

alexander <- c("Alexander and the terrible, horrible, no good, very bad day")
alexander <- as.tibble(alexander) 

alexander_scored <- alexander %>%
  unnest_tokens(word, value) %>%
  inner_join(afinn, by="word") %>% 
  glimpse()

mean(alexander_scored$score)


# SOTUs

sou <- read_csv("sou.csv")
glimpse(sou)

sentiment_sou <- sou %>%
  unnest_tokens(word, text) %>%
  inner_join(afinn, by = "word") # we'll join in the AFINN dictionary
glimpse(sentiment_sou)

sentiment_by_president <- sentiment_sou %>%
  group_by(president) %>% 
  summarise(avgscore = mean(score)) %>%
  arrange(desc(avgscore))

ggplot(sentiment_by_president, aes(reorder(president, avgscore), avgscore)) +
  geom_col() +
  coord_flip()

sentiment_sou_afinn <- sentiment_sou %>%
  group_by(message, date) %>% # We "group by" message and date instead of by president
  summarise(avgscore = mean(score)) %>%
  glimpse()

ggplot(sentiment_sou_afinn, aes(date, avgscore)) +
  geom_point() + 
  geom_smooth(method="lm")

# Try with labMT dictionary

sentiment_sou_labMT <- sou %>%
  unnest_tokens(word, text) %>%
  inner_join(labMT, by = "word")
glimpse(sentiment_sou_labMT)

sentiment_sou_counts_labMT <- sentiment_sou_labMT %>%
  group_by(message, date) %>%
  summarise(avgscore = mean(score)) %>%
  glimpse()

ggplot(sentiment_sou_counts_labMT, aes(date, avgscore)) +
  geom_point() +
  geom_smooth(method="lm")

### Bonus: Applying sentiment analysis to social media
### https://www.rollcall.com/news/campaigns/lead-midterms-twitter-republicans-went-high-democrats-went-low

candidate_tweets <- read_csv("alltweets.zip")
glimpse(candidate_tweets)

ggplot(candidate_tweets, aes(date, fill=party)) + 
  geom_histogram(stat = "count") +
  ylim(0, 500) +
  scale_fill_manual(values=c("#404f7c", "forestgreen", "#c63b3b")) +
  theme_minimal() 

tokenized_tweets <- candidate_tweets %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  glimpse()

all_sentiment <- tokenized_tweets %>%  
  inner_join(labMT, by = "word") %>%
  group_by(status_id, name, party, followers_count, percent_of_vote) %>% # group by tweet to get average sentiment of tweet
  summarise(sentiment = mean(score)) %>% # calculate avg score of tweet
  arrange(desc(sentiment)) # sort by avg score
  
final_pivot <- all_sentiment %>% 
  group_by(name, party, followers_count, percent_of_vote) %>% 
  summarise(avgscore = mean(sentiment)) %>% 
  glimpse()

ggplot(final_pivot, aes(y=percent_of_vote, x=avgscore, color=party)) + 
  geom_point(aes(size=followers_count)) + 
  scale_size(name="", range = c(1.5, 8)) +
  geom_smooth(method="lm", se = FALSE) + 
  labs(title = "As they go low... we go lower?",
       subtitle = "Democrats with more negative tweets won more often in 2018",
       caption = "Source: Twitter") +
  scale_color_manual(values=c("#404f7c", "#34a35c", "#34a35c", "#c63b3b")) +
  xlab("Average sentiment of tweets") +
  ylab("Percent of vote in 2018 midterms") +
  theme_minimal()


# Visualization and Communication 

# Exporting CSVs

sou <- read_csv("sou.csv")
write.csv(sou, "state-of-the-union-speeches.csv", row.names=FALSE)

# Tables 
#install.packages("DT")
#install.packages("formattable")

library(DT)
datatable(Trump_adj)

library(formattable)
formattable(Trump_adj,
            align =c("l","c"))

formattable(head(Trump_adj, n=15),
            align =c("l","c"))

formattable(head(Trump_adj, n=10), 
            align =c("l","r"),
            list(
              n = color_bar("lightblue")
            )
)

# Wordclouds

#install.packages("ggwordcloud")
library(ggwordcloud)

sou <- read_csv("sou.csv")
glimpse(sou)

sou_words_by_president <- sou %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, president, sort=TRUE)

glimpse(sou_words_by_president)

Obama_words <- sou_words_by_president %>%
  filter(president == "Barack Obama") %>%
  glimpse()

ggplot(head(Obama_words, n=25), aes(label = word, 
                                           size=n)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 14) +
  theme_minimal()

ggwordcloud(Obama_words$word, Obama_words$n, 
            min.freq = 10, 
            max.words=50)


# Wordtrees

#devtools::install_github("DataStrategist/wordTreeR")
library(wordtreer)

Dylan <- c("How many roads must a man walk down",
           "Before you call him a man?",
           "How many seas must a white dove sail",
           "Before she sleeps in the sand?",
           "How many times must the cannon balls fly",
           "Before they're forever banned?",
           "The answer, my friend, is blowin' in the wind",
           "The answer is blowin' in the wind",
           "How many years can a mountain exist",
           "Before it's washed to the sea?",
           "How many years can some people exist",
           "Before they're allowed to be free?",
           "How many times can a man turn his head",
           "And pretend that he just doesn't see?",
           "The answer, my friend, is blowin' in the wind",
           "The answer is blowin' in the wind",
           "How many times must a man look up",
           "Before he can see the sky?",
           "How many ears must one man have",
           "Before he can hear people cry?",
           "How many deaths will it take till he knows",
           "That too many people have died?",
           "The answer, my friend, is blowin' in the wind",
           "The answer is blowin' in the wind")

wordtree(text=Dylan,
         targetWord = "How",
         direction="suffix",
         Number_words = 20,
         fileName="dylan.html")
browseURL("dylan.html")

# Scatterplots

### A bar chart

sou <- read_csv("sou.csv")

sent_by_president <- sou %>%
  unnest_tokens(word, text) %>%
  inner_join(afinn, by = "word") %>%
  group_by(president) %>% 
  summarise(avgscore = mean(score)) %>%
  arrange(desc(avgscore))

ggplot(sent_by_president, aes(reorder(president, avgscore), avgscore)) +
  geom_col() +
  coord_flip()

### A scatterplot where text replaces points 

Trump <- read_csv("Trump_tweets.csv")

Trump_adj_sent <- Trump %>%
  unnest_tokens(word, text) %>% # tokenize the headlines
  anti_join(stop_words) %>%
  inner_join(parts_of_speech) %>% # join parts of speech dictionary
  group_by(word) %>% 
  filter(pos == "Adjective") %>% 
  count(word, sort = TRUE) %>%
  inner_join(labMT, by="word") %>%  # add in sentiment dictionary
  glimpse()

ggplot(Trump_adj_sent, aes(n, score, color = score>5)) +
  geom_text(aes(label=word), check_overlap = TRUE) +
  theme_minimal() +
  scale_color_manual(values=c("#c63b3b", "#404f7c")) +
  theme(legend.position = "none")

### A scatterplot with regression lines and title, subtitle and caption

ggplot(final_pivot, aes(y=percent_of_vote, x=avgscore, color=party)) + 
  geom_point(aes(size=followers_count)) + 
  scale_size(name="", range = c(1.5, 8)) +
  geom_smooth(method="lm", se = FALSE) + 
  labs(title = "As they go low... we go lower?",
       subtitle = "Democrats with more negative tweets won more often in 2018",
       caption = "Source: Twitter") +
  scale_color_manual(values=c("#404f7c", "#34a35c", "#34a35c", "#c63b3b")) +
  xlab("Average sentiment of tweets") +
  ylab("Percent of vote in 2018 midterms") +
  theme_minimal()


# Finally, please complete a course survey!







reddit <- read_csv("reddit_politics_072017_052019.csv.zip") 
glimpse(reddit)
hist(reddit$date, breaks = 30)

reddit$title <- reddit$headline # duplicate headline column

reddit_tokenized_pos <- reddit %>%
  unnest_tokens(word, headline) %>% # tokenize the headlines
  anti_join(stop_words) %>%
  inner_join(parts_of_speech) %>% # join parts of speech dictionary
  glimpse() 

glimpse(reddit_tokenized_pos)

reddit_nouns <- reddit_tokenized_pos %>%
  filter(pos == "Noun") %>% 
  count(word, sort = TRUE)
reddit_nouns

reddit_verbs <- reddit_tokenized_pos %>%
  filter(str_detect(pos, "Verb")) %>% 
  count(word, sort = TRUE) 
reddit_verbs

glimpse(reddit_tokenized_pos)












reviews <- read_csv("wine-reviews.zip") # https://www.kaggle.com/zynicide/wine-reviews/downloads/wine-reviews.zip/4
glimpse(reviews)

french_reviews <- reviews %>%
  filter(country == "France") %>% # Filter for only wines from "France"
  glimpse()

wine_bigrams <- french_reviews %>%
  unnest_tokens(bigram, description, token = "ngrams", n = 2) 

wine_bigrams_separated <- wine_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ") # separate bigram by space

wine_bigrams_separated_filtered <- wine_bigrams_separated %>% 
  filter(!word1 %in% stop_words$word) %>% # filter out stopwords from word1 column
  filter(!word2 %in% stop_words$word) # filter out stopwords from word2 column

wine_bigram_counts <- wine_bigrams_separated_filtered %>% 
  count(word1, word2, sort = TRUE) # count new bigrams
wine_bigram_counts



reviews <- read_csv("wine-reviews.zip") # https://www.kaggle.com/zynicide/wine-reviews/downloads/wine-reviews.zip/4
glimpse(reviews)

french_reviews <- reviews %>%
  filter(country == "France") %>% # Filter for only wines from "France"
  glimpse()

french_reviews_tokenized <- french_reviews %>%
  select(description, points, price, province, variety, winery) %>% # keep the columns we want
  unnest_tokens(word, description) %>% # tokenize the description column
  anti_join(stop_words) %>% # remove stopwords 
  glimpse() 

french_word_counts <- french_reviews_tokenized %>%
  count(word, sort=TRUE) %>%
  glimpse()



### Cluster analysis

reviews <- read_csv("wine-reviews.zip")
glimpse(reviews)

french_reviews <- reviews %>%
  filter(country == "France") %>% # Filter for only wines from "France"
  glimpse()

french_reviews_tokenized <- french_reviews %>%
  select(description, points, price, province, variety, winery) %>% # keep the columns we want
  unnest_tokens(word, description) %>% # tokenize the description column
  anti_join(stop_words) %>% # remove stopwords 
  glimpse() 

french_words_counted <- french_reviews_tokenized %>%
  count(word, province) # we need to count words as grouped by province 

french_reviews_corr <- french_words_counted %>%  
  group_by(province) %>%
  mutate(Prop = n / sum(n))  %>%
  subset(n >= 5) %>%
  select(-n) %>%
  spread(province, Prop) 

french_reviews_corr

# Prep data, fit model and visualize
french_reviews_corr[is.na(french_reviews_corr)] <- 0 # removes NAs as they'll break the model
french_reviews_corr_t <- t(french_reviews_corr[,-1]) # removes 'word' variable and transposes data
french_reviews_corr_dist <- dist(french_reviews_corr_t, method="euclidean") # builds a distance matrix by computing distance between rows 
fit <- hclust(french_reviews_corr_dist, method="ward.D") # clusters by province  
plot(fit, family="Arial")
rect.hclust(fit, k=5, border="cadetblue")  # fit five clusters 





