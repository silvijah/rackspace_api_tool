#!/bin/bash

get_values="curl -s -XGET -H \"X-Auth-User: $USERNAME\" -H \"X-Auth-Token: $APITOKEN\""
instance_id="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" "https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances" |tr "," "\n" |egrep "name" |tr '\"' "\0")"

function databases() {

echo -e -n "\n\n1 Information About the Instances"
echo -e -n "\n2 Actions for the Databases"
echo -e -n "\n \t---------"
echo -e -n "\n99 Back to Main Menu"
echo -e -n "\n0 Exit\n>>>>\t"

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
        99|MAINMENU)
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
echo -e -n 	"\n\t99 Back to the  Main Databases MENU "
echo -e -n	"\n\t0 EXIT\n>>>>\t"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|LISTAVAILABLEFLAVORS)
                       call_api /flavors |tr "," "\n" |tr "[" "\n" |tr ":" "\t" |egrep "ram|id|name" |tr "{" "\0" |tr '\"}]' "\0"
                        source ./databases.sh
                        listings
                        ;;

        2|ListInstancesInDetail)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
			call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
                        call_api /instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id|name|status|size" |tr '\"' "\t" |tr "{}" "\0"
                        source ./databases.sh
                        listings
        else 
		echo "No Instances Found"
			source ./databases.sh
			listings
	fi
		;;
        3|ListActiveDBs)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
                        call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
                        call_api /instances/$INSTANCEID/databases |tr "{" "\n" |tr "[{]}" "\0" |tr '\"' "\t"
                        source ./databases.sh
                        listings
                        else 
                echo "No Instances Found"
                        source ./databases.sh
                        listings
        fi
                ;;

       	4|CheckStatusOfRootUser)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
                        call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0";
                        read -p "INSTANCE ID " INSTANCEID;
                        call_api /instances/$INSTANCEID/root |tr "{" "\n" |tr '\"' "\t" |tr "}" "\0";
                        source ./databases.sh
                        listings
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        listings
        fi
                ;;
	5|LISTALLACTIVEUSERSINDATABASEINSTANCE)
        if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then          
	      call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n\n"
                        read -p "INSTANCE ID " INSTANCEID
                        call_api /instances/$INSTANCEID |tr "," "\n" |grep "name" |tr '\"' "\t" |tr ":" "\t"
                        call_api /instances/$INSTANCEID/users |tr "," "\n" |tr "[{}]" "\0" |tr '\"' "\t" |tr ":" "\t"
                        source ./databases.sh
                        listings
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        listings
        fi
                ;;
        99|MAINMENU)
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
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CHOOSE FROM THE AVAILABLE OPTION LIST.      "
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
echo -e -n      "\n\t99 Back to the  Main Databases MENU "
echo -e -n	"\n\t0 EXIT\n>>>>\t"


