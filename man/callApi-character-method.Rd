% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{callApi,character-method}
\alias{callApi,character-method}
\title{Call API}
\usage{
\S4method{callApi}{character}(url, apiKey = NULL)
}
\arguments{
\item{url}{The API URL to hit}

\item{apiKey}{An optional API key to use.}
}
\description{
A method to handle making the call to the API, checking that the response is successful and returning the appropriate object
}
