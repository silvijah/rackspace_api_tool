#!/bin/bash

USERNAME=
APIKEY=

while [ -n "$1" ]; do
	case $1 in
		-u)
			shift
			USERNAME="$1"
			;;
		-key|-k)
			shift
			APIKEY="$1"
			;;
	esac

	shift
done

LOCATION1="$(echo "$(curl -s -i -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "HTTP" |awk '{print $2}')")"
LOCATION2="$(echo "$(curl -s -i -XPOST https://lon.identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "HTTP" |awk '{print $2}')")"

if [ "$(echo "$LOCATION1")" = "200" ]; then

echo -e -n "\n\n\t Choose your Region:
\t1 DFW
\t2 ORD
\t----------------
\t0 EXIT\n>>>>\t"
while true
do
	read REGION
	case $REGION in

	1|dfw)LOCATION='dfw'
	ACCOUNT="$(echo "$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "tenantId" |tail -n1 |awk '{print $2}' |tr '\"' "\0")")"

APITOKEN="$(echo "$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "id" |head -n1 |awk '{print $2}' |tr '\"' "\0")")"
		source ./main_menu.sh
		main_menu
	;;
	2|ord)
	LOCATION='ord'
	ACCOUNT="$(echo "$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "tenantId" |tail -n1 |awk '{print $2}' |tr '\"' "\0")")"

APITOKEN="$(echo "$(curl -s -XPOST https://identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "id" |head -n1 |awk '{print $2}' |tr '\"' "\0")")"
		source ./main_menu.sh
		main_menu
	;;
	0|exit)
	echo "THANK YOU FOR USING THE API CLIENT"
                        exit
                        ;;
	*) echo "Choose One Of the Available Options"
	esac	
done
	elif [ "$(echo "$LOCATION2")" = "200" ]; then
	LOCATION='lon'
	ACCOUNT="$(echo "$(curl -s -XPOST https://$LOCATION.identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "tenantId" |tail -n1 |awk '{print $2}' |tr '\"' "\0")")"

	APITOKEN="$(echo "$(curl -s -XPOST https://$LOCATION.identity.api.rackspacecloud.com/v2.0/tokens -d '{ "auth":{ "RAX-KSKEY:apiKeyCredentials":{ "username":"'$USERNAME'", "apiKey":"'$APIKEY'" } } }' -H "Content-type: application/json" |tr "{}[]," "\n" |tr ":" "\t" |egrep "region|tenantId|id" |egrep "id" |head -n1 |awk '{print $2}' |tr '\"' "\0")")"
	source ./main_menu.sh
                main_menu
	else
	echo "Authentication Failed"
	exit
fi

export LOCATION LOCATION1 ACCOUNT APITOKEN

