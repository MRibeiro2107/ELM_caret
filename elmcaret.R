#Path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("checkpackages.R")

#Reading packages
packages<-c("caret","elmNNRcpp")

sapply(packages,packs)
#Define type of problem reached by the implementation

ELMmodell <- list(label = "Extreme Learning Machine",
                  type  ="Regression",
                  library="elmNNRcpp",
                  loop   =NULL,
                  prob = NULL)

ELMmodell$parameters = data.frame(parameter = c('nhid','actfun','init_weights'),
                                  class = c("numeric","character","character"),
                                  label = c('#Hidden Units',"#Activation Function", "#Weights Initialization"))

ELMmodell$grid = function(x, y, len = NULL, search = "grid") 
{
  funs           <-c('sig','sin','radbas','hardlim','hardlims','satlins','tansig','tribas','relu','purelin')
  weights        <- c('normal_gaussian','uniform_positive','uniform_negative')
  
  
  if(search == "grid")     {
    out <- data.frame(expand.grid(nhid = floor(runif(len, min = 1, max = 20)),
                                  actfun=as.character(funs),
                                  init_weights=as.character(weights)))
  } 
  else 
  {
    out <- data.frame(nhid = sample(1:20, replace = TRUE, size = len),
                      actfun = sample(fun, replace = TRUE, size = len),
                      init_weights = sample(weights, replace = TRUE, size = len))
  }
}


ELMmodell$fit = function(x, y, wts, param, lev, last, classProbs, ...) {
  elmNNRcpp::elm_train(x = as.matrix(x), y = as.matrix(y),
                       nhid         = param$nhid,
                       actfun       = as.character(param$actfun),
                       init_weights = as.character(param$init_weights),
                       ...
  )
}

ELMmodell$predict = function(modelFit, newdata, submodels = NULL)
  elmNNRcpp::elm_predict(modelFit, as.matrix(newdata))

ELMmodell$sort = function(x) x[order(x$nhid),]
