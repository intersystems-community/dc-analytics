## export globals from COMMUNITYPUBLIC
```

set gbl="Com*D.GBL,His*D.GBL"
s fn="DCPublic_globals.gz"
s s=##class(%Stream.FileBinaryGzip).%New() do s.LinkToFile(fn) do $System.OBJ.ExportToStream(gbl,s,"/mapped") do s.%Save() kill s

```

## build container with no cache
```
docker-compose build --no-cache
```
## open terminal to docker
```
docker-compose exec iris iris session iris -U IRISAPP
```

## global export
 $System.OBJ.Export("GlobalName.GBL","/irisdev/app/src/gbl/globalname.xml")
```