library(jsonlite)


#' Get Catalogs
#'
#' The getCatalogs(server) method can be used to get all the catalogs from the provided rds.server.
#'
#' @slot server The server to query for the catalogs.
#' @name getCatalogs
#' @rdname rds.server
#' @exportMethod getCatalogs
setGeneric("getCatalogs", function(server)
  standardGeneric("getCatalogs"))

#' @exportMethod getCatalogs
setMethod("getCatalogs", signature("rds.server"), function(server) {
  # Query the server for all the catalogs
  catalogsUrl <-
    paste(server@baseUrl,
          "/api/catalog",
          sep = "",
          collapse = NULL)
  response <- jsonlite::fromJSON(catalogsUrl)
  catalogs <- response[[1]]
  
  # Build the catalog classes
  rdsCatalogs = c()
  for (catalogIndex in 1:nrow(catalogs)) {
    rdsCatalog <- new(
      "rds.catalog",
      server = server,
      id = catalogs[catalogIndex, "id"],
      description = ifelse(is.null(catalogs[catalogIndex, "description"]), "", catalogs[catalogIndex, "description"]),
      label = ifelse(is.null(catalogs[catalogIndex, "label"]), "", catalogs[catalogIndex, "label"]),
      name = ifelse(is.null(catalogs[catalogIndex, "name"]), "", catalogs[catalogIndex, "name"]),
      dataProductCount = ifelse(is.null(nrow(catalogs[catalogIndex, "dataProducts"][[1]])), 0, nrow(catalogs[catalogIndex, "dataProducts"][[1]]))
    )
    rdsCatalogs <- append(rdsCatalogs, rdsCatalog)
  }
  
  return (rdsCatalogs)
})


#' Get Catalog
#'
#' The getCatalog(server, catalogId) method can be used to get the catalog with the provided ID from the provided rds.server.
#'
#' @slot server The server to query for the catalog.
#' @slot catalogId The ID of the desired catalog.
#' @name getCatalog
#' @rdname rds.server
#' @exportMethod getCatalog
setGeneric("getCatalog", function(server, catalogId)
  standardGeneric("getCatalog"))

#' @exportMethod getCatalog
setMethod("getCatalog", signature("rds.server", "character"), function(server, catalogId) {
  # TODO we need to change this to handle a 404 from a bad catalog ID rather than iterating through the entire list of catalogs
  
  # Query the server for all the catalogs
  catalogsUrl <-
    paste(server@baseUrl,
          "/api/catalog",
          sep = "",
          collapse = NULL)
  response <- jsonlite::fromJSON(catalogsUrl)
  catalogs <- response[[1]]
  
  # Build the catalog class
  rdsCatalog <- NULL
  for (catalogIndex in 1:nrow(catalogs)) {
    id <- catalogs[catalogIndex, "id"]
    if (catalogId == id) {
      rdsCatalog <- new(
        "rds.catalog",
        server = server,
        id = id,
        description = ifelse(is.null(catalogs[catalogIndex, "description"]), "", catalogs[catalogIndex, "description"]),
        label = ifelse(is.null(catalogs[catalogIndex, "label"]), "", catalogs[catalogIndex, "label"]),
        name = ifelse(is.null(catalogs[catalogIndex, "name"]), "", catalogs[catalogIndex, "name"]),
        dataProductCount = ifelse(is.null(nrow(catalogs[catalogIndex, "dataProducts"][[1]])), 0, nrow(catalogs[catalogIndex, "dataProducts"][[1]]))
      )
      break
    }
  }
  
  # Throw error if we cannot find the catalog.
  if (is.null(rdsCatalog)) {
    stop(
      paste(
        "No catalog could be found with the ID [",
        catalogId,
        "]",
        sep = "",
        collapse = NULL
      )
    )
  }
  
  return (rdsCatalog)
})

#' Get Data Products
#' 
#' The getDataProducts(catalog) method can be used to retrieve all the data products from the provided catalog. 
#' 
#' @slot catalog The catalog to query for the data products.
#' @name getDataProducts
#' @rdname rds.catalog
#' @exportMethod getDataProducts
setGeneric("getDataProducts", function(catalog)
  standardGeneric("getDataProducts"))

#' @exportMethod getDataProducts
setMethod("getDataProducts", signature("rds.catalog"), function(catalog) {
  # Set up the request URL
  server <- catalog@server
  dataProductsUrl <-
    paste(server@baseUrl,
          "/api/catalog/",
          catalog@id,
          sep = "",
          collapse = NULL)
  
  response <- jsonlite::fromJSON(dataProductsUrl)
  dataProducts = response[[1]]
  
  # Build the data product classes
  rdsDataProducts = c()
  for (productIndex in 1:nrow(dataProducts)) {
    rdsProduct <- new(
      "rds.dataProduct",
      catalog = catalog,
      id = dataProducts[productIndex, "id"],
      citation = ifelse(is.null(dataProducts[productIndex, "citation"]), "", dataProducts[productIndex, "citation"]),
      description = ifelse(is.null(dataProducts[productIndex, "description"]), "", dataProducts[productIndex, "description"]),
      label = ifelse(is.null(dataProducts[productIndex, "label"]), "", dataProducts[productIndex, "label"]),
      lastUpdate = as.POSIXct(dataProducts[productIndex, "lastUpdate"], format = "%Y-%m-%dT%H:%M:%OSZ"),
      name = ifelse(is.null(dataProducts[productIndex, "name"]), "", dataProducts[productIndex, "name"]),
      note = ifelse(is.null(dataProducts[productIndex, "note"]), "", dataProducts[productIndex, "note"]),
      provinence = ifelse(is.null(dataProducts[productIndex, "provinence"]), "", dataProducts[productIndex, "provinence"]),
      restriction = ifelse(is.null(dataProducts[productIndex, "restriction"]), "", dataProducts[productIndex, "restriction"])
    )
    rdsDataProducts <- append(rdsDataProducts, rdsProduct)
  }
  
  return (rdsDataProducts)
})

