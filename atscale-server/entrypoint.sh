#!/bin/sh

if [ -f ./first-time.set ]
then
  # JQ package used later in backend response parsing
  apt update
  apt install -y jq

  cp ./atscale.yaml /opt/atscale/conf
  chown atscale:atscale /opt/atscale/conf/atscale.yaml
  rm ./first-time.set
  su - atscale -c "/opt/atscale/versions/2021.3.0.3934/bin/configurator.sh --activate --automatic-install"

  RESPONSE="1"
  TIME=1
  echo "Waiting for engine ......."

  while [ "$RESPONSE" != "200 OK" ]
  do
    for license in /root/license/*
    do
      RESPONSE=$(curl --location --request PUT 'http://127.0.0.1:10502/license'  --header 'Content-Type: application/json' --data-binary "@$license" | jq -r '.status.message')
      sleep 1s
    done
    echo "$TIME seconds waiting"
    TIME=$(($TIME + 1))
  done
  echo "Engine started"

  TOKEN=$(curl  -u admin:admin --location --request GET 'http://localhost:10500/default/auth')

  for cube in /root/cubes/*
  do
    sleep 1s
    curl --location --request POST "http://localhost:10500/api/1.0/org/default/project" --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/xml" --data-binary "@$cube"
    sleep 5s
  done

  for connection in /root/connections/*
  do
    sleep 1s
    curl --location --request POST "http://localhost:10502/connection-groups/orgId/default"  --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json"  --data-binary "@$connection"
    sleep 5s
  done

  PROJECTS_ID=$(curl --location --request GET "http://localhost:10500/api/1.0/org/default/projects" --header "Authorization: Bearer $TOKEN" | jq -r '.response[].id')
  for project in $PROJECTS_ID
  do
    curl --location --request POST "http://localhost:10500/api/1.0/org/default/project/$project/publish" --header "Authorization: Bearer $TOKEN"
    sleep 1s
  done


  sleep 1s
  curl --location --request POST "http://localhost:10502/organizations/orgId/default" --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json" --data-raw '{"hiveServer2Port": 11111}'
  sleep 1s

  for settings_list in /root/settings/*
  do
    curl --location --request PATCH 'http://localhost:10502/settings' --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json"  --data-binary "@$settings_list"
  done

  curl --location --request POST 'http://localhost:10500/api/1.0/referrerOrg/default/support/service-control/engine/restart'
else
  su - atscale -c "/opt/atscale/bin/atscale_start"
fi

exec "$@"