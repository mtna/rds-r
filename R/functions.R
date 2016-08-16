library(jsonlite)
library(urltools)

#' Get Classification Function
#'
#' This function allows you to select a classification based on its ID. 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param class.id The classification ID to select
#' @param limit Specifies the number of codes to return
#' @param offset Specifies the starting index of the codes
#' @param codeSort Specifies how the codes should be sorted, options are ASC or DESC
#' @param key API key for views that require a key. 
#' @keywords classification
#' @export
#' @examples
#' get.classification("http://localhost:8080/rds/api/catalog/","myCollection","myView",class.id="myClass")
#' get.classification("http://localhost:8080/rds/api/catalog/","myCollection","myView",class.id="myClass",limit=10,offset=10)
#' get.classification("http://localhost:8080/rds/api/catalog/","myCollection","myView",class.id="myClass",codeSort="DESC")
get.classification <- function(url,collection,view,class.id=NULL,limit=NULL,offset=NULL,codeSort=NULL,key=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/classification/",class.id,sep="",collapse=NULL)
  
  # append any filled out options to the request 
  paramPrefix = "?"
  if(!is.null(limit)){
    request <- paste(request,paramPrefix,"limit=",limit,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(offset)){
    request <- paste(request,paramPrefix,"offset=",offset,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(codeSort)){
    request <- paste(request,paramPrefix,"codeSort=",codeSort,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(key)){
    request <- paste(request,paramPrefix,"key=",key,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  json <- jsonlite::fromJSON(request)
  id <- json$id
  codes <- data.frame(json$codes$resources)
  info <- data.frame(json$codes$info)
  classification <- new("rds.classification", id = id, codes = codes, info = info)
  return(classification)
}

#' Get Classifications Function
#'
#' This function allows you to use the select multiple classifications. 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param limit Specifies the number of classifications to return
#' @param offset Specifies the starting index of the classifications
#' @param codeLimit Specifies the number of codes to return in each classification
#' @param codeOffset Specifies the starting index of the codes in each classification
#' @param sort Specifies how to sort the classfications returned. Classifications will be sorted by their ID and can be sorted ASC or DESC
#' @param codeSort Specifies how the codes should be sorted, options are ASC or DESC
#' @param key API key for views that require a key. 
#' @keywords variable
#' @export
#' @examples
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView",limit=10,offset=10,sort="DESC") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView",codeLimit=100,codeSort="DESC")  
get.classifications <- function(url,collection,view,limit=NULL,offset=NULL,codeLimit=NULL,codeOffset=NULL,sort=NULL,codeSort=NULL,key=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/classifications",sep="",collapse=NULL)
  
  # append any filled out options to the request 
  paramPrefix = "?"
  if(!is.null(limit)){
    request <- paste(request,paramPrefix,"limit=",limit,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(offset)){
    request <- paste(request,paramPrefix,"offset=",offset,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(codeLimit)){
    request <- paste(request,paramPrefix,"codeLimit=",codeLimit,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(codeOffset)){
    request <- paste(request,paramPrefix,"codeOffset=",codeOffset,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(sort)){
    request <- paste(request,paramPrefix,"sort=",sort,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(codeSort)){
    request <- paste(request,paramPrefix,"codeSort=",codeSort,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(key)){
    request <- paste(request,paramPrefix,"key=",key,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  json <- jsonlite::fromJSON(request)
  classifications <- list()
  if(!is.null(json$classifications)){
    for(i in 1:length(json$classifications$resources$id)){
      id    <- json$classifications$resources$id[i]
      codes <- json$classifications$resources$codes$resources[[i]]
      info  <- json$classifications$resources$codes$info[i,]
      classification <- new("rds.classification",id=id, codes=codes, info=info)
      classifications <- c(classifications, classification)
    }
  }
  return(classifications)
}

#' Get Variable Function
#'
#' This function allows you to select the metadata for a single variable based off its ID. 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param var.id The variable ID to select
#' @param key API key for views that require a key. 
#' @keywords variable
#' @export
#' @examples
#' get.variable("http://localhost:8080/rds/api/catalog/","myCollection","myView","myVariable") 
get.variable <- function(url,collection,view,var.id=NULL,key=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/variable/",var.id,sep="",collapse=NULL)
  
  # append any filled out options to the request 
  paramPrefix = "?"
  
  if(!is.null(key)){
    request <- paste(request,paramPrefix,"key=",key,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  json <- jsonlite::fromJSON(request)
  variable <- data.frame(json)
  return(variable)
}

#' Get Variables Function
#'
#' This function allows you to use the select multiple variables metadata. 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param cols The columns to select
#' @param key API key for views that require a key. 
#' @keywords variable
#' @export
#' @examples
#' get.variables("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2") 
#' get.variables("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$demographics") 
get.variables <- function(url,collection,view,cols=NULL,key=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/variables",sep="",collapse=NULL)
  
  # append any filled out options to the request 
  paramPrefix = "?"
  if(!is.null(cols)){
    request <- paste(request,paramPrefix,"cols=",cols,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  if(!is.null(key)){
    request <- paste(request,paramPrefix,"key=",key,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  
  json <- jsonlite::fromJSON(request)
  variables <- data.frame(json$variables$resources)
  return(variables)
}

#' Inject Metadata
#'
#' This function will inject classification categories into the data frame to replace the codes.
#' @param data The original data frame from 
#' @param collection The collection ID
#' @keywords injection, metadata
#' @export
#' @examples
#' injectMetadata()
injectMetadata <- function(data,json){
  if(!is.null(json$metadata$classifications)){
    map <- c()
    for(i in 1:length(json$metadata$classifications$resources$id)){
      key<-json$metadata$classifications$resources$id[i]
      value<-json$metadata$classifications$resources$codes$resources[i]
      map[key]<-value
      map[[key]]
    }
    
    for(i in 1:json$metadata$variables$info$count){
      varId <-json$metadata$variables$resources$id[i]
      varClass <- json$metadata$variables$resources$classification[i]
      if(!is.na(varClass)){
        class <- map[[varClass]]
        data[,varId] <- factor(data[,varId],class$value,class$label)
      }
    }
  }
  return(data)
}

#' Select Function
#'
#' This function allows you to use the select function of RDS. 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param cols The columns to select
#' @param where Describes how to subset the records
#' @param orderby Describes how the results should be ordered
#' @param distinct Specifies that only distinct values should be returned
#' @param limit Specifies the number of records to return
#' @param offset Specifies the starting index of the records
#' @param classLimit Specifies the limit of classifications that should be returned
#' @param classOffset Specifies the starting index of the classifications to be returned
#' @param codeLimit Specifies the limit of codes that should be returned in each classification
#' @param codeOffset Specifies the starting indexes of the codes in each classification
#' @param facts Specifies that any facts available should be included in the returned metadata
#' @param freqs Specifies that any frequencies available should be included in the returned metadata
#' @param stats Specifies that any summary statistics available should be included in the returned 
#' @param count Specifies that the total count of records in the view should be included in the info section
#' @param key API key for views that require a key. 
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @keywords select
#' @export
#' @examples
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2") 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$var1,var2",where="var1<1 AND var2>=3) 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$var1,var2",orderby="var1 DESC,var2 ASC") 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$var1,var2",distinct=TRUE,limit=100,offset=100,count=TRUE) 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$demographics",inject=TRUE) 
select <- function(url,collection,view,cols=NULL,where=NULL,orderby=NULL,
                   distinct=FALSE,limit=NULL,offset=NULL,classLimit=NULL,classOffset=NULL,
                   codeLimit=NULL,codeOffset=NULL,facts=FALSE,freqs=FALSE,stats=FALSE,
                   count=FALSE,key=NULL,inject=FALSE){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/select?metadata",sep="",collapse=NULL)
  
  # append any filled out options to the request 
  if(!is.null(cols)){
    request <- paste(request,"&cols=",cols,sep="",collapse=NULL)
  }
  
  if(!is.null(where))  {
    request <- paste(request,"&where=",where,sep="",collapse=NULL)
  }
  
  if(!is.null(orderby))  {
    request <- paste(request,"&orderby=",url_encode(orderby),sep="",collapse=NULL)
  }
  
  if(distinct){
    request <- paste(request,"&distinct",sep="",collapse=NULL)
  }
  
  if(!is.null(limit))  {
    request <- paste(request,"&limit=",limit,sep="",collapse=NULL)
  }
  
  if(!is.null(offset))  {
    request <- paste(request,"&offset=",offset,sep="",collapse=NULL)
  }
  
  if(!is.null(classLimit))  {
    request <- paste(request,"&classLimit=",classLimit,sep="",collapse=NULL)
  }
  
  if(!is.null(classOffset))  {
    request <- paste(request,"&classOffset=",classOffset,sep="",collapse=NULL)
  }
  
  if(!is.null(codeLimit))  {
    request <- paste(request,"&codeLimit=",codeLimit,sep="",collapse=NULL)
  }
  
  if(!is.null(codeOffset))  {
    request <- paste(request,"&codeOffset=",codeOffset,sep="",collapse=NULL)
  }
  
  if(facts){
    request <- paste(request,"&facts",sep="",collapse=NULL)
  }
  
  if(freqs){
    request <- paste(request,"&freqs",sep="",collapse=NULL)
  }
  
  if(stats){
    request <- paste(request,"&stats",sep="",collapse=NULL)
  }
  
  if(!is.null(key))  {
    request <- paste(request,"&key=",key,sep="",collapse=NULL)
  }
  
  json <- jsonlite::fromJSON(request)
  
  # format the data and ensure the variable names are used as colnames in the data.frame 
  data <- data.frame(json$records)
  colnames(data)<-json$metadata$variables$resources$id
  
  # if metadata injection is desired we will look for classifications and make the proper adjusments to the data frame. 
  if(inject){
    data <- injectMetadata(data,json)
  }
  
  # format the info as a data.frame
  info <-data.frame(json$info) 
  
  # return a new RDS data set object with the data and the info
  metadata <- new("rds.metadata", json=json$metadata)
  dataSet <- new("rds.dataset", metadata = metadata, data = data, info = info)
  return(dataSet)
}

#' Tabulate Function
#'
#' This function allows you to use the tabulate function of RDS. 
#' @param url The base URL of the server RDS is running on
#' @param collection The collection ID
#' @param view The view ID
#' @param cols The columns to select
#' @param where Describes how to subset the records
#' @param orderby Describes how the results should be ordered
#' @param distinct Specifies that only distinct values should be returned
#' @param limit Specifies the number of records to return
#' @param offset Specifies the starting index of the records
#' @param classLimit Specifies the limit of classifications that should be returned
#' @param classOffset Specifies the starting index of the classifications to be returned
#' @param codeLimit Specifies the limit of codes that should be returned in each classification
#' @param codeOffset Specifies the starting indexes of the codes in each classification
#' @param facts Specifies that any facts available should be included in the returned metadata
#' @param freqs Specifies that any frequencies available should be included in the returned metadata
#' @param stats Specifies that any summary statistics available should be included in the returned 
#' @param count Specifies that the total count of records in the view should be included in the info section
#' @param key API key for views that require a key. 
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @keywords tabulate
#' @export
#' @examples
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2") 
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2",measures="AVG(var3)")
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2",measures="AVG(var3)",where="var1!=5",inject=TRUE) 
tabulate <- function(url,collection,view,dimensions=NULL,measures=NULL,orderby=NULL,
                     where=NULL,limit=NULL,offset=NULL,count=FALSE,key=NULL,inject=FALSE){
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/tabulate",sep="",collapse=NULL)
  
  # append any filled out options to the request 
  request <- paste(request,"?metadata",sep="",collapse=NULL)  
  
  if(!is.null(dimensions)){
    request <- paste(request,"&dims=",dimensions,sep="",collapse=NULL)
  }
  
  if(!is.null(measures)){
    request <- paste(request,"&measures=",measures,sep="",collapse=NULL)
  }
  
  if(!is.null(where))  {
    request <- paste(request,"&where=",where,sep="",collapse=NULL)
  }
  
  if(!is.null(orderby))  {
    request <- paste(request,"&orderby=",url_encode(orderby),sep="",collapse=NULL)
  }
  
  if(!is.null(limit))  {
    request <- paste(request,"&limit=",limit,sep="",collapse=NULL)
  }
  
  if(!is.null(offset))  {
    request <- paste(request,"&offset=",offset,sep="",collapse=NULL)
  }
  
  if(count)  {
    request <- paste(request,"&count",sep="",collapse=NULL)
  }
  
  if(!is.null(key))  {
    request <- paste(request,"&key=",key,sep="",collapse=NULL)
  }
  
  json <- jsonlite::fromJSON(request)
  
  # format the data and ensure the variable names are used as colnames in the data.frame 
  data <- data.frame(json$records)
  colnames(data)<-json$metadata$variables$resources$id
 
   # if metadata injection is desired we will look for classifications and make the proper adjusments to the data frame. 
  if(inject){
    data <- injectMetadata(data,json)
  }
  
  # format the info as a data.frame
  info <-data.frame(json$info) 
  
  # return a new RDS data set object with the data and the info
  metadata <- new("rds.metadata")
  if(!is.null(json$metadata)){
    metadata <- new("rds.metadata", json=json$metadata)
  }
  dataSet <- new("rds.dataset", metadata = metadata, data = data, info = info)
  return(dataSet)
}