install.packages("ggplot2")
install.packages("devtools")
install.packages("htmlTable")
library("ggplot2")
library("devtools")
library(htmlTable)
install("/Users/carsonhuntermtna/R/development/rds-r")
library("rds.r")

#select. Metadata and data being returned together. 
?rds.r::select
?names
 dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948", metadata=TRUE)
data <- dataSet@data
variables <- dataSet@variables
info <- dataSet@info
classifications <- dataSet@classifications
rm(data,dataSet,variables,info,classifications)

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",autoPage=FALSE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",inject=TRUE, metadata=TRUE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

#DISTINCT - not yet implemented
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC", distinct=TRUE)
data <- dataSet@data
variables <- dataSet@variables
rm(data,dataSet,variables)

#distinct not a valid param yet
#dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=TRUE,inject=TRUE)
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=FALSE,inject=FALSE)
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
dataSet <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948",dimensions="V480003", inject=TRUE)
data<-dataSet@data
variables<-dataSet@variables
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

#testing ggplot
tabulation <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948", metadata=TRUE,dimensions="V480045,V480014a", inject=TRUE)
data <- tabulation@data

#current
variables <- tabulation@variables
V480045 <- rds.r:::variable(variables,"V480045")
V480014a <- rds.r:::variable(variables,"V480014a")

## we will compute the percentage and format it as a percentage label for the chart
data$count<-as.numeric(as.character(data$count))
data = ddply(data, .(V480014a), transform, Pct = count/sum(count) * 100)
data = ddply(data, .(V480014a), transform, pos = (cumsum(count) - 0.5 * count))
data$label = paste0(sprintf("%.0f", data$Pct), "%")

###testing
dataSet <- select("http://localhost:8080/rds/api/query/", "anes", "anes1948", cols="$truman,$respondent", metadata=TRUE, rowLimit=10, autoPage=FALSE)

variablesMetadata <- get.variables("http://localhost:8080/rds/api/catalog/","anes","anes1948",cols="$truman,$respondent",columnLimit=10)
variableDf<-dataSet@variables
#varMethod <- rds.r::variables(dataSet)
varTable<-htmlTable(variableDf,col.rgroup = c("none", "#F7F7F7"),css.table="width: 100%; ", css.cell = "padding-left: 2%; padding-right: 2%; font-family:\"Helvetica Neue\",Helvetica,Arial,sans-serif; font-size:14px", rnames=FALSE)
jsonList<-dataSet@variables@json

print(varTable)


tabulation <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948", metadata=TRUE,dimensions="V480045,V480014a", inject=TRUE)
data <- tabulation@data
variables<-tabulation@variables
#get a list of variable names
variableNames <- list();

variableNames<-variables$label
install.packages("sjPlot")
library(sjPlot)
table<- sjtable<- sjt.xtab(data$V480045, data$V480014a,var.labels=variableNames)
print(table)


#editing classification method
V480045 <- rds.r::variable(dataSet@variables,"V480045")
classification <- rds.r::get.classification("http://localhost:8080/rds/api/catalog/","anes","anes1948",class.id=V480045$classificationUri)
classTable<-htmlTable(classification, col.rgroup = c("none", "#F7F7F7"),css.table="width: 100%;", rnames=FALSE)
```
