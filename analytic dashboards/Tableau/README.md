# Preparing the PC

You will need a driver to connect. We use **Cloudera Hive**. You can download the driver from the official website:
https://www.cloudera.com/downloads/connectors/hive/odbc/2-6-1.html
Registration is required, you can do it right there for free. You also need to know your OS and bit depth in order to choose the right version for download.
Installation is simple, no explanation required.


# Foreword

This guide describes how to connect Tableau to AtScale. 
However, the twb files already have the connection. 
Also in the tds folder are files for connecting to the AtScale public demo.


# Preparing AtScale

## Publishing a project
To connect a cube, you need to publish a project with the necessary cubes

To publish, select **PROJECTS > "Project name" > DRAFT "Project name" > PUBLISH**

![Publish a project](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/1.png)

In the window that appears, you can select another datasource or leave the current one by clicking Next.

![Publish Window](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/2.png)

## Downloading the tds file

After that, we will have a published project. We need a Tbaleau connection file. 
In the **published** project, select the **cube**. In our case, this is Members. Then go to the **CONNECT** tab. 
On it, select *Connect a BI Tool > TABLEAU*

![tds file](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/3.png)

In the window that appears, select **DOWNLOAD TDS**

![Downloading tds](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/4.png)

# Connect source to Tableau

## New file
When starting Tableau in left menu select Connect, To a File, More… from the list and open your .tds file that you downloaded earlier.

![Download tds](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/6.png) 
![Download tds](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/5.png)

## To an existing report
If you want to add a data source to an existing report, 
select the **Data Source** tab on the tab bar below and click on the Tableau icon in the top left, then follow the steps above.

## Authorization in the
Tableau data source will ask you to enter your username and password from Atscale

![Authorization](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/7.png)

After successful authorization your cube will appear in the data sources and you can get started.

![Cube in the report](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/8.png)

The TDS file is XML, so it won't be too hard to fix this XML in case 
you have republished the project under a different name, or made changes to the hostname of the Atscale server.

You can also replace the data source by right-clicking on it and selecting *Replace Data Source...*

![Source replacement 1](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/9.png)

Then you need to select the current and new data source in the window that appears

![Source replacement 2](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/10.png)


