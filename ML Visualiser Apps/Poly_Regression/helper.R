add_col <- function(df,degrees,feature)
{
  for(i in 1:degrees)
  {
    print(df[feature])
    df[paste(feature,"^",i)]=df[,feature]^i
  }
  return(df)
}

subset <- function(df,feature)
{
  return(df[feature])
}

 