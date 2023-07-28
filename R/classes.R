#' Rich Data Services Server
#' 
#' The RDS server is the basis for the rest of the classes and acts as a reference point for all the API calls to be built from.
#'
#' @slot baseUrl The URL to access the base rds server information, swagger, or other server level information. This will also be used to build additional API calls from.
#' @slot name The name of the RDS server.
#' @slot version The version of the RDS server.
#' @slot disclaimer If there is any system wide disclaimer about the data stored in this RDS server there may be a disclaimer that relates to the data. This will be an empty string if there is no disclaimer.
#' @name rds.server-class
#' @rdname rds.server-class
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
#' @name rds.catalog-class
#' @rdname rds.catalog-class
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
#' @name rds.dataProduct-class
#' @rdname rds.dataProduct-class
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
    provenance = "character",
    restriction = "character"
  )
)

#' Rich Data Services Frequencies 
#' 
#'
#' @name rds.frequency-class
#' @rdname rds.frequency-class
#' @exportClass rds.frequency
setClass(
  "rds.frequency",
  representation(
    weighted = "logical",
    weights = "list",
    frequencies ="data.frame"
  )
)

#' Rich Data Services Statistics
#' 
#' 
#' @name rds.statistics-class
#' @rdname rds.statistics-class
#' @exportClass rds.statistics
setClass(
  "rds.statistics",
  representation(
    weighted = "logical",
    weights = "list",
    distinct = "numeric",
    max = "numeric",
    mean = "numeric",
    median = "numeric",
    min = "numeric",
    missing = "numeric",
    populated = "numeric",
    standardDeviation = "numeric",
    variance = "numeric"
  )
)

#' Rich Data Services reserved values. Reserved values are codes that are set at the variable level (not classification) to identify values with special meaning amongst other non coded values.
#' 
#' 
#' @name rds.reservedValue-class
#' @rdname rds.reservedValue-class
#' @exportClass rds.reservedValue
setClass(
  "rds.reservedValue",
  representation(
    codeValue = "character",
    computable = "logical",
    name = "character"
  )
)

#' Rich Data Services Variable 
#' 
#' A variable containg the metadata round a column of data. This will provide information about the variable, what it is, the codes that apply to it and summary statistics. 
#' 
#' @slot id The variable ID.
#' @slot name The variable name.
#' @slot label The variable label.
#' @slot description The variable description. 
#' @slot questionText The question that was asked to get a response. This applies to variables whose data was collected through surveys.
#' @slot dataType The data type of the variable. This is a harmonized type that is used accross all data sources regardless of how the data is stored in the back. This is the property that should be evaluated if variable information or data needs to be displayed differently based on type. 
#' @slot storageType The data type that the variable is stored as in the back end data source. This is specific to the source and cannot be counted on to be the same accross all variables on the RDS server.
#' @slot fixedStorageWidth The width of the variable in a fixed file.
#' @slot startPosition The start position of the variables data in the context of a fixed file.
#' @slot endPosition The end position of the variables data in the context of a fixed file.
#' @slot decimals The number of decimal places the variables data may have.
#' @slot classificationId If the variable has a classification associated with it its ID will be here. This can be used for display or query purposes, however, the classificationUri will result in faster queries so that should be used for querying.
#' @slot classificationUri If the variable has a classification associated with it its URI will be here. This can be used for query purposes.
#' @slot index The index of the variable in the data product.
#' @slot reference Indicates if the variable is a reference. If true, this variable will not contain the full variable metadata, and the variable metadata should be retrieved from the server if more detail about the variable is desired.
#' @slot isDimension Indicates if the variable can be used as a dimension or not in tabulations.
#' @slot isMeasure Indicates if the variable can be used as a measure or not in tabulations.
#' @slot isRequired Indicates if the variable should always be included in the results or not.
#' @slot isWeight Indicates if the variable can be used as a weight.
#' @slot statistics A list of rds.statistics objects that potentially contains weighted or non weighted summary statistics of the variables values.
#' @slot frequencies A list of rds.frequency objects that potentially contains weighted or non weighted frequencies of the variables values.
#' @name rds.variable-class
#' @rdname rds.variable-class
#' @exportClass rds.variable
setClass(
  "rds.variable",
  representation(
    id = "character",
    name = "character",
    label = "character",
    description = "character",
    questionText = "character",
    universe = "character",
    note = "character",
    exclusion = "character",
    dataType = "character",
    storageType = "character",
    fixedStorageWidth = "numeric",
    startPosition = "numeric",
    endPosition = "numeric",
    decimals = "numeric",
    classificationId = "character",
    classificationUri = "character",
    index = "numeric",
    reference = "logical",
    isDimension = "logical",
    isDisclosive = "logical",
    isGeographical = "logical",
    isMeasure = "logical",
    isRequired = "logical",
    isTemporal = "logical",
    isWeight = "logical",
    reservedValues ="list",
    statistics ="list",
    frequencies ="list"
  )
)

#' Rich Data Services Data Set
#'
#' A data set contains the three main sections of an RDS query, metadata, data, and info. The metadata may or may not be present depending on what was requested in the query. If it is it will contain variable and classification metadata if available. The data will contain the actual data values that are returned from the query. The info will contain information about the query ran including the any limits, whether or not more columns or rows are available, and a total row count if available.
#'
#' @slot variables A data frame of the variable information of the variables included in the query
#' @slot records A data frame of the records returned.
#' @slot totals A data frame of the totals returned (tabulation only).
#' @slot info A data frame of the query information.
#' @name rds.dataset-class
#' @rdname rds.dataset-class
#' @exportClass rds.dataset
setClass(
  "rds.dataset",
  representation(
    variables = "list",
    records = "data.frame",
    totals = "data.frame",
    info = "data.frame"
  )
)
