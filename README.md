# Text Mining and Sentiment Analysis in R
Aleszu Bajak

# Introduction

This O'Reilly course will introduce participants to the techniques and applications of **text mining and sentiment analysis** by training them in easy-to-use open-source tools and scalable, replicable methodologies that will make them stronger data scientists and more thoughtful communicators. 

Using **RStudio** and several engaging and topical datasets sourced from **politics, social science, and social media**, this course will introduce **techniques for collecting, wrangling, mining and analyzing text data**. 

The course will also have participants derive and communicate insights based on their textual analysis using a set of data visualization methods. The techniques that will be used include n-gram analysis, sentiment analysis, and part-of-speech analysis.

By the end of this live, hands-on, online course, you’ll understand:

- The techniques and applications of textual analysis
- How to convert unstructured text from politics, social science, and social media into data 
- Techniques like **n-gram analysis**, **sentiment analysis**, **hierarchical cluster analysis**, and **parts-of-speech analysis**

And you’ll be able to:

- Ingest various text formats into RStudio
- Wrangle and analyze that text
- Visualize and communicate insights about those textual data


# Requirements and accessing data

Ideally, participants will have the **latest versions of R and RStudio** and the **tidytext** and **tidyverse**. To access all R scripts, participants should next download [this Github repository]() and set it as their working directory in RStudio using setwd(). 

This course can also be accessed on **RStudio Cloud** [here](TKTKTKKT).


# Table of contents

