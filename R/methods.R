#' Get Catalogs
#'
#' The getCatalogs(server) method can be used to get all the catalogs from the provided rds.server.
#'
#' @param server The server to query for the catalogs.
#' @name getCatalogs
#' @rdname getCatalogs
#' @exportMethod getCatalogs
setGeneric("getCatalogs", function(server)
  standardGeneric("getCatalogs"))

#' Get Catalogs
#'
#' The getCatalogs(server) method can be used to get all the catalogs from the provided rds.server.
#'
#' @import jsonlite
#' @param server The server to query for the catalogs.
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
#' @param server The server to query for the catalog.
#' @param catalogId The ID of the desired catalog.
#' @name getCatalog
#' @rdname getCatalog
#' @exportMethod getCatalog
setGeneric("getCatalog", function(server, catalogId)
  standardGeneric("getCatalog"))

#' Get Catalog
#'
#' The getCatalog(server, catalogId) method can be used to get the catalog with the provided ID from the provided rds.server.
#'
#' @import jsonlite
#' @param server The server to query for the catalog.
#' @param catalogId The ID of the desired catalog.
setMethod("getCatalog", signature("rds.server", "character"), function(server, catalogId) {
  # Query the server for the specified catlog
  rdsCatalog <- NULL
  tryCatch({
    catalogUrl <- paste(
      server@baseUrl,
      "/api/catalog/",
      catalogId,
      sep = "",
      collapse = NULL
    )
    catalog <- jsonlite::fromJSON(catalogUrl)
    rdsCatalog <- new(
      "rds.catalog",
      server = server,
      id = catalog$id,
      description = ifelse(is.null(catalog$description), "", catalog$description),
      label = ifelse(is.null(catalog$label), "", catalog$label),
      name = ifelse(is.null(catalog$name), "", catalog$name),
      dataProductCount = ifelse(is.null(nrow(
        catalog$dataProducts
      )), 0, nrow(catalog$dataProducts))
    )
  },
  error = function(e) {
    # RDS Catalog will remain null
  })
  
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
#' @import jsonlite
#' @param catalog The catalog to query for the data products.
#' @name getDataProducts
#' @rdname getDataProducts
#' @exportMethod getDataProducts
setGeneric("getDataProducts", function(catalog)
  standardGeneric("getDataProducts"))

#' Get Data Products
#'
#' The getDataProducts(catalog) method can be used to retrieve all the data products from the provided catalog.
#'
#' @import jsonlite
#' @param catalog The catalog to query for the data products.
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
      provenance = ifelse(is.null(dataProducts[productIndex, "provenance"]), "", dataProducts[productIndex, "provenance"]),
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
#' @param catalog The catalog to query for the data product.
#' @param dataProductId The ID of the desired data product.
#' @name getDataProduct
#' @rdname getDataProduct
#' @exportMethod getDataProduct
setGeneric("getDataProduct", function(catalog, dataProductId)
  standardGeneric("getDataProduct"))

#' Get Data Product
#'
#' The getDataProduct(catalog, dataProductId) method can be used to get the data product with the provided ID from the provided rds.catalog.
#'
#' @import jsonlite
#' @param catalog The catalog to query for the data product.
#' @param dataProductId The ID of the desired data product.
setMethod("getDataProduct", signature("rds.catalog", "character"), function(catalog, dataProductId) {
  # Get the server from the catalog
  server <- catalog@server
  
  # Query the server for the specified data product
  rdsDataProduct <- NULL
  tryCatch({
    dataProductUrl <- paste(
      server@baseUrl,
      "/api/catalog/",
      catalog@id,
      "/",
      dataProductId,
      sep = "",
      collapse = NULL
    )
    dataProduct <- jsonlite::fromJSON(dataProductUrl)
    rdsDataProduct <- new(
      "rds.dataProduct",
      catalog = catalog,
      id = dataProduct$id,
      citation = ifelse(is.null(dataProduct$citation), "", dataProduct$citation),
      description = ifelse(
        is.null(dataProduct$description),
        "",
        dataProduct$description
      ),
      label = ifelse(is.null(dataProduct$label), "", dataProduct$label),
      lastUpdate = as.POSIXct(dataProduct$lastUpdate, format = "%Y-%m-%dT%H:%M:%OSZ"),
      name = ifelse(is.null(dataProduct$name), "", dataProduct$name),
      note = ifelse(is.null(dataProduct$note), "", dataProduct$note),
      provenance = ifelse(
        is.null(dataProduct$provenance),
        "",
        dataProduct$provenance
      ),
      restriction = ifelse(
        is.null(dataProduct$restriction),
        "",
        dataProduct$restriction
      )
    )
  },
  error = function(e) {
    # RDS Data Product will remain null
  })
  
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

#' Get Variables
#'
#' The getVariables(dataProduct) method can be used to get the variable summaries of all the with the provided ID from the provided rds.dataProduct.
#'
#' @param dataProduct The rds.dataProduct to query for the variable.
#' @param cols An optional variable query following the RDS column syntax. If left NULL all the variable will be returned.
#' @param collimit An optional limit to the variables returned. If left NULL no limit will be applied.
#' @param coloffset An optional offset to the variables returned. If left NULL no offset will be applied
#' @name getVariables
#' @rdname getVariables
#' @exportMethod getVariables
setGeneric("getVariables", function(dataProduct,
                                    cols = NULL,
                                    collimit = NULL,
                                    coloffset = NULL)
  standardGeneric("getVariables"))

#' Get Variables
#'
#' The getVariables(dataProduct) method can be used to get the variable summaries of all the with the provided ID from the provided rds.dataProduct.
#'
#' @import jsonlite
#' @param dataProduct The rds.dataProduct to query for the variable.
#' @param cols An optional variable query following the RDS column syntax. If left NULL all the variable will be returned.
#' @param collimit An optional limit to the variables returned. If left NULL no limit will be applied.
#' @param coloffset An optional offset to the variables returned. If left NULL no offset will be applied
setMethod("getVariables", signature("rds.dataProduct"), function(dataProduct,
                                                                 cols = NULL,
                                                                 collimit = NULL,
                                                                 coloffset = NULL) {
  # Get catalog
  catalog <- dataProduct@catalog
  
  # Get rds server
  rds <- catalog@server
  
  # Set up the get request
  variablesUrl <- paste(
    rds@baseUrl,
    "/api/catalog/",
    catalog@id,
    "/",
    dataProduct@id,
    "/variables",
    sep = "",
    collapse = NULL
  )
  
  # add the cols if not null
  paramPrefix = "?"
  if (!is.null(cols)) {
    variablesUrl <- paste(variablesUrl,
                          paramPrefix,
                          "cols=",
                          cols,
                          sep = "",
                          collapse = NULL)
    paramPrefix = "&"
  }
  
  if (!is.null(collimit)) {
    variablesUrl <- paste(
      variablesUrl,
      paramPrefix,
      "collimit=",
      collimit,
      sep = "",
      collapse = NULL
    )
    paramPrefix = "&"
  }
  if (!is.null(coloffset)) {
    variablesUrl <- paste(
      variablesUrl,
      paramPrefix,
      "coloffset=",
      coloffset,
      sep = "",
      collapse = NULL
    )
  }
  
  variables <- jsonlite::fromJSON(variablesUrl)
  return (variables)
})

#' Get Variable
#'
#' The getVariable(dataProduct, variableId) method can be used to get the variable with the provided ID from the provided rds.dataProduct.
#'
#' @param dataProduct The rds.dataProduct to query for the variable.
#' @param variableId The ID of the desired variable.
#' @name getVariable
#' @rdname getVariable
#' @exportMethod getVariable
setGeneric("getVariable", function(dataProduct, variableId)
  standardGeneric("getVariable"))

#' Get Variable
#'
#' The getVariable(dataProduct, variableId) method can be used to get the variable with the provided ID from the provided rds.dataProduct.
#'
#' @import jsonlite
#' @param dataProduct The rds.dataProduct to query for the variable.
#' @param variableId The ID of the desired variable.
setMethod("getVariable", signature("rds.dataProduct", "character"), function(dataProduct, variableId) {
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  server <- catalog@server
  
  # Query the server for the specified variable
  rdsVariable <- NULL
  tryCatch({
    variableUrl <- paste(
      server@baseUrl,
      "/api/catalog/",
      catalog@id,
      "/",
      dataProduct@id,
      "/variable/",
      variableId,
      sep = "",
      collapse = NULL
    )
    variable <- jsonlite::fromJSON(variableUrl)
    
    # Gather the variable frequencies and format them
    variableFrequencies <- list()
    if (!is.null(variable$frequencies)) {
      for (i in 1:nrow(variable$frequencies$sets)) {
        # Get the set to work with
        frequencySet <- variable$frequencies$sets[i,]
        
        # Weight properties
        weighted <- frequencySet$weighted
        weights <- ""
        
        # Set up the data frame
        setValues <- names(frequencySet$map)
        setFrequencies <- frequencySet$map[1, ]
        frequencyDf <- data.frame()
        for (freqIndex in 1:length(setValues)) {
          value <- setValues[freqIndex]
          
          dfRow <- data.frame(value, setFrequencies[1, value])
          frequencyDf <- rbind(frequencyDf, dfRow)
        }
        names(frequencyDf) <- c("Value", "Frequency")
        
        variableFrequency <- new(
          "rds.frequency",
          weighted = weighted,
          weights = weights,
          frequencies = frequencyDf
        )
        
        variableFrequencies <-
          append(variableFrequencies, variableFrequency)
      }
    }
    
    rdsVariable <- new(
      "rds.variable",
      dataProduct = dataProduct,
      id = variable$id,
      name = ifelse(is.null(variable$name), "", variable$name),
      label = ifelse(is.null(variable$label), "", variable$label),
      description = ifelse(is.null(variable$description), "", variable$description),
      questionText = ifelse(
        is.null(variable$questionText),
        "",
        variable$questionText
      ),
      dataType = ifelse(is.null(variable$dataType), "", variable$dataType),
      storageType = ifelse(is.null(variable$storageType), "", variable$storageType),
      fixedStorageWidth = ifelse(
        is.null(variable$fixedStorageWidth),
        0,
        variable$fixedStorageWidth
      ),
      startPosition = ifelse(
        is.null(variable$startPosition),
        0,
        variable$startPosition
      ),
      endPosition = ifelse(is.null(variable$endPosition), 0, variable$endPosition),
      decimals = ifelse(is.null(variable$decimals), 0, variable$decimals),
      classificationId = ifelse(
        is.null(variable$classificationId),
        "",
        variable$classificationId
      ),
      classificationUri = ifelse(
        is.null(variable$classificationUri),
        "",
        variable$classificationUri
      ),
      index = ifelse(is.null(variable$index), 0, variable$index),
      reference = ifelse(is.null(variable$reference), FALSE, variable$reference),
      isMeasure = ifelse(is.null(variable$isMeasure), FALSE, variable$isMeasure),
      isRequired = ifelse(is.null(variable$isRequired), FALSE, variable$isRequired),
      isWeight = ifelse(is.null(variable$isWeight), FALSE, variable$isWeight),
      frequencies = variableFrequencies
    )
  },
  error = function(e) {
    # RDS Data Product will remain null
    print(e)
  })
  
  # Throw error if we cannot find the variable.
  if (is.null(rdsVariable)) {
    stop(
      paste(
        "No variable [",
        variableId,
        "] could be found in the data product [",
        dataProduct@id,
        "]",
        sep = "",
        collapse = NULL
      )
    )
  }
  
  return (rdsVariable)
})



#' Get Classifications
#'
#' The getClassifications(dataProduct) method can be used to retrieve the descriptive information about all the classifications that are used in the data product.
#'
#' @param dataProduct The rds.dataProduct to query for classifications.
#' @param limit Specifies the number of classifications to return.
#' @param offset Specifies the starting index of the classifications.
#' @name getClassifications
#' @rdname getClassifications
#' @exportMethod getClassifications
setGeneric("getClassifications", function(dataProduct,
                                          limit = NULL,
                                          offset = NULL)
  standardGeneric("getClassifications"))

#' Get Classifications
#'
#' The getClassifications(dataProduct) method can be used to retrieve the descriptive information about all the classifications that are used in the data product.
#'
#' @import jsonlite
#' @param dataProduct The rds.dataProduct to query for classifications.
#' @param limit Specifies the number of classifications to return.
#' @param offset Specifies the starting index of the classifications.
setMethod("getClassifications", signature("rds.dataProduct"), function(dataProduct,
                                                                       limit = NULL,
                                                                       offset = NULL) {
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  rds <- catalog@server
  
  # Set up the classifications query
  request <-
    paste(
      rds@baseUrl,
      "/api/catalog/",
      catalog@id,
      "/",
      dataProduct@id,
      "/classifications",
      sep = "",
      collapse = NULL
    )
  
  # append any filled out options to the request
  paramPrefix = "?"
  if (!is.null(limit)) {
    request <-
      paste(request,
            paramPrefix,
            "limit=",
            limit,
            sep = "",
            collapse = NULL)
    paramPrefix = "&"
  }
  
  if (!is.null(offset)) {
    request <-
      paste(request,
            paramPrefix,
            "offset=",
            offset,
            sep = "",
            collapse = NULL)
    paramPrefix = "&"
  }
  
  classifications <- jsonlite::fromJSON(request)
  return(classifications)
})

#' Get Classification
#'
#' The getClassification(dataProduct, classificationId) method can be used to get the classification with the provided ID from the provided rds.dataProduct.
#'
#' @param dataProduct The rds.dataProduct to query for the classification
#' @param classificationId The ID or URI of the desired classification
#' @param limit Specifies the number of codes to return.
#' @param offset Specifies the starting index of the codes.
#' @name getClassification
#' @rdname getClassification
#' @exportMethod getClassification
setGeneric("getClassification", function(dataProduct,
                                         classificationId,
                                         limit = 1000,
                                         offset = 0)
  standardGeneric("getClassification"))

#' Get Classification
#'
#' The getClassification(dataProduct, classificationId) method can be used to get the classification with the provided ID from the provided rds.dataProduct.
#'
#' @import jsonlite
#' @param dataProduct The rds.dataProduct to query for the classification
#' @param classificationId The ID or URI of the desired classification
#' @param limit Specifies the number of codes to return.
#' @param offset Specifies the starting index of the codes.
setMethod("getClassification", signature("rds.dataProduct", "character"), function(dataProduct,
                                                                                   classificationId,
                                                                                   limit = 1000,
                                                                                   offset = 0) {
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  rds <- catalog@server
  
  # create the GET request and retrieve the JSON result
  request <-
    paste(
      rds@baseUrl,
      "/api/catalog/",
      catalog@id,
      "/",
      dataProduct@id,
      "/classification/",
      classificationId,
      sep = "",
      collapse = NULL
    )
  
  json <- jsonlite::fromJSON(request)
  id <- json$id
  codeCount <- json$rootCodeCount
  keywordCount <- json$keywordCount
  levelCount <- json$levelCount
  
  if (codeCount > 0) {
    #query for codes in a separate call and add them on to this classification
    codeRequest <-
      paste(
        rds@baseUrl,
        "/api/catalog/",
        catalog@id,
        "/",
        dataProduct@id,
        "/classification/",
        classificationId,
        "/codes",
        sep = "",
        collapse = NULL
      )
    # append any filled out options to the request
    paramPrefix = "?"
    if (!is.null(limit)) {
      codeRequest <-
        paste(
          codeRequest,
          paramPrefix,
          "limit=",
          limit,
          sep = "",
          collapse = NULL
        )
      paramPrefix = "&"
    }
    
    if (!is.null(offset)) {
      codeRequest <-
        paste(
          codeRequest,
          paramPrefix,
          "offset=",
          offset,
          sep = "",
          collapse = NULL
        )
      paramPrefix = "&"
    }
    codeListJson <- jsonlite::fromJSON(codeRequest)
  }
  
  codes <- data.frame(codeListJson)
  return(codes)
})

#' Select
#'
#' The rds.select(dataProduct) method is used to access the record level data of the data product. In the explorer and through the API the total number of cells is limited to 10000 cells. This is done to keep a small and manageable amount of information going over the network. Be aware that by default the select method will perform numerous calls to build up a complete dataset. If this is not desired remember to set autoPage=FALSE.
#'
#' @param dataProduct The dataProduct whose data is desired.
#' @param limit Specifies the number of records to return.
#' @param offset Specifies the starting index of the records.
#' @param cols The columns to select, these should be specified in the appropriate RDS syntax.
#' @param colLimit Specifies the limit of classifications that should be returned
#' @param colOffset Specifies the starting index of the classifications to be returned
#' @param count Specifies that the total count of records in the dataProduct should be included in the info section.
#' @param orderby Describes how the results should be ordered.
#' @param where Describes how to subset the records based on variable values.
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param autoPage If set to true multiple queries will be sent to the RDS server in order to compile the complete data set.
#' @name rds.select
#' @rdname rds.select
#' @exportMethod rds.select
setGeneric("rds.select", function(dataProduct,
                                  limit = NULL,
                                  offset = NULL,
                                  cols = NULL,
                                  colLimit = NULL,
                                  colOffset = NULL,
                                  count = FALSE,
                                  orderby = NULL,
                                  where = NULL,
                                  inject = FALSE,
                                  autoPage = TRUE)
  standardGeneric("rds.select"))

#' Select
#'
#' The rds.select(dataProduct) method is used to access the record level data of the data product. In the explorer and through the API the total number of cells is limited to 10000 cells. This is done to keep a small and manageable amount of information going over the network. Be aware that by default the select method will perform numerous calls to build up a complete dataset. If this is not desired remember to set autoPage=FALSE.
#'
#' @import jsonlite urltools
#' @param dataProduct The dataProduct whose data is desired.
#' @param limit Specifies the number of records to return.
#' @param offset Specifies the starting index of the records.
#' @param cols The columns to select, these should be specified in the appropriate RDS syntax.
#' @param colLimit Specifies the limit of classifications that should be returned
#' @param colOffset Specifies the starting index of the classifications to be returned
#' @param count Specifies that the total count of records in the dataProduct should be included in the info section.
#' @param orderby Describes how the results should be ordered.
#' @param where Describes how to subset the records based on variable values.
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @param autoPage If set to true multiple queries will be sent to the RDS server in order to compile the complete data set.
setMethod("rds.select", signature("rds.dataProduct"), function(dataProduct,
                                                               limit = 20,
                                                               offset = 0,
                                                               cols = NULL,
                                                               colLimit = NULL,
                                                               colOffset = NULL,
                                                               count = FALSE,
                                                               orderby = NULL,
                                                               where = NULL,
                                                               inject = FALSE,
                                                               autoPage = TRUE) {
  # Flag indicating that we need to run another query
  query = TRUE
  metadata = TRUE
  
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  rds <- catalog@server
  
  # Resulting objects
  variableNames <- list()
  variableDf = NULL
  records = NULL
  info = NULL
  
  while (query) {
    # Build the select query
    select <- paste(
      rds@baseUrl,
      "/api/query/",
      catalog@id,
      "/",
      dataProduct@id,
      "/select",
      sep = "",
      collapse = NULL
    )
    
    # append any filled out options to the select
    paramPrefix <- "?"
    if (!is.null(limit))  {
      select <- paste(select,
                      paramPrefix,
                      "limit=",
                      limit,
                      sep = "",
                      collapse = NULL)
      paramPrefix <- "&"
    }
    
    if (!is.null(offset))  {
      select <- paste(select,
                      paramPrefix,
                      "offset=",
                      offset,
                      sep = "",
                      collapse = NULL)
      paramPrefix <- "&"
    }
    
    if (!is.null(cols)) {
      select <- paste(
        select,
        paramPrefix,
        "cols=",
        url_encode(paste(cols, collapse = ",")),
        sep = "",
        collapse = NULL
      )
      paramPrefix <- "&"
    }
    
    if (!is.null(colLimit))  {
      select <- paste(
        select,
        paramPrefix,
        "colLimit=",
        colLimit,
        sep = "",
        collapse = NULL
      )
      paramPrefix <- "&"
    }
    
    if (!is.null(colOffset))  {
      select <-
        paste(
          select,
          paramPrefix,
          "colOffset=",
          colOffset,
          sep = "",
          collapse = NULL
        )
      paramPrefix <- "&"
    }
    
    if (count)  {
      select <-
        paste(select,
              paramPrefix,
              "count=TRUE",
              sep = "",
              collapse = NULL)
      paramPrefix <- "&"
    }
    
    if (!is.null(orderby))  {
      select <-
        paste(
          select,
          paramPrefix,
          "orderby=",
          url_encode(paste(orderby, collapse = ",")),
          sep = "",
          collapse = NULL
        )
      paramPrefix <- "&"
    }
    
    if (!is.null(where))  {
      select <- paste(
        select,
        paramPrefix,
        "where=",
        url_encode(where),
        sep = "",
        collapse = NULL
      )
      paramPrefix <- "&"
    }
    
    if (inject) {
      select <-
        paste(select,
              paramPrefix,
              "inject=",
              inject,
              sep = "",
              collapse = NULL)
      paramPrefix <- "&"
    }
    
    if (metadata) {
      select <- paste(select,
                      paramPrefix,
                      "metadata=TRUE",
                      sep = "",
                      collapse = NULL)
      paramPrefix <- "&"
    }
    
    # Print the request so people know where we are in the process
    print(select)
    
    # Make the call
    json <- jsonlite::fromJSON(select)
    
    # Format the data and ensure the variable names are used as column names in the data.frame
    data <- data.frame(json$records)
    records <- rbind(records, data)
    
    # Put all of the variable names in a list and assign them to the columns.
    if (is.null(variableDf)) {
      variableDf <- data.frame()
      if (!is.null(json$variables)) {
        # Create a data frame from the returned list
        variableDf = as.data.frame(json$variables)
        
        # Populate variable ids by iterating through rows.
        for (row in 1:nrow(variableDf)) {
          id    <- variableDf[row, "id"]
          variableNames <- c(variableNames, id)
        }
        rownames(variableDf) < variableNames
      }
    }
    
    
    # Format the info as a data.frame
    # Convert info list to dataframe, with properties as the headers. We always need to update the info so the query flag is updated correctly
    info <- data.frame(t(json$info[-1]))
    
    # check if we should run the query again, if so, sleep for a short duration
    query = (autoPage && info$moreRows[[1]])
    if (query) {
      metadata <- FALSE
      offset <- offset + limit
      limit <- floor(10000 / length(variableNames))
      Sys.sleep(0.2)
    }
  }
  
  # Set the column names
  colnames(records) <- variableNames
  
  # Create and return the data set
  dataSet <-
    new(
      "rds.dataset",
      variables = variableDf,
      records = records,
      info = info
    )
  
  return(dataSet)
})


#' Tabulate
#'
#' The rds.tabulate(dataProduct) method is used to create aggregated tables and perform analysis on a data product.
#'
#' @param dataProduct The dataProduct whose data is being used in the tabulation.
#' @param dimensions The names of the variables that should be used as dimensions.
#' @param measures The variables that should be used as a measure, will be the count by default.
#' @param limit Specifies the number of records to return.
#' @param offset Specifies the starting index of the records.
#' @param orderby Describes how the results should be ordered.
#' @param where Describes the subset of records the tabulation should run on.
#' @param totals Specifies if totals should be included. Totals are used to provide roll up information about the counts of dimensions at different levels.
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @name rds.tabulate
#' @rdname rds.tabulate
#' @exportMethod rds.tabulate
setGeneric("rds.tabulate", function(dataProduct,
                                    dimensions,
                                    measures = NULL,
                                    limit = NULL,
                                    offset = NULL,
                                    orderby = NULL,
                                    where = NULL,
                                    totals = TRUE,
                                    inject = FALSE)
  standardGeneric("rds.tabulate"))

#' Tabulate
#'
#' The rds.tabulate(dataProduct) method is used to create aggregated tables and perform analysis on a data product.
#'
#' @import jsonlite urltools
#' @param dataProduct The dataProduct whose data is being used in the tabulation.
#' @param dimensions The names of the variables that should be used as dimensions.
#' @param measures The variables that should be used as a measure, will be the count by default.
#' @param limit Specifies the number of records to return.
#' @param offset Specifies the starting index of the records.
#' @param orderby Describes how the results should be ordered.
#' @param where Describes the subset of records the tabulation should run on.
#' @param totals Specifies if totals should be included. Totals are used to provide roll up information about the counts of dimensions at different levels.
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
setMethod("rds.tabulate", signature("rds.dataProduct", "character"), function(dataProduct,
                                                                              dimensions,
                                                                              measures = NULL,
                                                                              limit = NULL,
                                                                              offset = NULL,
                                                                              orderby = NULL,
                                                                              where = NULL,
                                                                              totals = TRUE,
                                                                              inject = FALSE) {
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  rds <- catalog@server
  
  # Create the query
  tabulate <-
    paste(
      rds@baseUrl,
      "/api/query/",
      catalog@id,
      "/",
      dataProduct@id,
      "/tabulate",
      sep = "",
      collapse = NULL
    )
  
  # Append any filled out options to the request
  paramPrefix <- "?"
  tabulate <- paste(tabulate,
                    paramPrefix,
                    "metadata=true",
                    sep = "",
                    collapse = NULL)
  paramPrefix <- "&"
  
  if (inject) {
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "inject=true",
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
  if (totals) {
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "totals=true",
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
  if (!is.null(dimensions)) {
    tabulate <- paste(
      tabulate,
      paramPrefix,
      "dims=",
      url_encode(paste(dimensions, collapse = ",")),
      sep = "",
      collapse = NULL
    )
    paramPrefix <- "&"
  }
  
  if (!is.null(measures)) {
    tabulate <- paste(
      tabulate,
      paramPrefix,
      "measure=",
      url_encode(paste(measures, collapse = ",")),
      sep = "",
      collapse = NULL
    )
    paramPrefix <- "&"
  }
  
  if (!is.null(limit))  {
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "limit=",
                      limit,
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
  if (!is.null(offset))  {
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "offset=",
                      offset,
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
  if (!is.null(where))  {
    tabulate <-
      paste(
        tabulate,
        paramPrefix,
        "where=",
        url_encode(where),
        sep = "",
        collapse = NULL
      )
    paramPrefix <- "&"
  }
  
  if (!is.null(orderby))  {
    tabulate <-
      paste(
        tabulate,
        paramPrefix,
        "orderby=",
        url_encode(paste(orderby, collapse = ",")),
        sep = "",
        collapse = NULL
      )
    paramPrefix <- "&"
  }
  
  # Print the request and get the JSON
  print(tabulate)
  json <- jsonlite::fromJSON(tabulate)
  
  # Format the data and ensure the variable names are used as colnames in the data.frame
  data <- data.frame(json$records)
  totals <- data.frame(json$totals)
  
  variableNames <- list()
  variableDf <- data.frame()
  if (!is.null(json$variables)) {
    # Create a data frame from the returned list
    variableDf = as.data.frame(json$variables)
    
    # Populate variable ids by iterating through rows.
    for (row in 1:nrow(variableDf)) {
      id    <- variableDf[row, "id"]
      variableNames <- c(variableNames, id)
    }
    colnames(data) <- variableNames
  }
  # Format the info as a data.frame
  info <- data.frame(t(json$info[-1]))
  
  dataSet <-
    new(
      "rds.dataset",
      variables = variableDf,
      records = data,
      totals = totals,
      info = info
    )
  return(dataSet)
})
