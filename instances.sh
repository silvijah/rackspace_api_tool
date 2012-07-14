#!/bin/bash

function instances()
{

echo -e -n 	"\n\tLIST AVAILABLE FLAVORS - 1"
echo -e -n 	"\n\tLIST AVAILABLE INSTANCES - 2"
echo -e -n 	"\n\tGET THE DETAILED INFORMATION ABOUT A SPECIFIC INSTANCE - 3"
echo -e -n	"\n\tDELETE A SPECIFIC DATABASE INSTANCE - 4"
echo -e -n 	"\n\tLIST PRESENTLY ACTIVE DATABASES - 5"
echo -e -n 	"\n\tLOGIN TO THE INSTANCE - 6"
echo -e -n 	"\n\tCREATE A NEW DATABASE - 7"
echo -e -n	"\n\tENABLE ROOT USER - 8"
echo -e -n	"\n\tWHICH INSTANCE HAS ROOT USER ENABLED - 9"
echo -e -n	"\n\tRESTART DATABASE INSTANCE - 10"
echo -e -n	"\n\tRESIZE THE DATABASE INSTANCE - 11"
echo -e -n	"\n\tRESIZE INSTANCE VOLUME - 12"
echo -e -n 	"\n\tMAIN MENU - 13"
echo -e -n 	"\n\tEXIT - 14\n\n"

while true
do
		read CONFIRM
		case $CONFIRM in
	1|LISTAVAILABLEFLAVORS)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.servers.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors |tr "," "\n";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;

        2|LISTAVAILABLEINSTANCES)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep  "id|name|status|size";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
	
	3|ListInstancesInDetail)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
			echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
			read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id|name|status|size";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
        4|DeleteDatabaseInstance)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID;
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
        5|ListActiveDBs)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "{" "\n";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
       6|LoginToTheDatabase)   
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
				curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n";
				curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id";
				echo -e -n "\n\tNOW CHOOSE THE HOSTNAME ID:\n"
				read -p "DBUSER " DBUSER;
				read -p "HOSTNAME " HOSTNAME;
                                mysql -h $HOSTNAME -u$DBUSER $DATABASE -p;
				source ~/rackspace_api_tool/menu.sh
				main_menu
				;;
	7|CreateANewDB)
				vi ~/create_db_instance; 
				cd ~;
				curl -s -v -d @create_db_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep "created|status|id|hostname|updated"
				source ~/rackspace_api_tool/menu.sh
				main_menu
                        ;;
	8|EnableRootUser)
				curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root |python -mjson.tool;
				source ~/rackspace_api_tool/menu.sh
				main_menu
			;;
	9|CheckStatusOfRootUser)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                curl -s -XGET -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root;
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
	10|RestartDatabase)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
				cd ~;
                                curl -v -d @restart_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
	11|RESIZETHEINSTANCE)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
				cd ~/rackspace_api_tool;
				vi ~/rackspace_api_tool/resize_instance;
                                curl -v -d @resize_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
	12|RESIZETHEINSTANCEVOLUME)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                cd ~/rackspace_api_tool;
                                vi ~/rackspace_api_tool/resize_instance_volume;
                                curl -v -d @resize_instance_volume -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
        13|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "~/rackspace_api_tool/main_menu.sh" ]; then
                                source ~/rackspace_api_tool/main_menu.sh
                                main_menu
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        14|Exit)
      echo        " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE      "
  esac
done
}
