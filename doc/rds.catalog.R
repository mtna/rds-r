## ---- message=FALSE, warning=FALSE, echo=FALSE--------------------------------
library("rds.r")
library("knitr")

## -----------------------------------------------------------------------------
# set up the base API URL
url = "https://public.richdataservices.com/rds"

# connect to the server
rds <- get.rds(url)

# get a catalog
covid19 <- rds.r::getCatalog(rds, "covid19")

## -----------------------------------------------------------------------------
dataProduct <- rds.r::getDataProduct(covid19, "ppp_loan")

