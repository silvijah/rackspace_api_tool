#!/bin/bash

function monitoring()
{

echo -e -n "\n\n1 Entities"
echo -e -n "\n2 Checks"
echo -e -n "\n3 Check Type Information"
echo -e -n "\n4 Notifications"
echo -e -n "\n5 Notification Plans"
echo -e -n "\n6 Alarms"
#echo -e -n "\n5 List Available Monitoring Zones"
echo -e -n "\n \t---------"
echo -e -n "\n15 Back to Main Menu"
echo -e -n "\n0 Exit\n"

while true
do
                read CONFIRM
                case $CONFIRM in

	1|entities)
                        source ./monitoring.sh
                        entities
                        ;;
	2|checks)
			source ./monitoring.sh
			checks
			;;
	3|checktypes)
			source ./monitoring.sh
			check_types
			;;
	4|notifications)
			source ./monitoring.sh
			notifications
			;;
	5|plans)
			source ./monitoring.sh
			notification_plan
			;;
	6|alarms)
			source ./monitoring.sh
			alarms
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

function check_types() {

echo -e -n "\n1 List Available Check Types"
echo -e -n "\n2 Information about A Specific Check Type"
echo -e -n "\n \t------"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"


while true
do
	read CONFIRM
	case $CONFIRM in
	
	1|CheckTypes)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/check_types |tr ":" "\t" |tr -d "{" |tr -d "}" |tr -d ",|[|]"
                        source ./monitoring.sh
                        check_types
			;;
	2|GetCheckType)
		read -p "Choose one of the Following Check Types:
                                remote.dns
                                remote.ssh
                                remote.smtp
                                remote.http
                                remote.tcp
                                remote.ping
                                remote.ftp-banner
                                remote.imap-banner
                                remote.pop3-banner
                                remote.smtp-banner
                                remote.postgresql-banner
                                remote.telnet-banner
                                remote.mysql-banner
                                remote.mssql-banner 
				" checktypeid;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/check_types/$checktypeid 
			echo -e -n "\n\n --------- "
                        source ./monitoring.sh
                        check_types
                        ;;			
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
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

function checks()
{

echo -e -n "\n\n1 \tList All active Checks"
echo -e -n "\n2 \tGet Information about the Check"
echo -e -n "\n3 \tCreate a Check"
echo -e -n "\n4 \tModify Check"
echo -e -n "\n5 \tDelete Check"
echo -e -n "\n6 \tTest Check Before It is Created"
echo -e -n "\n7 \tTest an Existing Check"
echo -e -n "\n \t------"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|listcheck)    curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|label|*_v4|uri"
                        read -p "Entity Name " entityname
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/
                        source ./monitoring.sh
                        checks
                        ;;
        2|getcheck)     curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                        read -p "Entity Name " entityname
                        read -p "Check Name " CHECKNAME
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$checkname
                        source ./monitoring.sh
                        checks
                        ;;
        3|Createcheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                        read -p "Entity Name " entityname
                        read -p "Check Name " CHECKNAME
                        read -p "Monitoring Zone Name: mzdfw/mzlon/mzhkg/mzord/mziad " ZONE
                        read -p "Available Monitoring Checks to Choose from:
                                remote.dns
                                remote.ssh
                                remote.smtp
                                remote.http
                                remote.tcp
                                remote.ping
                                remote.ftp-banner
                                remote.imap-banner
                                remote.pop3-banner
                                remote.smtp-banner
                                remote.postgresql-banner
                                remote.telnet-banner
                                remote.mysql-banner
                                remote.mssql-banner " checknames
                        curl -i -s -XPOST -d '{ "details" : {  },  "label" : "'$CHECKNAME'",  "monitoring_zones_poll" : [ "'$ZONE'" ],  "period" : "60",  "target_alias" : "default",  "timeout" : 30,  "type" : "'$checknames'" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/ |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                        ;;
        4|Modifycheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks
                        read -p "Check ID: " checkid;
				read -p "New Check Name: " newcheckname
				read -p "Monitoring zone: mzdfw/mzlon/mzhkg/mzord/mziad " newzone
				read -p "Check period (Default is 60s): " periodtime
				read -p "Timeout (Default is 30s): " timeouttime
                      curl -i -s -XPUT -d '{ "details" : {  },  "label" : "'$newcheckname'",  "monitoring_zones_poll" : [ "'$newzone'" ],  "period" : "'$periodtime'",  "target_alias" : "default",  "timeout" : '$timeouttime',  "type" : "'$checknames'" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$checkid |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                        ;;
        5|Deletecheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4";
                        read -p "Entity Name " entityname;
                        curl -s -i -XGET -H "X-Auth-Token: $APITOKEN" -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks;
			read -p "Check Name you want to delete: " deletecheck
			curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$deletecheck |egrep "HTTP|Date"
                        source ./monitoring.sh
                        checks
                        ;;
        6|testcheck)
                        curl -i -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4"
                        read -p "Entity Name " entityname
                        read -p "Check Name " CHECKNAME
                        read -p "Monitoring Zone Name: mzdfw/mzlon/mzhkg/mzord/mziad " ZONE
                        read -p "Available Monitoring Checks to Choose from:
                                remote.dns
                                remote.ssh
                                remote.smtp
                                remote.http
                                remote.tcp
                                remote.ping
                                remote.ftp-banner
                                remote.imap-banner
                                remote.pop3-banner
                                remote.smtp-banner
                                remote.postgresql-banner
                                remote.telnet-banner
                                remote.mysql-banner
                                remote.mssql-banner " checknames
                        curl -i -s -XPOST -d '{ "details" : {  },  "label" : "'$CHECKNAME'",  "monitoring_zones_poll" : [ "'$ZONE'" ],  "period" : "60",  "target_alias" : "default",  "timeout" : 30,  "type" : "'$checknames'" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/test-check/ |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                        ;;
        7|testexistingcheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4"
                        read -p "Entity Name " entityname
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/
			read -p "Check ID: " checkidtest
			curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$checkidtest/test
                        source ./monitoring.sh
                        checks  
                        ;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
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


