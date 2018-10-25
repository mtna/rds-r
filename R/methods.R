setGeneric("classification", function(classificationsMetadata, class.id) standardGeneric("classification"))

setMethod("classification", signature("list", "character"), function(classificationsMetadata, class.id) {
  if(!is.null(classificationsMetadata)){
      # TODO this would be better to use index instead of for/if, but can't figure it out
      # index <- match(c(class.id),metadata@json$classifications$resources$id)
    #index <- match(c(class.id),classificationsMetadata$id)
      for(i in 1:length(classificationsMetadata)){
        if(classificationsMetadata[[i]]@id==class.id){
          id    <- classificationsMetadata[[i]]@id
          keywordCount <- classificationsMetadata[[i]]@name
          codes <- classificationsMetadata[[i]]@codes
          levelCount <- classificationsMetadata[[i]]@levelCount
          uri <- classificationsMetadata[[i]]@uri
          codeCount <- classificationsMetadata[[i]]@codeCount
          name <- classificationsMetadata[[i]]@name
          classification <- new("rds.classification",id=id, uri=uri, name=name, codeCount=codeCount, levelCount=levelCount,codes=codes)
          return(classification)
        }
      }
  }
})

#TODO rewriting classifications method to get them not from metadata
#TODO add way to get codes - make a separate call?
setGeneric("classifications", function(classificationsMetadata) standardGeneric("classifications"))

setMethod("classifications", signature("rds.classifications"), function(classificationsMetadata) {
  if(!is.null(classificationsMetadata@json)){
      classifications <- list()
      codes <- list()
    
      for(i in 1:length(classificationsMetadata@json)){
        id    <- classificationsMetadata@json[[i]]@id
        name <- classificationsMetadata@json[[i]]@name
        codes <- classificationsMetadata@json[[i]]@codes
        levelCount <- classificationsMetadata@json[[i]]@levelCount
        uri <- classificationsMetadata@json[[i]]@uri
        codeCount <- classificationsMetadata@json[[i]]@codeCount
        classification <- new("rds.classification",id=id, uri=uri, name=name, codeCount=codeCount, levelCount=levelCount,codes=codes)
        classifications <- c(classifications, classification)
      }
      return(classifications)
   }
})

setGeneric("variable", function(variables,var.id) standardGeneric("variable")) 

setMethod("variable", signature("rds.variables", "character"), function(variables, var.id) {
  if(!is.null(variables@json)){
    matchedVar <- match(var.id, names(variables@json))
    return(variables@json[[matchedVar]])
  }
})