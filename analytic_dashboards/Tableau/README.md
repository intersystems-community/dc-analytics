## To an existing report
If you want to add a data source to an existing report, 
select the **Data Source** tab on the tab bar below and click on the Tableau icon in the top left, then follow the steps above.

## Authorization in the
Tableau data source will ask you to enter your username and password from Atscale (admin/admin)

![Authorization](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/7.png)

After successful authorization your cube will appear in the data sources and you can get started.

![Cube in the report](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/8.png)

The TDS file is XML, so it won't be too hard to fix this XML in case 
you have republished the project under a different name, or made changes to the hostname of the Atscale server.

You can find TDS files here: "analytic_dashboards/Tableau/tds/"

You can also replace the data source by right-clicking on it and selecting *Replace Data Source...*

![Source replacement 1](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/9.png)

Then you need to select the current and new data source in the window that appears

![Source replacement 2](https://github.com/teccod/AtScale-Tableau-DC/blob/main/readme_img/10.png)