function entities()
{

echo -e -n "\n\n1 \tList All available Entities"
echo -e -n "\n2 \tGet Entity"
echo -e -n "\n3 \tCreate an Entity"
echo -e -n "\n4 \tModify Entity"
echo -e -n "\n5 \tDelete Entity"
echo -e -n "\n \t-----\n"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|listentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|label|*_v4|count|limit"
                        source ./monitoring.sh
                        entities
                        ;;
        2|getentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4"
                        read -p "Entity Name " entityname
                        curl -s -i -XGET --data-binary '{"ip_addresses": {"default": "'$NEWIP'"}}' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname |egrep -v "X-*|*-Encoding"
                        source ./monitoring.sh
                        entities
                        ;;
        3|Createanentity)
                        read -p "Enter the IP Address of the Server you want to monitor " IPADD
                        read -p "Name your entity " NAME
                        curl -s -i -XPOST -H "Content-Type: application/json" -H "Accept: application/json" -d '{ "ip_addresses" : { "default" : "'$IPADD'" }, "label" : "'$NAME'", "metadata" : {  }}' -H "X-Auth-Token: $APITOKEN" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        entities
                        ;;
        4|Modifyentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4"
                        read -p "Entity Name " entityname
                        read -p "Specify New IP you want to Monitor " NEWIP
                        curl -s -i -XPUT --data-binary '{"ip_addresses": {"default": "'$NEWIP'"}}' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname |egrep "Data|Location"
                        source ./monitoring.sh
                        entities
                        ;;
        5|Deleteentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4"
                        read -p "Entity Name " entityname
                        curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname
                        source ./monitoring.sh
                        entities
                        ;;

        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
                        else
echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"
                        fi
                        ;;
        0|Exit)
      echo " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo " UNFORTUNATELY THIS IS NOT A VALID ENTRY. CHOOSE ONE OF THE AVAILABLE MENU OPTIONS "
  esac

done
}



function notification_plan () {

echo -e -n "\n1 List Created Notification Plans"
echo -e -n "\n2 Information about A Specific Notification Plan"
echo -e -n "\n3 Create A Notification Plan"
echo -e -n "\n4 Modify A Notification Plan"
echo -e -n "\n5 Delete A Notification Plan"
echo -e -n "\n \t-----\n"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"

while true
do

	read CONFIRM
	case $CONFIRM in
	
	1|listnotificationplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
		source ./monitoring.sh
			notification_plan
		;;
	2|getnotification)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
		read -p "Enter Notification Plan ID: " notificationid
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans/$notificationid
		source ./monitoring.sh
                        notification_plan
		;;
	3|createplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
                        read -p "Enter Notification ID: " notification
			read -p "Notification plan Name: " NAMEOFAPLAN
		read -p "Choose one of the Following Notification Options:
			Notify When in Warning State - warning_state
			Notify When in OK State  - ok_state
			Notify When in Error State  - error_state 
			" notificationstatus
		curl -i -X POST --data-binary '{      "label": "'$NAMEOFAPLAN'",      "'$notificationstatus'": [          "'$notification'"      ]}' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
			source ./monitoring.sh
                        notification_plan
		;;
	4|modifyplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
                read -p "Enter Notification ID: " notificationid
		read -p "Choose one of the Following Notification Options:
                        Notify When in Warning State - warning_state
                        Notify When in OK State  - ok_state
                        Notify When in Error State  - error_state 
			" notificationstatus
                curl -s -XPUT  --data-binary '{      "label": "'$NAMEOFAPLAN'",      "'$notificationstatus'": [          "'$notificationid'"      ]}' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
			source ./monitoring.sh
                        notification_plan
			;;
	5|deleteplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
		read -p "Enter Notification Plan ID: " planid
		curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans/$planid
		source ./monitoring.sh
                        notification_plan
		;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
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

