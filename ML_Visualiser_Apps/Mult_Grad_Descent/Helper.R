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
  return((mat)%*%(theta))
}

cost<-function(df,theta,response)
{
  sumc=0
  m=dim(df)[1]
  response=as.matrix(response)
  sumc=sum((hypothesis(df,theta)-response)^2)/(2*m)
  return(sumc)
}
grad<-function(df,theta,y,m)
{
  g=(1/m)*(t(df)%*%(hypothesis(df,theta)-y))
  return(g)
}
grad_desc_regression<-function(df,y,theta,alpha,num_iter)
{
  y=as.matrix(y)
  theta=as.matrix(theta)
  m=as.numeric(dim(df)[1])
  J_History=rep(0,times=num_iter)
  for(i in 1:num_iter)
  {
    theta=theta-alpha*grad(df,theta,y,m)
    J_History[i]=cost(df,theta,y)
  }
  return(list(jhist=J_History,mintheta=theta))
}
