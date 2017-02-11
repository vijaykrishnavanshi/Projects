
sigmoid <- function(z)
{
  return(1.0/(1+exp(-z)))
}

instdf<-function(df)
{
  return(cbind("x0"=rep(1,times=length(df)),df))
}

subsetdf<-function(df,feature)
{
  return(df[,c(feature)])
}

hypothesis <- function(mat,theta)
{
  mat=as.matrix(mat)
  theta=as.matrix(theta)
  return(sigmoid((mat)%*%(theta)))
}

cost<-function(df,theta,response)
{
  m=dim(df)[1]
  h=hypothesis(df,theta)
  J=(t(-y)%*%log(h)-t(1-y)%*%log(1-h))/m
  return(J)
}
grad<-function(df,theta,y,m)
{
  g=(1/m)*(t(df)%*%(hypothesis(df,theta)-y))
  return(g)
}
grad_desc_logistic_regression<-function(df,y,theta,alpha,num_iter)
{
  y=as.matrix(y)
  theta=as.matrix(theta)
  m=as.numeric(dim(df)[1])
  #print(m)
  J_History=rep(0,times=num_iter)
  for(i in 1:num_iter)
  {
    #print(cost(df,theta,y))
    theta=theta-alpha*grad(df,theta,y,m)
    J_History[i]=cost(df,theta,y)
  }
  return(list(jhist=J_History,mintheta=theta))
}