function notifications() {

echo -e -n "\n1 List Created Notifications"
echo -e -n "\n2 Test All Created Notifications"
echo -e -n "\n3 Test A Specific Notification"
echo -e -n "\n4 Create A New Notification"
echo -e -n "\n5 Information about A Specific Notification"
echo -e -n "\n6 Modify A Notification"
echo -e -n "\n7 Delete A Notification"
echo -e -n "\n \t-----\n"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"

while true
do

	read CONFIRM
	case $CONFIRM in

	1|listnotification)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
		source ./monitoring.sh
			notifications
		;;
	2|testallnotifications)
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/test-notification
		source ./monitoring.sh
                        notifications
		;;
	3|testanotification)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
		read -p "Notification ID: " notificationname
		curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications/$notificationname/test
		source ./monitoring.sh
                        notifications
		;;
	4|createnotification)
			echo -e -n "\n1 Webhook Notification "
			echo -e -n "\n2 Email Notification "
	
			while true
			do
			read CONFIRM
			case $CONFIRM in
			1|webhook)
			read -p "Specify which URL You would like to send an alert Notifications  " URLNAME
			read -p "Name your Notification: " NOTIFICATIONNAME
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "details" : { "url" : "'$URLNAME'" }  "label" : "'$NOTIFICATIONNAME'",  "type" : "webhook"}' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
			source ./monitoring.sh
                        notifications
			;;
			2|email)
			read -p "Specify an Email address to send an alert Notification to: " EMAIL
#			curl -s -XPOST -d '{ "details" : { "address" : "'$EMAIL'" }  "label": "email",  "type": "email"}' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
			curl -s -XPOST -d '{ "label" : "email", "type" : "email", "details" : { "address" : "'$EMAIL'" } }' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications

			source ./monitoring.sh
                        notifications
			esac
			done
	#	source ./monitoring.sh
        #                notifications	
	;;	
	5|informationaboutnotification)
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications |egrep "id|count|limit"
			read -p "Choose A Notification ID: " notificationid
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications/$notificationid
			source ./monitoring.sh
                        notifications
			;;	
	6|modifynotification)
			echo -e -n "\n1 Modify Webhook Notification "
                        echo -e -n "\n2 Modify Email Notification "

                        while true
                        do
                        read CONFIRM
                        case $CONFIRM in
                        1|webhook)
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
                        read -p "Notification ID: " notificationid
                        read -p "Specify which URL You would like to send an alert Notifications  " NEWURLNAME
                curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "details" : { "url" : "'$URLNAME'" }  "type" : "webhook"}' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications/$notificationid
                        source ./monitoring.sh
                        notifications
			;;
			2|email)
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
			read -p "Notification ID: " notificationid
                        read -p "Specify a New Email address to send an alert Notification to: " NEWEMAIL
                        curl -s -i -XPUT -d '{ "type" : "email", "details" : { "address" : "'$NEWEMAIL'" } }' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications/$notificationid |egrep "HTTP|Date"
                        source ./monitoring.sh
                        notifications
                        esac
                        done
			;;
		7|deletenotification)
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications
                        read -p "Notification ID: " notificationid
			curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications/$notificationid |egrep "HTTP|Date"
			source ./monitoring.sh
                        notifications
			;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
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

function alarms() {

echo -e -n "\n1 Create An Alarm"
echo -e -n "\n2 Test Created Alarm"
echo -e -n "\n3 List Created Alarms"
echo -e -n "\n4 Information About a Specific Alarm"
echo -e -n "\n5 Modify a Specific Alarm"
echo -e -n "\n6 Delete a Specific Alarm"
echo -e -n "\n \t-----\n"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n"


while true
do

                read CONFIRM
                case $CONFIRM in

	1|createalarm)
		
		;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./monitoring.sh" ]; then
                        source ./monitoring.sh
                                monitoring
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
