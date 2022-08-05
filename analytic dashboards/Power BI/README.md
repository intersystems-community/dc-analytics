## AtScale
First you need to run two AtScale and IRIS containers “docker-compose up -d atscale”, “docker-compose up -d iris”. The AtSacle container already has a test published cube.

## PowerBI
To view and develop reports on PowerBI, first of all, you need to download PowerBI Desktop on the official Microsoft website https://www.microsoft.com/store/productId/9NTXR16HNW1T
Then, to connect, you need to click Get data -> More -> Database -> AtScale cubes.

![image](https://user-images.githubusercontent.com/47400570/165940147-26abee0c-2030-4b44-9622-d3eced32c081.png)

In the server field, you need to insert an MDX link and select Data Connectivity mode "DirectQuery" and click OK.

![image](https://user-images.githubusercontent.com/47400570/165940185-9c02d280-08ac-4d71-9e20-c9c1277cb43e.png)

An authorization dialog will open in which you need to enter User name and Password (default admin: admin), then click Connect

![image](https://user-images.githubusercontent.com/47400570/165940238-74fc94a2-92a7-434d-bdbe-e161116a9ac8.png)

Then a dialog box will open, where all available cubes in the source will be displayed, select the one you need and click Load.

![image](https://user-images.githubusercontent.com/47400570/165940278-accc4fa7-d521-4972-93fc-b59ba5610fcf.png)

Done. Now you can start developing dashboards. On the left are the fields that can be used to build reports.

![image](https://user-images.githubusercontent.com/47400570/165940410-0c7cdd67-0adf-450c-901c-5b455a8fde1d.png)
