#! /bin/bash

function main_menu()
{

echo -e -n "\n\nMAIN MENU : \n\n"

while true; do
        echo "1 AUTHENTICATE"
        echo "2 DATABASE INSTANCES"
        echo "3 EXIT"

        read CONFIRM
        case $CONFIRM in
                1|PLEASEAUTHORISE)
                        echo " PLEASE AUTHORISE: "
                       if [ "~/rackspace_api_tool/authentication.sh" ]; then
                                source ~/rackspace_api_tool/authentication.sh
                                authenticate
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
                2|INSTANCES)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "~/rackspace_api_tool/databases.sh" ]; then
                                source ~/rackspace_api_tool/databases.sh
                                instances
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
                3|EXIT)
                        echo "THANK YOU FOR USING THE API CLIENT"
                        exit
                        ;;
                *)
                        echo "UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE"
                        ;;
        esac
done

}
