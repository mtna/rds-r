## ---- message=FALSE, warning=FALSE, echo=FALSE--------------------------------
library(rds.r)
library(knitr)
library(rmarkdown)

## -----------------------------------------------------------------------------
rds <- get.rds("http://dev.richdataservices.com")
catalog <- rds.r::getCatalog(rds, "uscensus")
dataProduct <- rds.r::getDataProduct(catalog, "census2010-hp")

## -----------------------------------------------------------------------------
# Set autoPage = FALSE for example so we don't have the entire data set.
# We will also limit the columns to 9 and rows to 10 so that the table looks OK in the HTML.
dataSet <-
  rds.r::select(dataProduct,
                colLimit = 9,
                limit = 10,
                autoPage = FALSE)
kable(dataSet@records)

## -----------------------------------------------------------------------------
# Showing just 6 columns for the sake of space.
kable(dataSet@variables[c(4, 3, 7, 6, 1, 13)])

## -----------------------------------------------------------------------------
# Set autoPage = FALSE for example so we don't have the entire data set.
# We will also limit the rows to 5 so that the table looks OK in the HTML.
dataSet <-
  rds.r::select(dataProduct,
                limit = 5,
                autoPage = FALSE,
                inject = TRUE)
paged_table(dataSet@records)

## -----------------------------------------------------------------------------
# We will search for SerialNO directly, anything that starts with P (regex)
dataSet <-
  rds.r::select(
    dataProduct,
    cols = "serialno,p.*",
    limit = 5,
    autoPage = FALSE,
    inject = TRUE
  )
kable(dataSet@records)

## -----------------------------------------------------------------------------
# We will search with the keyword of code
dataSet <-
  rds.r::select(
    dataProduct,
    cols = "$code",
    limit = 5,
    autoPage = FALSE,
    inject = TRUE
  )
kable(dataSet@records)

