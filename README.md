# DC Analytics

[![Gitter](https://img.shields.io/badge/chat-on%20telegram-blue.svg)](https://t.me/joinchat/FoZ4M0KF5NakAJPwyg1Saw)

InterSystems Developer Community analytics.
Project made with InterSystems Analytics (DeepSee) and various BI systems to visualize and analyze members, articles, questions, answers, views and other pieces of content and activity on [InterSystems Developer Community](community.intersystems.com). This project contains pre-configured IRIS and Atscale  deployment in Docker containers and project files for BI systems .

[See Live DC analytics](we'll provide the link to online demo as soon as we made it)

### 1. To start IRIS 
Open the terminal in this directory and run:  
```
$ docker-compose up -d iris
```
Check the availability of the service:  
http://localhost:52773/dsw/index.html#/DCANALYTICS 
    
Standard login and password:  
_system/SYS 

### 2. To start the Atscale server:  

A license must be entered to run Atscale server. To do this, you need to put the json file with the license in the folder "atscale-dataset/src/license".

If you need to change hostname parameter, open directory "atscale-dataset", file "atscale.yaml" and edit (ip or dns name):  
loadbalancer_dns_name: "127.0.0.1"  
    
Run docker container with the command:  
```
docker-compose up -d atscale  
```
Wait 2-3 minutes while server is starting up and check the availability of the service:  
http://localhost:10500/login  
    
Standard login and password:  
admin/admin 

If you want to access the web interface, at the initialization step, you need to leave the default connection port, leave the login and password admin / admin and select an Embedded directory for storing data. These connection settings are stored in the BI projects settings.

### 3. To use BI projects

#### Power BI

You may simply run the .pbix file from "analytic dashboards\Power BI" in Power BI desktop. Power BI stored data in this file, so to have actual data you firstly need to update the report by the Refresh button.

#### Logi
You need a licensed copy of the Logi report Designer to run the reports.

In the folder "analytic dashboards\logi report\En report" you can find the report for the EN community.

In folder "analytic dashboards\logi report\members by community" you can find the report about distribution of members by different language communities.

# Collaboration

If you want to use this project on your inw IRIS installation, you may use the following instructions.

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
1. Enable iKnow in namespace web-application settings. Be sure, that everything listed above is installed.
2. Download from release `DSW.config.and.iKnow.files.zip` and move files `sets.txt` and `backlist.txt` from archive to `<your_instance>/Mgr/DCANALYTICS/`.
3. Run in terminal:
```
DCANALYTICS> do ##class(Community.iKnow.Utils).setup()
DCANALYTICS> do ##class(Community.iKnow.Utils).update()
DCANALYTICS> do ##class(Community.Utils).UpdateСubes()
```
4. Open iKnow dashboard:`<server:port>/dsw/index.html#!/d/iKnow.dashboard?ns=DCANALYTICS`
5. Done
