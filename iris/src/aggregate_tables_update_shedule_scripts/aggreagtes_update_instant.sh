#!/bin/sh

apt update
apt install -y jq
host=$'localhost'
user=$'admin'
password=$'admin'

MIN=`date +"%M"`
export MIN
next=$(($MIN+1))
hour=`date +"%H"`
export hour
time_expression="0 $next $hour ? * *"
echo $time_expression

job_ids=()
project_engine_id=()
cubes=()
TOKEN=$(curl  -u $user:$password --location --request GET "http://$host:10500/default/auth")
PROJECTS_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/projects" --header "Authorization: Bearer $TOKEN" | jq -r '.response[].id')
for project in $PROJECTS_ID
do
	CUBES_ID=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.cubes.cube[].id')
    project_engine_id=$(curl --location --request GET "http://$host:10500/api/1.0/org/default/project/$project" --header "Authorization: Bearer $TOKEN" | jq -r '.response.annotations.annotation[2].value')
	for cube in $CUBES_ID
	do
		job_ids[${#job_ids[@]}]="$(curl --location --request POST "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/$project_engine_id/cubeId/$cube/jobs" --header "Authorization: Bearer $TOKEN" --header 'Accept: */*' --header "Content-Type: application/json" --data-raw "{\"full_build\":false,\"time_expression\":\"$time_expression\"}" | jq -r '.response.job_id')" 
        project_engine_ids[${#project_engine_ids[@]}]=$project_engine_id
		cubes[${#cubes[@]}]=$cube
		sleep 1s
	done
done

sleep 2m

for i in "${!job_ids[@]}"
do
	echo $(curl --location --request DELETE "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/${project_engine_ids[$i]}/cubeId/${cubes[$i]}/jobs/${job_ids[$i]}" --header "Authorization: Bearer $TOKEN")
done
