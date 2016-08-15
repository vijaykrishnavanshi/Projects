library(caret)
WDBC_data=read.csv("wdbc.data",head=FALSE,sep = ",")
WPBC_data=read.csv("wpbc.data",head=FALSE,sep = ",")
bcw_data=read.csv("breast-cancer-wisconsin.data",head=FALSE,sep = ",")

bcw_data<-bcw_data[-(which(bcw_data$V7=="?")),]
dim(bcw_data)
inTrain<-createDataPartition(y=bcw_data$V11,p=0.75,list=FALSE)
training<-bcw_data[inTrain,]
testing<-bcw_data[-inTrain,]
dim(training)
dim(testing)
# Summary shows that data is skewedbut when we explore the target variable we see 
# that the class is well balanced. 
summary(training)
# Taking a look at class distribution of target variable 
hist(bcw_data$V11,main = "Class Distribution" , xlab = "Target Variable" )
# Here
# 2 -> Benign Tumor
# 4 -> Malignant Tumor
# Techniques that are available for Classification 
# 1.Quadratic Discrimnant Analysis
# 2.Linear Discriminant Analysis
# 3.K - Nearest Neighbour - 1
# 4.K - Nearest Neighbour - 3
# 5.Losgistic Regression 
# Logistic Regression and KNN was tried as they do not assume the gaussian 
# distribution of the data. Variables being skewed this condition was not staisfied 
modelFit1=train(x=training[,2:10],y=as.factor(training[,11]),method = "glm")
summary(modelFit1)
set.seed(1)
library(class)
knn.pred=knn(training[,2:10],testing[,2:10],training[,11],k=1)
knn.pred=knn(training[,2:10],testing[,2:10],training[,11],k=3)
# knn 1 was selected as the classifier war erring more on the False Positive 
# side that the False Negative Side 










# Clustering Part 
# techniques available
# 1. Principle Component Analysis
# 2. K - Means Algorithm
#    - Hartigan-Wong
#    - Lloyd
#    - Forgy
#    - MacQueen
#
# Not used PCA as the number of feature was much less than the number of data points
# and k - means can better handle skewed data
# Data points were spanning over small range of values so Variability was also not an 
# issue
kmeans(bcw_data[,2:10],2,iter.max = 100)
cluster_fit=kmeans(bcw_data[,2:10],2,iter.max = 100)
cluster_fit$cluster
hist(cluster_fit$cluster)
res=cluster_fit$cluster
table(ifelse(res==1,2,4),bcw_data[,11])

#Error Metric
# accurarcy = 96.04


# Regression 
summary(WPBC_data)

inTrain1<-createDataPartition(y=WPBC_data$V3,p=0.75,list=FALSE)
training<-WPBC_data[inTrain,]
testing<-WPBC_data[-inTrain,]
dat <- training[,2:34]

lmFit1 <- train(V3~., dat, method = "lm", preProcess=c("pca"), 
                 trControl = trainControl(method = "cv"))
lmFit1.pred<-predict(lmFit1,testing[2:34])
sqrt(sum((lmFit1.pred-testing[,3])^2)/94)
# This goes off by 

lmFit2 <- train(V3~., dat, method = "lm", 
                 trControl = trainControl(method = "cv"))
lmFit2.pred<-predict(lmFit2,testing[2:34])
sqrt(sum((lmFit2.pred-testing[,3])^2)/94)
# this goes off by 22 hours


# As the data has many correlated features PCA is used to reduce the number of 
# features for better and improved prediction but the results does not support 
# the arguement
# Cross validation was used to better generalise the error
# So second fit was selected as they give better result.
