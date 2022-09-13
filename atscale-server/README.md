## Using a vanilla AtScale image

You can run a vanilla AtScale image with this command:

```
docker run \
   --restart=always \
   --name atscale \
   --hostname atscale \
   --tty \
   -v atscale-data:/opt/atscale/data \
   -v atscale-conf:/opt/atscale/conf \
   -v atscale-log:/opt/atscale/log \
   -p 10500:10500 \
   -p 10502:10502 \
   -p 10503:10503 \
   -p 10525:10525 \
   -p 11111:11111 \
   -d containers.intersystems.com/intersystems/adaptive-analytics:2021.3.0.3934
```

You may find the following commands useful:

Print container log:

```
docker logs -f atscale
```

Delete container:

```
docker rm -f atscale
```

Remove all volumes (atscale settings):

```
docker volume rm atscale-data atscale-log atscale-conf
```

Remove image from atscale:

```
docker image rm containers.intersystems.com/intersystems/adaptive-analytics:2021.3.0.3934
```

## atscale-server description

### Changing the port to connect Iris-dataset  
    
1. Open the menu "Setting" -> "Data Warehouses" and click on the arrow opposite the connection to "Iris".  
<img src="https://user-images.githubusercontent.com/49229973/158963229-f5f28c2a-22ce-4f86-bdc7-2ba33d44710f.jpg" width="800" />

2. Connection settings will appear, click "Edit".
<img src="https://user-images.githubusercontent.com/49229973/158963472-7f2edeb4-75e9-4b3f-8a06-748067f455ea.jpg" width="800" />

3. Change the iris port and save the settings. 
<img src="https://user-images.githubusercontent.com/49229973/158963630-c74e5950-17b0-47b6-8663-89c80ee2ec6a.jpg" width="800" />
