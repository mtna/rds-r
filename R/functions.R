#' Get RDS Server
#'
#' This function uses the provided host, port, and protocol to build up an RDS server. This will create the base
#' api paths that the server uses as well as pulling basis information about the server.
#'
#' @param host The host or domain name of the server
#' @param port The port the RDS server is running on if needed. This is NULL by default.
#' @param protocol The protocol to use in the call, http by default.
#' @import methods
#' @keywords server
#' @export
#' @examples
#' get.rds("http://dev.richdataservices.com")
get.rds <- function(host,
                    port = NULL,
                    protocol = "http") {
  # Set up the URL of the server
  baseUrl <- ""
  
  # if the user has not included the protocol, we will append it now
    if (!startsWith(host, "http")) {
    baseUrl <- protocol
    if (!endsWith(protocol, "://")) {
      baseUrl <- paste(baseUrl, "://", sep = "", collapse = NULL)
    }
  }
  
  # add the domain to the url
  baseUrl <- paste(baseUrl, host, sep = "", collapse = NULL)
  if (!is.null(port)) {
    baseUrl <- paste(baseUrl, ":", port, sep = "", collapse = NULL)
  }
  baseUrl <- paste(baseUrl, "/rds", sep = "", collapse = NULL)
  
  # Get the server information
  serverInfo <-
    jsonlite::fromJSON(paste(baseUrl, "/api/server/info", sep = "", collapse = NULL))
  serverName <- serverInfo[[1]][1]
  serverVersion <- serverInfo[[2]][1]
  
  # Get the disclaimer if available, this may return null
  disclaimer <-
    tryCatch(
      jsonlite::fromJSON(paste(
        baseUrl, "/api/server/disclaimer", sep = "", collapse = NULL
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
