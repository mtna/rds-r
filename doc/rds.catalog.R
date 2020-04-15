## ---- message=FALSE, warning=FALSE, echo=FALSE--------------------------------
library("rds.r")
library("knitr")

## -----------------------------------------------------------------------------
# set up the host / domain name of the RDS instance
host = "http://dev.richdataservices.com"

# connect to the server
rds <- get.rds(host)

# get a catalog
census <- rds.r::getCatalog(rds, "uscensus")

## -----------------------------------------------------------------------------
dataProduct <- rds.r::getDataProduct(census, "census2010-hp")

