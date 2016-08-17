<style>
  .col2 {
    columns: 2 300px;         /* number of columns and width in pixels*/
    -webkit-columns: 2 300px; /* chrome, safari */
    -moz-columns: 2 300px;    /* firefox */
  }
</style>
Overview
--------

This document will explore using Metadata Technology North America's (MTNA) Rich Data Services (RDS) and how to integrate it with R. MTNA has written an RDS package for R that provides functions to efficiently access the data and metadata stored in a RDS server. This document serves as an example of how to access and use the two data functions provided, select and tabulate. In this example we will be using data from the American National Election Study in 1948. We have this stored on MTNA's public RDS server at {host}.

    ## Visit http://strengejacke.de/sjPlot for package-vignettes.

Data Dictionary
---------------

RDS contains variable metadata for every view that is accessible through the RDS library. The quality of this metadata depends on how the view has been managed and what the administrators have added, so this may be only include basic information like id, data type, and width, but it may also contain variable labels, descriptions, question information, and even classfication metadata.

To access the metadata for a view we will use the **get.variables** function, we will need to supply a base URL, collection, and view at the bare minimum. In this case lets assume that we want to take a look at all the variables that related to Harry S. Truman. To do that we will specify **cols=$truman** indicating that we want all the variables that have Truman in the name, label, description, or question text.

The variable metadata will be returned as a data.frame with the variable properties as the header and each variables values as a record.

``` r
anesVariables <- get.variables("http://localhost:8080/rds/api/catalog/","test","NES1948",cols="$truman")
table <- sjPlot::sjt.df(anesVariables, useViewer = F,describe=FALSE,encoding = "UTF-8", no.output=TRUE, altr.row.col=TRUE, show.rownames=FALSE)$knitr
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
id
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
name
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
label
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
question
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
index
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
storageType
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
displayType
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
width
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
classification
</th>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
WHY PPL VTD FOR TRUMAN 1
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
Q. 5. WHY DO YOU THINK PEOPLE VOTED FOR TRUMAN. Q. 5A. ARE THERE ANY OTHER KINDS OF REASONS WHY YOU THINK PEOPLE VOTED FOR TRUMAN.
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
16
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014A
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480014b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480014b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
WHY PPL VTD FOR TRUMAN 2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
Q. 5. WHY DO YOU THINK PEOPLE VOTED FOR TRUMAN. Q. 5A. ARE THERE ANY OTHER KINDS OF REASONS WHY YOU THINK PEOPLE VOTED FOR TRUMAN.
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
17
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480014B
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480015a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480015a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
WHY PPL VTD AGNST TRUMAN 1
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
Q. 6. DO YOU THINK THERE WAS ANYTHING SPECIAL ABOUT TRUMAN THAT MADE SOME PEOPLE VOTE AGAINST HIM.
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
18
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480015A
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480015b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480015b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
WHY PPL VTD AGNST TRUMAN 2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
Q. 6. DO YOU THINK THERE WAS ANYTHING SPECIAL ABOUT TRUMAN THAT MADE SOME PEOPLE VOTE AGAINST HIM.
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
19
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480015B
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480031a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480031a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
GRPS IDENTIFIED W TRUMAN 1
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
1.  GROUPS IDENTIFIED WITH TRUMAN
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
40
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480031A
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480031b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480031b
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
GRPS IDENTIFIED W TRUMAN 2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
1.  GROUPS IDENTIFIED WITH TRUMAN
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
41
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
V480031B
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480031c
</td>
        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
        V480031c
        </td>
        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
        GRPS IDENTIFIED W TRUMAN 3
        </td>
        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
        1.  GROUPS IDENTIFIED WITH TRUMAN
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
            42
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
            NUMERIC
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
            NUMERIC
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
            2
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
            V480031C
            </td>
            </tr>
            <tr>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
            V480033a
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
            V480033a
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
            ISSUES CONNECTED W TRMN 1
            </td>
            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
            1.  ISSUES MENTIONED IN CONNECTION WITH TRUMAN
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                46
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                NUMERIC
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                NUMERIC
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                2
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                V480033A
                </td>
                </tr>
                <tr>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                V480033b
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                V480033b
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                ISSUES CONNECTED W TRMN 2
                </td>
                <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                1.  ISSUES MENTIONED IN CONNECTION WITH TRUMAN
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                    47
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                    NUMERIC
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                    NUMERIC
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                    2
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                    V480033B
                    </td>
                    </tr>
                    <tr>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                    V480035a
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                    V480035a
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                    PERSONAL ATTRIBUTE TRMN 1
                    </td>
                    <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                    1.  PERSONAL ATTRIBUTES OF TRUMAN
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                        50
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                        NUMERIC
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                        NUMERIC
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                        2
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
                        V480035A
                        </td>
                        </tr>
                        <tr>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                        V480035b
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                        V480035b
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                        PERSONAL ATTRIBUTE TRMN 2
                        </td>
                        <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                        1.  PERSONAL ATTRIBUTES OF TRUMAN
                            </td>
                            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                            51
                            </td>
                            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                            NUMERIC
                            </td>
                            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                            NUMERIC
                            </td>
                            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                            2
                            </td>
                            <td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
                            V480035B
</td>
</tr>
</table>

Individual Variable Metadata
----------------------------

In the event that users need to access a single variables metadata instead of a group of variables the **get.variable** function can be used. Again we will need to know the base URL, collection, and view, as well as the variable ID. In this case we will specify the **var.id** parameter as V480014a.

``` r
var <- get.variable("http://localhost:8080/rds/api/catalog/","test","NES1948",var.id="V480014a")
table <- sjPlot::sjt.df(var, useViewer = F,describe=FALSE,encoding = "UTF-8", no.output=TRUE, show.rownames=FALSE)$knitr
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
id
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
name
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
label
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
question
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
index
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
storageType
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
displayType
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
width
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
classification
</th>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014a
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
WHY PPL VTD FOR TRUMAN 1
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
Q. 5. WHY DO YOU THINK PEOPLE VOTED FOR TRUMAN. Q. 5A. ARE THERE ANY OTHER KINDS OF REASONS WHY YOU THINK PEOPLE VOTED FOR TRUMAN.
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
16
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NUMERIC
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
2
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
V480014A
</td>
</tr>
</table>
Individual Classification Metadata
----------------------------------

