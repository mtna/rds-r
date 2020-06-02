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
  catalogsUrl <- paste(server@baseUrl, "/api/catalog", sep = "")
  response <- jsonlite::fromJSON(catalogsUrl)
  catalogs <- response[[1]]
  
  # Build the catalog classes
  rdsCatalogs = c()
  for (catalogIndex in 1:nrow(catalogs)) {
    rdsCatalog <- new(
      "rds.catalog",
      server = server,
      id = catalogs[catalogIndex, "id"],
      description = ifelse(is.null(catalogs[catalogIndex, "description"]), NA_character_, catalogs[catalogIndex, "description"]),
      label = ifelse(is.null(catalogs[catalogIndex, "label"]), NA_character_, catalogs[catalogIndex, "label"]),
      name = ifelse(is.null(catalogs[catalogIndex, "name"]), NA_character_, catalogs[catalogIndex, "name"]),
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
    catalogUrl <-
      paste(server@baseUrl, "/api/catalog/", catalogId, sep = "")
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
      paste("No catalog could be found with the ID [", catalogId, "]",  sep = "")
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
    paste(server@baseUrl, "/api/catalog/", catalog@id, sep = "")
  response <- jsonlite::fromJSON(dataProductsUrl)
  dataProducts = response[[1]]
  
  # Build the data product classes
  rdsDataProducts = c()
  for (productIndex in 1:nrow(dataProducts)) {
    rdsProduct <- new(
      "rds.dataProduct",
      catalog = catalog,
      id = dataProducts[productIndex, "id"],
      citation = ifelse(is.null(dataProducts[productIndex, "citation"]), NA_character_, dataProducts[productIndex, "citation"]),
      description = ifelse(is.null(dataProducts[productIndex, "description"]), NA_character_, dataProducts[productIndex, "description"]),
      label = ifelse(is.null(dataProducts[productIndex, "label"]), NA_character_, dataProducts[productIndex, "label"]),
      lastUpdate = as.POSIXct(dataProducts[productIndex, "lastUpdate"], format = "%Y-%m-%dT%H:%M:%OSZ"),
      name = ifelse(is.null(dataProducts[productIndex, "name"]), NA_character_, dataProducts[productIndex, "name"]),
      note = ifelse(is.null(dataProducts[productIndex, "note"]), NA_character_, dataProducts[productIndex, "note"]),
      provenance = ifelse(is.null(dataProducts[productIndex, "provenance"]), NA_character_, dataProducts[productIndex, "provenance"]),
      restriction = ifelse(is.null(dataProducts[productIndex, "restriction"]), NA_character_, dataProducts[productIndex, "restriction"])
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
    dataProductUrl <- 
      paste(server@baseUrl, "/api/catalog/", catalog@id, "/", dataProductId,sep = "")
    dataProduct <- jsonlite::fromJSON(dataProductUrl)
    rdsDataProduct <- new(
      "rds.dataProduct",
      catalog = catalog,
      id = dataProduct$id,
      citation = ifelse(is.null(dataProduct$citation), NA_character_, dataProduct$citation),
      description = ifelse(
        is.null(dataProduct$description),
        NA_character_,
        dataProduct$description
      ),
      label = ifelse(is.null(dataProduct$label), NA_character_, dataProduct$label),
      lastUpdate = as.POSIXct(dataProduct$lastUpdate, format = "%Y-%m-%dT%H:%M:%OSZ"),
      name = ifelse(is.null(dataProduct$name), NA_character_, dataProduct$name),
      note = ifelse(is.null(dataProduct$note), NA_character_, dataProduct$note),
      provenance = ifelse(
        is.null(dataProduct$provenance),
        NA_character_,
        dataProduct$provenance
      ),
      restriction = ifelse(
        is.null(dataProduct$restriction),
        NA_character_,
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
      paste("No data product [", dataProductId, "] could be found in the catalog [", catalog@id, "]", sep = "")
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
  variablesUrl <- 
    paste(rds@baseUrl, "/api/catalog/", catalog@id, "/", dataProduct@id, "/variables", sep = "")
  
  # add the cols if not null
  paramPrefix = "?"
  if (!is.null(cols)) {
    variablesUrl <- 
      paste(variablesUrl, paramPrefix, "cols=", cols, sep = "")
    paramPrefix = "&"
  }
  
  if (!is.null(collimit)) {
    variablesUrl <-
      paste(variablesUrl, paramPrefix, "collimit=", collimit, sep = "")
    paramPrefix = "&"
  }
  if (!is.null(coloffset)) {
    variablesUrl <-
      paste(variablesUrl, paramPrefix, "coloffset=", coloffset, sep = "")
  }
  
  variables <- jsonlite::fromJSON(variablesUrl)
  variables <- parseVariables(variables)
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
    variableUrl <- 
      paste(server@baseUrl, "/api/catalog/", catalog@id, "/", dataProduct@id, "/variable/", variableId, sep = "")
    print(variableUrl)
    variable <- jsonlite::fromJSON(variableUrl)
    
    # Gather the variable frequencies and format them
    variableFrequencies <- list()
    if (!is.null(variable$frequencies)) {
      for (i in 1:nrow(variable$frequencies$sets)) {
        # Get the set to work with
        frequencySet <- variable$frequencies$sets[i,]
        
        # Weight properties
        weighted <- frequencySet$weighted
        weights <- NA_character_
        
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
    
    # Gather the variable summaryStatistics and format them
    variableStatistics <- list()
    if (!is.null(variable$summaryStatistics)) {
      for (i in 1:nrow(variable$summaryStatistics$sets)) {
        # Get the set to work with
        statisticSet <- variable$summaryStatistics$sets[i,]
        statistics <- new(
          "rds.statistics",
          weighted = statisticSet[i, "weighted"],
          weights = ifelse(is.null(statisticSet[i, "weights"]), NA_character_, statisticSet[i, "weights"]),
          distinct = ifelse(is.null(statisticSet[i, "distinct"]), NA_real_, statisticSet[i, "distinct"]),
          max = ifelse(is.null(statisticSet[i, "max"]), NA_real_, statisticSet[i, "max"]),
          mean = ifelse(is.null(statisticSet[i, "mean"]), NA_real_, statisticSet[i, "mean"]),
          median = ifelse(is.null(statisticSet[i, "median"]), NA_real_, statisticSet[i, "median"]),
          min = ifelse(is.null(statisticSet[i, "min"]), NA_real_, statisticSet[i, "min"]),
          missing = ifelse(is.null(statisticSet[i, "missing"]), NA_real_, statisticSet[i, "missing"]),
          populated = ifelse(is.null(statisticSet[i, "populated"]), NA_real_, statisticSet[i, "populated"]),
          standardDeviation = ifelse(is.null(statisticSet[i, "standardDeviation"]), NA_real_, statisticSet[i, "standardDeviation"]),
          variance = ifelse(is.null(statisticSet[i, "variance"]), NA_real_, statisticSet[i, "variance"])
        )
        
        variableStatistics <- append(variableStatistics, statistics)
      }
    }
    
    rdsVariable <- new(
      "rds.variable",
      id = variable$id,
      name =  variable$name,
      storageType = variable$storageType,
      index = variable$index,
      label = ifelse(is.null(variable$label), NA_character_, variable$label),
      description = ifelse(is.null(variable$description), NA_character_, variable$description),
      questionText = ifelse(is.null(variable$questionText), NA_character_, variable$questionText),
      dataType = ifelse(!is.null(variable$dataType), variable$dataType, NA_character_),
      fixedStorageWidth = ifelse(is.null(variable$fixedStorageWidth), NA_integer_, variable$fixedStorageWidth),
      startPosition = ifelse(is.null(variable$startPosition), NA_integer_, variable$startPosition),
      endPosition = ifelse(is.null(variable$endPosition), NA_integer_, variable$endPosition),
      decimals = ifelse(is.null(variable$decimals), NA_integer_, variable$decimals),
      classificationId = ifelse(is.null(variable$classificationId), NA_character_, variable$classificationId),
      classificationUri = ifelse(is.null(variable$classificationUri), NA_character_, variable$classificationUri),
      reference = ifelse(is.null(variable$reference), FALSE, variable$reference),
      isDimension = ifelse(is.null(variable$isDimension), FALSE, variable$isDimension),
      isMeasure = ifelse(is.null(variable$isMeasure), FALSE, variable$isMeasure),
      isRequired = ifelse(is.null(variable$isRequired), FALSE, variable$isRequired),
      isWeight = ifelse(is.null(variable$isWeight), FALSE, variable$isWeight),
      statistics = variableStatistics,
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

#' Parse Variables
#'
#' A method to parse the variable data frames that are returned from the REST call into a list of variable objects.
#'
#' @param variableDf The variable data frame to parse
#' @name parseVariables
#' @rdname parseVariables
setGeneric("parseVariables", function(variableDf)
  standardGeneric("parseVariables"))

#' Parse Variables
#'
#' A method to parse the variable data frames that are returned from the REST call into a list of variable objects.
#'
#' @param variableDf The variable data frame to parse
setMethod("parseVariables", signature("data.frame"), function(variableDf) {
  variables <- list()
  if(nrow(variableDf) > 0){
    for (row in 1:nrow(variableDf)) {
      # Gather the variable frequencies and format them
      frequencies  <- variableDf[row, "frequencies"]
      variableFrequencies <- list()
      if (!is.null(frequencies) && !is.null(frequencies$sets[[1]])) {
        for (i in 1:length(frequencies$sets)) {
          # Get the set to work with
          frequencySet <- frequencies$sets[[i]]
          
          # Weight properties
          weighted <- frequencySet$weighted
          weights <- NA_character_
          
          # Set up the data frame
          setValues <- names(frequencySet$map)
          setFrequencies <- frequencySet$map[1, ]
          frequencyDf <- data.frame()
          if (length(setValues) > 1) {
            for (freqIndex in 1:length(setValues)) {
              value <- setValues[freqIndex]
              
              dfRow <- data.frame(value, setFrequencies[1, value])
              frequencyDf <- rbind(frequencyDf, dfRow)
            }
          } else{
            frequencyDf <- data.frame(setValues, setFrequencies)
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
      
      # Gather the variable summaryStatistics and format them
      summaryStatistics  <- variableDf[row, "summaryStatistics"]
      variableStatistics <- list()
      if (!is.null(summaryStatistics) && !is.null(frequencies$sets[[1]])) {
        for (i in 1:nrow(summaryStatistics)) {
          # Get the set to work with
          statisticSet <- summaryStatistics$sets[[i]]
          statistics <- new(
            "rds.statistics",
            weighted = statisticSet[i, "weighted"],
            weights = ifelse(is.null(statisticSet[i, "weights"]), NA_character_, statisticSet[i, "weights"]),
            distinct = ifelse(is.null(statisticSet[i, "distinct"]), NA_real_, statisticSet[i, "distinct"]),
            max = ifelse(is.null(statisticSet[i, "max"]), NA_real_, statisticSet[i, "max"]),
            mean = ifelse(is.null(statisticSet[i, "mean"]), NA_real_, statisticSet[i, "mean"]),
            median = ifelse(is.null(statisticSet[i, "median"]), NA_real_, statisticSet[i, "median"]),
            min = ifelse(is.null(statisticSet[i, "min"]), NA_real_, statisticSet[i, "min"]),
            missing = ifelse(is.null(statisticSet[i, "missing"]), NA_real_, statisticSet[i, "missing"]),
            populated = ifelse(is.null(statisticSet[i, "populated"]), NA_real_, statisticSet[i, "populated"]),
            standardDeviation = ifelse(is.null(statisticSet[i, "standardDeviation"]), NA_real_, statisticSet[i, "standardDeviation"]),
            variance = ifelse(is.null(statisticSet[i, "variance"]), NA_real_, statisticSet[i, "variance"])
          )
          
          variableStatistics <- append(variableStatistics, statistics)
        }
      }
      
      # pull out the variables to test existence from the data frame
      label  <- variableDf[row, "label"]
      description  <- variableDf[row, "description"]
      questionText  <- variableDf[row, "questionText"]
      dataType  <- variableDf[row, "dataType"]
      uri  <- variableDf[row, "uri"]
      fixedStorageWidth  <- variableDf[row, "fixedStorageWidth"]
      startPosition <- variableDf[row, "startPosition"]
      endPosition  <- variableDf[row, "endPosition"]
      decimals  <- variableDf[row, "decimals"]
      classificationId  <- variableDf[row, "classificationId"]
      classificationUri  <- variableDf[row, "classificationUri"]
      reference  <- variableDf[row, "reference"]
      isDimension  <- variableDf[row, "isDimension"]
      isMeasure  <- variableDf[row, "isMeasure"]
      isRequired  <- variableDf[row, "isRequired"]
      isWeight  <- variableDf[row, "isWeight"]
      
      rdsVariable <- new(
        "rds.variable",
        id = variableDf[row, "id"],
        name = variableDf[row, "name"],
        storageType = variableDf[row, "storageType"],
        index = variableDf[row, "index"],
        label = ifelse(is.null(label), NA_character_, label),
        description = ifelse(is.null(description), NA_character_, description),
        questionText = ifelse(is.null(questionText), NA_character_, questionText),
        dataType = ifelse(!is.null(dataType), dataType, NA_character_),
        fixedStorageWidth = ifelse(is.null(fixedStorageWidth), NA_integer_, fixedStorageWidth),
        startPosition = ifelse(is.null(startPosition), NA_integer_, startPosition),
        endPosition = ifelse(is.null(endPosition), NA_integer_, endPosition),
        decimals = ifelse(is.null(decimals), NA_integer_, decimals),
        classificationId = ifelse(is.null(classificationId), NA_character_, classificationId),
        classificationUri = ifelse(is.null(classificationUri), NA_character_, classificationUri),
        reference = ifelse(is.null(reference), FALSE, reference),
        isDimension = ifelse(is.null(isDimension), FALSE, isDimension),
        isMeasure = ifelse(is.null(isMeasure), FALSE, isMeasure),
        isRequired = ifelse(is.null(isRequired), FALSE, isRequired),
        isWeight = ifelse(is.null(isWeight), FALSE, isWeight),
        statistics = variableStatistics,
        frequencies = variableFrequencies
      )
      variables <- append(variables, rdsVariable)
    }
  }
  return (variables)
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
    paste(rds@baseUrl, "/api/catalog/", catalog@id, "/", dataProduct@id, "/classifications", sep = "")
  
  # append any filled out options to the request
  paramPrefix = "?"
  if (!is.null(limit)) {
    request <-
      paste(request, paramPrefix, "limit=", limit, sep = "")
    paramPrefix = "&"
  }
  
  if (!is.null(offset)) {
    request <-
      paste(request, paramPrefix, "offset=", offset, sep = "")
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
    paste(rds@baseUrl, "/api/catalog/", catalog@id, "/", dataProduct@id, "/classification/", classificationId, sep = "")
  
  json <- jsonlite::fromJSON(request)
  id <- json$id
  codeCount <- json$rootCodeCount
  keywordCount <- json$keywordCount
  levelCount <- json$levelCount
  
  if (codeCount > 0) {
    #query for codes in a separate call and add them on to this classification
    codeRequest <-
      paste(rds@baseUrl, "/api/catalog/", catalog@id, "/", dataProduct@id, "/classification/", classificationId, "/codes", sep = "")
    # append any filled out options to the request
    paramPrefix = "?"
    if (!is.null(limit)) {
      codeRequest <-
        paste(codeRequest,  paramPrefix, "limit=", limit, sep = "")
      paramPrefix = "&"
    }
    
    if (!is.null(offset)) {
      codeRequest <-
        paste(codeRequest, paramPrefix, "offset=", offset, sep = "")
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
#' @param weights Ids of numeric variables to weight the data with. This should only be used for variables that are flagged as weights. 
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
                                  weights = NULL,
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
#' @param weights Ids of numeric variables to weight the data with. This should only be used for variables that are flagged as weights. 
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
                                                               weights = NULL,
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
    select <- paste(rds@baseUrl, "/api/query/", catalog@id, "/", dataProduct@id, "/select", sep = "")
    
    # append any filled out options to the select
    paramPrefix <- "?"
    if (!is.null(limit))  {
      select <- paste(select, paramPrefix, "limit=", limit, sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(offset))  {
      select <- paste(select, paramPrefix, "offset=", offset, sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(cols)) {
      select <-
        paste(select, paramPrefix, "cols=", url_encode(paste(cols, collapse = ",")), sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(colLimit))  {
      select <-
        paste(select, paramPrefix, "colLimit=", colLimit, sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(colOffset))  {
      select <-
        paste(select, paramPrefix, "colOffset=", colOffset, sep = "")
      paramPrefix <- "&"
    }
    
    if (count)  {
      select <-
        paste(select, paramPrefix, "count=TRUE", sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(orderby))  {
      select <-
        paste(select, paramPrefix, "orderby=", url_encode(paste(orderby, collapse = ",")), sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(weights))  {
      select <-
        paste(select, paramPrefix, "weights=", url_encode(paste(weights, collapse = ",")), sep = "")
      paramPrefix <- "&"
    }
    
    if (!is.null(where))  {
      select <-
        paste(select, paramPrefix, "where=", url_encode(where), sep = "")
      paramPrefix <- "&"
    }
    
    if (inject) {
      select <-
        paste(select, paramPrefix, "inject=", inject, sep = "")
      paramPrefix <- "&"
    }
    
    if (metadata) {
      select <- paste(select, paramPrefix, "metadata=TRUE", sep = "")
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
  
  # Set the column names of the records
  if(ncol(records)>0) {
    colnames(records) <- variableNames
  } else {
    #if no records were returned we initiate the records as a new data frame with no data and the correct variable names
    records <- as.data.frame(matrix(vector(), ncol = length(variableNames)))
    names(records) <- variableNames
  } 

  # change to the correct data type based on variable types
  if(nrow(variableDf) > 0){
    for (row in 1:nrow(variableDf)) {
      id <- variableDf[row, "id"]
      classificationUri <- variableDf[row, "classificationUri"]
      dataType <- variableDf[row, "dataType"]
  
      if(!is.null(classificationUri) && !is.na(classificationUri) && inject == T){
        records[, id] <- as.factor(records[, id])
      } else if(dataType == "CHAR" || dataType == "TEXT" || dataType == "LONG_TEXT" || dataType == "BIG_INTEGER" || dataType == "BIG_DECIMAL"){
        records[, id] <- as.character(records[, id])
      } else if (dataType == "BYTE" || dataType == "SHORT" || dataType == "INTEGER" || dataType == "LONG") {
        records[, id] <- as.integer(as.character(records[, id]))
      } else if (dataType == "FLOAT" || dataType == "DOUBLE" || dataType == "NUMERIC") {
        records[, id] <- as.numeric(as.character(records[, id]))
      } else if (dataType == "DATE") {
        records[, id] <- as.Date(records[, id])
      } else if (dataType == "BOOLEAN") {
        records[, id] <- as.logical(as.character(records[, id]))
      }
    }
  }

  # Create and return the data set
  dataSet <-
    new(
      "rds.dataset",
      variables = parseVariables(variableDf),
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
#' @param weights Ids of numeric variables to weight the data with. This should only be used for variables that are flagged as weights. 
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
                                    weights = NULL,
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
#' @param weights Ids of numeric variables to weight the data with. This should only be used for variables that are flagged as weights. 
#' @param where Describes the subset of records the tabulation should run on.
#' @param totals Specifies if totals should be included. Totals are used to provide roll up information about the counts of dimensions at different levels.
#' @param inject Specifies if metadata should be injected into the data frame. If true and there are classifications available the columns codes will be replaced with code values. Defaults to FALSE
setMethod("rds.tabulate", signature("rds.dataProduct", "character"), function(dataProduct,
                                                                              dimensions,
                                                                              measures = NULL,
                                                                              limit = NULL,
                                                                              offset = NULL,
                                                                              orderby = NULL,
                                                                              weights = NULL,
                                                                              where = NULL,
                                                                              totals = TRUE,
                                                                              inject = FALSE) {
  # Get the catalog from the data product
  catalog <- dataProduct@catalog
  
  # Get the server from the catalog
  rds <- catalog@server
  
  # Create the query
  tabulate <-
    paste(rds@baseUrl, "/api/query/", catalog@id, "/", dataProduct@id, "/tabulate", sep = "")
  
  # Append any filled out options to the request
  paramPrefix <- "?"
  tabulate <- paste(tabulate, paramPrefix, "metadata=true", sep = "")
  paramPrefix <- "&"
  
  if (inject) {
    tabulate <-
      paste(tabulate, paramPrefix, "inject=true", sep = "")
    paramPrefix <- "&"
  }
  
  if (totals) {
    tabulate <-
      paste(tabulate, paramPrefix, "totals=true", sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(dimensions)) {
    tabulate <-
      paste(tabulate, paramPrefix, "dims=", url_encode(paste(dimensions, collapse = ",")), sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(measures)) {
    tabulate <-
      paste(tabulate, paramPrefix, "measure=", url_encode(paste(measures, collapse = ",")), sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(limit))  {
    tabulate <- paste(tabulate, paramPrefix, "limit=", limit, sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(offset))  {
    tabulate <-
      paste(tabulate, paramPrefix, "offset=", offset, sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(weights))  {
    tabulate <-
      paste(tabulate, paramPrefix, "weights=", url_encode(paste(weights, collapse = ",")), sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(where))  {
    tabulate <-
      paste(tabulate, paramPrefix, "where=", url_encode(where), sep = "")
    paramPrefix <- "&"
  }
  
  if (!is.null(orderby))  {
    tabulate <-
      paste(tabulate, paramPrefix, "orderby=", url_encode(paste(orderby, collapse = ",")), sep = "")
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
    
    # Set the column names of the records
    if(ncol(data)>0) {
      colnames(data) <- variableNames
    } else {
      #if no records were returned we initiate the records as a new data frame with no data and the correct variable names
      data <- as.data.frame(matrix(vector(), ncol = length(variableNames)))
      names(data) <- variableNames
    } 
    
    # Set the column names of the totals
    if(ncol(totals)>0) {
      colnames(totals) <- variableNames
    } else {
      #if no totals were returned we initiate the totals as a new data frame with no data and the correct variable names
      totals <- as.data.frame(matrix(vector(), ncol = length(variableNames)))
      names(totals) <- variableNames
    } 
    
  }
  # Format the info as a data.frame
  info <- data.frame(t(json$info[-1]))
  
  # change to the correct data type based on variable types
  if(nrow(variableDf) > 0){
    for (row in 1:nrow(variableDf)) {
      id <- variableDf[row, "id"]
      classificationUri <- variableDf[row, "classificationUri"]
      dataType <- variableDf[row, "dataType"]
  
      if(!is.null(classificationUri) && !is.na(classificationUri) && inject == T){
        data[, id] <- as.factor(data[, id])
      }else if (dataType == "CHAR" || dataType == "TEXT" || dataType == "LONG_TEXT" || dataType == "BIG_INTEGER" || dataType == "BIG_DECIMAL"){
        data[, id] <- as.character(data[, id])
      } else if (dataType == "BYTE" || dataType == "SHORT" || dataType == "INTEGER" || dataType == "LONG") {
        data[, id] <- as.integer(as.character(data[, id]))
      } else if (dataType == "FLOAT" || dataType == "DOUBLE" || dataType == "NUMERIC") {
        data[, id] <- as.numeric(as.character(data[, id]))
      } else if (dataType == "DATE") {
        data[, id] <- as.Date(data[, id])
      } else if (dataType == "BOOLEAN") {
        data[, id] <- as.logical(as.character(data[, id]))
      }
    }
  }
  
  dataSet <-
    new(
      "rds.dataset",
      variables = parseVariables(variableDf),
      records = data,
      totals = totals,
      info = info
    )
  return(dataSet)
})
