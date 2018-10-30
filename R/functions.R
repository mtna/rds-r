library(jsonlite)
library(urltools)

#' Get Classification Function
#'
#' This function allows you to select a classification based on its ID. 
#' @param url The base URL of the RDS server
#' @param catalog The catalog ID
#' @param dataProduct The dataProcuct ID
#' @param class.id The classification ID to select
#' @param imit Specifies the number of codes to return
#' @param offset Specifies the starting index of the codes
#' @param codeSort Specifies how the codes should be sorted, options are ASC or DESC
#' @param key API key for dataProducts that require a key. 
#' @keywords classification
#' @export
#' @examples
#' get.classification("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",class.id="myClass")
#' get.classification("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",class.id="myClass",limit=10,offset=10)
#' get.classification("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",class.id="myClass",codeSort="DESC")
get.classification <- function(url, catalog, dataProduct, class.id=NULL, codeSort=NULL, 
                               key=NULL, limit=NULL, offset=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/classification/",class.id,sep="",collapse=NULL)
  
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
  codeCount <-json$rootCodeCount
  keywordCount <- json$keywordCount
  levelCount <- json$levelCount
  
  #testing
  if(codeCount>0){
    #query for codes in a separate call and add them on to this classification
    #TODO add a limit
    codeRequest <- paste(url,catalog,"/",dataProduct,"/classification/",class.id,"/codes",sep="",collapse=NULL)
    # append any filled out options to the request 
    paramPrefix = "?"
    if(!is.null(limit)){
      codeRequest <- paste(codeRequest,paramPrefix,"limit=",limit,sep="",collapse=NULL)
      paramPrefix = "&"
    }
    
    if(!is.null(offset)){
      codeRequest <- paste(codeRequest,paramPrefix,"offset=",offset,sep="",collapse=NULL)
      paramPrefix = "&"
    }
    
    if(!is.null(codeSort)){
      codeRequest <- paste(codeRequest,paramPrefix,"codeSort=",codeSort,sep="",collapse=NULL)
      paramPrefix = "&"
    }
    
    if(!is.null(key)){
      codeRequest <- paste(codeRequest,paramPrefix,"key=",key,sep="",collapse=NULL)
      paramPrefix = "&"
    }
    codeListJson <- jsonlite::fromJSON(codeRequest)
    print(codeListJson)
  }
  codes <- data.frame(codeListJson)
  #end test
  
  #codes <- data.frame(json$codes$resources)
  #info <- data.frame(json$codes$info)
  classification <- new("rds.classification", id = id, codes = codes)
  return(classification)
}

#' Get Classifications Function
#'
#' This function allows you to use the select multiple classifications. 
#' @param url The base URL of the RDS server
#' @param catalog The catalog ID
#' @param dataProduct The dataProduct ID
#' @param codeLimit Specifies the number of codes to return in each classification
#' @param codeOffset Specifies the starting index of the codes in each classification
#' @param codeSort Specifies how the codes should be sorted, options are ASC or DESC
#' @param key API key for dataProducts that require a key. 
#' @param limit Specifies the number of classifications to return
#' @param offset Specifies the starting index of the classifications
#' @param sort Specifies how to sort the classfications returned. Classifications will be sorted by their ID and can be sorted ASC or DESC
#' @keywords variable
#' @export
#' @examples
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",limit=10,offset=10,sort="DESC") 
#' get.classifications("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",codeLimit=100,codeSort="DESC")  
get.classifications <- function(url, catalog, dataProduct, codeLimit=NULL, codeOffset=NULL, codeSort=NULL, 
                                key=NULL, limit=NULL, offset=NULL, sort=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/classifications",sep="",collapse=NULL)
  
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
  
  for(i in 1:nrow(json)){
    id    <- json$id[[i]]
    uri<-json$uri[[i]]
    name<-json$name[[i]]
    codeCount<-json$codeCount[[i]]
    levelCount<-json$levelCount[[i]]
    #codes <- json[[i]]
    #info  <- json$classifications$resources$codes$info[i,]
    classification <- new("rds.classification",id=id, uri=uri, name=name, codeCount=codeCount,levelCount=levelCount)
    classifications <- c(classifications, classification)
  }

  return(classifications)
}

