# For beginers

If you are new in Tableau you can get acquainted with the dashboards using the trial version of the product. You can download Tableau [here](https://www.tableau.com/products/desktop/download). You will be asked to fill in information about yourself. Tableau have their [get started tutorial](https://help.tableau.com/current/guides/get-started-tutorial/en-us/get-started-tutorial-home.htm). You will finde there meven more than you need to explore and change our dashdoards.

"Monthly_EnCommunityAnalytics public demo.twb" connected to online public demo. Credentials for AtScale: login: user password: userp@ss 

"Monthly_EnCommunityAnalytics local.twb"  connected to our local container. Credentials for AtScale: login: admin password: admin

Tableau works in direct connection mode. Loading data may take up to ten minutes

## To an existing report
If you want to add a data source to an existing report, 
select the **Data Source** tab on the tab bar below and click on the Tableau icon in the top left, then follow the steps above.

## Authorization in the
Tableau data source will ask you to enter your username and password from Atscale (admin/admin)

![Authorization](https://user-images.githubusercontent.com/91419671/189289302-fda2cab8-92d9-4802-beaa-2b421e4f2674.png)

After successful authorization your cube will appear in the data sources and you can get started.

![Cube in the report](https://user-images.githubusercontent.com/91419671/189289522-03bfa04d-806e-4680-a27a-aec325c3aca5.png)

The TDS file is XML, so it won't be too hard to fix this XML in case 
you have republished the project under a different name, or made changes to the hostname of the Atscale server.

You can find TDS files here: "analytic_dashboards/Tableau/tds/"

You can also replace the data source by right-clicking on it and selecting *Replace Data Source...*

![Source replacement 1](https://user-images.githubusercontent.com/91419671/189289604-248e8047-4c1d-4a77-8cff-65a77c11f8f5.png)

Then you need to select the current and new data source in the window that appears

![Source replacement 2](https://user-images.githubusercontent.com/91419671/189289659-ce92657d-63b2-4c67-b9fd-de14d264b1c8.png)


