# Code to test KwicRTopics Widget

library("htmlwidgets")

# navigate to package dir
setwd("kwictopics")       

survey_responses_raw<-read.csv("/Users/aneesha/user2018/surveyresponses.csv", stringsAsFactors = FALSE)
# Perform Character Encoding
survey_responses$documents <- iconv(survey_responses_raw$documents, "latin1", "ASCII", sub="")
# Vectorize the documents
survey_responses <- Corpus(VectorSource(as.vector(survey_responses$documents))) 
# Text Preprocessing
# Convert to lowercase
survey_responses <- tm_map(survey_responses, tolower)
# remove punctuation
survey_responses <- tm_map(survey_responses, removePunctuation)
#remove numbers
survey_responses <- tm_map(survey_responses, removeNumbers);
# remove generic and custom stopwords
stopword <- c(stopwords('english'), "best");
survey_responses <- tm_map(survey_responses, removeWords, stopword)
survey_responses <- tm_map(survey_responses, stemDocument)

survey_Dtm <- DocumentTermMatrix(survey_responses, control = list(minWordLength = 2));
survey_Dtm2 <- removeSparseTerms(survey_Dtm, sparse=0.98)

k = 12;
SEED = 1234;

no_top_words = 6
no_top_documents = 6

survey.lda <- LDA(survey_Dtm2, k, method="Gibbs", control=list(seed = SEED))

devtools::install()                                      
library(kwictopics)

kwictopicsWidget(survey.lda, k, survey_responses_raw$documents)

