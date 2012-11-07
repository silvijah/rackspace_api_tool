#! /bin/bash

function main_menu()
{

echo -e -n "\n\nMAIN MENU : \n\n"

while true; do
        echo "1 DATABASE INSTANCES"
	echo "2 MONITORING"
	echo "3 NextGen SERVERS"
	echo "4 LOAD BALANCERS"
        echo "0 EXIT"

        read CONFIRM
        case $CONFIRM in
                1|INSTANCES)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
        #                if [ "./databases.sh" ]; then
        #                        source ./databases.sh
        #                        databases
        #                else
        #                        echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
        #                fi
        #                ;;
		if [ "$LOCATION" = "dfw" ]; then 
echo -e -n "\n\n\t Choose your Region:
\t1 DFW
\t2 ORD
\t----------------
\t0 EXIT\n>>>>\t"
while true
do
		read EDITEDLOCATION
		case $EDITEDLOCATION in

		1|dfw)
			LOCATION="dfw"
			source ./databases.sh
				databases
				;;
		2|ord)
			LOCATION="ord"
				source ./databases.sh
				databases
		esac
done
	elif [ "$LOCATION" = "ord" ]; then       
echo -e -n "\n\n\t Choose your Region:
\t1 DFW
\t2 ORD
\t----------------
\t0 EXIT\n>>>>\t"
while true
do
                read EDITEDLOCATION
                case $EDITEDLOCATION in

                1|dfw)
                        LOCATION="dfw"
                        source ./databases.sh
                                databases
                                ;;
                2|ord)
                        LOCATION="ord"
                                source ./databases.sh
                                databases
                esac
done

	else
		source ./databases.sh
			databases
fi
		;;
				
		2|monitoring)
			echo " PLEASE CHOOSE ONE OF THE FOLLOWING MONITORING INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
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
	lbaasinfo="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{}[]" "\n" |tr "," "\n" |egrep "name" |tr '\"' "\t")"

	if [ "$(echo "$lbaasinfo" | awk '{print $1}' |head -n1)" = 'name' ]; then
	echo -e -n "\n\nYou Have The Following LoadBalancers Configured: \n\n"
	curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers |tr "{[}]" "\n" |tr "," "\n" |egrep "loadBalancers|name|protocol|status" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |tr ":" "\t"
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
