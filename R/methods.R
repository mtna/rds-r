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
#' @slot dataProduct The rds.dataProduct to query for the variable.
#' @slot cols An optional variable query following the RDS column syntax. If left NULL all the variable will be returned.
#' @slot collimit An optional limit to the variables returned. If left NULL no limit will be applied.
#' @slot coloffset An optional offset to the variables returned. If left NULL no offset will be applied
#' @name getVariables
#' @rdname rds.dataProduct
#' @exportMethod getVariables
setGeneric("getVariables", function(dataProduct,
                                    ...,
                                    cols = NULL,
                                    collimit = NULL,
                                    coloffset = NULL)
  standardGeneric("getVariables"))

#' @exportMethod getVariables
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
#' @slot dataProduct The rds.dataProduct to query for the variable.
#' @slot variableId The ID of the desired variable.
#' @name getVariable
#' @rdname rds.dataProduct
#' @exportMethod getVariable
setGeneric("getVariable", function(dataProduct, variableId)
  standardGeneric("getVariable"))

#' @exportMethod getVariable
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
        frequencySet <- variable$frequencies$sets[i, ]
        
        # Weight properties
        weighted <- frequencySet$weighted
        weights <- ""
        
        # Set up the data frame
        setValues <- names(frequencySet$map)
        setFrequencies <- frequencySet$map[1,]
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
#' @slot dataProduct The rds.dataProduct to query for classifications.
#' @slot limit Specifies the number of classifications to return.
#' @slot offset Specifies the starting index of the classifications.
#' @name getClassifications
#' @rdname rds.dataProduct
#' @exportMethod getClassifications
setGeneric("getClassifications", function(dataProduct,
                                          ...,
                                          limit = NULL,
                                          offset = NULL)
  standardGeneric("getClassifications"))

#' @exportMethod getClassifications
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



#' Get Variable
#'
#' The getClassification(dataProduct, classificationId) method can be used to get the classification with the provided ID from the provided rds.dataProduct.
#'
#' @slot dataProduct The rds.dataProduct to query for the classification
#' @slot classificationId The ID or URI of the desired classification
#' @slot limit Specifies the number of codes to return.
#' @slot offset Specifies the starting index of the codes.
#' @name getClassification
#' @rdname rds.dataProduct
#' @exportMethod getClassification
setGeneric("getClassification", function(dataProduct,
                                         classificationId,
                                         ...,
                                         limit = 1000,
                                         offset = 0)
  standardGeneric("getClassification"))

#' @exportMethod getClassification
setMethod("getClassification", signature("rds.dataProduct", "character"), function(dataProduct, classificationId, limit=1000, offset=0) {

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
#' The select(dataProduct) method is used to access the record level data of the data product. In the explorer and through the API the total number of cells is limited to 10000 cells. This is done to keep a small and manageable amount of information going over the network. Be aware that by default the select method will perform numerous calls to build up a complete dataset. If this is not desired remember to set autoPage=FALSE.
#'
#' @slot dataProduct The dataProduct whose data is desired.
#' @slot limit Specifies the number of records to return.
#' @slot offset Specifies the starting index of the records.
#' @slot cols The columns to select, these should be specified in the appropriate RDS syntax.
#' @slot colLimit Specifies the limit of classifications that should be returned
#' @slot colOffset Specifies the starting index of the classifications to be returned
#' @slot count Specifies that the total count of records in the dataProduct should be included in the info section.
#' @slot orderby Describes how the results should be ordered.
#' @slot where Describes how to subset the records based on variable values.
#' @slot inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @slot metadata Specifies if variable metadata should be included in the response.
#' @slot autoPage If set to true multiple queries will be sent to the RDS server in order to compile the complete data set.
#' @name select
#' @rdname rds.dataProduct
#' @exportMethod select
setGeneric("select", function(dataProduct,
                              ...,
                              limit = NULL,
                              offset = NULL,
                              cols = NULL,
                              colLimit = NULL,
                              colOffset = NULL,
                              count = FALSE,
                              orderby = NULL,
                              where = NULL,
                              inject = FALSE,
                              metadata = FALSE,
                              autoPage = TRUE)
           standardGeneric("select"))

#' @exportMethod select
setMethod("select", signature("rds.dataProduct"), function(dataProduct,
                                                           limit = 20,
                                                           offset = 0,
                                                           cols = NULL,
                                                           colLimit = NULL,
                                                           colOffset = NULL,
                                                           count = FALSE,
                                                           orderby = NULL,
                                                           where = NULL,
                                                           inject = FALSE,
                                                           metadata = FALSE,
                                                           autoPage = TRUE) {
  # Flag indicating that we need to run another query
  query = TRUE
  
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
      select <- paste(select,
                      paramPrefix,
                      "cols=",
                      cols,
                      sep = "",
                      collapse = NULL)
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
          url_encode(orderby),
          sep = "",
          collapse = NULL
        )
      paramPrefix <- "&"
    }
    
    if (!is.null(where))  {
      select <- paste(select,
                      paramPrefix,
                      "where=",
                      where,
                      sep = "",
                      collapse = NULL)
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
      metadata <- false
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
#' The tabulate(dataProduct) method is used to create aggregated tables and perform analysis on a data product.
#'
#' @slot dataProduct The dataProduct whose data is being used in the tabulation.
#' @slot dimensions The names of the variables that should be used as dimensions.
#' @slot measures The variables that should be used as a measure, will be the count by default.
#' @slot limit Specifies the number of records to return.
#' @slot offset Specifies the starting index of the records.
#' @slot orderby Describes how the results should be ordered.
#' @slot where Describes the subset of records the tabulation should run on.
#' @slot totals Specifies if totals should be included. Totals are used to provide roll up information about the counts of dimensions at different levels.
#' @slot inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
#' @slot metadata Specifies if variable metadata should be included in the response.
#' @name tabulate
#' @rdname rds.dataProduct
#' @exportMethod tabulate
setGeneric("tabulate", function(dataProduct,
                                dimensions,
                                ...,
                                measures = NULL,
                                limit = NULL,
                                offset = NULL,
                                orderby = NULL,
                                where = NULL,
                                totals = TRUE,
                                inject = FALSE,
                                metadata = FALSE)
  standardGeneric("tabulate"))

#' @exportMethod tabulate
setMethod("tabulate", signature("rds.dataProduct", "character"), function(dataProduct,
                                                                          dimensions,
                                                                          measures = NULL,
                                                                          limit = NULL,
                                                                          offset = NULL,
                                                                          orderby = NULL,
                                                                          where = NULL,
                                                                          totals = TRUE,
                                                                          inject = FALSE,
                                                                          metadata = FALSE) {
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
  if (metadata) {
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "metadata=true",
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
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
    tabulate <- paste(tabulate,
                      paramPrefix,
                      "dims=",
                      dimensions,
                      sep = "",
                      collapse = NULL)
    paramPrefix <- "&"
  }
  
  if (!is.null(measures)) {
    tabulate <- paste(
      tabulate,
      paramPrefix,
      "measures=",
      measures,
      sep = "",
      collapse = NULL
    )
    paramPrefix <- "&"
  }
  
  if (!is.null(limit))  {
    tabulate <- paste(
      tabulate,
      paramPrefix,
      "rowLimit=",
      rowLimit,
      sep = "",
      collapse = NULL
    )
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
        url_encode(orderby),
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