#' Get Variable Function
#'
#' This function allows you to select the metadata for a single variable based off its ID. 
#' @param url The base URL of the RDS server
#' @param catalog The catalog ID
#' @param dataProduct The dataProduct ID
#' @param key API key for dataProducts that require a key. 
#' @param var.id The variable ID to select
#' @keywords variable
#' @export
#' @examples
#' get.variable("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct","myVariable") 
get.variable <- function(url, catalog, dataProduct, key=NULL, var.id=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/variable/",var.id,sep="",collapse=NULL)
  
  # append any filled out options to the request 
  paramPrefix = "?"
  
  if(!is.null(key)){
    request <- paste(request,paramPrefix,"key=",key,sep="",collapse=NULL)
    paramPrefix = "&"
  }
  print(request)
  json <- jsonlite::fromJSON(request)
  variable <- data.frame(json)
  removals <- c()

  for (i in names(variable)) {
    column <- variable[[i]]
    if(length(column) == 0){
      removals <- c(removals, i)
    }
  }
  
  variable <- variable[ , !(names(variable) %in% removals)]
  return(variable)
}

#' Get Variables Function
#'
#' This function allows you to select multiple variables metadata. 
#' @param url The base URL of the RDS server
#' @param catalog The catalog ID
#' @param dataProduct The dataProduct ID
#' @param cols The columns to select
#' @param key API key for dataProducts that require a key. 
#' @param limit Limit the number of variables returned
#' @keywords variable
#' @export
#' @examples
#' get.variables("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="var1,var2") 
#' get.variables("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="$demographics") 
get.variables <- function(url,catalog,dataProduct,cols=NULL,key=NULL, columnLimit=NULL){
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/variables",sep="",collapse=NULL)
 
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
   
   if(!is.null(columnLimit)){
     request <- paste(request,paramPrefix,"columnLimit=",columnLimit,sep="",collapse=NULL)
     paramPrefix = "&"
   }
  print(request)
  # json <- jsonlite::fromJSON(request)
  # variables <- data.frame(json$variables)
   variables <- jsonlite::fromJSON(request)

  removals <- c()
  for (i in names(variables)) {
    column <- variables[[i]]
    if(length(column) == 0){
      removals <- c(removals, i)
    }
  }
  variables <- variables[ , !(names(variables) %in% removals)]
  return(variables)
}

