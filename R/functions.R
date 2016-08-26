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
get.classification <- function(url, collection, view, class.id=NULL, codeSort=NULL, 
                               key=NULL, limit=NULL, offset=NULL){
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
#' @param codeLimit Specifies the number of codes to return in each classification
#' @param codeOffset Specifies the starting index of the codes in each classification
#' @param codeSort Specifies how the codes should be sorted, options are ASC or DESC
#' @param key API key for views that require a key. 
#' @param limit Specifies the number of classifications to return
#' @param offset Specifies the starting index of the classifications
#' @param sort Specifies how to sort the classfications returned. Classifications will be sorted by their ID and can be sorted ASC or DESC
#' @keywords variable
#' @export
#' @examples
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView",limit=10,offset=10,sort="DESC") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCollection","myView",codeLimit=100,codeSort="DESC")  
get.classifications <- function(url, collection, view, codeLimit=NULL, codeOffset=NULL, codeSort=NULL, 
                                key=NULL, limit=NULL, offset=NULL, sort=NULL){
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
#' @param key API key for views that require a key. 
#' @param var.id The variable ID to select
#' @keywords variable
#' @export
#' @examples
#' get.variable("http://localhost:8080/rds/api/catalog/","myCollection","myView","myVariable") 
get.variable <- function(url, collection, view, key=NULL, var.id=NULL){
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
injectMetadata <- function(data,metadata){
  if(!is.null(metadata$classifications)){
    map <- c()
    for(i in 1:length(metadata$classifications$resources$id)){
      key<-metadata$classifications$resources$id[i]
      value<-metadata$classifications$resources$codes$resources[i]
      map[key]<-value
      map[[key]]
    }
    
    for(i in 1:metadata$variables$info$count){
      varId <-metadata$variables$resources$id[i]
      varClass <- metadata$variables$resources$classification[i]
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
#' This function allows you to use the select function of RDS. RDS typically gives out a limited amount of 
#' data to keep the service quick and efficient. This select function will query RDS as many times as needed
#' to compile and return the entire data set to the R user. 
#' 
#' @param url The base URL of the RDS server
#' @param collection The collection ID
#' @param view The view ID
#' @param autoPage If set to true multiple queries will be sent to the RDS server in order to compile the complete data set
#' @param classLimit Specifies the limit of classifications that should be returned
#' @param classOffset Specifies the starting index of the classifications to be returned
#' @param codeLimit Specifies the limit of codes that should be returned in each classification
#' @param codeOffset Specifies the starting indexes of the codes in each classification
#' @param cols The columns to select
#' @param colLimit Specifies the limit of classifications that should be returned
#' @param colOffset Specifies the starting index of the classifications to be returned
#' @param count Specifies that the total count of records in the view should be included in the info section
#' @param distinct Specifies that only distinct values should be returned
#' @param facts Specifies that any facts available should be included in the returned metadata
#' @param freqs Specifies that any frequencies available should be included in the returned metadata
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param key API key for views that require a key. 
#' @param limit Specifies the number of records to return
#' @param offset Specifies the starting index of the records
#' @param orderby Describes how the results should be ordered
#' @param sleep Specifies the time to wait between each query to the server in order to not overwhelm the server. Default is 0.2 seconds.
#' @param stats Specifies that any summary statistics available should be included in the returned 
#' @param varProperties Specifies the variable properties to include / exclude from the returned variable metadata. Can be a regex or property names. 
#' @param where Describes how to subset the records
#' @keywords select
#' @export
#' @examples
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2") 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2",where="var1<1 AND var2>=3") 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2",orderby="var1 DESC,var2 ASC") 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="var1,var2",distinct=TRUE,limit=100,offset=100,count=TRUE) 
#' select("http://localhost:8080/rds/api/catalog/","myCollection","myView",cols="$demographics",inject=TRUE) 
select <- function(url, collection, view, autoPage=TRUE, classLimit=NULL, classOffset=NULL, codeLimit=NULL, codeOffset=NULL,
                   cols=NULL, colLimit=NULL, colOffset=NULL, count=FALSE, distinct=FALSE, facts=FALSE, freqs=FALSE, 
                   inject=FALSE, key=NULL, limit=NULL, offset=NULL, orderby=NULL, sleep=0.2, stats=FALSE, varProperties=NULL,
                   where=NULL){
  
  # get the initial data set that we will append information to. 
  dataSet <- selectPage(url,collection,view,cols,where,orderby,distinct,limit,offset,colLimit,colOffset,
                        classLimit,classOffset,codeLimit,codeOffset,facts,freqs,stats,count=TRUE,varProperties,key, metadata=TRUE, inject=FALSE)
  
  #create a list of data sets that will be appended to each other to build up all the columns in the final dataset
  i <- 1
  dataSets <- list()
  data <- dataSet@data
  
  # set up the info that will be used for pagination
  info <- dataSet@info
  columnInfo <- info
  
  if(autoPage){
    # get all the columns through multiple calls to selectPage
    while(columnInfo$moreCols){
      Sys.sleep(sleep)
      colOffset <- columnInfo$colOffset + columnInfo$colLimit
      colDataSet <- selectPage(url,collection,view,cols,where,orderby,distinct,limit,offset,colLimit,colOffset,
                               classLimit,classOffset,codeLimit,codeOffset,facts,freqs,stats,count=FALSE,varProperties,key,metadata=FALSE,inject=FALSE)
      
      columnInfo <- colDataSet@info
      i <- i+1
      dataSets[[i]] <- colDataSet@data
      
    }
    
    # append the column datasets to each other
    dataSets[[1]] <- data
    if(length(dataSets)>1){
      for(i in 2:length(dataSets)){
        data <- cbind(data,dataSets[[i]])
      }
    }
    
    # determine the number of rows to ask for, in this version we need to ensure < 10k cells to be able to get the maximum return within the cell limit
    # in the future we will probably get the cell limit from the data source. 
    limit <- floor(10000/info$colCount);
    
    # set up list of data sets
    i <- 1
    dataSets <- list()
    dataSets[[i]] <- data
    
    # set up info used for pagination
    rowInfo <- info
    
  }
  
  # we will grab the metadata once and use it for the resulting data set
  metadata <- dataSet@metadata
  
  if(autoPage){
    # get records using selectPage
    while(rowInfo$moreRows){
      Sys.sleep(sleep)
      getMetadata=FALSE
      if(i == 1){
        getMetadata=TRUE
      }
      offset <- rowInfo$offset+rowInfo$limit
      colOffset=0
      colLimit=info$colCount
      rowDataSet <- selectPage(url,collection,view,cols,where,orderby,distinct,limit,offset,colLimit,colOffset,
                               classLimit,classOffset,codeLimit,codeOffset,facts,freqs,stats,count=FALSE,varProperties,key,metadata=getMetadata,inject=FALSE)
      if(i == 1){
        metadata <- rowDataSet@metadata
      }else{
        rowDataSet@metadata <- metadata
      }
      
      i <- i+1
      dataSets[[i]] <- rowDataSet@data
      rowInfo <- rowDataSet@info
    }
    # ensure the info returned is the last info.
    info<-rowInfo
    
    # append the records together. 
    data <- dataSets[[1]]
    if(length(dataSets)>1){
      for(i in 2:length(dataSets)){
        data2 <- dataSets[[i]]
        names(data2) <- names(data) 
        data <- rbind(data,data2)
      }
    }
  }
  
  if(inject){
    data <- injectMetadata(data,metadata@json)
  }
  
  # return a new RDS data set object with the data and the info
  dataSet <- new("rds.dataset", metadata = metadata, data = data, info = info)
  
  return(dataSet)
}

selectPage <- function(url,collection,view,cols=NULL,where=NULL,orderby=NULL,
                       distinct=FALSE,limit=NULL,offset=NULL,colLimit=NULL,colOffset=NULL,
                       classLimit=NULL,classOffset=NULL,codeLimit=NULL,codeOffset=NULL,facts=FALSE,
                       freqs=FALSE,stats=FALSE, count=FALSE,varProperties=NULL,key=NULL,metadata=FALSE,inject=FALSE){
  
  # create the GET request and retrieve the JSON result
  request <- paste(url,collection,"/",view,"/select",sep="",collapse=NULL)
  
  if(metadata){
    request <- paste(request,"?metadata",sep="",collapse=NULL)
  }else{
    request <- paste(request,"?metadata=FALSE",sep="",collapse=NULL)
  }
  
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
  
  if(!is.null(colLimit))  {
    request <- paste(request,"&colLimit=",colLimit,sep="",collapse=NULL)
  }
  
  if(!is.null(colOffset))  {
    request <- paste(request,"&colOffset=",colOffset,sep="",collapse=NULL)
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
  
  if(!is.null(varProperties))  {
    request <- paste(request,"&varProperties=",varProperties,sep="",collapse=NULL)
  }
  
  if(!is.null(key))  {
    request <- paste(request,"&key=",key,sep="",collapse=NULL)
  }
  
  json <- jsonlite::fromJSON(request)
  
  # format the data and ensure the variable names are used as colnames in the data.frame 
  data <- data.frame(json$records)
  colnames(data)<-json$metadata$variables$resources$id
  
  # if metadata injection is desired we will look for classifications and make the proper adjusments to the data frame. 
  if(metadata & inject){
    data <- injectMetadata(data,json$metadata)
  }
  
  # format the info as a data.frame
  info <- data.frame(json$info)
  
  # return a new RDS data set object with the data and the info
  rds.metadata <- new("rds.metadata")
  if(metadata){
    rds.metadata <- new("rds.metadata", json=json$metadata)
  }
  dataSet <- new("rds.dataset", metadata = rds.metadata, data = data, info = info)
  
  return(dataSet)
}

#' Tabulate Function
#'
#' This function allows you to use the tabulate function of RDS. 
#' @param url The base URL of the server RDS is running on
#' @param collection The collection ID
#' @param view The view ID
#' @param dimensions The names of the variables that should be used as dimensions
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param key API key for views that require a key. 
#' @param limit Specifies the number of records to return
#' @param measures The variables that should be used as a measure, will be the count by default
#' @param offset Specifies the starting index of the records
#' @param orderby Describes how the results should be ordered
#' @param where Describes the subset of records the tabulation should run on
#' @keywords tabulate
#' @export
#' @examples
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2") 
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2",measures="AVG(var3)")
#' tabulate("http://localhost:8080/rds/api/catalog/","myCollection","myView",dimensions="var1,var2",measures="AVG(var3)",where="var1!=5",inject=TRUE) 
tabulate <- function(url, collection, view, dimensions=NULL, inject=FALSE, 
                     key=NULL, limit=NULL, measures=NULL, offset=NULL, orderby=NULL,
                     where=NULL){
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
    data <- injectMetadata(data,json$metadata)
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