install.packages("ggplot2")
install.packages("devtools")

library("ggplot2")
library("devtools")
install("/Users/carsonhuntermtna/R/development/rds-r")
library("rds.r")
#select. Metadata and data being returned together. 
?rds.r::select
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948aws")
data <- dataSet@data

#this isn't a valid call - should this be variables/varaible? or just look at the catalog?
#dataSet <- select("http://localhost:8080/rds/api/query/catalog/","anes","anes1948aws",autoPage=FALSE)
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948aws",autoPage=FALSE)
data <- dataSet@data

#has unstopped loop problem
#dataSet <- select("http://localhost:8080/rds/api/catalog/","anes","anes1948",inject=TRUE)
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948aws",inject=TRUE)
data <- dataSet@data

dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948aws",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=TRUE)
data <- dataSet@data
info <- dataSet@info

#question: is respondent a section from the old json? 
dataSet <- select("http://localhost:8080/rds/api/query/","anes","anes1948aws",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=TRUE,inject=TRUE)
data <- dataSet@data
info <- dataSet@info

#get the metdata returned with the data and use the methods to access var and class metadata
metadata<-dataSet@metadata
variables <- rds.r:::variables(metadata)
var <- rds.r:::variable(metadata,"V480006")

classifications <- rds.r:::classifications(metadata)
class <- rds.r:::classification(metadata, var$classification)
codes <- class@codes
info <- class@info

#tabulations
?rds.r::tabulate
dataSet <- rds.r::tabulate("http://localhost:8080/rds/api/query/","anes","anes1948aws",dimensions="V480003",inject=TRUE)
data<-dataSet@data
metadata<-dataSet@metadata
V480003<-rds.r:::variable(metadata,"V480003")

ggplot(data, aes(x = factor(data$V480003), y = data$count)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5,size=12),axis.text.y=element_text(size=12),legend.position="top")+
  xlab(V480003$label)+
  coord_flip()

#select a single variables metadata
#HELP: this quits on jsonlite::fromJson(request)
?get.variable
varMetadata <- get.variable("http://localhost:8080/rds/api/catalog/","anes","anes1948aws",var.id="V480003")

#query variable metadata for multiple variables metadata
##HELP what is the respondent? its a keyword
?get.variables
variablesMetadata <- get.variables("http://localhost:8080/rds/api/catalog/","anes","anes1948aws",cols="$respondent")

#select a single classifications metadata
?get.classification
#classMetadata <- get.classification("http://localhost:8080/rds/api/catalog/","anes","anes1948aws",class.id=varMetadata$classification)
classMetadata <- get.classification("http://localhost:8080/rds/api/catalog/","anes","anes1948aws",class.id="V480003")
id <- classMetadata@id
codes <- classMetadata@codes
info <- classMetadata@info

#query multiple classfication metadata
?get.classifications
classificationsMetadata <- get.classifications("http://richdataservices.com/public/api/catalog/","test","anes1948")
