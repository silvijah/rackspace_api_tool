#! /bin/bash

function main_menu()
{

while true; do 
	echo -e -n "\n\nCHOOSE ONE OF THE FOLLOWING OPTIONS:"
	echo -e -n "\n1 MAIN MENU"
	echo -e -n "\n2 DATABASES"
	echo -e -n "\n3 EXIT\n"

	read CONFIRM
	case $CONFIRM in
		1|MAINMENU) 
			echo " PLEASE AUTHORISE: "
			if [ "~/rackspace_api_tool/main_menu.sh" ]; then
				source ~/rackspace_api_tool/main_menu.sh
				main_menu
			else
				echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
			fi
			;;
		2|DATABASES)
			echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
			if [ "~/rackspace_api_tool/instances.sh" ]; then
				source ~/rackspace_api_tool/instances.sh
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
