# *News*

# rds-r 0.0.1.9000  

### Fixes

    * Added logic to set the data types of the columns in the data frame based on the variable metadata that is returned by the server. Classified variables will be factors, otherwise columns will be character, integer, numeric, logical, or Date columns.