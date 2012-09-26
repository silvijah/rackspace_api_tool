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
echo -e -n "\n0 Exit\n >>"

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
echo -e -n "\n0 \tExit\n >>"


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
echo -e -n "\n0 \tExit\n >>"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|listcheck)    curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|label|*_v4|uri|default"
                        read -p "Entity ID " entityname
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/
                        source ./monitoring.sh
                        checks
                        ;;
        2|getcheck)     curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                        read -p "Entity ID " entityname
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks
                        read -p "Check Name " CHECKNAME
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$checkname
                        source ./monitoring.sh
                        checks
                        ;;
	3|CreateCheck)
		echo -e -n "\t\n1 \tCreate remote.dns Check"
                echo -e -n "\t\n2 \tCreate remote.ssh Check"
                echo -e -n "\t\n3 \tCreate remote.smtp Check"
                echo -e -n "\t\n4 \tCreate remote.http Check"
                echo -e -n "\t\n5 \tCreate remote.tcp Check"
                echo -e -n "\t\n6 \tCreate remote.ping Check"
                echo -e -n "\t\n7 \tCreate remote.ftp-banner Check"
                echo -e -n "\t\n8 \tCreate remote.imap-banner Check"
                echo -e -n "\t\n9 \tCreate remote.smtp-banner Check"
                echo -e -n "\t\n10 \tCreate remote.postgresql-banner Check"
                echo -e -n "\t\n11 \tCreate remote.telnet-banner Check"
                echo -e -n "\t\n12 \tCreate remote.mysql-banner Check"            
                echo -e -n "\t\n13 \tCreate remote.mssql-banner Check\n >>"


while true
do
                                read CONFIRM
                                case $CONFIRM in

                1|remote.dns)
			checknames=remote.dns
                        source ./monitoring.sh
                       createcheck1
                        ;;
                2|remote.ssh)
			checknames=remote.ssh
                        source ./monitoring.sh
                       createcheck1
                        ;;
                3|remote.smtp)
			checknames=remote.smtp
                        source ./monitoring.sh
                       createcheck1
                        ;;
                4|remote.http)
			checknames=remote.http
                        source ./monitoring.sh
                       createcheck2
                        ;;
                5|remote.tcp)
			checknames=remote.tcp
                        source ./monitoring.sh
                       createcheck1
                        ;;
                6|remote.ping)
			checknames=remote.ping
                        source ./monitoring.sh
                       createcheck1
                        ;;
                7|remote.ftp-banner)
			checknames=remote.ftp-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                8|remote.imap-banner)
			checknames=remote.imap-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                9|remote.smtp-banner)
			checknames=remote.smtp-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                10|remote.postgresql-banner)
			checknames=remote.postgresql-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                11|remote.telnet-banner)
			checknames=remote.telnet-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                12|remote.mysql-banner)
			checknames=remote.mysql-banner
                        source ./monitoring.sh
                       createcheck1
                        ;;
                13|remote.mssql-banner)
			checknames=remote.mssql-banner
                        source ./monitoring.sh
                       createcheck1
                esac
                        done
                     ;;
        4|Modifycheck)
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
			read -p "Entity ID: " entitymofifycheck
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
                        read -p "Entity ID " entityname;
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks;
			read -p "Check Name you want to delete: " deletecheck
			curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/$deletecheck |egrep "HTTP|Date"
                        source ./monitoring.sh
                        checks
                        ;;
        6|testcheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4|default"
                        read -p "Entity ID " entityname
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks
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
                                remote.mssql-banner 
				" checknames;
                        curl -i -s -XPOST -d '{ "details" : {  },  "label" : "'$CHECKNAME'",  "monitoring_zones_poll" : [ "'$ZONE'" ],  "period" : "60",  "target_alias" : "default",  "timeout" : 30,  "type" : "'$checknames'" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/test-check/ |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                        ;;
        7|testexistingcheck)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4|default"
                        read -p "Entity ID " entityname
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

function createcheck1()
{
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                        read -p "Entity ID " entityname
                        read -p "New Check Name " CHECKNAME
                        read -p "Monitoring Zone Name: mzdfw/mzlon/mzhkg/mzord/mziad " ZONE
			curl -i -s -XPOST -d '{ "details" : {  },  "label" : "'$CHECKNAME'",  "monitoring_zones_poll" : [ "'$ZONE'" ],  "period" : "60",  "target_alias" : "default",  "timeout" : 30,  "type" : "'$checknames'" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/ |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                       
}

