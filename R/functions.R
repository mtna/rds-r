#' Get RDS Server
#'
#' This function uses the provided API URL to connect to a RDS server. Connecting to the server will 
#' validate that this URL is correct and all the subsequent calls for catalogs, data products, metadata,
#' or data will use this API URL as a base.
#'
#' @param apiUrl The RDS API URL of the RDS instance that is being accessed. 
#' @import methods
#' @keywords server
#' @export
#' @examples
#' get.rds("http://dev.richdataservices.com/rds/api")
get.rds <- function(apiUrl) {
  # Set up the URL of the server
  baseUrl <- apiUrl
  
  # if the user has a trailing / we will remove it.
  if (endsWith(baseUrl, "/")) {
    baseUrl <- substr(baseUrl, 0, nchar(baseUrl)-1)
  }
  
  # Get the server information
  serverInfo <-
    jsonlite::fromJSON(paste(baseUrl, "/server/info", sep = "", collapse = NULL))
  serverName <- serverInfo[[1]][1]
  serverVersion <- serverInfo[[2]][1]
  
  # Get the disclaimer if available, this may return null
  disclaimer <-
    tryCatch(
      jsonlite::fromJSON(paste(
        baseUrl, "/server/disclaimer", sep = "", collapse = NULL
      )),
      error = function(e) {
        disclaimer <- ""
      }
    )
  
  # Set up and return the server
  server <-
    new(
      "rds.server",
      baseUrl = baseUrl,
      name = serverName,
      version = serverVersion,
      disclaimer = disclaimer
    )
  return (server)
}
