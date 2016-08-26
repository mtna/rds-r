library("ggplot2")
install("/home/andrew/R/development/rds.r")

#select. Metadata and data being returned together. 
?rds::select
dataSet <- select("http://richdataservices.com/public/api/catalog/","test","anes1948")
data <- dataSet@data

dataSet <- select("http://richdataservices.com/public/api/catalog/","test","anes1948",autoPage=FALSE)
data <- dataSet@data

dataSet <- select("http://richdataservices.com/public/api/catalog/","test","anes1948",inject=TRUE)
data <- dataSet@data

dataSet <- select("http://richdataservices.com/public/api/catalog/","test","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC", distinct = TRUE)
data <- dataSet@data
info <- dataSet@info

dataSet <- select("http://richdataservices.com/public/api/catalog/","test","anes1948",cols="$respondent",where="V480003=1",orderby="V480045,V480047 DESC",distinct=TRUE,inject=TRUE)
data <- dataSet@data
info <- dataSet@info

#get the metdata returned with the data and use the methods to access var and class metadata
metadata<-dataSet@metadata
variables <- rds:::variables(metadata)
var <- rds:::variable(metadata,"V480006")

classifications <- rds:::classifications(metadata)
class <- rds:::classification(metadata, var$classification)
codes <- class@codes
info <- class@info

#tabulations
?rds::tabulate
dataSet <- rds::tabulate("http://richdataservices.com/public/api/catalog/","test","anes1948",dimensions="V480003",inject=TRUE)
data<-dataSet@data
metadata<-dataSet@metadata
V480003<-rds:::variable(metadata,"V480003")

ggplot(data, aes(x = factor(data$V480003), y = data$count)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5,size=12),axis.text.y=element_text(size=12),legend.position="top")+
  xlab(V480003$label)+
  coord_flip()

#select a single variables metadata
?get.variable
varMetadata <- get.variable("http://richdataservices.com/public/api/catalog/","test","anes1948",var.id="V480003")

#query variable metadata for multiple variables metadata
?get.variables
variablesMetadata <- get.variables("http://richdataservices.com/public/api/catalog/","test","anes1948",cols="$respondent")

#select a single classifications metadata
?get.classification
classMetadata <- get.classification("http://richdataservices.com/public/api/catalog/","test","anes1948",class.id=varMetadata$classification)
id <- classMetadata@id
codes <- classMetadata@codes
info <- classMetadata@info

#query multiple classfication metadata
?get.classifications
classificationsMetadata <- get.classifications("http://richdataservices.com/public/api/catalog/","test","anes1948")