function createcheck2()
{
			curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                        read -p "Entity ID " entityname
                        read -p "New Check Name " CHECKNAME
                        read -p "Monitoring Zone Name: mzdfw/mzlon/mzhkg/mzord/mziad " ZONE
			read -p "URL you would like to monitor " URL

			curl -i -s -XPOST -d '{ "label": "'$CHECKNAME'", "type": "'$checknames'", "details": { "url": "'$URL'", "method": "GET" }, "monitoring_zones_poll": [ "'$ZONE'" ], "timeout": 30, "period": 100, "target_alias": "default" }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname/checks/ |egrep "HTTP|Date|Location"
                        source ./monitoring.sh
                        checks
                       
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
echo -e -n "\n0 \tExit\n\n >>"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|listentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|label|*_v4|default|count|limit"
                        source ./monitoring.sh
                        entities
                        ;;
        2|getentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4|default"
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
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4|default"
                        read -p "Entity Name " entityname
                        read -p "Specify New IP you want to Monitor " NEWIP
                        curl -s -i -XPUT --data-binary '{"ip_addresses": {"default": "'$NEWIP'"}}' -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityname |egrep "Data|Location"
                        source ./monitoring.sh
                        entities
                        ;;
        5|Deleteentity)
                        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities |egrep "id|public0_v4|private0_v4|default"
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
echo -e -n "\n0 \tExit\n >>"

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
		curl -i -X POST --data-binary '{      "label": "'$NAMEOFAPLAN'",      "'$notificationstatus'": [          "'$notification'"      ]}' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans |egrep "HTTP|Date|Location"
			source ./monitoring.sh
                        notification_plan
		;;
	4|modifyplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
                read -p "Enter Notification Plan ID: " notificationplanid
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notifications 
		read -p "Enter Notification ID: " notificationid
		read -p "Choose one of the Following Notification Options:
                        Notify When in Warning State - warning_state
                        Notify When in OK State  - ok_state
                        Notify When in Error State  - error_state 
						" notificationstatus
                curl -s -XPUT -i  -d '{      "'$notificationstatus'": [ "'$notificationid'"] }' -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans/$notificationplanid |egrep "HTTP|Date|Location"
			source ./monitoring.sh
                        notification_plan
			;;
	5|deleteplan)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans
		read -p "Enter Notification Plan ID: " planid
		curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/notification_plans/$planid |egrep "HTTP|Date"
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
echo -e -n "\n0 \tExit\n >>"

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
#echo -e -n "\n2 Test Created Alarm"
echo -e -n "\n3 List Created Alarms"
echo -e -n "\n4 Information About a Specific Alarm"
#echo -e -n "\n5 Modify a Specific Alarm"
echo -e -n "\n6 Delete a Specific Alarm"
echo -e -n "\n \t-----\n"
echo -e -n "\n15 \tBack to Monitoring Options Menu"
echo -e -n "\n0 \tExit\n >>"


while true
do

                read CONFIRM
                case $CONFIRM in

	1|createalarm)
		echo -e -n "\n1 \tCreate remote.dns Alarm"
		echo -e -n "\n2 \tCreate remote.ssh Alarm"
		echo -e -n "\n3 \tCreate remote.smtp Alarm"
		echo -e -n "\n4 \tCreate remote.http Alarm"
		echo -e -n "\n5 \tCreate remote.tcp Alarm"
		echo -e -n "\n6 \tCreate remote.ping Alarm"
		echo -e -n "\n7 \tCreate remote.ftp-banner Alarm"
		echo -e -n "\n8 \tCreate remote.imap-banner Alarm"
		echo -e -n "\n9 \tCreate remote.smtp-banner Alarm"
		echo -e -n "\n10 \tCreate remote.postgresql-banner Alarm"
		echo -e -n "\n11 \tCreate remote.telnet-banner Alarm"
		echo -e -n "\n12 \tCreate remote.mysql-banner Alarm"		
		echo -e -n "\n13 \tCreate remote.mssql-banner Alarm\n >>"
		
			while true
			do
				read CONFIRM
				case $CONFIRM in

		1|remote.dns)	
			source ./monitoring.sh
                       alarms
			;;
		2|remote.ssh)
			source ./monitoring.sh
                       alarms
			;;
		3|remote.smtp)
			source ./monitoring.sh
                       alarms
			;;
		4|remote.http)
			source ./monitoring.sh
                       alarms
			;;			
		5|remote.tcp)
			source ./monitoring.sh
                       alarms
			;;
		6|remote.ping)
			source ./monitoring.sh
                       alarms
                        ;;
		7|remote.ftp-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		8|remote.imap-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		9|remote.smtp-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		10|remote.postgresql-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		11|remote.telnet-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		12|remote.mysql-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		13|remote.mssql-banner)
			source ./monitoring.sh
                       alarms
                        ;;
		esac
			done
			;;
	2|testalarm)
		source ./monitoring.sh
                       alarms		
		;;
	3|listalarms)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
		read -p "Entity ID: " entityid
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityid/alarms
		source ./monitoring.sh
                       alarms
		;;
	4|getalarm)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                read -p "Entity ID: " entityid
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityid/alarms
		read -p "Alarm ID: " alarmid
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityid/alarms/$alarmid
		source ./monitoring.sh
                       alarms
		;;
	6|deletealarm)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities
                read -p "Entity ID: " entityidtodelete
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityidtodelete/alarms
                read -p "Alarm ID: " alarmidtodelete
                curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://monitoring.api.rackspacecloud.com/v1.0/$ACCOUNT/entities/$entityidtodelete/alarms/$alarmidtodelete |egrep "HTTP|Date"
		source ./monitoring.sh
                       alarms
		;;
        15|MAINMENU)
                        echo " Alarm tools are coming soon. Please choose one of the available MONITORING OPTIONS: "
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