#' Get Data Product
#' 
#' The getDataProduct(catalog, dataProductId) method can be used to get the data product with the provided ID from the provided rds.catalog.
#' 
#' @slot catalog The catalog to query for the data product.
#' @slot dataProductId The ID of the desired data product.
#' @name getDataProduct
#' @rdname rds.catalog
#' @exportMethod getDataProduct
setGeneric("getDataProduct", function(catalog, dataProductId)
  standardGeneric("getDataProduct"))

#' @exportMethod getDataProduct
setMethod("getDataProduct", signature("rds.catalog", "character"), function(catalog, dataProductId) {
  # TODO we need to change this to handle a 404 from a bad data product ID rather than iterating through the entire list of data products
  
  # Set up the request URL
  server <- catalog@server
  dataProductsUrl <-
    paste(server@baseUrl,
          "/api/catalog/",
          catalog@id,
          sep = "",
          collapse = NULL)
  
  response <- jsonlite::fromJSON(dataProductsUrl)
  dataProducts = response[[1]]
  
  # Build the data product classes
  rdsDataProduct = NULL
  for (productIndex in 1:nrow(dataProducts)) {
    id <- dataProducts[productIndex, "id"]
    if (dataProductId == id) {
      rdsDataProduct <- new(
        "rds.dataProduct",
        catalog = catalog,
        id = id,
        citation = ifelse(is.null(dataProducts[productIndex, "citation"]), "", dataProducts[productIndex, "citation"]),
        description = ifelse(is.null(dataProducts[productIndex, "description"]), "", dataProducts[productIndex, "description"]),
        label = ifelse(is.null(dataProducts[productIndex, "label"]), "", dataProducts[productIndex, "label"]),
        lastUpdate = as.POSIXct(dataProducts[productIndex, "lastUpdate"], format = "%Y-%m-%dT%H:%M:%OSZ"),
        name = ifelse(is.null(dataProducts[productIndex, "name"]), "", dataProducts[productIndex, "name"]),
        note = ifelse(is.null(dataProducts[productIndex, "note"]), "", dataProducts[productIndex, "note"]),
        provinence = ifelse(is.null(dataProducts[productIndex, "provinence"]), "", dataProducts[productIndex, "provinence"]),
        restriction = ifelse(is.null(dataProducts[productIndex, "restriction"]), "", dataProducts[productIndex, "restriction"])
      )
      break
    }
  }
  
  # Throw error if we cannot find the data product.
  if (is.null(rdsDataProduct)) {
    stop(
      paste(
        "No data product [",
        dataProductId,
        "] could be found in the catalog [",
        catalog@id,
        "]",
        sep = "",
        collapse = NULL
      )
    )
  }
  
  return (rdsDataProduct)
})

# get a classification
setGeneric("classification", function(classifications, id)
  standardGeneric("classification"))

setMethod("classification", signature("data.frame", "character"), function(classifications, id) {
  if (!is.null(classifications)) {
    for (i in 1:nrow(classifications)) {
      if (classifications$id[i] == id) {
        df <- data.frame(classifications[i,])
        return(df)
      }
    }
  }
})

#get a specific variable from a dataframe, returned in a dataframe
setGeneric("variable", function(variables, id)
  standardGeneric("variable"))

setMethod("variable", signature("data.frame", "character"), function(variables, id) {
  df <- data.frame
  if (!is.null(variables)) {
    for (i in 1:nrow(variables)) {
      row <- variables[i,]
      if (row["id"] == id) {
        df <- data.frame(row)
      }
    }
  }
  return(df)
})

#pass in a list of variables and transform it to a data.frame (tibble)
setGeneric("variablesFromList", function(jsonList)
  standardGeneric("variablesFromList"))

setMethod("variablesFromList", signature("list"), function(jsonList) {
  propertyIndex <- 1
  varIndex = 1
  #add all of the variables to a list that will be binded into a data.frams
  dataList = list()
  
  # l<-vector("list", length(variable))
  for (variable in jsonList) {
    # l<-names(variable)
    # l<-unique(l)
    
    dataList[[propertyIndex]] <- variable
    propertyIndex <- propertyIndex + 1
  }
  #create data frame, bind variables from list, and set column nmaes
  df <- data.frame()
  df <- dplyr::bind_rows(dataList)
  return(df)
  
})