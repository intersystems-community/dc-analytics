# DC Analytics

[![Gitter](https://img.shields.io/badge/chat-on%20telegram-blue.svg)](https://t.me/joinchat/FoZ4M0KF5NakAJPwyg1Saw)

InterSystems Developer Community analytics.
Project made with InterSystems IRIS BI (DeepSee), Power BI and Logi Report Designer to visualize and analyze members, articles, questions, answers, views and other pieces of content and activity on [InterSystems Developer Community](community.intersystems.com). This project contains pre-configured IRIS and Atscale  deployment in Docker containers and project files for BI systems . This project also deployed online and you can check it here:

### See Live DC analytics

[PowerBI Interactive Dashboard with connection to the Adaptive Analytics Instance](https://app.powerbi.com/view?r=eyJrIjoiMjU0NjgyNjgtYjA0NS00M2Q3LTg3NzUtN2EwNjVjMGQ0Yzk5IiwidCI6IjRlMzI1ZjgzLWE4YWYtNGY2Yy05ODY3LTBkYTA4YmU1MGZjMCIsImMiOjEwfQ%3D%3D&pageName=ReportSection&language=en-us)

[Instance of Adaptive Analytics powered by AtScale](http://atscale-public.demo.community.intersystems.com:10500/login)

Login: user
Password: userp@$$

### How to run DC analytics on a personal laptop:
First, you need to clone this repository to your local machine. Below in the text we will use relative paths to files when describing what is where. We assume that you are already in the project's root directory.


### 1. Starting IRIS 
InterSystem IRIS stores all the data in this sample project/ So we need InterSystems IRIS up and running and persists data. Below we will take the vanila image of InterSystems IRIS and load Community analytics data. Open the terminal in the project directory and run:  
```
$ docker-compose up -d iris
```

This procedure will take 10-15 minutes.

After build will complete, you may check the IRIS BI dashboards here:  
http://localhost:52773/dsw/index.html#/DCANALYTICS

It will looks like that:

<img width="437" alt="image" src="https://user-images.githubusercontent.com/41373877/184346201-61a3cc68-8cdc-4fcc-a27d-664a877728eb.png">

Standard login and password:  
_system/SYS 

One of basic dashboards:
<img width="1188" alt="image" src="https://user-images.githubusercontent.com/41373877/184346339-7e896fcd-629b-4225-85c2-950d9fe63723.png">



#### Option: UDAF optimization
If you have a commercial license on IRIS you may have LOGIN and PASSWORD for use in private ZPM registry.
In that case you may install isc-udaf package from there.
Installation command in IRIS looks like this:
```
zpm "repo -n registry -r -url https://pm.intersystems.com/ -user LOGIN -pass PASSWORD"
zpm "install isc-udaf"
```
Next, you have to swith UDAF on in AtScale Data Warehouse settings:
Go to http://[your-atscale-server]:10500/org/default/settings/data-warehouses and set Custom Function Installation Mode to Custom Managed value.
![image](https://user-images.githubusercontent.com/41373877/184353600-f0032b36-cf35-418b-94bf-d79c5e1a9a53.png)

UDAF gives AtScale 2 main advantages: 
- the ability to store query cash (they call it Aggregate Tables), so that the next query, using aggregation on data, takes from the database already pre calculated results.
- the ability to use additional functions (actually User-Defined Aggregate Functions) and data processing algorithms that AtScale is forced to store in the data source. 
They are stored in the database in a separate table and Adaptive Analytics can call them by name in auto generated queries. When AtScale can use these functions, the speed of queries increases.

AtScale has an internal logic for updating aggregate tables, but it is much more convenient to control this process yourself.
You can configure updates on a per-cube basis in the web interface of AtScale and then use scripts from "iris/src/aggregate tables update shedule scripts" to export schedules and import to another instance, or use the exported schedule file as a backup. You will also find a script to set all cubes to the same update schedule if you do not want to configure each one individually.


### 2. To start an Atscale server:  

A license must be provided to run Atscale server. To do this you need to put the json file with the license in the folder "atscale-dataset/src/license". 
#ToDo Add how to give a link by docker-compose having one license for several projects.

In case you plan to deploy this project to some server you might want to alter hostname parameter: open directory "atscale-dataset", file "atscale.yaml" and edit (ip or dns name):  
loadbalancer_dns_name: "127.0.0.1"  

#### Authenticating to the InterSystems Container Registry(ICR)
This sample uses [AtScale docker container](https://github.com/intersystems-community/dc-analytics/blob/28d6040ca99a99641f0c88689c3402cc5872e9b2/docker-compose.yml#L17) in ICR. This is a gated registry, thus the access token will be requested which you can obtain being a current InterSystems customer.
To sign into the ICR, take the following steps:

Open https://containers.intersystems.com/ in your browser and sign in using your InterSystems credentials.

Retrieve your Docker login token, or the full login command.

In your Docker interface (for example, your PowerShell window or Linux command line), authenticate to the ICR using the provided credentials. You can do this by copying and pasting the full docker login command displayed, for example:

```
docker login -u="your_username" -p="provided_password" containers.intersystems.com
```

For security reasons, however, you may want to instead enter the command docker login containers.intersystems.com, then enter your username at the Username prompt and paste your password into the Password: prompt.

Note: If you are logged into another Docker registry, the docker login command may result in an error; log out of the other registry before logging into containers.intersystems.com.


    
Run docker container with the command:  
```
docker-compose up -d atscale  
```
This will take a few minutes to pull and build the container. 

After successful build wait 2-3 minutes while server is starting up and check the availability of the service:  

http://localhost:10500/login  
    
Standard login and password:  
admin/admin 

This web interface lets you create and edin AtScale BI cubes. You need to follow the initial AtScale setup wizard and choose the following options. 

- you need to leave the default connection port
- leave the login and password admin / admin 
- select an Embedded directory for storing data

These connection settings are stored in the BI projects settings.

If you want to modify AtScale cubes you can find them in the projects tab. When you finish editing cubes and want to save changes go to the export tab of the project and download the xml representation of your cube. Then you need to put this file in the “/atscale-server/src/cubes/” folder of the repository (file name doesn't matter) and delete the existing xml file of the project. If you don't delete the original file AtScale wouldn't publish the updated project with the same name and id. At the next build a new version of the project will be automatically passed to AtScale and will be ready for use as a default project.

AtScale doesn't provide public documentation. In order to obtain the documentation open http://localhost:10500/org/default/support and go to the Documentation tab. You will be redirected to https://documentation.atscale.com/ and will be able to view it. We recommend examining [this](https://documentation.atscale.com/2022.2.0/creating-and-sharing-cubes/creating-cubes) chapter to work with existing projects.

#### Saving changes:
By default, all changes to the IRIS or Atscale projects are saved inside these systems.  
To cancel all changes and return to the default settings, from the current directory, run the command:  
```
docker-compose down -v
```
**Warning!** This will remove all created Iris and  Atscale containers and any changes saved in them.  


### 3. Using BI projects

#### Using demo IRIS and AtScale.

In "analytic dashboards" folder you can find BI projects that are configured for both local data source and deployed online demo.

The AtScale online demo located at http://atscale-public.demo.community.intersystems.com:10500/login. Login and password for it: user/userp@$$

#### Power BI
The option of creation and editing of Power BI dashboards is available only for Windows OS.

You may simply run the .pbix file from "analytic dashboards\Power BI" in the [Power BI desktop](https://powerbi.microsoft.com/en-gb/desktop/). Power BI stores BI data in this file, so when you open it for the first time it will show BI dashboards with data that was loaded by developers of this project. Click the refresh button to load the actual data into Power BI. Use the same credentials as in the Adaptive Analytics (AtScale) with Simple Auth method (admin/admin).

If you want to modify the Power BI dashboards you may check [official beginner's guide](https://docs.microsoft.com/en-us/power-bi/fundamentals/desktop-getting-started) to learn the basics. We already prepare all the data, so you can start from [build report](https://docs.microsoft.com/en-us/power-bi/fundamentals/desktop-getting-started#build-reports) step.

After you finish modifying the Power BI project and save it, the changes will be automatically stored in the Power BI file in the repository.

#### Logi
You need a licensed copy of the Logi Report Designer to edit and run the reports. Also, you will need drivers for jdbc connection. You can find them here: https://github.com/teccod/Logi-JDBC-drivers. To use them you need to place [lib](https://github.com/teccod/Logi-JDBC-drivers/tree/main/lib) folder in the root folder of Logi Report Designer's installation directory.

#ToDo Describe how to obtain your copy of Logi Designer or Logi Server. From WRC or similar.

On the Start page of Logi Report Designer you need to click the Browse button in the Open category and select the path to the .cat file, then open a .cls file.

In  "analytic dashboards\logi report\En report" folder  you may find the Сommunity monthly overview report - x pages report.

In "analytic dashboards\logi report\members by community" folder  you may find a simple report regarding the distribution of members by different language communities.

If you want to modify Logi reports you may be interested in [official beginner's guide](https://devnet.logianalytics.com/hc/en-us/articles/4405661292567-Report-Types) to understand this BI system. If you only want quickly examine some data, you may be interested in explanation how to make a [chart](https://devnet.logianalytics.com/hc/en-us/articles/4405664328087-Lesson-4-Creating-a-Chart-Report) or a [table](https://devnet.logianalytics.com/hc/en-us/articles/4405664328983-Lesson-5-Creating-a-Table-Report#Task1). The beginner's guide describes the process of creating a widget in a new report file. You can insert a chart or table into an existing report. You can do it from the Insert tab or Component window.

![image](https://user-images.githubusercontent.com/91419671/181744373-dcbe9939-e6cf-46e4-8ef2-a60f0ed70e21.png)

When you finish editing reports, you need to save the changes in the cls file, which is responsible for the visual part and in the cat file both, which is responsible for the structure and data processing.

# Collaboration

If you want to use this project on your onw IRIS installation, you may use the following instructions.

## Installation
### Basic
1. First be sure, that you have [MDX2JSON](https://github.com/intersystems-ru/Cache-MDX2JSON) and [DSW](https://github.com/intersystems-ru/DeepSeeWeb) installed.
2. Create new namespace with **DCANALYTICS** name.
3. Enable DeepSee in namespace web-application settings.
4. Download from release and import `DCAnalytics_classes*.xml` file.
5. Download from release `DCAnalytics_globals.gz` and run in terminal:
```
DCANALYTICS> do ##class(Community.Utils).setup("path/to/global/archive.gz file")
```
6. Download from release `DSW.config.and.iKnow.files.zip` and move file `dcanalytics.json` from archive to `<your_instance>/CSP/dsw/configs/`. The name of `dcanalytics.json` should match the name of the namespace.
7. Open in your browser `<server:port>/dsw/index.html?ns=DCANALYTICS`.
8. Done
### With iKnow
1. Enable iKnow in namespace web-application settings. Be sure that everything listed above is installed.
2. Download from release `DSW.config.and.iKnow.files.zip` and move files `sets.txt` and `backlist.txt` from archive to `<your_instance>/Mgr/DCANALYTICS/`.
3. Run in terminal:
```
DCANALYTICS> do ##class(Community.iKnow.Utils).setup()
DCANALYTICS> do ##class(Community.iKnow.Utils).update()
DCANALYTICS> do ##class(Community.Utils).UpdateСubes()
```
4. Open iKnow dashboard:`<server:port>/dsw/index.html#!/d/iKnow.dashboard?ns=DCANALYTICS`
5. Done
