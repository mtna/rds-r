
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
setClass("rds.dataset", representation(variables="data.frame",classifications="data.frame",data="data.frame",info="data.frame"))