Looking at the previously retrieved variable, V480014a, users may notice that this has a classification associated with it that has the id **V480014A**. If users want to view the classification they can use the classification ID to retreive the metadata as an **rds.classification** class. The rds.classification will contain three properties, the ID (character), the codes and their labels (data.frame), and an info section (data.frame) that will indicate information about the codes returned.

Due to the fact that classifications can sometimes be very large (tens of thousands of codes) code limits can be placed on the classification to allow pagination through the classification if desired, the default code limit is 100. Codes can also be sorted in ASC or DESC order by their codes.

``` r
class <- get.classification("http://localhost:8080/rds/api/catalog/","test","NES1948",class.id=var$classification)
codes <- class@codes
asc.table <- sjPlot::sjt.df(codes, useViewer = F,describe=FALSE,encoding = "UTF-8", no.output=TRUE, altr.row.col=TRUE, show.rownames=FALSE)$knitr
class <- get.classification("http://localhost:8080/rds/api/catalog/","test","NES1948",class.id=var$classification,codeSort = "DESC")
codes <- class@codes
desc.table <- sjPlot::sjt.df(codes, useViewer = F,describe=FALSE,encoding = "UTF-8", no.output=TRUE, altr.row.col=TRUE, show.rownames=FALSE)$knitr
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
value
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
label
</th>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
10
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
BETTER MAN
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
20
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
EXPERIENCED, GOOD RECORD
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
30
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
TRUMAN PRO-LABOR, NEGRO, WORKING MAN
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
40
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
GOOD CAMPAIGN CONDUCTED BY TRUMAN
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
50
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
DEMOCRATS MEAN PROSPERITY, REPUBLICANS
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
60
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
TRUMAN PRO RENT CONTROL, PRICE CONTROL,
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
70
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
ROOSEVELT TRADITION
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
80
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
PERSONAL ATTRIBUTES
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
90
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
OTHER
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
91
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NO SECOND REASON
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
98
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
DK
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
99
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
NA
</td>
</tr>
</table>
<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
value
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black;">
label
</th>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
99
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NA
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
98
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
DK
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
91
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
NO SECOND REASON
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
90
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
OTHER
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
80
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
PERSONAL ATTRIBUTES
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
70
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
ROOSEVELT TRADITION
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
60
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
TRUMAN PRO RENT CONTROL, PRICE CONTROL,
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
50
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
DEMOCRATS MEAN PROSPERITY, REPUBLICANS
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
40
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
GOOD CAMPAIGN CONDUCTED BY TRUMAN
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
30
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
TRUMAN PRO-LABOR, NEGRO, WORKING MAN
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
20
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center;">
EXPERIENCED, GOOD RECORD
</td>
</tr>
<tr>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
10
</td>
<td style="padding:0.2cm; text-align:left; vertical-align:top; text-align:center; background-color:#eaeaea;">
BETTER MAN
</td>
</tr>
</table>

Multiple Classifications
------------------------

Multiple classifications can be retrieved as well using the **get.classifications** function. This will return a list of **rds.classification** objects.

``` r
classifications <- get.classifications("http://localhost:8080/rds/api/catalog/","test","NES1948")
```

<br/><br/><br/><br/>
