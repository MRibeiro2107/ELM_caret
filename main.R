#Example
rm(list=ls(all=TRUE))
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Reading the code for ELM in Caret
source("checkpackages.R")

#Reading packages
packages<-c("caret","elmNNRcpp")

sapply(packages,packs)

#Reading ELM in caret
source("elmcaret.R")

#mtcars data
data(mtcars)

#caret control
trControl <- trainControl(method = "cv",number = 5)

#model training with whole mtcars data
ELM      <-train(mtcars[,-1],mtcars[,1],
           method=ELMmodell,
           preProc = c("center", "scale"),
           tuneLength = 5,
           trControl = trControl,
           metric="Rsquared")
ELM