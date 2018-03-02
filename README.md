# DCPublic
Public version developer community analytics.
## Installation
### Basic
1. First be sure, that you have [MDX2JSON](https://github.com/intersystems-ru/Cache-MDX2JSON) and [DSW](https://github.com/intersystems-ru/DeepSeeWeb) installed.
2. Create new namespace with **DCPUBLIC** name.
3. Enable DeepSee in namespace web-application settings.
4. Download from release and import `DCPuplic_classes*.xml` file.
5. Download from release `DCPublic_globals.gz` and run in terminal:
```
DCPUBLIC> do ##class(Community.Utils).setup("path/to/global/archive")
```
6. Download from release `DSW.config.and.iKnow.files.zip` and move file `dcpublic.json` from archive to `<your_instance>/CSP/dcpublic/configs/`.
7. Open in your browser `<server:port>/dsw/index.html?ns=DCPUBLIC`.
8. Done
### With iKnow
1. Be sure, that everything listed above is installed.
2. Download from release `DSW.config.and.iKnow.files.zip` and move files `sets.txt` and `backlist.txt` from archive to `<your_instance>/Mgr/DCPUBLIC/`.
3. Run in terminal:
```
DCPUBLIC> do ##class(Community.iKnow.Utils).setup()
DCPUBLIC> do ##class(Community.iKnow.Utils).update()
DCPUBLIC> do ##class(Community.Utils).UpdateСubes()
```
4. Open iKnow dashboard:`<server:port>/dsw/index.html#!/d/iKnow.dashboard?ns=DCPUBLIC`
5. Done
