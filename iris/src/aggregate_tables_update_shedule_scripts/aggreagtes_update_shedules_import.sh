#!/bin/sh

apt update
apt install -y jq

host=$'localhost'
user=$'admin'
password=$'admin'

TOKEN=$(curl  -u $user:$password --location --request GET "http://$host:10500/default/auth")
echo '{"shedules": {' >> shedules.json
echo '"shedule":[' >> shedules.json
PROJECTS_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/projects" --header "Authorization: Bearer $TOKEN" | jq -r '.response[].id')
echo $PROJECTS_ID
for project in $PROJECTS_ID
do
	CUBES_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.cubes.cube[].id')
    project_engine_id=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.annotations.annotation[2].value')
	for cube in $CUBES_ID
	do
		curl --location --request GET "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/$project_engine_id/cubeId/$cube/jobs?active=true" --header "Authorization: Bearer $TOKEN" | jq '.' >> shedules.json
        echo ',' >> shedules.json	
		sleep 1s
	done
done
echo '{"response":[]}]}}' >> shedules.json
cp shedules.json settings
rm shedules.json