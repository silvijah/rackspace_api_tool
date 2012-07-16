#!/bin/bash

function authenticate()
{

authenticate= read -p "USERNAME " USERNAME; read -p "ACCOUNT " ACCOUNT; read -p "API KEY " APIKEY;read -p "DATACENTER LOCATION " LOCATION;

auth_response="$(curl -i -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/v1.0 | egrep -e '(^HTTP/1.1|^X-Auth-Token)')"

APITOKEN=

if [ "$(echo "$auth_response" | head -1 | awk '{print $2}')" = "204" ]; then
        APITOKEN="$(echo "$auth_response" | tail -1 | awk '{print $NF}' | sed -e 's/[\r\n]//g')"
else
        echo    "Authentication failed"
        exit
fi


#read -p "username " USERNAME
#read -p "API key " APIKEY
#read -p "ACCOUNT " ACCOUNT

#curl -i -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/v1.0
} 
