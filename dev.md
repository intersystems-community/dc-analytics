## export globals from COMMUNITYPUBLIC
```

set gbl="Com*D.GBL,His*D.GBL"
s fn="DCPublic_globals.gz"
s s=##class(%Stream.FileBinaryGzip).%New() do s.LinkToFile(fn) do $System.OBJ.ExportToStream(gbl,s,"/mapped") do s.%Save() kill s

```

## build container with no cache
```
docker-compose build --no-cache --progress=plain
```
## open terminal to docker
```
docker-compose exec iris iris session iris -U IRISAPP
```

## global export
```
 $System.OBJ.Export("GlobalName.GBL","/irisdev/app/src/gbl/globalname.xml")
```

## service account key base64 command
```
$ base64 iris-community-demos-09899421cfc4.json | tr -d '\n'
```

## alternative atscale image
```
ghcr.io/intersystems-community/atscale-server:2021.3.0.3934
```

To use this alternative image you need to authorize docker to download images from [ghcr.io](https://ghcr.io).  
Login requires your GitHub account credentials, run the command in the terminal:  
```
$ docker login ghcr.io
> Username: your_username
> Password: your_github_token
```

When entering a password, you need to use the GitHub access token, you can read how to get it at the [link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token).  
In the "GitHub access token" settings, should be opened access to read packages from the GitHub package registry:  
<img src="https://user-images.githubusercontent.com/49229973/157600567-f80a8f9f-15e2-41c6-bf18-2c3ef6e1639d.jpg" width="600" />

## update AtScale aggregates

You can use this comand to copy scripts inside AtScale container

```
docker cp path_to_repo/Public-InterSystems-Developer-Community-analytics/iris/src/aggregate_tables_update_shedule_scripts/aggreagtes_update_instant.sh public-intersystems-developer-community-analytics_atscale_1:/root/aggreagtes_update_instant.sh 
```

Next step you run a script by this command:

```
docker exec -it public-intersystems-developer-community-analytics_atscale_1  aggreagtes_update_instant.sh 
```

