host=$'localhost'
user=$'admin'
password=$'admin'


TOKEN=$(curl  -u $user:$password --location --request GET "http://$host:10500/default/auth")

i=0
echo [] > arr
while [ "$(jq ".shedules.shedule[$i].response" shedules.json | diff -q arr -)" == "Files arr and - differ" ]
do	
	j=0
	while [ "$(jq ".shedules.shedule[$i].response[$j]" shedules.json)" != null ] 
	do
		echo "i = $i, j = $j "
		project_id=$(jq -r ".shedules.shedule[$i]" shedules.json | jq -r ".response[$j].project_id" )
		cube_id=$(jq -r ".shedules.shedule[$i]" shedules.json | jq -r ".response[$j].cube_id")
		time_expression=$(jq -r ".shedules.shedule[$i]" shedules.json | jq -r ".response[$j].time_expression")
		echo "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/$project_id/cubeId/$cube_id/jobs"
		echo "--data-raw '{'full_build':false,'time_expression':'$time_expression'}'"
		curl --location --request POST "http://$host:10502/aggregate-batch/scheduler/orgId/default/projectId/$project_id/cubeId/$cube_id/jobs" --header "Authorization: Bearer $TOKEN" --header 'Accept: */*' --header "Content-Type: application/json" --data-raw "{\"full_build\":false,\"time_expression\":\"$time_expression\"}"
		let "j += 1"
	done
	let "i += 1"
done