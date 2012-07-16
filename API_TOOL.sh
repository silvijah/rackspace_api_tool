#! /bin/bash

authenticate= read -p "USERNAME " USERNAME; read -p "ACCOUNT " ACCOUNT; read -p "API KEY " APIKEY;read -p "DATACENTER LOCATION " LOCATION;

auth_response="$(curl -i -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/v1.0 | egrep -e '(^HTTP/1.1|^X-Auth-Token)')"

APITOKEN=

if [ "$(echo "$auth_response" | head -1 | awk '{print $2}')" = "204" ]; then
	APITOKEN="$(echo "$auth_response" | tail -1 | awk '{print $NF}' | sed -e 's/[\r\n]//g')"
else
	echo	"Authentication failed"
	exit
fi

while true; do 
	echo -e -n "\n\tCHOOSE ONE OF THE FOLLOWING OPTIONS:\n\n"
	echo "1 DATABASE INSTANCES"
	echo "2 EXIT"

	read CONFIRM
	case $CONFIRM in
		1|INSTANCES)
			if [ "~/rackspace_api_tool/databases.sh" ]; then
				source ~/rackspace_api_tool/databases.sh
				instances
			else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
		2|EXIT)
			echo "THANK YOU FOR USING THE API CLIENT"
			exit
			;;
		*) 
			echo "UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE"
			;;
	esac
done
