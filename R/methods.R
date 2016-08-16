setGeneric("classification", function(metadata, class.id) standardGeneric("classification"))

setMethod("classification", signature("rds.metadata", "character"), function(metadata, class.id) {
  if(!is.null(metadata@json)){
    if(!is.null(metadata@json$classifications)){
      index <- match(c(class.id),metadata@json$classifications$resources$id)
      id    <- metadata@json$classifications$resources$id[index]
      codes <- metadata@json$classifications$resources$codes$resources[[index]]
      info  <- metadata@json$classifications$resources$codes$info[index,]
      classification <- new("rds.classification",id=id, codes=codes, info=info)
      return(classification)
    }
  }
})

setGeneric("classifications", function(metadata) standardGeneric("classifications"))

setMethod("classifications", signature("rds.metadata"), function(metadata) {
  if(!is.null(metadata@json)){
    if(!is.null(metadata@json$classifications)){
      classifications <- list()
      for(i in 1:length(metadata@json$classifications$resources$id)){
        id    <- metadata@json$classifications$resources$id[i]
        codes <- metadata@json$classifications$resources$codes$resources[[i]]
        info  <- metadata@json$classifications$resources$codes$info[i,]
        classification <- new("rds.classification",id=id, codes=codes, info=info)
        classifications <- c(classifications, classification)
      }
      return(classifications)
    }
  }
})

setGeneric("variable", function(metadata,var.id) standardGeneric("variable")) 

setMethod("variable", signature("rds.metadata", "character"), function(metadata, var.id) {
  if(!is.null(metadata@json)){
    variables <- metadata@json$variables$resources
    variable <- variables[variables$id==var.id,]
    return(variable)
  }
})

setGeneric("variables", function(metadata) standardGeneric("variables")) 

setMethod("variables", signature("rds.metadata"), function(metadata) {
  if(!is.null(metadata@json)){
    variables <- metadata@json$variables$resources
    return(variables)
  }
})