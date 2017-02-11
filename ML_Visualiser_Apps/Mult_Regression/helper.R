splitdf <- function(dataframe, seed=NULL,part=0.5) {
  if (!is.null(seed)) set.seed(seed)
  index <- 1:nrow(dataframe)
  trainindex <- sample(index, trunc(length(index)*part))
  trainset <- dataframe[trainindex, ]
  testset <- dataframe[-trainindex, ]
  list(trainset=trainset,testset=testset)
}

rmse <- function(model,typedata,resp){
  return(sqrt(sum((predict(model,typedata)-typedata[[resp]])^2)/dim(typedata)[1]))
}



# require(caTools)
# set.seed(101) 
# sample = sample.split(data$anycolumn, SplitRatio = .75)
# train = subset(data, sample == TRUE)
# test = subset(data, sample == FALSE)
