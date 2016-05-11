
# Input from the files they can be anything like docs from the web or any thing you want to read
in1 <- readLines("in1.txt")
in2 <- readLines("in2.txt")
in3 <- readLines("in3.txt")
in4 <- readLines("in4.txt")
in5 <- readLines("in5.txt")
in6 <- readLines("in6.txt")
in7 <- readLines("in7.txt")
in1
# We assume it to be a data that we will use as our corpus from which data needs to queried
input_list <- list(in1, in2, in3, in4, in5, in6, in7)
input_num <- length(input_list)
input_num
names(input_list) <- paste0("in", c(1:input_num))

names(input_list)
# we assume that we have recieved a query like 
query <- "Human Mind"

# including required libraries
library(SnowballC)
library(tm)


inputs <- VectorSource(c(input_list, query))
inputs$Names <- c(names(input_list), "query")
inputs$Names
my_corpus <- Corpus(inputs)
my_corpus

# getTransformations()


my_corpus <- tm_map(my_corpus, content_transformer(removePunctuation))
my_corpus$doc1

my_corpus <- tm_map(my_corpus, content_transformer(stemDocument))
my_corpus$doc1
my_corpus <- tm_map(my_corpus, content_transformer(removeNumbers))
my_corpus <- tm_map(my_corpus, content_transformer(tolower))
my_corpus <- tm_map(my_corpus, content_transformer(stripWhitespace))
my_corpus$doc1


term_doc_matrix_stm <- TermDocumentMatrix(my_corpus)
inspect(term_doc_matrix_stm[0:14, ])


term_doc_matrix <- as.matrix(term_doc_matrix_stm)



# Defining the function to compute weights 
get_tf_idf_weights <- function(tf_vec, df) {
  # Computes tfidf weights from a term frequency vector and a document
  # frequency scalar
  weight = rep(0, length(tf_vec))
  weight[tf_vec > 0] = (1 + log2(tf_vec[tf_vec > 0])) * log2(input_num/df)
  weight
}

cat("A word appearing in 4 of 6 documents, occuring 1, 2, 3, and 6 times, respectively: \n", 
    get_tf_idf_weights(c(1, 2, 3, 0, 0, 6), 4))



get_weights_per_term_vec <- function(tfidf_row) {
  term_df <- sum(tfidf_row[1:input_num] > 0)
  tf_idf_vec <- get_tf_idf_weights(tfidf_row, term_df)
  return(tf_idf_vec)
}

tfidf_matrix <- t(apply(term_doc_matrix, c(1), FUN = get_weights_per_term_vec))
colnames(tfidf_matrix) <- colnames(term_doc_matrix)

tfidf_matrix[0:3, ]



#angle <- seq(-pi, pi, by = pi/16)
#plot(cos(angle) ~ angle, type = "b", xlab = "angle in radians", main = "Cosine similarity by angle")



tfidf_matrix <- scale(tfidf_matrix, center = FALSE, scale = sqrt(colSums(tfidf_matrix^2)))
tfidf_matrix[0:3, ]


query_vector <- tfidf_matrix[, (input_num + 1)]
tfidf_matrix <- tfidf_matrix[, 1:input_num]



doc_scores <- t(query_vector) %*% tfidf_matrix
length(doc_scores)
names(input_list)
unlist(input_list)
results_df <- data.frame(doc = names(input_list), score = t(doc_scores))
results_df <- results_df[order(results_df$score, decreasing = TRUE), ]



options(width = 2000)
print(results_df, row.names = FALSE, right = FALSE, digits = 2)


