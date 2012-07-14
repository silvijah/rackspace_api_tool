#! /bin/bash

read -p "USERNAME " USERNAME;
read -p "ACCOUNT " ACCOUNT;
read -p "API KEY " APIKEY;
read -p "DATACENTER LOCATION " LOCATION;
curl -i -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/v1.0;
read -p "VALID API TOKEN " APITOKEN;

while true; do 
	echo -e -n "\n\tCHOOSE ONE OF THE FOLLOWING OPTIONS:\n\n"
	echo "1 DATABASE INSTANCES"
	echo "2 EXIT"

	read CONFIRM
	case $CONFIRM in
		1|INSTANCES)
			if [ "~/rackspace_api_tool/instances.sh" ]; then
				source ~/rackspace_api_tool/instances.sh
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
