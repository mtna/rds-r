#' Rich Data Services Classification
#' 
#' A classification contains its ID, the codes and values of the classification, and information about the query run to select the classfication and its codes. 
#'
#' \describe{
#'    \item{id}{The classification ID.}
#'    
#'    \item{codes}{The codes and code values of the classification.}
#'    
#'    \item{info}{The information about the query run.}
#'  }
#' @name rds.classification-class
#' @rdname rds.classification-class
#' @exportClass rds.classification
setClass("rds.classification", representation(id="character", codes="data.frame", info="data.frame"))

#' Rich Data Services Metadata
#' 
#' Metadata consists of variable and classification metadata. The metadata class gives users a way to access the metadata in convenient ways. 
#'
#' \describe{
#'    \item{json}{The metadata json returned from a query.}
#'  }
#' @name rds.metadata-class
#' @rdname rds.metadata-class
#' @exportClass rds.metadata
setClass("rds.metadata", representation(json="list"))

#' Rich Data Services Data Set
#'
#' A Data Set contains the three main sections of an RDS result, metadata, data, and info. 
#' The metadata may or may not be present. If it is it will contain variable and classification metadata if available
#' The data will contain the actual data values that are returned from the query.
#' The info will contain information about the query ran including the any limits, whether or not more columns or rows are available, and a total row count if available. 
#'
#' \describe{
#'    \item{metadata}{Variable and classification metadata to accompany the data returned.}
#' 
#'    \item{data}{Data returned from a query.}
#'
#'    \item{info}{Information about the query ran.}
#'  }
#' @name rds.dataset-class
#' @rdname rds.dataset-class
#' @exportClass rds.dataset
setClass("rds.dataset", representation(metadata="rds.metadata",data="data.frame",info="data.frame"))