## AtScale
To develop reports on PowerBI + AtScale, you first need to run the AtScale and IRIS containers “docker-compose up -d atscale”, “docker-compose up -d iris”.

### Creating a cube in AtSacle
Go to http://localhost:10500 is authorized (default admin:admin) in the top navigation menu go to Projects, all created projects will be displayed here. The container already has a GameOfThrones test project.

To create your own cube, you need to click “+ New projects” in Projects and write the name of the project in the window that appears.

![image](https://user-images.githubusercontent.com/47400570/165940835-7ced36e6-5a0e-4ec6-aadb-aab6729035a7.png)

Then you need to go to the created project and press Enter Model.

![image](https://user-images.githubusercontent.com/47400570/165940869-a963617e-160e-429a-9fcd-5082fbc6b4dd.png)

To view detailed documentation, you can go to Support -> Documentation. Here is the official AtScale documentation.

EnCommunityAnalytics2 test cube example:

![image](https://user-images.githubusercontent.com/47400570/165940961-71666008-8186-4ac8-906a-79dda15e3567.png)

Then you need to publish this project by going to Project -> (your project) and clicking Publish.

![image](https://user-images.githubusercontent.com/47400570/165941009-9b5e94d5-e1a3-4bb5-95c2-4547db685bf2.png)

## PowerBI connection

First of all, you need to download PowerBI Desktop on the official Microsoft website https://www.microsoft.com/store/productId/9NTXR16HNW1T

Then, to connect, you need to click Get data -> More -> Database -> AtScale cubes.

![image](https://user-images.githubusercontent.com/47400570/165941132-8ee8c6e4-1fa6-4208-9a83-2f8b0d498110.png)

In the server field, you need to insert an MDX link and select Data Connectivity mode "DirectQuery" and click OK.

![image](https://user-images.githubusercontent.com/47400570/165941252-28f1eaf7-2b9a-44ad-a1ea-962f474a3cd9.png)

An authorization dialog will open in which you need to enter User name and Password (default admin: admin), then click Connect.

![image](https://user-images.githubusercontent.com/47400570/165941281-6fabb96c-9c85-41d5-801b-26461ef04eb8.png)

Then a dialog box will open, where all available cubes in the source will be displayed, select the one you need and click Load.

![image](https://user-images.githubusercontent.com/47400570/165941335-bb47c062-20c5-4ed6-afdc-b3621bcbd447.png)

Done. Now you can start developing dashboards. On the left are the fields that can be used to build reports.

![image](https://user-images.githubusercontent.com/47400570/165941386-7da52024-a193-4c41-aff9-55bf0bf5da74.png)
