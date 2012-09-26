#!/bin/bash

function nextgenservers()
{

echo -e -n "\n\n1 Servers"
echo -e -n "\n2 Server Addresses"
echo -e -n "\n3 Server Actions"
echo -e -n "\n4 Volume Attachment Actions"
echo -e -n "\n5 Flavors"
echo -e -n "\n6 Images"
echo -e -n "\n7 Metadata"
echo -e -n "\n8 Limits of the Account"
echo -e -n "\n \t---------"
echo -e -n "\n15 Back to Main Menu"
echo -e -n "\n0 Exit\n >>"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|servers)
                        source ./nextgen.sh
                        servers
                        ;;
        2|addresses)
                        source ./nextgen.sh
                        addresses
                        ;;
        3|actions)
                        source ./nextgen.sh
                        actions
                        ;;
        4|volumeactions)
                        source ./nextgen.sh
                        volumeattachment
                        ;;
        5|flavors)
                        source ./nextgen.sh
                        flavors
                        ;;
        6|images)
                        source ./nextgen.sh
                        images
                        ;;
	7|metadata)	source ./nextgen.sh
			metadata
			;;
	8|limits)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/limits" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
			source ./nextgen.sh
			nextgenservers
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

function servers()

{

echo -e -n "\n\n\t1 List All servers"
echo -e -n "\n\t2 List Information about All of the Servers"
echo -e -n "\n\t3 Information about A Specific Server"
echo -e -n "\n\t4 Create A Server"
echo -e -n "\n\t5 Update A Server"
echo -e -n "\n\t6 Delete A Server"
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"


while true
do
        read CONFIRM
        case $CONFIRM in
        
        1|allservers)
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                        source ./nextgen.sh
                        servers "\t"
                        ;;
	2|detailserver)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/detail |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep -v "servers"
			source ./nextgen.sh
			servers "\t"
			;;
	3|serverinfo)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
		read -p "Provide Server ID: " SERVERID
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep -v "servers"
		source ./nextgen.sh
                        servers "\t"
                        ;;
	4|createaserver)
		echo "This Creates a Server with AUTO Disk Extension"
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|]" |tr "]" "\n";
		read -p "Choose an Image ID: " IMAGEID;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "disk|id|name|ram|swap|vcpus";
		read -p "Choose Flavor ID: " FLAVORID;
		read -p "How Would You Like to Name the Server: " SERVERNAME;
		read -p "Set User Password: " USERPASS
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"server" : { "name" : "'$SERVERNAME'", "imageRef" : "'$IMAGEID'", "flavorRef" : "'$FLAVORID'", "adminPass" : "'$USERPASS'", "OS-DCF:diskConfig" : "AUTO"}}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers;
			source ./nextgen.sh
                        servers "\t"
                        ;;
	5|updateserver)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID
		echo -e -n "\t\n1 \tChange Server Name\n>>>"
#                echo -e -n "\t\n2 \tChange IPv4 address"
#                echo -e -n "\t\n3 \tCreate IPv6 address"


while true
do
                                read CONFIRM
                                case $CONFIRM in

                1|servername)
		read -p "New Server Name: " SERVERNAMENEW;
		curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"server" : { "name" : "'$SERVERNAMENEW'" }}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n"
		source ./nextgen.sh
                        servers "\t"
                        ;;
#                2|ipv4)
#			;;
#		3|ipv6)

		esac
		done
		;;
	6|deleteserver)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID
		curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID |grep "HTTP"
		source ./nextgen.sh
                        servers "\t"
		;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
source ./nextgen.sh
                                nextgenservers
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

function addresses()
{

echo -e -n "\n\n\t1 List All IP addresses of the Server"
echo -e -n "\n\t2 List a Server addresses of a Specific Network "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in

	1|ips)
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep -v "href|rel"
		read -p "Choose a Server ID: " SERVERID
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/ips |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n"
		source ./nextgen.sh
                        addresses "\t"
                        ;;
	2|network)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep -v "href|rel"
                read -p "Choose a Server ID: " SERVERID
		read -p "Choose a Network ID: public/private: " NETWORKID
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/ips/$NETWORKID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n"
                source ./nextgen.sh
                        addresses "\t"
                        ;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
