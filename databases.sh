#!/bin/bash

function databases() {

echo -e -n "\n\n1 Information About the Instances"
echo -e -n "\n2 Actions for the Databases"
echo -e -n "\n \t---------"
echo -e -n "\n15 Back to Main Menu"
echo -e -n "\n0 Exit\n"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|listings)
                        source ./databases.sh
                        listings
                        ;;
        2|actions)
                        source ./databases.sh
                        actions
                        ;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./main_menu.sh" ]; then
source ./main_menu.sh
                                main_menu
                        else
echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        0|Exit)
      echo " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo " UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE "
  esac

done
}


function listings() {

echo -e -n      "\n\n\t1 List Available Flavors "
echo -e -n      "\n\t2 List All Created Instances "
echo -e -n      "\n\t3 List Presently Active Databases "
echo -e -n      "\n\t4 Check ROOT User Status "
echo -e -n      "\n\t5 List Users for A Specific Database "
echo -e -n 	"\n\t --------- "
echo -e -n 	"\n\t15 Back to the  Main Databases MENU "
echo -e -n	"\n\t0 EXIT \n\n"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|LISTAVAILABLEFLAVORS)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors |tr "," "\n" |tr "[" "\n" |tr ":" "\t" |egrep "name|ram|id"
                        source ./databases.sh
                        listings
                        ;;

        2|ListInstancesInDetail)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id|name|status|size";
                        source ./databases.sh
                        listings
                        ;;
        3|ListActiveDBs)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "{" "\n";
                        source ./databases.sh
                        listings
                        ;;
       	4|CheckStatusOfRootUser)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root;
                        source ./databases.sh
                        listings
                        ;;
	5|LISTALLACTIVEUSERSINDATABASEINSTANCE)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n\n"
                        read -p "INSTANCE ID " INSTANCEID
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |tr "," "\n" |grep "name"
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n" |tr ":" "\t" |tr "[{}]" "\t"
                        source ./databases.sh
                        listings
                        ;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./databases.sh" ]; then
                                source ./databases.sh
                                databases
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        0|Exit)
      echo        " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE      "
  esac


done
}

function actions() {


echo -e -n      "\n\t1 Create A New Instance (THIS CREATES A BRAND NEW DATABASE AND A USER FOR THE NEW INSTANCE) "
echo -e -n      "\n\t2 Delete A Specific Database Instance "
echo -e -n      "\n\t3 Restart The Database Instance "
echo -e -n      "\n\t4 Resize The Database Instance "
echo -e -n      "\n\t5 Resize The Instance Volume "
echo -e -n      "\n\t6 Login To The Database (YOU MUST BE LOGGED INTO YOUR CLOUD SERVER TO PERFORM THIS ACTION) "
echo -e -n      "\n\t7 Create a Database On the Existing Instance "
echo -e -n      "\n\t8 Delete the Database "
echo -e -n      "\n\t9 Create an Additional User for A Specific Database "
echo -e -n      "\n\t10 Enable ROOT User "

echo -e -n	"\n\t	----- "
echo -e -n      "\n\t15 Back to the  Main Databases MENU "
echo -e -n	"\n\t0 EXIT \n\n"


while true
do
                read CONFIRM
                case $CONFIRM in

        1|CreateANewDB)
                                source ./create_db_function.sh
                                createdbinstance
                                curl -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances <<< $createinstance |tr "," "\n" |egrep "created|status|id|hostname|updated|name" |tr ":" "\t"
                                source ./databases.sh
                                actions
                        ;;
        2|DeleteDatabaseInstance)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep "name|id"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
                        curl -i -s -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |egrep "HTTP|Date"
                        source ./databases.sh
                        actions
                        ;;
        3|RestartDatabase)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id"
                        read -p "INSTANCE ID " INSTANCEID
                        source ./restart_instance.sh
                        reboot
                                curl -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action <<< $reboot
                                source ./databases.sh
                                actions
                        ;;
        4|RESIZETHEINSTANCE)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id"
                                read -p "INSTANCE ID " INSTANCEID
                                source ./resize_instance.sh
                                resizeinstance
                                curl  -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action <<< $resize
                                source ./databases.sh
                                actions
                        ;;

        5|RESIZETHEINSTANCEVOLUME)
                                curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep  "id";
                                read -p "INSTANCE ID " INSTANCEID;
                                source ./resize_instance_volume.sh
                                resizevolume
                                curl -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action <<< $volumeresize
                                source ./databases.sh
                                actions
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
                                source ./databases.sh
                                actions
                                ;;

        7|CREATEDATABASEONEXISTINGINSTANCE)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
                        source ./create_db_existing_instance.sh
                        createdbexistinginstance
                        curl -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases <<< $newdb |tr "," "\n"
                        source ./databases.sh
                        actions
                        ;;
        8|DELETEDATABASE)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n" |grep "name";
                        echo -e -n "\nNOW CHOOSE THE DATABASE YOU WANT TO DELETE\n";
                        read -p "DATABASE NAME " DBNAME;
                        curl -s -XDELETE "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases/$DBNAME |tr "," "\n";
                        echo -e -n "\nDATABASE SUCCESSFULLY DELETED\n"
                        source ./databases.sh
                        actions
                        ;;
        9|CREATEUSERFORASPECIFICDATABASE)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |grep "id"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n\n"
                        read -p "INSTANCE ID " INSTANCEID
                        curl -s -XGET "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases |tr "," "\n" |grep "database" |tr "{" "\n" |tr "}]" "\t"
                        source ./createuserforinstance.sh
                        createuserforinstance
                        curl -s -T - -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users <<< $createuser |tr "," "\n"
                        source ./databases.sh
                        actions
                        ;;
        10|EnableRootUser)
                        curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/insta
nces |tr "," "\n" |grep  "id";
                        read -p "INSTANCE ID " INSTANCEID;
                        curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.r
ackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/root |python -mjson.tool;
                        source ./databases.sh
                        actions
                        ;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./databases.sh" ]; then
                                source ./databases.sh
                                databases
                        else
                                echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        0|Exit)
      echo        " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE      "
  esac

done
}