1. [Course outline](#course-outline)
2. [Datasets used](#datasets-used)
2. [Text analysis in the wild](#text-analysis-in-the-wild)
3. [Text analysis methods](#text-analysis-methods)
4. [Sentiment analysis methods](#sentiment-analysis-methods)
5. [Visualization and communication](#visualization-and-communication)


# Course outline

- We'll first explore several real-world applications of data mining and sentiment analysis. 
- Next, we'll walk through several techniques using R. 
- Finally, we'll explore techniques to visualize and communicate insights about those textual data.


# Datasets used

- [Trump's 2018 State of the Union speeches](https://github.com/aleszu/text-mining-course/blob/master/trump2018.txt) 
- [U.S. State of the Union speeches](https://github.com/aleszu/text-mining-course/blob/master/sou.csv)
- [Wine reviews from WineEnthusiast.com](https://github.com/aleszu/text-mining-course/blob/master/wine-reviews.zip)
- [Tweets by U.S. Senate candidates through 2018](https://github.com/aleszu/text-mining-course/blob/master/alltweets.zip)


# Text as data 

Text mining is all about making sense of text. That could mean counting the frequency of specific words, understanding the overall sentiment of a document, or applying statistical techniques to draw big-picture conclusions from a corpus. Whether one is analyzing social media posts, customer reviews or news articles, these techniques can be essential to understanding and deriving meaningful insights. 

Note: Though there are several ways to mine data and perform sentiment analysis in R -- with packages such as [tm](https://cran.r-project.org/web/packages/tm/), [quanteda](https://cran.r-project.org/web/packages/quanteda/), and [sentimentr](https://cran.r-project.org/web/packages/sentimentr/index.html) -- this course uses R's [tidytext](http://tidytextmining.com/) package, developed by Julia Silge and David Robinson, and several tidy tools found in the [tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html) package.


# Text analysis in the wild

BuzzFeed's [analysis of U.S. State of the Union speeches](https://www.buzzfeednews.com/article/peteraldhous/trump-state-of-the-union-words) over time is a great example of text analysis. As an added bonus, journalist Peter Aldhous shared all his data and open-sourced his methodology as an [Rmarkdown document](https://buzzfeednews.github.io/2018-01-trump-state-of-the-union/).   

![img](img/sotu1.png)
![img](img/sotu2.png)

The New York Times' [Mueller Report citations article](https://www.nytimes.com/interactive/2019/04/19/us/politics/mueller-report-citations.html) is another example of a text analysis in mainstream media, used to explain which of and how often Trump's associates appeared in the report. Check out my [Storybench tutorial that includes R code](http://www.storybench.org/how-to-build-a-bubble-chart-of-individuals-mentioned-in-the-mueller-report/) for mining the Mueller Report for specific keywords.  

![img](img/nytimes-Mueller-text-analysis.png)

FiveThirtyEight published an [analysis tallying](https://fivethirtyeight.com/features/which-democrats-are-campaigning-on-trump/) the instances of the name "Trump" in 2020 candidate messaging. The dataset was 2020 candidate emails sent to subscribers. 

![img](img/538-candidates-talk-Trump.png)

The Boston Globe's [Arresting Words investigation](https://apps.bostonglobe.com/graphics/2016/04/arresting-words/) visualized transcripts of police arrests to isolate tops words uttered by those being hauled in. 

![img](img/globe-arresting-all.png)
![img](img/globe-arresting2.png)
![img](img/globe-arresting.png)


## Text analysis in marketing 

Crimson Hexagon, recently acquired by Brandwatch, delivers "actionable social insights for the enterprise," i.e. how is Under Armour clothing or Shock Top beer [being discussed online](https://www.slideshare.net/liberateyourbrand/crimson-hexagon-10-2030)? 

![img](img/crimson-hexagon-underarmour.jpg)
![img](img/crimson-hexagon.png)


## Sentiment analysis in the wild

FiveThirtyEight [applied sentiment analysis](https://fivethirtyeight.com/features/the-happiest-and-saddest-fans-in-baseball-according-to-reddit/) to Reddit comments to assess the overall "sadness" of baseball fans summarized team.. 

![img](img/538-baseball-sad.png)

In Roll Call, I [published a sentiment analysis](https://www.rollcall.com/news/campaigns/lead-midterms-twitter-republicans-went-high-democrats-went-low) of tweets by politicians in the run-up to the 2018 Midterms. We'll get into this data and analysis later in this course.  

![img](img/rollcall1.png)

![img](img/rollcall2.png)

FiveThirtyEight used sentiment analysis to help [contrast presidential inauguration speeches](https://fivethirtyeight.com/live-blog/donald-trump-inauguration/). Does the "More positive words" annotation and x-axis ticks make this graphic easier to understand?

![img](img/538-positive-inauguraladdresses.png)


## Sentiment analysis in finance

Bloomberg routinely analyzes Twitter sentiment surrounding keywords, companies and entities, [such as this 2017 Vodaphone analysis](https://www.bloomberg.com/professional/blog/twitter-trade-profits-vodafone-courts-idea-cellular-india/), to better inform the trading strategies of its clients.

![img](img/bloomberg.png)

J.P. Morgan [has published about sentiment analysis](https://www.jpmorgan.com/global/research/machine-learning) it has applied to analyst reports and news articles to assess the relationship between stock trades and news sentiment.

![img](img/jpmorgan.png)


## Text mining on craft beer data

The community of tidytext users is large and very open to sharing code. Here are some examples of informal text mining and sentiment analyses that have been popoular on the Internet: [craft beer reviews](https://www.kaylinpavlik.com/tidy-text-beer/) and [Harry Potter books](https://cfss.uchicago.edu/notes/harry-potter-exercise/).

![img](img/beeradvocate.png)

![img](img/harrypotter.png)


## Q&A 

**Question:** What real-world text analysis projects stuck out to you as memorable? Why? What was harder to get your head around and why? 


# Text analysis methods

This section will introduce methods for tokenization, n-gram analysis, hierarchical cluster analysis and part-of-speech analysis. We will then conduct a brief text analysis activity to isolate top words, top phrases and top parts of speech for a dataset. 


## Tokenization

First let's do some basic text ingestion and analysis using tidytext functions like unnest_tokens() for tokenizing and count() for, well, counting. 

```{r}
### Text and tokenization
line <- c("The quick brown fox jumps over the lazy dog.") 
line 

line_tbl <- as_tibble(line) # get into Tidy format
line_tbl

line_tokenized <- line_tbl %>%
  unnest_tokens(word, value)  # tokenize!
line_tokenized

line_tokenized %>% count(word) # count
line_tokenized %>% count(word, sort=TRUE) # count and sort
```

Let's also remove the stop words using the anti_join() function, [which is well explained here](https://rpubs.com/williamsurles/293454). As the slide shows, anti_join() removes everything that matches a specified column in a supplied table. We'll use left_join() later in this course. SQL and Python users will know this as a merge function.

![img](img/joins-slide.png)

We can always inspect this or any table in RStudio using View(). 

```{r}
line_clean <- line_tokenized %>% 
  anti_join(stop_words) # cut out stopwords 
line_clean 

View(stop_words) # let's inspect stopwords. 
```

**Question**: Are all of these stopwords really worth cutting out? Can you find one that you want to include in your analysis?


## n-gram analysis

Google's [n-gram viewer](https://books.google.com/ngrams/) is probably the most well-known example of n-gram analysis. We'll use President Donald Trump's 2018 State of the Union speech to explore 1-grams, 2-grams and 3-grams. 

First, we'll ingest the text file, tidy the data and then tokenize the text. 

```{r}
trump_speech <- read_file("trump2018.txt") # alternatively, use read_file(file.choose())
trump_speech

trump_speech_tbl <- as_tibble(trump_speech) # tidy the data
trump_speech_tbl

trump_counts <- trump_speech_tbl %>%
  unnest_tokens(word, value) # tokenize
trump_counts # 5,864 words
```

We'll next use the count() function we previously introduced.  Wow, that's a lot of *and's, the's* and *to's*. Let's remove the stop words and count the words. 

```{r}
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
#write.csv(trump_counts, "trump_counts.csv") # write to csv
```


Ok, moving on to bigrams. Let's use unnest_token()'s "token" and "n" arguments. Then we'll count the bigrams and view them with head(). 

```{r}
# Bigrams
bigrams <- trump_speech_tbl %>%
  unnest_tokens(bigram, value, token = "ngrams", n = 2) %>%
  count(bigram, sort=TRUE)
head(bigrams, n=20) # too many stopwords!
```

This works but it's not terribly insightful because of all the stop words. Let's remove stop words according to the way Julia Silge and David Robinson suggest in [Text Mining with R](https://www.tidytextmining.com/ngrams.html). 

```{r}
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
```

Now we see some interesting bigrams like "MS 13," "North Korea" and "immigration system." Trump's still hammering those 2018 talking points today, isn't he? 

**Question:** How would you export this table as a CSV? Can you write the function in R? 

Finally, let's change the "n" argument to "3" and count the trigrams.

```{r}

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
```

**Question:** How would you summarize these results for a non-technical audience? Could you design a top 10 table with your exported CSV in Excel and embed it alongside your code? What would your headline be for this State of the Union speech in particular?  


# Sentiment analysis methods


# Visualization and communication
