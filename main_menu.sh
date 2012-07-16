#! /bin/bash

function main_menu()
{

echo -e -n "\n\nMAIN MENU : \n\n"

while true; do
#        echo "1 AUTHENTICATE"
        echo "1 DATABASE INSTANCES"
        echo "2 EXIT"

        read CONFIRM
        case $CONFIRM in
#                1|PLEASEAUTHORISE)
#                        echo " PLEASE AUTHORISE: "
#                       if [ "./authentication.sh" ]; then
#                                source ./authentication.sh
#                                authenticate
#                        else
#                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
#                        fi
#                        ;;
                1|INSTANCES)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./databases.sh" ]; then
                                source ./databases.sh
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

}
