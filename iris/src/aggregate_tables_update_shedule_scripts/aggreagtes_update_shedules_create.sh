#!/bin/sh

apt update
apt install -y jq
host=$'localhost'
user=$'admin'
password=$'admin'

time_expression=$'0 0 1 ? * *'

TOKEN=$(curl  -u $user:$password --location --request GET "http://$host:10500/default/auth")
PROJECTS_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/projects" --header "Authorization: Bearer $TOKEN" | jq -r '.response[].id')
for project in $PROJECTS_ID
do
	CUBES_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.cubes.cube[].id')
    project_engine_id=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.annotations.annotation[2].value')
	for cube in $CUBES_ID
	do
		$curl --location --request POST "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/$project_engine_id/cubeId/$cube/jobs" --header "Authorization: Bearer $TOKEN" --header 'Accept: */*' --header "Content-Type: application/json" --data-raw "{\"full_build\":false,\"time_expression\":\"$time_expression\"}""
		echo 'create'
        sleep 1s
	done
done