#' Select Function
#'
#' This function allows you to use the select function of RDS. RDS typically gives out a limited amount of 
#' data to keep the service quick and efficient. This select function will query RDS as many times as needed
#' to compile and return the entire data set to the R user. 
#' 
#' @param url The base URL of the RDS server
#' @param catalog The catalog ID
#' @param dataProduct The dataProduct ID
#' @param autoPage If set to true multiple queries will be sent to the RDS server in order to compile the complete data set
#' @param classLimit Specifies the limit of classifications that should be returned
#' @param classOffset Specifies the starting index of the classifications to be returned
#' @param codeLimit Specifies the limit of codes that should be returned in each classification
#' @param codeOffset Specifies the starting indexes of the codes in each classification
#' @param cols The columns to select
#' @param colLimit Specifies the limit of classifications that should be returned
#' @param colOffset Specifies the starting index of the classifications to be returned
#' @param count Specifies that the total count of records in the dataProduct should be included in the info section
#' @param distinct Specifies that only distinct values should be returned
#' @param facts Specifies that any facts available should be included in the returned metadata
#' @param freqs Specifies that any frequencies available should be included in the returned metadata
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param key API key for dataProducts that require a key. 
#' @param rowLimit Specifies the number of records to return
#' @param offset Specifies the starting index of the records
#' @param orderby Describes how the results should be ordered
#' @param sleep Specifies the time to wait between each query to the server in order to not overwhelm the server. Default is 0.2 seconds.
#' @param stats Specifies that any summary statistics available should be included in the returned 
#' @param where Describes how to subset the records
#' @param cellLimit Specifies maximum number of cells that can be returned - defaults to 10,000
#' @keywords select
#' @export
#' @examples
#' select("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="var1,var2") 
#' select("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="var1,var2",where="var1<1 AND var2>=3") 
#' select("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="var1,var2",orderby="var1 DESC,var2 ASC") 
#' select("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="var1,var2",distinct=TRUE,limit=100,offset=100,count=TRUE) 
#' select("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",cols="$demographics",inject=TRUE) 
select <- function(url, catalog, dataProduct, inject=FALSE, autoPage=TRUE, classLimit=NULL, classOffset=NULL, codeEquals=NULL, codeLimit=NULL, codeOffset=NULL,
                   cols=NULL, colLimit=NULL, colOffset=NULL, count=FALSE, distinct=FALSE, facts=FALSE, freqs=FALSE, 
                    key=NULL, rowLimit=NULL, offset=NULL, orderby=NULL, sleep=0.2, stats=FALSE, where=NULL, metadata=FALSE, cellLimit=10000){
  # get the initial data set that we will append information to. 
  dataSet <- selectPage(url,catalog,dataProduct,inject,cols,where,orderby,distinct,rowLimit,offset,colLimit,colOffset,
                        classLimit,classOffset,codeEquals,codeLimit,codeOffset,facts,freqs,stats,count=TRUE,key, metadata)

  #create a list of data sets that will be appended to each other to build up all the columns in the final dataset
  i <- 1
  dataSets <- list()
  data <- dataSet@data
  info <- dataSet@info
  columnInfo <- info
  columnCount <- columnInfo$columnCount
  if(!is.null(rowLimit) && rowLimit*columnCount <= cellLimit){
    autoPage = false;
  }else if(!is.null(rowLimit)&& rowLimit > cellLimit){
    autoPage = true;
  }
  if(autoPage){
    # adjust limit
    rowLimit = floor(cellLimit/columnCount);
  }
  
  if(autoPage){
    # get all the columns through multiple calls to selectPage
    while(columnInfo$moreColumns){
      Sys.sleep(sleep)
      colOffset <- columnInfo$columnOffset + columnInfo$columnLimit
  
      colDataSet <- selectPage(url,catalog,dataProduct,inject,cols,where,orderby,distinct,rowLimit,offset,colLimit,colOffset,
                               classLimit,classOffset,codeEquals,codeLimit,codeOffset,facts,freqs,stats,count=FALSE,key,metadata)
      
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
   
    # set up list of data sets
    i <- 1
    dataSets <- list()
    dataSets[[i]] <- data
    
    # set up info used for pagination
    rowInfo <- info
  } 
  
  # we will grab the metadata once and use it for the resulting data set
  variables <- dataSet@variables
  classifications <- dataSet@classifications 

  if(autoPage){
    while(rowInfo$moreRows){
      Sys.sleep(sleep)
      #only get the metadata (variables) once and store it, so that you can just continue to build up the dataset
      getMetadata=FALSE
      if(i == 1){
        getMetadata=TRUE
        offset<- rowInfo$rowOffset
      }else{
        offset <- offset+rowInfo$rowLimit
      }
     
      colOffset=0
      colLimit = info$columnCount
      rowDataSet <- selectPage(url,catalog,dataProduct,inject=FALSE,cols,where,orderby,distinct,rowLimit,offset,colLimit,colOffset,classLimit,classOffset,
                               codeEquals,codeLimit,codeOffset,facts,freqs,stats,count=FALSE,key,metadata=getMetadata)
      #the first time through, get the variables from the data set and store them. the second time through, use this stored list since you're not getting the metadata
      if(i == 1){
        variables<- rowDataSet@variables
      }else{
        rowDataSet@variables <- variables
      }
      i <- i+1
      dataSets[[i]] <- rowDataSet@data
      rowInfo <- rowDataSet@info
      rowOffset <- rowInfo$rowOffset
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
  
  # return a new RDS data set object with the data and the info
  dataSet <- new("rds.dataset", variables = variables, data = data, info = info)
  return(dataSet)
}

selectPage <- function(url,catalog,dataProduct,inject=FALSE,cols=NULL,where=NULL,orderby=NULL,
                       distinct=FALSE,rowLimit=NULL,offset=NULL,colLimit=NULL,colOffset=NULL,
                       classLimit=NULL,classOffset=NULL,codeEquals=NULL,codeLimit=NULL,codeOffset=NULL,
                       facts=FALSE,freqs=FALSE,stats=FALSE, count=FALSE,key=NULL,metadata=FALSE){
  
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/select",sep="",collapse=NULL)
  if(metadata){
    request <- paste(request,"?metadata=TRUE",sep="",collapse=NULL)
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
  if(!is.null(rowLimit))  {
    request <- paste(request,"&limit=",rowLimit,sep="",collapse=NULL)
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
  
  if(!is.null(codeEquals))  {
    request <- paste(request,"&codeEquals=",codeEquals,sep="",collapse=NULL)
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
  if (inject) {
    request <- paste(request, "&inject=", inject, sep = "", collapse = NULL)
  }
  print(request)
  json <- jsonlite::fromJSON(request)
  # format the data and ensure the variable names are used as colnames in the data.frame 
  data <- data.frame(json$records)
  dataList <- json$records
  #put all of the variable names in a list and assign them to the columns.
  variableNames <- list();
  for(variable in json$variables){
    id    <- variable$id
    variableNames <- c(variableNames, id)
  }
  colnames(data)<-variableNames

  # format the info as a data.frame
  info <- data.frame(json$info)
  
  # return a new RDS data set object with the data and the info
  rds.variables <-new("rds.variables")
  if(metadata){
    rds.variables <- new("rds.variables", json=json$variables)
  }
  dataSet <- new("rds.dataset", variables = rds.variables,data = data, info = info)
  
  return(dataSet)
}

#' Tabulate Function
#'
#' This function allows you to use the tabulate function of RDS. 
#' @param url The base URL of the server RDS is running on
#' @param catalog The catalog ID
#' @param dataProduct The dataProduct ID
#' @param dimensions The names of the variables that should be used as dimensions
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param key API key for dataProducts that require a key. 
#' @param rowLimit Specifies the number of records to return
#' @param measures The variables that should be used as a measure, will be the count by default
#' @param offset Specifies the starting index of the records
#' @param orderby Describes how the results should be ordered
#' @param where Describes the subset of records the tabulation should run on
#' @keywords tabulate
#' @export
#' @examples
#' tabulate("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",dimensions="var1,var2") 
#' tabulate("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",dimensions="var1,var2",measures="AVG(var3)")
#' tabulate("http://localhost:8080/rds/api/catalog/","myCatalog","myDataProduct",dimensions="var1,var2",measures="AVG(var3)",where="var1!=5",inject=TRUE) 
tabulate <- function(url, catalog, dataProduct, dimensions=NULL, inject=FALSE, key=NULL, rowLimit=NULL, 
                     measures=NULL, offset=NULL, orderby=NULL,where=NULL, metadata=FALSE){
  
  # create the GET request and retrieve the JSON result
  request <- paste(url,catalog,"/",dataProduct,"/tabulate",sep="",collapse=NULL)
  
  # append any filled out options to the request 
  if(metadata){
    request <- paste(request,"?metadata=true",sep="",collapse=NULL)
  }else{
    request <- paste(request,"?metadata=FALSE",sep="",collapse=NULL)
  }
  
  if(inject){
    request <- paste(request,"&inject=true",sep="",collapse=NULL)
  }
  
  if(!is.null(dimensions)){
    request <- paste(request,"&dims=",dimensions,sep="",collapse=NULL)
  }
  
  if(!is.null(measures)){
    request <- paste(request,"&measures=",measures,sep="",collapse=NULL)
  }
  
  if(!is.null(where))  {
    request <- paste(request,"&where=",url_encode(where),sep="",collapse=NULL)
  }
  
  if(!is.null(orderby))  {
    request <- paste(request,"&orderby=",url_encode(orderby),sep="",collapse=NULL)
  }
  
  if(!is.null(rowLimit))  {
    request <- paste(request,"&rowLimit=",rowLimit,sep="",collapse=NULL)
  }
  
  if(!is.null(offset))  {
    request <- paste(request,"&offset=",offset,sep="",collapse=NULL)
  }
  
  if(!is.null(key))  {
    request <- paste(request,"&key=",key,sep="",collapse=NULL)
  }
  print(request)
  json <- jsonlite::fromJSON(request)
  # format the data and ensure the variable names are used as colnames in the data.frame 
  data <- data.frame(json$records)
 
  variableNames <- list();
  for(variable in json$variables){
    id    <- variable$id
    variableNames <- c(variableNames, id)
  }
  colnames(data)<-variableNames

  # format the info as a data.frame
  info <-data.frame(json$info) 
  variables <- new("rds.variables")

  if(!is.null(json$variables)){
    variables <- new("rds.variables", json=json$variables)
  }
  dataSet <- new("rds.dataset", variables = variables, data = data, info = info)
  return(dataSet)
}