source ./nextgen.sh
                                nextgenservers
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

function actions()
{

echo -e -n "\n\n\t1 Change Server Password"
echo -e -n "\n\t2 Reboot the Server "
echo -e -n "\n\t3 Rebuild the Server "
echo -e -n "\n\t4 Resize the Server "
echo -e -n "\n\t5 "Confirm Resize" the Server "
echo -e -n "\n\t6 "Revert Resize" the Server "
echo -e -n "\n\t7 Set the Server to RESCUE Mode "
echo -e -n "\n\t8 Set the Server to UNRESCUE Mode "
echo -e -n "\n\t9 Create an Image of a Specified Server "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in


	1|password)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep -v "servers"
	read -p "The New Password: " NEWPASS
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"changePassword" : { "adminPass" : "'$NEWPASS'"}}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	2|reboot)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
		read -p "Hard or Soft reboot?" REBOOT;
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"reboot" : { "type" : "'$REBOOT'"}}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	3|rebuild)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|]" |tr "]" "\n";
                read -p "Choose an Image ID: " IMAGEID;
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "disk|id|name|ram|swap|vcpus";
                read -p "Choose Flavor ID: " FLAVORID;
                read -p "How Would You Like to Name the Server: " SERVERNAME;
                read -p "Set User Password: " USERPASS
                curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"rebuild" : { "name" : "'$SERVERNAME'", "imageRef" : "'$IMAGEID'", "flavorRef" : "'$FLAVORID'", "adminPass" : "'$USERPASS'", "OS-DCF:diskConfig" : "AUTO"}}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|]" |tr "]" "\n";
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	4|resize)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "disk|id|name|ram|swap|vcpus";
                read -p "Choose Flavor ID: " FLAVORID;
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"resize" : { "flavorRef" : "'$FLAVORID'" }}' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
			;;
	5|confirmresize)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"              
                read -p "Provide Server ID: " SERVERID;
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"confirmResize" : null }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	6|revertresize)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"              
                read -p "Provide Server ID: " SERVERID;
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"revertResize" : null }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	7|rescue)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
        curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"rescue" : "none" }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	8|unrescue)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
        curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"unrescue" : null }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	9|createimage)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
		read -p "How would you like to call your Image?: " IMAGENAME;
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"createImage" : { "name" : "'$IMAGENAME'"} }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/action;
                        source ./nextgen.sh
                        actions "\t"
                        ;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
			source ./nextgen.sh
                                nextgenservers
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

function volumeattachment()
{

echo -e -n  "\n\nTHIS REQUIRES A CLOUD BLOCK STORAGE PRODUCT. IT IS NOT YET AVAILABLE. THESE OPTIONS WILL BE COMING UP SOON "
#echo -e -n "\n\n\t1 Attach Volume to Server "
#echo -e -n "\n\t2 List Volume Attachments "
#echo -e -n "\n\t3 Get Volume Attachment Details "
#echo -e -n "\n\t4 Delete Volume Attachment "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in

#	1|attach)
#		;;
#	2|list)
#		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
#                read -p "Provide Server ID: " SERVERID;
#		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/os-volume_attachments"
#                source ./nextgen.sh
#                        volumeattachment "\t"
#                        ;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                nextgenservers
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

function flavors()
{

echo -e -n "\n\n\t1 List all of the Available Flavors "
echo -e -n "\n\t2 Get the details of an individual Flavor "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in
	
	1|list)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "disk|id|name|ram|swap|vcpus";
			source ./nextgen.sh
				flavors
			;;
	2|detail)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "disk|id|name|ram|swap|vcpus";
			read -p "Choose a Flavor ID: " FLAVORIDS
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/flavors/$FLAVORIDS" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./nextgen.sh
                                flavors
			;;

        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                nextgenservers
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


