#' Rich Data Services Server
#' 
#' The RDS server is the basis for the rest of the classes and acts as a reference point for all the API calls to be built from.
#'
#' @slot baseUrl The URL to access the base rds server information, swagger, or other server level information. This will also be used to build additional API calls from.
#' @slot name The name of the RDS server.
#' @slot version The version of the RDS server.
#' @slot disclaimer If there is any system wide disclaimer about the data stored in this RDS server there may be a disclaimer that relates to the data. This will be an empty string if there is no disclaimer.
#' @name rds.server
#' @rdname rds.server
#' @exportClass rds.server
setClass(
  "rds.server",
  representation(
    baseUrl = "character",
    name = "character",
    version = "character",
    disclaimer = "character"
  )
)


#' Rich Data Services Catalog
#' 
#' A catalog provides basic information about the data products it contains and the data in them. It will also carry the server along to build up the API calls for itself and any data products under it.
#' 
#' @slot server The server this catalog is a part of.
#' @slot id The catalog ID.
#' @slot description The catalog description. This may contain embedded HTML.
#' @slot label The catalog label.
#' @slot name The catalog name.
#' @slot dataProductCount The number of data products stored in the catalog
#' @name rds.catalog
#' @rdname rds.catalog
#' @exportClass rds.catalog
setClass(
  "rds.catalog",
  representation(
    server = "rds.server",
    id = "character",
    description = "character",
    label = "character",
    name = "character",
    dataProductCount = "numeric"
  )
)


#' Rich Data Services Data Product
#' 
#' A data product serves as the basis of which to query data and metadata. It also provides basic information about the data.
#' 
#' @slot catalog The catalog this data product is a part of.
#' @slot id The data product ID.
#' @slot citation The data product citation. This may contain embedded HTML.
#' @slot description The data product description. This may contain embedded HTML.
#' @slot label The data product label.
#' @slot lastUpdate A timestamp indicating when the data product was last updated.
#' @slot name The data product name.
#' @slot note Additional information or notes about the data product. This may contain embedded HTML.
#' @slot provenance Information about where the data product originated from or who owns it. This may contain embedded HTML.
#' @slot restriction Information about any restrictions that may apply to the data of this data product. This may contain embedded HTML.
#' @name rds.dataProduct
#' @rdname rds.dataProduct
#' @exportClass rds.dataProduct
setClass(
  "rds.dataProduct",
  representation(
    catalog = "rds.catalog",
    id = "character",
    citation = "character",
    description = "character",
    label = "character",
    lastUpdate = "POSIXct",
    name = "character",
    note = "character",
    provinence = "character",
    restriction = "character"
  )
)

#' Rich Data Services Data Set
#'
#' A data set contains the three main sections of an RDS query, metadata, data, and info. The metadata may or may not be present depending on what was requested in the query. If it is it will contain variable and classification metadata if available. The data will contain the actual data values that are returned from the query. The info will contain information about the query ran including the any limits, whether or not more columns or rows are available, and a total row count if available.
#'
#' @slot variables A data frame of the variable information of the variables included in the query
#' @slot classifications A data frame of the classification information for the classificaitons included in the query.
#' @slot data A data frame of the records returned.
#' @slot info A data frame of the query information.
#' @name rds.dataset
#' @rdname rds.dataset
#' @exportClass rds.dataset
setClass(
  "rds.dataset",
  representation(
    variables = "data.frame",
    classifications = "data.frame",
    data = "data.frame",
    info = "data.frame"
  )
)
