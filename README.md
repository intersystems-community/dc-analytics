# DC Analytics

[![Gitter](https://img.shields.io/badge/chat-on%20telegram-blue.svg)](https://t.me/joinchat/FoZ4M0KF5NakAJPwyg1Saw)

InterSystems Developer Community analytics.
Project made with InterSystems Analytics (DeepSee) to visualize and analyze members, articles, questions, answers, views and other pieces of content and activity on [InterSystems Developer Community](community.intersystems.com)

[See Live DC analytics](https://analytics.community.intersystems.com/dswpub/index.html#!/?ns=COMMUNITYPUBLIC&embed=1)
![DC analytics](https://github.com/MakarovS96/images/blob/master/dcanalitycs.jpg)

# Collaboration

## Installation
### Basic
1. First be sure, that you have [MDX2JSON](https://github.com/intersystems-ru/Cache-MDX2JSON) and [DSW](https://github.com/intersystems-ru/DeepSeeWeb) installed.
2. Create new namespace with **DCANALYTICS** name.
3. Enable DeepSee in namespace web-application settings.
4. Download from release and import `DCAnalytics_classes*.xml` file.
5. Download from release `DCAnalytics_globals.gz` and run in terminal:
```
DCANALYTICS> do ##class(Community.Utils).setup("path/to/global/archive")
```
6. Download from release `DSW.config.and.iKnow.files.zip` and move file `dcanalytics.json` from archive to `<your_instance>/CSP/dcanalytics/configs/`. The name of `dcanalytics.json` should be match the name of the namespace.
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
