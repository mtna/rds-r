#### _WARNING: THIS PROJECT IS IN EARLY DEVELOPMENT STAGE. CONTENT OR CODE SHOULD ONLY BE USED FOR TESTING OR EVALUATION PURPOSES._

<a href="https://www2.richdataservices.com"><img src="https://www2.richdataservices.com/assets/logo.svg" align="left" target="_blank" hspace="10" vspace="6" style="max-width: 200px"></a>

**Rich Data Services** (or **RDS**) is a suite of REST APIs designed by [Metadata Technology North America (MTNA)](https://www.mtna.us) to meet various needs for data engineers, managers, custodians, and consumers. RDS provides a range of services including data profiling, mapping, transformation, validation, ingestion, and dissemination. For more information about each of these APIs and how you can incorporate or consume them as part of your work flow please visit the MTNA website.

## References
[Examples](https://github.com/mtna/rds-r-examples) | [News](./NEWS.md)
|---|---|

## Install

This package can be installed through the use of devtools. It is currently not available through the CRAN repository, although we are working towards that.

```r
devtools::install_github("mtna/rds-r", build_vignettes = TRUE)
browseVignettes(package="rds.r")
```
## Overview

This R library facilitates access and integration with the [Rich Data Services API](http://www.richdataservices.com), enabling immediate access to the catalogs and data products hosted on RDS. This allows R developers to access the data through the R library and not have to do any of the technical work of building up the API calls and handling the responses. Data and metadata will be retrieved, parsed into the appropriate classes, and returned to the developer to be begin working with immediately. 

## Why RDS?
Retrieving data and metadata for analytical, reporting, or visualization purposes is typically a time and resource consuming process that involves several steps such as:
-   Locating and downloading the data
-   Converting and loading into R
-   Computing subsets or aggregation
-   Finding relevant documentation
-   Manually transcribing codes/classification/labels and other descriptive elements into R objects

RDS simplifies this process by offering a REST API to perform all of the above in *a single step*! No need to download data, convert across formats, spend hours skimming though cryptic PDF/Excel/Word and other legacy files for documentation.

RDS combines on the fly querying and tabulation capabilities with metadata retrieval features. Comprehensive variable and classification metadata can accompany any data queried through RDS, enabling immediate reuse and rendering. 

Visit the RDS web site for detailed information on the platform capabilities or learn more about how to complement and deliver your data to you users. 

## Contribute
Putting this product together and maintaining the repository takes time and resources. We welcome your support in any shape or form, in particular:

* Contribute to the package following our [contribution guidelines][contribute].
* Let us know is you find any discrepancy or have suggestions towards enhancing the content or quality of the library
* Donations are appreciated and can be made through [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GKAYVJSBLN92E)
* Consider using RDS or any of our data/metadata [services, products, or expertise](http://www.mtna.us)


[contribute]: ./CONTRIBUTING.md
