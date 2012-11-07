#!/bin/bash


function dns()

{

echo -e -n "\n\n\t1 Limits
\t2 Domains
\t3 Subdomains
\t4 Records
\t5 Reverse DNS
\t----------
\t99 Main Products Menu
\t0 Exit\n\n>>>>\t"


while true
do
	read DNSMENU
	case $DNSMENU in

	1|limits)
		source ./dns.sh
		limits
		;;
	2|domains)
		source ./dns.sh
		domains
		;;
	3|subdomains)
		source ./dns.sh
		subdomains
		;;
	4|records)
		source ./dns.sh
		records
		;;
	5|reverse)
		source ./dns.sh
		reversedns
		;;
	99|menu)
		source ./main_menu.sh
		main_menu
		;;
	0|exit)
		echo "Thank You for Using API Client"
		exit
		;;
	*) "Choose One Of the Available Menu Options"
	esac
done

}

function limits()

{

echo -e -n "\n\n\t\t1 List All Limits
\t\t2 List Limit Types
\t\t3 List Specific Limit
\t\t-------------
\t\t99 Main DNS Menu
\t\t0 Exit\n\n>>>>\t"

while true
do
	read DNSLIMITS
	case $DNSLIMITS in


	1|alllimits)
		call_dnsapi /limits |tr "{}[]" "\n" |tr "," "\n\t" |tr '\"' "\0"
		source ./dns.sh
		limits
		;;
	2|limittypes)
                call_dnsapi /limits/types |tr "{}[]" "\n" |tr "," "\n\t" |tr '\"' "\0"

		source ./dns.sh
		limits
		;;
	3|specificlimit)
		echo -e -n "\n\t\t\t1 RATE_LIMIT
\t\t\t2 DOMAIN_LIMIT
\t\t\t3 DOMAIN_RECORD_LIMIT
\t\t\t-----------------
\t\t\t99 Return To Limits Menu
\t\t\t0 Exit\n>>>>\t"

	read SPECIFICLIMIT
	case $SPECIFICLIMIT in

		1|ratelimit)
                call_dnsapi /limits/rate_limit |tr "{}[]" "\n" |tr "," "\n\t" |tr '\"' "\0"
		source ./dns.sh
			limits
		;;
		2|domainlimit)
		call_dnsapi /limits/domain_limit |tr "{}[]" "\n" |tr "," "\n\t" |tr '\"' "\0"
                source ./dns.sh
                        limits
                ;;
		3|recordlimit)
		call_dnsapi /limits/domain_record_limit |tr "{}[]" "\n" |tr "," "\n\t" |tr '\"' "\0"
                source ./dns.sh
                        limits
                ;;
		99|return)
		source ./dns.sh
                        limits
                ;;
		0|exit)
		echo "Thank You for Using API Client"
		;;
		*) echo "Choose One of the Available Options"
	esac	
		;;
	
	99|menu)
		source ./dns.sh
		dns
		;;
	0|exit)
		echo "Thank You for Using API Client"
		exit
		;;
	*) echo "Choose One Of the Available DNS Options"
	esac

done

}



function call_dnsapi()


{

curl -s -i -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://{$LOCATION}dns.api.rackspacecloud.com/v1.0/${ACCOUNT}${1}

}

