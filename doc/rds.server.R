## ---- message=FALSE, warning=FALSE, echo=FALSE--------------------------------
library("rds.r")
library("knitr")

## -----------------------------------------------------------------------------
# set up the host / domain name of the RDS instance
host = "http://dev.richdataservices.com"

# connect to the server
rds <- get.rds(host)

## -----------------------------------------------------------------------------
  properties <- c("Name", "Version", "Base URL", "Disclaimer")
  df <- data.frame(rds@name, rds@version, rds@baseUrl, rds@disclaimer)
  names(df) <- properties
  kable(df)

## -----------------------------------------------------------------------------
catalogs <- rds.r::getCatalogs(rds)
catalogDf <- data.frame()
for(catalog in catalogs){
  df <- data.frame(catalog@id, catalog@name, catalog@label, catalog@description, catalog@dataProductCount)
  catalogDf <- rbind(catalogDf, df)
} 
names(catalogDf) <- c("ID", "Name", "Label","Description","# Data Products")

kable(catalogDf)

## -----------------------------------------------------------------------------
catalog <- rds.r::getCatalog(rds, "uscensus")
df <- data.frame(catalog@id, catalog@name, catalog@label, catalog@description, catalog@dataProductCount)
names(df) <- c("ID", "Name", "Label","Description","# Data Products")
kable(df)

