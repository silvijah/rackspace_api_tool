#!/bin/bash

function authenticate()
{
#read -p "username " USERNAME
#read -p "API key " APIKEY
#read -p "ACCOUNT " ACCOUNT

curl -i -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/v1.0
} 
