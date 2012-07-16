#! /bin/bash

authenticate= read -p "USERNAME " USERNAME; read -p "RACKSPACE ACCOUNT NUMBER/DDI " ACCOUNT; read -p "API KEY (PROVIDED BY RACKSPACE WHEN THE ACCOUNT IS CREATED) " APIKEY;
while true;
do
	echo -e -n "\nDataCenter Location: \n"
	echo "1 LON"
	echo "2 DFW"
	echo "3 ORD"

	read CONFIRM
	case $CONFIRM in
	1|LON)
		if [ "./lonauth.sh" ]; then
                   source ./lonauth.sh
                   lonauth
		else
		echo -e -n "\n Authentication Failed\n" 
		fi
;;	
	2|DFW)
		if [ "./dfwauth.sh" ]; then
                 source ./dfwauth.sh
                 dfwauth;
                else
                echo -e -n "\n Authentication Failed\n" 
		fi
;;
	3|ORD)
		if [ "./dfwauth.sh" ]; then
                source ./dfwauth.sh
                dfwauth;
                else
                echo -e -n "\n Authentication Failed\n" 
		fi
;;
	esac
	done
			
