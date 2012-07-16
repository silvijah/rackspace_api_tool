#!/bin/bash

function instances()
{
#read -p "VALID API TOKEN " APITOKEN

echo -e -n 	"\n\t1 LIST AVAILABLE FLAVORS "
echo -e -n 	"\n\t2 CREATE A NEW INSTANCE (THIS CREATES A BRAND NEW DATABASE AND A USER FOR THE NEW INSTANCE) "
echo -e -n 	"\n\t3 LIST ALL CREATED DATABASE INSTANCES "
echo -e -n 	"\n\t4 LIST DATABASE INSTANCE STATUS AND DETAILS "
echo -e -n	"\n\t5 DELETE A SPECIFIC DATABASE INSTANCE "
echo -e -n	"\n\t6 ENABLE ROOT USER "
echo -e -n	"\n\t7 ROOT USER STATUS "
echo -e -n	"\n\t8 RESTART THE DATABASE INSTANCE "
echo -e -n	"\n\t9 RESIZE THE DATABASE INSTANCE "
echo -e -n	"\n\t10 RESIZE INSTANCE VOLUME "
echo -e -n 	"\n\t11 LIST PRESENTLY ACTIVE DATABASES "
echo -e -n 	"\n\t12 LOGIN TO THE DATABASE "
echo -e -n	"\n\t13 CREATE A DATABASE ON EXISTING INSTANCE "
echo -e -n	"\n\t14 DELETE DATABASE "
echo -e -n	"\n\t15 CREATE USER FOR A SPECIFIC DATABASE "
echo -e -n	"\n\t16 LIST USERS IN ACTIVE DATABASE INSTANCE "
echo -e -n 	"\n\t17 MAIN MENU "
echo -e -n 	"\n\t18 EXIT \n\n"

while true
do
		read CONFIRM
		case $CONFIRM in
	1|LISTAVAILABLEFLAVORS)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.servers.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors |tr "," "\n";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
        2|CreateANewDB)
                                cd ~/rackspace_api_tool;
				vi ~/rackspace_api_tool/create_db_instance;
                                curl -s -v -d @create_db_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep "created|status|id|hostname|updated"
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
        3|LISTAVAILABLEINSTANCES)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep  "id|name|status|size";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
	
	4|ListInstancesInDetail)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
			echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
			read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id|name|status|size";
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
        5|DeleteDatabaseInstance)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID;
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
	6|EnableRootUser)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
			read -p "INSTANCE ID " INSTANCEID;
			curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root |python -mjson.tool;
			source ~/rackspace_api_tool/menu.sh
			main_menu
			;;
	7|CheckStatusOfRootUser)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root;
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
	8|RestartDatabase)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
			cd ~/rackspace_api_tool;
                                curl -v -d @restart_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
	9|RESIZETHEINSTANCE)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
				cd ~/rackspace_api_tool;
				vi ~/rackspace_api_tool/resize_instance;
                                curl -v -d @resize_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;

        10|RESIZETHEINSTANCEVOLUME)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                cd ~/rackspace_api_tool;
                                vi ~/rackspace_api_tool/resize_instance_volume;
                                curl -v -d @resize_instance_volume -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ~/rackspace_api_tool/menu.sh
                                main_menu
                        ;;
        11|ListActiveDBs)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "{" "\n";
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
       12|LoginToTheDatabase)
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
	13|CREATEDATABASEONEXISTINGINSTANCE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			cd ~/rackspace_api_tool;
			vi create_db_on_existing_instance;
			curl -s -v -d @create_db_on_existing_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n";
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
	14|DELETEDATABASE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n" |grep "name";
                        echo -e -n "\nNOW CHOOSE THE DATABASE YOU WANT TO DELETE\n";
                        read -p "DATABASE NAME " DBNAME;
			curl -s -XDELETE "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases/$DBNAME |tr "," "\n";
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
	15|CREATEUSERFORASPECIFICDATABASE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |grep "name";
                        cd ~/rackspace_api_tool;
                        vi create_user_for_instance;
			curl -s -v -d @create_user_for_instance -XPOST -H "Content-type: application/xml" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n";
                        source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;	
	16|LISTALLACTIVEUSERSINDATABASEINSTANCE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |grep "name";
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n";
			source ~/rackspace_api_tool/menu.sh
                        main_menu
                        ;;
        17|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "~/rackspace_api_tool/main_menu.sh" ]; then
                                source ~/rackspace_api_tool/main_menu.sh
                                main_menu
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        18|Exit)
      echo        " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE      "
  esac
done
}
