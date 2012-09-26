#! /bin/bash

function main_menu()
{

echo -e -n "\n\nMAIN MENU : \n\n"

while true; do
#        echo "1 AUTHENTICATE"
        echo "1 DATABASE INSTANCES"
	echo "2 MONITORING"
	echo "3 NextGen SERVERS"
        echo "0 EXIT"

        read CONFIRM
        case $CONFIRM in
                1|INSTANCES)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./databases.sh" ]; then
                                source ./databases.sh
                                databases
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
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

                0|EXIT)
                        echo "THANK YOU FOR USING THE API CLIENT"
                        exit
                        ;;
                *)
                        echo "UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE"
                        ;;
        esac
done

}