function images()

{

echo -e -n "\n\n\t1 List all of the Available Images "
echo -e -n "\n\t2 Get the details of an individual Image "
echo -e -n "\n\t3 Delete an Image "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in


	1|list)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "images|id|rel|name" |egrep -v "href";
	source ./nextgen.sh
                       	images
                        ;;
	2|detail)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "images|id|rel|name" |egrep -v "href";
	read -p "Choose an Image ID: " IMAGEID
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$IMAGEID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
        source ./nextgen.sh
                        images
                        ;;
	3|delete)	
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "images|id|rel|name" |egrep -v "href";
        read -p "Choose an Image ID: " IMAGEID
        curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$IMAGEID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
        source ./nextgen.sh
                        images
			;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                nextgenservers
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

function metadata()
{




echo -e -n "\n\n\t1 Metadata for A Server "
echo -e -n "\n\t2 Metadata for An Image  "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to NextGen Servers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
        read CONFIRM
        case $CONFIRM in


	1|servers)
echo -e -n "\n\n\t1 List Metadata of a Server "
echo -e -n "\n\t2 Set Metadata of a Server  "
echo -e -n "\n\t3 Update metadata of a Server  "
echo -e -n "\n\t4 Get Metadata Item "
echo -e -n "\n\t5 Set Metadata Item for a Server "
echo -e -n "\n\t6 Delete Metadata Item from a Server "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to Metadata Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

	while true
do
	read CONFIRM
	case $CONFIRM in

	1|list)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./nextgen.sh
                       metadata
		;;
	2|set)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
		read -p "Metadata Name: " LABEL;
        curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "metadata" : { "Label" : "'$LABEL'", "Version" : "2.1" } }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata
                ;;
	3|update)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
                read -p "Metadata Name: " LABEL;
        curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{  "metadata" : { "Label" : "'$LABEL'" } }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata

		;;
	4|item)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
		read -p "Label Name: " KEY;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata/$KEY" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata
		;;
	5|setitem)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
                read -p "Label Name: " KEY;
        curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "meta" : { "Label" : "'$KEY'"} }' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata/$KEY" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		;;
	6|delete)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide Server ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
	read -p "Label Name: " KEY;
	curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/$SERVERID/metadata/$KEY |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		;;

	15|MAINMENU)    
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                metadata
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
			;;
	2|Images)

echo -e -n "\n\n\t1 List Metadata of a Image "
echo -e -n "\n\t2 Set Metadata of a Image  "
echo -e -n "\n\t3 Update metadata of a Image  "
echo -e -n "\n\t4 Get Metadata Item "
echo -e -n "\n\t5 Set Metadata Item for a Image "
echo -e -n "\n\t6 Delete Metadata Item from a Image "
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to Metadata Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"
		

	while true
do
	read CONFIRM
	case $CONFIRM in


1|list)
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata
                ;;

2|set)
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
                read -p "Metadata Name: " LABEL;
        curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "metadata" : { "Label" : "'$LABEL'", "Version" : "2.1" } }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata
                ;;
        3|update)
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
                read -p "Metadata Name: " LABEL;
        curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{  "metadata" : { "Label" : "'$LABEL'" } }' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata

                ;;
        4|item)
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
                read -p "Label Name: " KEY;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata/$KEY" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                source ./nextgen.sh
                       metadata
                ;;
        5|setitem)
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
                read -p "Label Name: " KEY;
        curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "meta" : { "Label" : "'$KEY'"} }' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata/$KEY" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                ;;
        6|delete)
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name"
                read -p "Provide IMAGE ID: " SERVERID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' " https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |grep "Label";
        read -p "Label Name: " KEY;
        curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/images/$SERVERID/metadata/$KEY |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                ;;
        15|MAINMENU)    
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                metadata
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
	;;

	15|MAINMENU)    
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./nextgen.sh" ]; then
                        source ./nextgen.sh
                                nextgenservers
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