while true
do
                read CONFIRM
                case $CONFIRM in

        1|CreateANewDB)
				call_api /flavors |tr "," "\n" |tr "[" "\n" |tr ":" "\t" |egrep "ram|id|name" |tr "{" "\0" |tr '\"}]' "\0"
                                read -p "Choose a Flavor ID: " FLAVOURID
				read -p "Please Enter your New Database name " DB1
				read -p "Please Enter your New Instance name " INSTANCE
				read -p "Please Enter your New Username " USER
				read -p "User Password " -s PASSWORD;
        	                echo -e -n "\n"
                	        read -p "Confirm the Password " -s PASSWORD2;
                if [ $PASSWORD == $PASSWORD2 ]; then 	
		curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-Token: $APITOKEN" -d '{"instance": {"databases": [{ "character_set": "utf8", "collate": "utf8_general_ci", "name": "'$DB1'" }],"flavorRef": "'https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors/$FLAVOURID'", "name": "'$INSTANCE'", "users": [{"databases": [{"name": "'$DB1'"}], "name": "'$USER'", "password": "'$PASS'" }], "volume": {"size": 2}}}' https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances |tr "," "\n" |egrep "created|status|id|hostname|updated|name" |tr ":" "\t"
			else
			 echo -e -n "\n\nPasswords do not match\n"
                source ./databases.sh
                        actions

                fi
                                source ./databases.sh
                                actions
                        ;;
        2|DeleteDatabaseInstance)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
                        call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
                        curl -i -s -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID |egrep "HTTP|Date"
                        source ./databases.sh
                        actions
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
        3|RestartDatabase)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
                        call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        read -p "INSTANCE ID " INSTANCEID
		curl -s -i -XPOST -H "Content-type: application/json" -H "X-Auth-Token: $APITOKEN" -d '{ "restart": {} }' https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action |egrep "HTTP|Date"
                                source ./databases.sh
                                actions
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
        4|RESIZETHEINSTANCE)
			if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
                                call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                                read -p "INSTANCE ID " INSTANCEID
				call_api /flavors |tr "," "\n" |tr "[" "\n" |tr ":" "\t" |egrep "ram|id|name" |tr "{" "\0" |tr '\"}]' "\0"
				read -p "Choose a Flavor ID: " FLAVOURID
				curl -s -i -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -d '{ "resize": { "flavorRef": "'https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors/$FLAVOURID'" }}' https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action |egrep "HTTP|Date"
                                source ./databases.sh
                                actions
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;

        5|RESIZETHEINSTANCEVOLUME)
		if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then                  
              			call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                                read -p "INSTANCE ID " INSTANCEID;
				read -p "Choose a Disk size: 1-50GB " sizenumber
			curl -s -i -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -d "{ \"resize\": { \"volume\": { \"size\": $sizenumber }}}" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/action |egrep "HTTP|Date"
                                source ./databases.sh
                                actions
                       else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
       	6|LoginToTheDatabase)
		if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then                  
              			call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                                read -p "INSTANCE ID " INSTANCEID;
                                call_api /instances/$INSTANCEID/users |tr "," "\n" |tr "{[" "\t" |tr '\"' "\0" |tr "]}" "\0" 
                                call_api /instances/$INSTANCEID |tr "," "\n" |egrep "hostname|id" |tr "{[" "\t" |tr '\"' "\0";
                                echo -e -n "\n\tNOW CHOOSE THE HOSTNAME ID:\n"
                                read -p "DBUSER " DBUSER;
                                read -p "HOSTNAME " HOSTNAME;
                                mysql -h $HOSTNAME -u$DBUSER $DATABASE -p;
                                source ./databases.sh
                                actions
                                else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;

        7|CREATEDATABASEONEXISTINGINSTANCE)
	      if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
			call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n"
                        read -p "INSTANCE ID " INSTANCEID
			read -p  "Your New Database Name: " DATABASENAME
			curl -s -i -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -d '{ "databases": [{"character_set": "utf8", "collate": "utf8_general_ci", "name": "'$DATABASENAME'" }]}' https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases
                        source ./databases.sh
                        actions
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
        8|DELETEDATABASE)
		if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = '"name":' ]; then                  
		      	call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0";
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n";
                        read -p "INSTANCE ID " INSTANCEID;
                        call_api /instances/$INSTANCEID/databases |tr "," "\n" |grep "name";
                        echo -e -n "\nNOW CHOOSE THE DATABASE YOU WANT TO DELETE\n";
                        read -p "DATABASE NAME " DBNAME;
                        curl -s -XDELETE "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/databases/$DBNAME |tr "," "\n";
                        echo -e -n "\nDATABASE SUCCESSFULLY DELETED\n"
                        source ./databases.sh
                        actions
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
        9|CREATEUSERFORASPECIFICDATABASE)
		if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then                  
	      	call_api /instances |tr "," "\n" |egrep "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        echo -e -n "\nNOW CHOOSE ONE OF THE AVAILABLE INSTANCE IDs\n\n"
                        read -p "INSTANCE ID " INSTANCEID
			call_api /instances/$INSTANCEID/databases |tr "," "\n" |grep "name" |tr "[{}]" "\0" |tr '\"' "\t";
                        echo -e -n "\nChoose A Database You Are Creating a User for\n";
                        read -p "DATABASE NAME " DBNAME;
			read -p "New UserName " USER;
			read -p "User Password " -s PASSWORD;
			echo -e -n "\n"
			read -p "Confirm the Password " -s PASSWORD2;
		if [ $PASSWORD == $PASSWORD2 ]; then  
		curl -s -i -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -d '{ "users": [{ "databases": [{ "name": "'$DBNAME'" }], "name": "'$USER'", "password": "'$PASSWORD'"}]}' https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/instances/$INSTANCEID/users |tr "," "\n" |egrep "HTTP|Date" 
		source ./databases.sh
                        actions
			else 
		echo -e -n "\n\nPasswords do not match\n"
		source ./databases.sh
                        actions

		fi
                        else
                echo "No Instances Found"
                        source ./databases.sh
                        actions
        fi
                ;;
        10|EnableRootUser)
                  
		if [ "$(echo "$instance_id" | awk '{print $1}' |head -n1)" = 'name:' ]; then
	      call_api /instances |tr "," "\n" |egrep  "name|id" |tr '\"' "\t" |tr "{}]" "\0"
                        read -p "INSTANCE ID " INSTANCEID
                       post_api /instances/$INSTANCEID/root
                        source ./databases.sh
                        actions
		else
                echo "No Instances Found"
                        source ./databases.sh
                        listings
        fi
                ;;
        99|MAINMENU)
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
    *) echo "  UNFORTUNATELY THIS IS NOT A VALID ENTRY. CHOOSE FROM THE AVAILABLE OPTION LIST.      "
  esac

done
}

call_api()

{

curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/${ACCOUNT}${1}
}

function post_api()
{

curl -s -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.databases.api.rackspacecloud.com/v1.0/${ACCOUNT}${1}
}
