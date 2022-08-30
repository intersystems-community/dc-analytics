Here you can find scripts to manage aggregates build schedules. In all scripts you can set proper host, login and password variables for you. Default is localhost and admin/admin so you can use scripts without changes for this project.

aggreagtes_update_shedules_create.sh create build schedules for all projects in Adaptive Analytics installation. You may set up a scheduled time variable in cron format for all projects at once.

aggreagtes_update_instant.sh run the aggregates update at start of next minute.

If you want more control on aggregates, you may be interested in this:

aggreagtes_update_shedules_export_from_file.sh export all existing schedules from Adaptive Analytics installation. You may set up schedules for each cube in each project individually in the web interface and export them for future use in another instance or for backup purposes.

aggreagtes_update_shedules_import.sh can take the file from the previous script and import schedules from it to Adaptive Analytics installation.

It is convenient to use these scripts inside an AtScale docker container.

You can use this comand to copy scripts inside AtScale container

```
docker cp path_to_folder_with_scripts\script_name.sh public-intersystems-developer-community-analytics_atscale_1:/root/aggreagtes_update_shedules_create.sh
```

Next step you run a script by this command:

```
docker exec -it public-intersystems-developer-community-analytics_atscale_1  script_name.sh
```


