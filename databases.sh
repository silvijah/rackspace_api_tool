#!/bin/bash

function instances()
{

echo -e -n 	"\n\n\t1 LIST AVAILABLE FLAVORS "
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
echo -e -n 	"\n\t12 LOGIN TO THE DATABASE (YOU MUST BE LOGGED INTO YOUR CLOUD SERVER TO PERFORM THIS ACTION) "
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
			source ./databases.sh
			instances
			;;
        2|CreateANewDB)
				source ./create_db_function.sh
				createdbinstance
                                curl -s -d @createdbinstance -XPOST -H "Content-type: application/json" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep "created|status|id|hostname|updated"
                                source ./databases.sh
                                instances
                        ;;
        3|LISTAVAILABLEINSTANCES)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep  "id|name|status|size";
			source ./databases.sh
			instances
			;;
	
	4|ListInstancesInDetail)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
			echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
			read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id|name|status|size";
			source ./databases.sh
			instances
			;;
        5|DeleteDatabaseInstance)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID;
                        source ./databases.sh
                        instances
                        ;;
	6|EnableRootUser)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
			read -p "INSTANCE ID " INSTANCEID;
			curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root |python -mjson.tool;
			source ./databases.sh
			instances
			;;
	7|CheckStatusOfRootUser)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root;
                        source ./databases.sh
                        instances
                        ;;
	8|RestartDatabase)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
			cd .;
                                curl -v -d @restart_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ./databases.sh
                                instances
                        ;;
	9|RESIZETHEINSTANCE)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
				cd .;
				vi ./resize_instance;
                                curl -v -d @resize_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ./databases.sh
                                instances
                        ;;

        10|RESIZETHEINSTANCEVOLUME)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                cd .;
                                vi ./resize_instance_volume;
                                curl -v -d @resize_instance_volume -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action
                                source ./databases.sh
                                instances
                        ;;
        11|ListActiveDBs)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "{" "\n";
                        source ./databases.sh
                        instances
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
                                source ./databases.sh
                                instances
                                ;;
	13|CREATEDATABASEONEXISTINGINSTANCE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			source ./create_db_existing_instance.sh
			createdbexistinginstance
			curl -s -d @create_db_on_existing_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n";
                        source ./databases.sh
                        instances
                        ;;
	14|DELETEDATABASE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n" |grep "name";
                        echo -e -n "\nNOW CHOOSE THE DATABASE YOU WANT TO DELETE\n";
                        read -p "DATABASE NAME " DBNAME;
			curl -s -XDELETE "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases/$DBNAME |tr "," "\n";
			echo -e -n "\nDATABASE SUCCESSFULLY DELETED\n"
                        source ./databases.sh
                        instances
                        ;;
	15|CREATEUSERFORASPECIFICDATABASE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
			curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |grep "name";
			source ./createuserforinstance.sh
                        createuserforinstance
			curl -s -d @create_user_for_instance -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n";
                        source ./databases.sh
                        instances
                        ;;	
	16|LISTALLACTIVEUSERSINDATABASEINSTANCE)
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |grep "name";
			curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n";
			source ./databases.sh
                        instances
                        ;;
        17|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./main_menu.sh" ]; then
                                source ./main_menu.sh
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
