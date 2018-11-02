setGeneric("classification", function(classifications, id) standardGeneric("classification"))

setMethod("classification", signature("data.frame", "character"), function(classifications, id) {
  if(!is.null(classifications)){
      for(i in 1:nrow(classifications)){
        if(classifications$id[i]==id){
          df <- data.frame(classifications[i,])
          return(df)
        }
      }
  }
})

#get a specific variable from a dataframe, returned in a dataframe
setGeneric("variable", function(variables,id) standardGeneric("variable")) 

setMethod("variable", signature("data.frame", "character"), function(variables, id) {
  df<-data.frame
  if(!is.null(variables)){
    for(i in 1:nrow(variables)){
         row<-variables[i,]
      if(row["id"]==id){
        df <- data.frame(row)
      }
    }
  }
  return(df)
})

#pass in a list of variables and transform it to a data.frame (tibble)
setGeneric("variablesFromList", function(jsonList) standardGeneric("variablesFromList")) 

setMethod("variablesFromList", signature("list"), function(jsonList) {
  
    propertyIndex<-1
    varIndex=1
    #add all of the variables to a list that will be binded into a data.frams
    dataList=list()
    
   # l<-vector("list", length(variable))
    for(variable in jsonList){
      # l<-names(variable)
      # l<-unique(l)
     
      dataList[[propertyIndex]]<-variable
      propertyIndex<-propertyIndex+1
    }
    #create data frame, bind variables from list, and set column nmaes
    df<-data.frame()
    df<-dplyr::bind_rows(dataList)
    return(df)
  
})