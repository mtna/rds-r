install.packages("ggplot2")
install.packages("devtools")
install.packages("htmlTable")
library("ggplot2")
library("devtools")
library("htmlTable")
install("/Users/carsonhuntermtna/R/development/rds-r")
library("rds.r")
source("/Users/carsonhuntermtna/R/development/rds-r/rdsFunctions.R")

#select. Metadata and data being returned together. 
?rds.r::select
dataSet <- select("http://localhsot:8080/rds/api/query/","anes","anes1948", metadata=TRUE)
data <- dataSet@data
variables <- dataSet@variables
info <- dataSet@info
rm(data,dataSet,variables,info)

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",autoPage=FALSE, metadata = TRUE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",inject=TRUE, metadata=TRUE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",inject=FALSE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

#get the metdata returned with the data and use the methods to access var and class metadata
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=FALSE,inject=FALSE)
variables<-dataSet@variables
var <- rds.r:::variable(variables,"V480045")
rm(data,dataSet,variables,var)

#query multiple classifications' metadata
?get.classifications
classifications <- get.classifications("http://localhost:8080/rds/api/catalog/","anes","anes1948")
#classifications <- new("rds.classifications",json=classificationsMetadata)
#newclassifications <- rds.r:::classifications(classifications)

#select a single classifications metadata
?get.classification
class <- rds.r:::classification(classifications, var$classificationId)
class <- rds.r:::classification(classifications, "V480006")
id <- class@id
codes <- class@codes

#tabulations
?rds.r::tabulate
#dataSet <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948",dimensions="V480003", inject=TRUE)
dataSet <- tabulate("http://localhost:8080/rds/api/query/","anes","anes1948",dimensions="V480003", inject=TRUE, metadata = TRUE)
data<-dataSet@data
variables<-dataSet@variables
#TODO this shouldn't be there, it doesn't get back any variables? 
V480003<-rds.r:::variable(variables,"V480003")

#plot v480003 var
ggplot(data, aes(x = factor(data$V480003), y = data$count)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5,size=12),axis.text.y=element_text(size=12),legend.position="top")+
  xlab(V480003$label)+ 
  coord_flip()

#select a single variables' metadata
?get.variable
varMetadata <- get.variable("http://localhost:8080/rds/api/catalog/","anes","anes1948",var.id="V480003")

#query variable metadata for multiple variables metadata
?get.variables
variablesMetadata <- get.variables("http://localhost:8080/rds/api/catalog/","anes","anes1948",cols="$respondent")

#injecting metadata
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",inject=TRUE)
data<-dataSet@data

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",autoPage=FALSE)
data <- dataSet@data

# Variable information
variables<-dataSet@variables
V480045 <- rds.r:::variable(variables,"V480045")
classificationsMetadata <- get.classifications("http://localhost:8080/rds/api/catalog/","anes","anes1948")


dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948", colLimit=10, rowLimit = 10, metadata = TRUE, inject=TRUE)
data <- dataSet@data
dataTable<-htmlTable(data,col.rgroup = c("none", "#F7F7F7"), css.table="width: 100%;",css.cell = " font-family:\"Helvetica Neue\",Helvetica,Arial,sans-serif; font-size:14px", rnames=FALSE)

library(magrittr)
library(tidyr)
library(dplyr)
library(htmlTable)
library(tibble)

table  %>% tidyHtmlTable(data, header = variables$label,
                cell_value = data$count, 
                rnames = data$V480045)


tabulation <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948", metadata=TRUE,dimensions="V480045,V480014a", inject=TRUE, orderby = "V480045,V480014a")
data <- tabulation@data
variables<-tabulation@variables
variableNames <- list();
variableNames<-variables$label
#table<- sjtable<- sjt.xtab(data$V480045, data$V480014a,var.labels=variableNames)

#reshape to wide
wideDf <- data %>% spread(V480014a, count)

#set first column as row names and remove it as a column
row.names(wideDf) <- make.names(wideDf[,1],TRUE)
wideDf$V480045<- NULL
table<-htmlTable(wideDf)

