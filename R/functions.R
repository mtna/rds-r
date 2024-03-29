#' Get RDS Server
#'
#' This function uses the provided host, port, protocol, and application path to build up an RDS server. This will create the base
#' paths that the server uses to build up future requests as well as pulling basic information about the server.
#'
#' @param host The host or domain name of the server
#' @param port The port the RDS server is running on if needed. This is NULL by default.
#' @param protocol The protocol to use in the call, http by default.
#' @param path The path to the RDS application root. This will be rds by default, if no path is desired (for instances behind a proxy) this can be set to null
#' @param apiKey The user's apiKey to access the API, if the API is not secured this can be NULL.
#' @import methods
#' @keywords server
#' @export
#' @examples
#' get.rds("https://covid19.richdataservices.com/rds")
get.rds <- function(host,
                    port = NULL,
                    protocol = "http",
                    path = "rds",
                    apiKey = NULL) {
  # parse the string into a URL object (data frame)
  url <- url_parse(host)
  
  # if the port is provided set this on the URL
  if(is.na(url$port) && !is.null(port)){
    url$port<-port
  }
  
  # if the protocol is provided set this on the URL
  if(is.na(url$scheme) && !is.null(protocol)){
    url$scheme<-protocol
  }
  
  # if the path is provided set this on the URL
  if(is.na(url$path) && !is.null(path)){
    url$path<-path
  }
  
  # Set up the URL of the server
  baseUrl <- url_compose(url)
  
  # Get the server information
  url <- paste(baseUrl, "/api/server/info", sep = "", collapse = NULL)
  response <- if(!is.null(apiKey)) GET(url, add_headers("X-API-KEY"=apiKey)) else GET(url)
  if(response$status_code != 200){
    stop(paste("Error getting server info, response code [",response$status_code,"]", sep = "", collapse = NULL))
  }
  serverInfo <- jsonlite::fromJSON(content(response, "text"))
  serverName <- serverInfo[[1]][1]
  serverVersion <- serverInfo[[2]][1]
  
  # Get the disclaimer if available, this may return null
  url <- paste(baseUrl, "/api/server/disclaimer", sep = "", collapse = NULL)
  response <- if(!is.null(apiKey)) GET(url, add_headers("X-API-KEY"=apiKey)) else GET(url)
  disclaimer <-
    tryCatch(
      jsonlite::fromJSON(content(response, "text")),
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
