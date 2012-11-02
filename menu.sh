#! /bin/bash

function main_menu()
{

while true; do 
	echo -e -n "\n\nCHOOSE ONE OF THE FOLLOWING OPTIONS:"
	echo -e -n "\n1 MAIN MENU"
	echo -e -n "\n2 DATABASES"
	echo -e -n "\n3 MONITORING"
	echo -e -n "\n4 NEXTGEN SERVERS"
	echo -e -n "\n5 LOAD BALANCERS"
	echo -e -n "\n0 EXIT\n"

	read CONFIRM
	case $CONFIRM in
		1|MAINMENU) 
			echo " PLEASE AUTHORISE: "
			if [ "./main_menu.sh" ]; then
				source ./main_menu.sh
				main_menu
			else
				echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
			fi
			;;
		2|DATABASES)
			echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
			if [ "./databases.sh" ]; then
				source ./databases.sh
				instances
			else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
		3|MONITORING)
		echo " PLEASE CHOOSE ONE OF THE FOLLOWING MONITORING INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                                source ./monitoring.sh
                                monitoring
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
		4|NEXTGEN)
                        if [ ".nextgen.sh" ]; then
                                source ./nextgen.sh
                                nextgenservers
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
                5|LBAAS)
        lbaasinfo="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{}[]" "\n" |tr "," "\n" |egrep "name" |tr '\"' "\t")"

	if [ "$(echo "$lbaasinfo" | awk '{print $1}' |head -n1)" = 'name' ]; then
	echo -e -n "\n\nYou Have The Following LoadBalancers Configured: \n\n"
	lbaas_get /loadbalancers |tr "{[}]" "\n" |tr "," "\n" |egrep "loadBalancers|name|protocol|status" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |tr ":" "\t"
        else
        echo -e -n "\nYou do Not have Any LoadBalancers Setup\n\n"
	fi
          
	      if [ "lbaas.sh" ]; then
                                source ./lbaas.sh
                                loadbalancers
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;


		0|EXIT)
			echo "THANK YOU FOR USING THE API CLIENT"
			exit
			;;
		*) 
			echo "UNFORTUNATELY THIS IS NOT A VALID ENTRY. CHOOSE FROM THE AVAILABLE OPTIONS MENU. "
			;;
	esac
done
}
