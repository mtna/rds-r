#' Rich Data Services Classification
#' 
#' A classification contains its ID, the codes and values of the classification, and information about the query run to select the classfication and its codes. 
#'
#' \describe{
#'    \item{id}{The classification ID.}
#'    
#'    \item{codes}{The codes and code values of the classification.}
#'    
#'    \item{codeCount}{The number of codes on a classificatino.}
#'  }
#' @name rds.classification-class
#' @rdname rds.classification-class
#' @exportClass rds.classification
#' setClass("rds.classification", representation(id="character", codes="data.frame", info="data.frame"))
setClass("rds.classification", representation(id="character", uri="character", name="character", codeCount="numeric", levelCount="numeric",codes="data.frame" ))

#' Rich Data Services Variables
#' 
#' A list of variable objects containing their metadata. 
#'
#' \describe{
#'    \item{json}{The variable json returned from a query.}
#'  }
#' @name rds.variables-class
#' @rdname rds.variables-class
#' @exportClass rds.variables
setClass("rds.variables", representation(json="list"))


#' Rich Data Services Classifications
#' 
#' A list of classification objects containing their metadata. 
#'
#' \describe{
#'    \item{json}{The classification json returned from a query.}
#'  }
#' @name rds.classifications-class
#' @rdname rds.classifications-class
#' @exportClass rds.classifications
setClass("rds.classifications", representation(json="list"))

# TODO take out metadata, add in classifications 

#' Rich Data Services Data Set
#'
#' A Data Set contains the three main sections of an RDS result, metadata, data, and info. 
#' The metadata may or may not be present. If it is it will contain variable and classification metadata if available
#' The data will contain the actual data values that are returned from the query.
#' The info will contain information about the query ran including the any limits, whether or not more columns or rows are available, and a total row count if available. 
#'
#' \describe{
#' 
#'    \item{data}{Data returned from a query.}
#'
#'    \item{info}{Information about the query ran.}
#'    
#'    \item{variables}{List of variables and their metadata.}
#'    
#'  }
#' @name rds.dataset-class
#' @rdname rds.dataset-class
#' @exportClass rds.dataset
setClass("rds.dataset", representation(variables="rds.variables",classifications="rds.classifications",data="data.frame",info="data.frame"))