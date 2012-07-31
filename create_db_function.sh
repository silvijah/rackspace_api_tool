#! /bin/bash

function createdbinstance() {

read -p "Please Enter your New Database name " DB1
read -p "Please Enter your New Instance name " INSTANCE
read -p "Please Enter your New Username " USER
read -p "New Password " PASS

createinstance="
{
	\"instance\": {
		\"databases\": [{
			\"character_set\": \"utf8\",
			\"collate\": \"utf8_general_ci\",
			\"name\": \"$DB1\"
		}],
		\"flavorRef\": \"https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors/1\",
		\"name\": \"$INSTANCE\",
		\"users\": [{
			\"databases\": [{
				\"name\": \"$DB1\"
			}],
			\"name\": \"$USER\",
			\"password\": \"$PASS\"
		}],
		\"volume\": {\"size\": 2}
	}
}"

export createinstance
}
