#! /bin/bash

USERNAME=
ACCOUNT=
APIKEY=

while [ -n "$1" ]; do
	case $1 in
		-u)
			shift
			USERNAME="$1"
			;;
		-a)
			shift
			ACCOUNT="$1"
			;;
		-key)
			shift
			APIKEY="$1"
			;;
	esac

	shift
done

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
		if [ "./ordauth.sh" ]; then
                source ./ordauth.sh
                ordauth;
                else
                echo -e -n "\n Authentication Failed\n" 
		fi
;;
	esac
	done
			
