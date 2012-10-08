#!/bin/bash

function lonauth()
{
VERSION=v1.0
LOCATION=lon
auth_response="$(curl -i -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Key: $APIKEY"  https://$LOCATION.identity.api.rackspacecloud.com/$VERSION | egrep -e '(^HTTP/1.1|^X-Auth-Token)')"

APITOKEN=

if [ "$(echo "$auth_response" | head -1 | awk '{print $2}')" = "204" ]; then
        APITOKEN="$(echo "$auth_response" | tail -1 | awk '{print $NF}' | sed -e 's/[\r\n]//g')"
else
        echo    "Authentication failed"
        exit
fi

export VERSION LOCATION
while true; do
        echo -e -n "\n\tCHOOSE ONE OF THE FOLLOWING OPTIONS:\n\n"
        echo "1 DATABASE INSTANCES"
        echo "2 MONITORING"
	echo "3 NextGen SERVERS"
	echo "4 LOAD BALANCERS"
        echo "5 EXIT"

        read CONFIRM
        case $CONFIRM in
                1|INSTANCES)
                        if [ "./databases.sh" ]; then
                                source ./databases.sh
                                databases
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
                2|MONITORING)   
                        if [ ".monitoring.sh" ]; then
                                source ./monitoring.sh
                                monitoring
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
		3|NEXTGEN)      
			if [ ".nextgen.sh" ]; then
                                source ./nextgen.sh
                                nextgenservers
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
		4|LBAAS)
			if [ "lbaas.sh" ]; then
                                source ./lbaas.sh
                                loadbalancers
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
                5|EXIT)
                        echo "THANK YOU FOR USING THE API CLIENT"
                        exit
                        ;;
                *)
                        echo "UNFORTUNATELY THIS IS NOT A VALID ENTRY. CHOOSE FROM THE AVAILABLE OPTION LIST."
                        ;;
        esac
done
}
