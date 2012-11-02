#!/bin/bash

function lbaas_get()

{

curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}${1}

}

function list_lbaas()

{

	lbaas_get /loadbalancers |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|address|id"  | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g'
                        echo -e -n "\n";
                        read -p "Choose LoadBalancer ID: " LBID

}


function lbaas_xml()

{

curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/xml' -H 'Accept: application/xml'  https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}${1}

}


function loadbalancers()
{

echo -e -n "\n\n\t1 Load Balancers "
echo -e -n "\n\t2 Error Page "
echo -e -n "\n\t3 Nodes "
#echo -e -n "\n\t4 Virtual IPs "
echo -e -n "\n\t4 Access Lists "
echo -e -n "\n\t5 SSL Termination "
echo -e -n "\n\t6 Metadata"
echo -e -n "\n\t7 Additional Options "
echo -e -n "\n \t---------"
echo -e -n "\n\t15 Back to Main Menu"
echo -e -n "\n\t0 Exit\n >>\t"

while true
do
                read CONFIRM
                case $CONFIRM in

        1|lbs)
                        source ./lbaas.sh
                        loadbalancerinfo
                        ;;
        2|error)
                        source ./lbaas.sh
                        error
                        ;;
        3|nodes)
                        source ./lbaas.sh
                        nodes
                        ;;
        4|accesslist)
                        source ./lbaas.sh
                        accesslist
                        ;;
        5|ssltermination)
                        
			#echo -e -n "\nThis Option Is Coming Soon\n"
                        #source ./lbaas.sh
                        #loadbalancers
                        #;;
			source ./lbaas.sh
                        ssltermination
                        ;;
	6|metadata)	
			echo -e -n "\nThis Option Is Coming Soon\n"
                        source ./lbaas.sh
                        loadbalancers
                        ;;

#			source ./lbaas.sh
#			metadata
#			;;
	7|additional)
			source ./lbaas.sh
			additional
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

function ssltermination()

{	

		lbaas_get /loadbalancers |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|address|id"  | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g';
                       echo -e -n "\n";
		read -p "Your LoadBalancer ID: " LBID;
sslallowed="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID |tr "[]{}," "\n" |egrep protocol |tr ":" "\t")"
        

	if [ "$(echo "$sslallowed" |awk '{print $2}' |grep -o -P '.{1}' |tr '\"' "\0" |tail -n2 |head -n1)" = 'S' ]; then

echo -e -n  "\n\n//////////////////////////////////////////////////
Your LoadBalancer Does not Support SSL Termination
 ////////////////////////////////////////////////////\n"
                source ./lbaas.sh
                loadbalancers
	else

echo -e -n "\n\n\t1 Check SSL Termination Status
\t2 Edit SSL Termination (Certificate)
\t3 Disable SSL Termination 
\t---------------
\t15 Main SSL Certificate Menu\n>>>>\t"
	
	 read ALLOWEDSSL
         case $ALLOWEDSSL in

	1|checkstatus)
		lbaas_get /loadbalancers/$LBID/ssltermination |tr "{}" "\n" |tr '\"' "\0" |tr "," "\n"
		echo -e -n "\n\n"
		source ./lbaas.sh
		loadbalancers
		;;
	2|edit)
	#	list_lbaas 
	#	curl -s -XPUT -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN"  https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/ssltermination |tr '\"' "\t"
                source ./lbaas.sh
                ssltermination
		;;
	3|delete)
		list_lbaas
		curl -s -XDELETE -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/ssltermination
		source ./lbaas.sh
                ssltermination
                ;;
        15|menu)
                source ./lbaas.sh
                loadbalancers
	esac

	fi

}

function additional()

{

echo -e -n "\n\t1 Health Monitor Status "
echo -e -n "\n\t2 Session Status "
echo -e -n "\n\t3 Connection Information "
echo -e -n "\n\t4 Content Caching "
echo -e -n "\n\t5 List Ports & Protocols "
echo -e -n "\n\t6 List All LoadBalancer Algorithms "
echo -e -n "\n \t---------"
echo -e -n "\n\t15 Back to LoadBalancer Menu "
echo -e -n "\n\t0 Exit\n >>>\t"

while true
do
	
	read additional
	case $additional in

	1|Configure)
		list_lbaas;
health_monitor="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/healthmonitor |tr "," "\n" |tr ":" "\t" |grep "type" |tr "{" "\0")"
		if [ "$(echo "$health_monitor" | awk '{print $2}')" = '"type"' ]; then
			
			echo -e -n "\n\n\t1 List Health Monitor "
			echo -e -n "\n\t2 Configure Health Monitor "
			echo -e -n "\n\t3 Delete Health Monitor \n"

		read CONFIGURE
		case $CONFIGURE in
	
		1|list)
        	        lbaas_get /loadbalancers/$LBID/healthmonitor |tr "{" "\n" |tr '}\":' "\t" |tr "," "\n";
			echo -e -n "\n\n"
                	source ./lbaas.sh
	                additional
        	        ;;
		2|configure)

                	echo -e -n "\n\n\t Choose The Health Monitor Type: "
	                echo -e -n "\n\t1 CONNECT "
        	        echo -e -n "\n\t2 HTTP "
	                echo -e -n "\n\t3 HTTPS \n"


        		        read types
	                case $types in

        	        1|connect)
                	TYPES="CONNECT"
	                ;;
        	        2|http)
	                TYPES="HTTP"
        	        ;;
                	3|HTTPS)
	                TYPES="HTTPS"
        	        ;;
                	*)
	                echo " Invalid Option. Try Again "
        	        esac

                	read -p "Choose A Timeout Variable: 1-300s " TIMEOUTS
	                read -p "Choose A Delay Variable: 1-3600s " DELAY
        	        read -p "Attempts Before Deactivation: 1-10 " attempts


                	if [ $TYPES == CONNECT ]; then
	                curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "type": "'$TYPES'", "delay": '$DELAY', "timeout": '$TIMEOUTS', "attemptsBeforeDeactivation": '$attempts' }' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/healthmonitor
        	        source ./lbaas.sh
	                additional
	                else
        	        read -p "Choose a Path to be used in the Sample Page: " path
                	curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "type": "'$TYPES'", "delay": '$DELAY', "timeout": '$TIMEOUTS', "attemptsBeforeDeactivation": '$attempts', "path": "'$path'", "statusRegex":"'^[234][0-9][0-9]$'", "bodyRegex": "'^[234][0-9][0-9]$'" }' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/healthmonitor
	                source ./lbaas.sh
        	        additional
                	fi
	                ;;
			3|delete)
	                curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/healthmonitor
        	        source ./lbaas.sh
                	additional
                        ;;
				esac
			else
			echo -e -n "\n\nYou do not Have Health Monitors Setup \n"
		
			
			echo -e -n "\n\n\t1 Setup The Monitor "
			echo -e -n "\n\t-------- "
			echo -e -n "\n\t15 Back to LoadBalancer Menu"
		
		read NOMONITORS
		case $NOMONITORS in

		1|setup)
			
		source ./lbaas.sh
                        nohealth
			;;
		15|MAINMENU)
			source ./lbaas.sh
                                loadbalancers
			;;
		*) echo "Choose One of the Available Options "
		
		esac
		fi		
			;;
	2|sessions)
		list_lbaas;
	session="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/sessionpersistence |tr "{}" "\n" |tr '\"' "\t" |egrep persist)"
		if [ "$(echo "$session" | awk '{print $1}')" = 'persistenceType' ]; then 
			
			echo -e -n "\n\n\t1 List Session persistence Information "
			echo -e -n "\n\t2 Edit Session Persistence "
			echo -e -n "\n\t3 Delete Session Persistence "
			echo -e -n "\n\t-------- "
                        echo -e -n "\n\t15 Back to LoadBalancer Menu\n>>>>\t"
		algorithms
		
			read SESSION
			case $SESSION in 

		1|list)
			lbaas_get /loadbalancers/$LBID/sessionpersistence |tr "{}" "\n" |tr '\"' "\t"
			source ./lbaas.sh
				additional
			;;
		2|add) 
			curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "sessionPersistence":{ "persistenceType":"HTTP_COOKIE" }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/sessionpersistence |egrep "HTTP|Date"
			source ./lbaas.sh
				additional
			;;
		3|delete)
			curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/sessionpersistence |egrep "HTTP|Date"
			source ./lbaas.sh
				additional		
			esac	
		else
			echo "No Session Persistence Is Enabled "

			echo -e -n "\n\n\t1 Enable Session Persistence "
			echo -e -n "\n\t-------- "
                        echo -e -n "\n\t15 Back to Additional Options Menu"

				read NOSESSION
				case $NOSESSION in



				1|enable)
				curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "sessionPersistence":{ "persistenceType":"HTTP_COOKIE" }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/sessionpersistence |egrep "HTTP|Date"
                        source ./lbaas.sh
                                additional
				;;
				15|menu)
				source ./lbaas.sh
				additional
				;;
				*) echo "Choose one of the Available Options "
				esac
		fi
			;;
	3|connections)
			list_lbaas;	
connection="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/connectionlogging |tr "{}" "\n" |tr '\"' "\t" |egrep "true" |tr ":" "\0")"	
		if [ "$(echo "$connection" | awk '{print $2}')" = 'true' ]; then
			
			echo -e -n "\n\n\t You Have Connection Logging Enabled "
			echo -e -n "\n\t1 Disable Connection Logging \n"
			echo -e -n "\n\t-------- "
                        echo -e -n "\n\t15 Back to Additional Options Menu\n>>>>\t"

			read CONNECTION
			case $CONNECTION in
		
				1|disable)
				curl -s -i -XPUT -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "connectionLogging": { "enabled":false }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/connectionlogging |tr "{}" "\n" |tr '\"' "\t"
				source ./lbaas.sh
				additional
				;;
				15|menu)
                                source ./lbaas.sh
                                additional
				;;
			*) echo "Choose one of the Available Options "
                            
			esac
		else
			echo -e -n "\n\n\t Your Connection Logging is Disabled \n"
			echo -e -n "\n\t1 Enable Connection Logging \n"
                        echo -e -n "\n\t-------- "
                        echo -e -n "\n\t15 Back to Additional Options Menu\n"

		
		read CONNECTIONYES
                        case $CONNECTIONYES in

                                1|enable)
                                curl -s -i -XPUT -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "connectionLogging": { "enabled":true }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/connectionlogging |tr "{}" "\n" |tr '\"' "\t"
                                source ./lbaas.sh
                                additional
                                ;;
                                15|menu)
                                source ./lbaas.sh
                                additional
				;;
				*) echo "Choose one of the Available Options "
			esac
		fi
		;;
	4|caching)
		list_lbaas
caching="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/contentcaching |tr "{}" "\n" |tr '\"' "\t" |egrep enabled |tr ":" "\0")"
		if [ "$(echo "$caching" |awk '{print $2}')" = 'true' ]; then	
echo -e -n "\n\nYour Content Caching Is Enabled
\t1 Disable Content Caching
\t------------
\t15 Cancel Disable Content Caching & Return to Additional Options Menu\n\n>>>>\t"

			read DISABLECACHE
			case $DISABLECACHE in


		1|Disable)
		curl -s -i -XPUT -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "contentCaching": { "enabled":false }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/contentcaching |tr "{}" "\n" |tr '\"' "\t"
                        source ./lbaas.sh
                        additional
			;;
		15|menu)
			source ./lbaas.sh
			additional
			;;
		*) echo "Choose One of the Available Options"
			esac		
		else
echo -e -n "\n\nYour Content Caching Is Disabled
\t1 Enable Content Caching
\t------------
\t15 Cancel Disable Content Caching & Return to Additional Options Menu\n\n>>>>\t"

			read ENABLECACHE
			case $ENABLECACHE in

		1|enable)
		curl -s -i -XPUT -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "contentCaching": { "enabled":true }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/contentcaching |tr "{}" "\n" |tr '\"' "\t"
                                source ./lbaas.sh
                                additional
                                ;;
                15|menu)
                        source ./lbaas.sh
                        additional
                        ;;
                *) echo "Choose One of the Available Options"
                        esac
		fi
		;;
	5|ports)
		lbaas_get /loadbalancers/protocols |tr ",:" "\t" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |tr "{" "\n" |tr "[]}" "\0"
		echo -e -n "\n\n"
		source ./lbaas.sh
                        additional
		;;		
	6|algorithmsinfo)
		lbaas_get /loadbalancers/algorithms |tr "{[]}" "\n" |tr '\",' "\0"
		echo -e -n "\n\n"
                source ./lbaas.sh
                        additional
		;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./main_menu.sh" ]; then
                        source ./lbaas.sh
                                loadbalancers
                        else
echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"

                        fi
                        ;;
        0|Exit)
      echo " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo " UNFORTUNAELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE "
  esac

done

}



function nohealth()

{

                        echo -e -n "\n\n\t Choose The Health Monitor Type: "
                        echo -e -n "\n\t1 CONNECT "
                        echo -e -n "\n\t2 HTTP "
                        echo -e -n "\n\t3 HTTPS \n"


                                read types
                        case $types in

                        1|connect)
                        TYPES="CONNECT"
                        ;;
                        2|http)
                        TYPES="HTTP"
                        ;;
                        3|HTTPS)
                        TYPES="HTTPS"
                        ;;
                        *)
                        echo " Invalid Option. Try Again "
                        esac

                        read -p "Choose A Timeout Variable: 1-300s " TIMEOUTS
                        read -p "Choose A Delay Variable: 1-3600s " DELAY
                        read -p "Attempts Before Deactivation: 1-10 " attempts


                        if [ $TYPES == CONNECT ]; then
                        curl -s -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "type": "'$TYPES'", "delay": '$DELAY', "timeout": '$TIMEOUTS', "attemptsBeforeDeactivation": '$attempts' }' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/healthmonitor
                        source ./lbaas.sh
                        additional
                        else
                        read -p "Choose a Path to be used in the Sample Page: " path
                        curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "type": "'$TYPES'", "delay": '$DELAY', "timeout": '$TIMEOUTS', "attemptsBeforeDeactivation": '$attempts', "path": "'$path'", "statusRegex":"'^[234][0-9][0-9]$'", "bodyRegex": "'^[234][0-9][0-9]$'" }' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/${ACCOUNT}/loadbalancers/$LBID/healthmonitor
                        source ./lbaas.sh
                        additional
                        fi
                       


}

function accesslist()

{

echo -e -n "\n\n\t1 List the Available Access Lists "
echo -e -n "\n\t2 Create a New Access List "
echo -e -n "\n\t3 Delete a Network Item "
echo -e -n "\n\t4 Delete the Entire Access List "
echo -e -n "\n \t---------"
echo -e -n "\n\t15 Back to LoadBalancer Menu"
echo -e -n "\n\t0 Exit\n >>\t"



while true
do
	read ACCESS
	case $ACCESS in

	1|List)
		list_lbaas
		lbaas_get /loadbalancers/$LBID/accesslist |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n"
		source ./lbaas.sh
		accesslist
			;;	


	2|create)
		list_lbaas
		read -p "Specify An IP address: " IPADDR

			echo -e -n "\n\t1 ALLOW "
			echo -e -n "\n\t2 DENY \n"

		read CONDITION
		case $CONDITION in
	
		1|allow)
		CONDITION=ALLOW
		;;
		2|deny)
		CONDITION=DENY
		;;
	esac
	
		curl -s -i -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "accessList": [{ "address": "'$IPADDR'", "type": "'$CONDITION'" }]} ' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/accesslist"
		source ./lbaas.sh
        	        accesslist
		;;

	3|deletenetworkitem)

		if [ "$(echo "$network_id" | awk '{print $1}')" = '"type"' ]; then
		list_lbaas
		lbaas_get /loadbalancers/$LBID/accesslist |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |tr ":" "\t"
		read -p "Choose a NetworkID to Delete: " NETWORKID;
		curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/accesslist/$NETWORKID"|egrep "HTTP|Date";
			source ./lbaas.sh
                	accesslist
		else echo "No AccessLists Found"
			source ./lbaas.sh
	                accesslist
		fi
		;;
	4|deleteaccesslist)
	if [ "$(echo "$network_id" | awk '{print $1}')" = '"type"' ]; then
        list_lbaas
	curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/accesslist" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |tr ":" "\t" |egrep "HTTP|Date"
	source ./lbaas.sh
                accesslist
        else echo "No AccessLists Found"
        source ./lbaas.sh
                accesslist
        fi

network_id="$(curl -s -XGET -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/accesslist |tr "," "\n" |tr ":" "\t" |egrep "type")"
	;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./main_menu.sh" ]; then
                        source ./lbaas.sh
                                loadbalancers
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

function other()

{
echo -e -n "\n\n\t1 Billable Usage Report for the All LoadBalancers "
echo -e -n "\n\t2 List Account Level Usage "
echo -e -n "\n\t3 List Historical Usage for A Specific LoadBalancer "
echo -e -n "\n\t4 List Current LoadBalancer Usage "
echo -e -n "\n \t\t---------"
echo -e -n "\n\t\t15 Back to LoadBalancer Menu"
echo -e -n "\n\t\t0 Exit\n >>"

while true
do
	read CONFIRM
	case $CONFIRM in


	1|billable)
		read -p "The esac "

	esac
done

}

function nodes()

{

echo -e -n "\n\n\t\t1 List Nodes "
echo -e -n "\n\t\t2 List Details of a Single Node "
echo -e -n "\n\t\t3 Add Nodes "
echo -e -n "\n\t\t4 Edit Nodes "
echo -e -n "\n\t\t5 Delete Nodes "
echo -e -n "\n \t\t---------"
echo -e -n "\n\t\t15 Back to LoadBalancer Menu"
echo -e -n "\n\t\t0 Exit\n >>"

while true
do
                read CONFIRM
                case $CONFIRM in

	1|list)
		list_lbaas;
        	lbaas_get /loadbalancers/$LBID/nodes |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        nodes "\t"
                        ;;
	2|details)
        	list_lbaas;	
		echo -e -n "\n"
		lbaas_get /loadbalancers/$LBID/nodes |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |egrep "address|id";
			echo -e -n "\n";
			read -p "Specify a Node ID: " NODEID;
			echo -e -n "\n\n";
		lbaas_get /loadbalancers/$LBID/nodes/$NODEID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        nodes "\t"
                        ;;
	3|addnode)
		list_lbaas
		echo  -e -n "\nNextGen Servers\n"
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/detail |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|addr";
                echo -e -n  "\nFirstGen Servers\n"
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' "https://$LOCATION.servers.api.rackspacecloud.com/v1.0/$ACCOUNT/servers/detail" |tr "," "\n"|egrep "name|public|private" |tr '\"' "\0" |tr "{[}]" "\t";
		echo -e -n "\n"
		read -p "Which IP you want to add: " IPADDR;
		lbaas_get /loadbalancers/protocols |tr ",:" "\t" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |tr "{" "\n" |tr "[]}" "\0";
		echo -e -n "\n\n"
		read -p "Specify a Port to use: 
" PORT;
		echo "Choose a Condition: "
		echo -e -n "\n\t1 Enabled "
		echo -e -n "\n\t2 Disabled "
		echo -e -n "\n\t3 Draining "
		echo -e -n "\n\t---------- "
		echo -e -n "\n\t15 Cancel Add Node & Return to Main Nodes Menu\n\n>>>>\t"
while true
do
	read CONFIRM
	case $CONFIRM in

	1|enabled)
		condition=ENABLED
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"nodes": [{ "address": "'$IPADDR'", "port": '$PORT', "condition": "'$condition'" }]}' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                nodes "\t"
		;;
	2|disabled)
		condition=DISABLED
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"nodes": [{ "address": "'$IPADDR'", "port": '$PORT', "condition": "'$condition'" }]}' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                nodes "\t"
		;;
	3|draining)
		condition=DRAINING
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"nodes": [{ "address": "'$IPADDR'", "port": '$PORT', "condition": "'$condition'" }]}' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                nodes "\t"
		;;		
	15|menu)
		source ./lbaas.sh
		nodes
	esac
done
			;;

	4|edit)
	list_lbaas;
	lbaas_get /loadbalancers/$LBID/nodes |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g';
                read -p "Specify a Node ID: " NODEID;

echo -e -n "please select your option:
1) enabled 
2) disabled 
3) draining\n\n>>>\t"

read condition

echo -e -n "Please Select your Type of a Server:
1 primary
2 secondary
----------
15 Return To Main Nodes Menu\n>>>>\t"

read type1

case $condition in
        1)
        COND=ENABLED
        ;;
        2)
        COND=DISABLED
        ;;
        3)
        COND=DRAINING
        ;;
        *)
	echo "Invalid Option. Please choose again."
        ;;
esac

case $type1 in
        1)
        type1=PRIMARY
        ;;
        2)
        type1=SECONDARY
        ;;
	15|menu)
	source ./lbaas.sh
	nodes
	;;
        *)
        echo "Invalid Option. Please choose again."
        ;;
esac

case $COND in

		 ENABLED)
              curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d '{"node": {"condition": "'$COND'", "type": "'$type1'" }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes/$NODEID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP|Date"
                        source ./lbaas.sh
                        nodes "\t"
                        ;;
        	DISABLED) 
			curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d '{"node": {"condition": "'$COND'", "type": "'$type1'" }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes/$NODEID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP|Date"
                	source ./lbaas.sh
			nodes "\t"
                ;;
        	DRAINING) 
		curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -d '{"node": {"condition": "'$COND'", "type": "'$type1'" }}' https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes/$NODEID |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP|Date"
                source ./lbaas.sh
                nodes "\t"
                ;;
esac
	
;;
	5|delete)
        list_lbaas;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                read -p "Specify a Node ID: " NODEID;
		curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes/$NODEID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP|Date";
		source ./lbaas.sh
                nodes "\t"
                ;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./main_menu.sh" ]; then
                        source ./lbaas.sh
                                loadbalancers
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

function loadbalancerinfo()

{

echo -e -n "\n\t1 Information about A Specific LoadBalancer"
echo -e -n "\n\t2 Create A LoadBalancer"
echo -e -n "\n\t3 Update A LoadBalancer"
echo -e -n "\n\t4 Delete A LoadBalancer"
echo -e -n "\n\t5 LoadBalancer Statistics"
echo -e -n "\n\t6 Virtual IPs"
echo -e -n "\n\t7 Allowed Domains"
echo -e -n "\n\t8 Add IPv6 VirtualIP"
echo -e -n "\n\t9 Remove an IPv6 IP address"
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to LoadBalancers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
	
        read CONFIRM
        case $CONFIRM in
       
 
	1|detaillbaas)
		echo -e -n "\n\n";
		list_lbaas;
		lbaas_get /loadbalancers/$LBID |tr "{[]}" "\n" |tr "," "\n" |egrep -v "cluster|ipVersion" |tr '\"' "\0";
                        source ./lbaas.sh
                        loadbalancerinfo "\t"
			;;
	2|createlbaas)
		echo -e -n "\n\n";
		read -p "LoadBalancer Name:	" LBAASNAME

	echo -e -n "\n\t1 DNS(TCP) 53"
	echo -e -n "\n\t2 DNS(UDP) 53"
	echo -e -n "\n\t3 FTP 21"
	echo -e -n "\n\t4 HTTP 80"
	echo -e -n "\n\t5 HTTPS 443"
	echo -e -n "\n\t6 IMAPS 993"
	echo -e -n "\n\t7 IMAPv4 143"
	echo -e -n "\n\t8 LDAP 383"
	echo -e -n "\n\t9 LDAPS 636"
	echo -e -n "\n\t10 MYSQL 3306"
	echo -e -n "\n\t11 POP3 110"
	echo -e -n "\n\t12 POP3S 995"
	echo -e -n "\n\t13 SMTP 25"
	echo -e -n "\n\t14 TCP (custom port)"
	echo -e -n "\n\t15 TCP_CLIENT_FIRST (custom port)"
	echo -e -n "\n\t16 UDP (custom port)"
	echo -e -n "\n\t17 UDP_STREM (custom port)"
	echo -e -n "\n\t18 SFTP 22"
	echo -e -n "\n \t------"
	echo -e -n "\n\t25 Cancel Create Load Balancer & Back to LoadBalancer Options Menu"
	echo -e -n "\n\t0 Exit\n\n\n >>\t"


	read PROTOCOLS
	case $PROTOCOLS in

	1|dnstcp)
		PROTOCOL='DNS'
		PORT='53'
	;;
	2|DNSUDP)
		PROTOCOL='DNS'
		PORT='53'
	;;
	3|FTP)
		PROTOCOL='FTP'
		PORT='21'
	;;
	4|HTTP)
		PROTOCOL='HTTP'
		PORT='80'
	;;
	5|HTTPS)
		PROTOCOL='HTTPS'
		PORT='443'
	;;
	6|IMAPS)
		PROTOCOL='IMAPS'
		PORT='993'
	;;
	7|IMAPV4)
		PROTOCOL='IMAPv4'
		PORT='143'
	;;
	8|LDAP)
		PROTOCOL='LDAP'
		PORT='389'
	;;
	9|LDAPS)
		PROTOCOL='LDAPS'
		PORT='636'
	;;
	10|MYSQL)
		PROTOCOL='MYSQL'	
		PORT='3306'
	;;
	11|POP3)
		PROTOCOL='POP3'
		PORT='110'
	;;
	12|POP3S)
		PROTOCOL='POP3S'	
		PORT='995'
	;;
	13|SMTP)
		PROTOCOL='SMTP'
		PORT='25'
	;;
	14|TCP)
		PROTOCOL='TCP'
		read -p "Specify A Custom Port Number: " PORT
	;;
	15|tcp_client_first)
		PROTOCOL='TCP_CLIENT_FIRST'
		read -p "Specify A Custom Port Number: " PORT
	;;
	16|UDP)
		PROTOCOL='UDP'
		read -p "Specify A Custom Port Number: " PORT
	;;
	17|udp-stream)
		PROTOCOL='UDP_STREAM'
		read -p "Specify A Custom Port Number: " PORT
	;;
	18|SFTP)
		PROTOCOL='SFTP'
		PORT='22'
	;;
	25|exit)
		source ./lbaas.sh
		loadbalancerinfo
	;;
	*)
	echo "Invalid Option. Please choose again."
        ;;

esac


	echo -e -n "Which Type of VirtualIP You would Like to Use: PUBLIC/PRIVATE? :
		1) PUBLIC
		2) PRIVATE\n\n>>>\t"

	read VIRTUALIP	
	case $VIRTUALIP in

	1|PUBLIC)
		VIRTUALIP='PUBLIC'
		;;
	2|PRIVATE)
		VIRTUALIP='PRIVATE'
		;;
	*)
		echo "Invalid Option. Please choose again."
        ;;
esac 

		echo -e -n "\n\n\tNEXTGEN SERVERS	\n"

		lbaas_get /servers/detail |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|addr" |egrep -v 'rax|bandwidth';
		echo  -e -n"\n\n\tFIRSTGEN SERVERS\n"
		lbaas_xml /servers/detail |tr "<" "\n" |tr "/>" "\n" |egrep "name|addr";
		read -p "Which Node you Would like to add? (Choose private IP of the Server)	" PRIVATEIP ;
			
		curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"loadBalancer": { "name": "'$LBAASNAME'", "port": '$PORT', "protocol": "'$PROTOCOL'", "virtualIps": [ { "type": "'$VIRTUALIP'" } ], "nodes": [ { "address": "'$PRIVATEIP'", "port": '$PORT', "condition": "ENABLED" } ] }}' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g' |egrep "loadBalancer|name|id|protocol|port|status";
			source ./lbaas.sh
                        loadbalancerinfo "\t"
                        ;;
	3|updatelbaas)
		list_lbaas

		echo -e -n "\n\nChoose an Algorithm:
		1 Least_Connections
		2 Random 
		3 Round_Robin 
		4 Weighted_Least_Connections 
		5 Weighted_Round_Robin 
		\t-----------
		15 Cancel Update & Back to LoadBalancer Menu \n>>>\t"
while true
do

	read CONFIRM
	case $CONFIRM in

		1|least)
		algorithm=LEAST_CONNECTIONS
		source ./lbaas.sh
		algorithms "\t"
		;;
		2|random)
		algorithm='RANDOM'
		source ./lbaas.sh
                algorithms "\t"
		;;
		3|robin)
		algorithm='ROUND_ROBIN'
		source ./lbaas.sh
                algorithms "\t"
		;;
		4|weighted_least)
		algorithm='WEIGHTED_LEAST_CONNECTIONS'
		source ./lbaas.sh
                algorithms "\t"
		;;
		5|weighted_robin)
		algorithm='WEIGHTED_ROUND_ROBIN'
		source ./lbaas.sh
                algorithms "\t"
		;;
		15|exit)
		source ./lbaas.sh
		loadbalancerinfo
esac
done


		;;
		
	4|deletelbaas)
	echo -e -n "\n\n\t1 Choose A LoadBalancer to Delete "
        echo -e -n "\n\t15 Cancel Delete LoadBalancer & Back to the LoadBalancer Options Menu\n"

while true
do

	read CANCEL
        case $CANCEL in
	1|choose)
	list_lbaas
	echo -e -n "\n\n"
        curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" ;
        source ./lbaas.sh
                loadbalancerinfo "\t"
		;;
        15|exit)
                source ./lbaas.sh
                loadbalancerinfo
        esac
done
;;
	5|stats)
	list_lbaas;
	lbaas_get /loadbalancers/$LBID/stats |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g';
	source ./lbaas.sh
        	loadbalancerinfo "\t"
                ;;
	6|virtualips)	
		list_lbaas;
		lbaas_get /loadbalancers/$LBID/virtualips |tr "{[" "\n" |tr "]}" "\n" |tr "," "\n" |tr '\"' "\0";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
	7|alloweddomains)
	echo -e "\n\n\t\t\t\tINFORMATION\t\t\t\n\nThe allowed domains are restrictions set for the allowed domain names used for adding load balancer nodes. In order to submit a domain name as an address for the load balancer node to add, the user must verify that the domain is valid by using the List Allowed Domains call. Once verified, simply supply the domain name in place of the node's address in the Add Nodes call. \n\n"
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/alloweddomains" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
	8|addipv6)	
	list_lbaas
echo -e -n "Choose The type of VirtualIP to add:
\n1\tPUBLIC
2\tSERVICENET\n
15\n\tCancel Additional IP and Go Back to LoadBalancer Menu \n>>>\t"

read type1

case $type1 in
	1)ipVersion=PUBLIC
	;;
	2)ipVersion=SERVICENET
	;;
	15|exit)
	source ./lbaas.sh
	loadbalancerinfo
	;;
	*)echo " Choose Another Option. Your Chosen Option Is Invalid. "
	;;
esac

case $ipVersion in
	PUBLIC) 
	 curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "type":"'$ipVersion'", "ipVersion":"IPV6" }' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/virtualips" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
esac
;;
	9|removeipv6)
	list_lbaas;
	lbaas_get /loadbalancers/$LBID/virtualips |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" | sed -e 's/"//g' -e 's/\([^:]*\):\(.*\)/\1: \2/g';
	read -p "Choose a IPV6 VirtualIP ID: " vipid
	curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/virtualips/$vipid" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP|Date";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
        15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./lbaas.sh" ]; then
			source ./lbaas.sh
                                loadbalancers
                        else
echo "CHOOSE ONE OF THE AVAILABLE OPTIONS"

                        fi
                        ;;
        0|Exit)
      echo " THANK YOU FOR USING API CLIENT "
      exit
      ;;
    *) echo " Choose One of the Available Menu Options "
  esac
done

}

function algorithms()

{

	echo -e -n "\n\n1 Change LoadBalancer Name
2 Keep LoadBalancer Name the Same
	\t -------
15 Cancel LoadBalancer Edit & Return to LoadBalancer Menu\n\n"

	read LBNAME
	case $LBNAME in

	1|change)
        read -p "New LoadBalancer Name: " LBNAME;
	source ./lbaas.sh
		lbaasname
	curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "loadBalancer": { "name": "'$LBNAME'", "algorithm": "'$algorithm'", "protocol": "'$PROTOCOL'", "port": "'$PORT'" } }' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |egrep "HTTP|Date";
        source ./lbaas.sh
               loadbalancerinfo "\t"
		;;
	2|nochange)
		source ./lbaas.sh
                lbaasname
        curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "loadBalancer": { "algorithm": "'$algorithm'", "protocol": "'$PROTOCOL'", "port": "'$PORT'" } }' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |egrep "HTTP|Date";
        source ./lbaas.sh
               loadbalancerinfo "\t"
		;;
	15|menu)
		source ./lbaas.sh
		loadbalancerinfo "\t"
		;;
	esac

}
		
function lbaasname()

{

	echo -e -n "\n\t1 DNS(TCP) 53"
        echo -e -n "\n\t2 DNS(UDP) 53"
        echo -e -n "\n\t3 FTP 21"
        echo -e -n "\n\t4 HTTP 80"
        echo -e -n "\n\t5 HTTPS 443"
        echo -e -n "\n\t6 IMAPS 993"
        echo -e -n "\n\t7 IMAPv4 143"
        echo -e -n "\n\t8 LDAP 383"
        echo -e -n "\n\t9 LDAPS 636"
        echo -e -n "\n\t10 MYSQL 3306"
        echo -e -n "\n\t11 POP3 110"
        echo -e -n "\n\t12 POP3S 995"
        echo -e -n "\n\t13 SMTP 25"
        echo -e -n "\n\t14 TCP (custom port)"
        echo -e -n "\n\t15 TCP_CLIENT_FIRST (custom port)"
        echo -e -n "\n\t16 UDP (custom port)"
        echo -e -n "\n\t17 UDP_STREM (custom port)"
        echo -e -n "\n\t18 SFTP 22"
        echo -e -n "\n \t------"
        echo -e -n "\n\t25 Back to LoadBalancers Options Menu"
        echo -e -n "\n\t0 Exit\n\n\n >>\t"

read PROTOCOLS
        case $PROTOCOLS in

        1|dnstcp)
                PROTOCOL='DNS'
                PORT='53'
        ;;
        2|DNSUDP)
                PROTOCOL='DNS'
                PORT='53'
        ;;
        3|FTP)
                PROTOCOL='FTP'
                PORT='21'
        ;;
        4|HTTP)
                PROTOCOL='HTTP'
                PORT='80'
        ;;
        5|HTTPS)
                PROTOCOL='HTTPS'
		PORT='443'
        ;;
        6|IMAPS)
                PROTOCOL='IMAPS'
                PORT='993'
	;;
        7|IMAPV4)
                PROTOCOL='IMAPv4'
                PORT='143'
        ;;
        8|LDAP)
                PROTOCOL='LDAP'
                PORT='389'
        ;;
        9|LDAPS)
                PROTOCOL='LDAPS'
                PORT='636'
        ;;
        10|MYSQL)
                PROTOCOL='MYSQL'
                PORT='3306'
        ;;
        11|POP3)
                PROTOCOL='POP3'
                PORT='110'
        ;;
        12|POP3S)
                PROTOCOL='POP3S'
                PORT='995'
        ;;
        13|SMTP)
                PROTOCOL='SMTP'
                PORT='25'
        ;;
	14|TCP)
                PROTOCOL='TCP'
                read -p "Specify A Custom Port Number: " PORT
        ;;
        15|tcp_client_first)
                PROTOCOL='TCP_CLIENT_FIRST'
                read -p "Specify A Custom Port Number: " PORT
        ;;
        16|UDP)
                PROTOCOL='UDP'
                read -p "Specify A Custom Port Number: " PORT
        ;;
        17|udp-stream)
                PROTOCOL='UDP_STREAM'
                read -p "Specify A Custom Port Number: " PORT
        ;;
        18|SFTP)
                PROTOCOL='SFTP'
                PORT='22'
        ;;
        *)
        echo "Invalid Option. Please choose again."
       ;;

esac

}

function error()

{

	echo "
An Error Page is the HTML file that is shown to an End User who is attempting to access a LoadBalancer node that is offline/unavailable."
	echo -e -n "\n\n1 \tList A Present Error Page"
	echo -e -n "\n2\tSet a Custom Error Page"
	echo -e -n "\n3\tDelete an Error Page"
	echo -e -n "\n \t------"
	echo -e -n "\n\t15 Back to LoadBalancers Options Menu"
	echo -e -n "\n\t0 Exit\n\n\n >>\t"

while true
do
	read CONFIRM
	case $CONFIRM in

	1|geterror)
	list_lbaas;
	lbaas_get /loadbalancers/$LBID/errorpage |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
	source ./lbaas.sh
               error "\t"
		;;
	2|adderror)
	list_lbaas;
	echo "
As this is very custom option, I recommend to do the following:

	> create a brand new file,
	> add the required HTML content,
	> save the file,
	> run the following cURL command:

	curl -s -v -d @your_created_file -XPOST -H "Content-type: application/json" -H "X-Auth-User: $USERNAME" -H "X-Auth-Token: $APITOKEN" https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/$LBID/errorpage

"; 
       source ./lbaas.sh
               error "\t"
                ;;
	3|deleteerror)
        list_lbaas;
	curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/errorpage" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "HTTP/Date";
		source ./lbaas.sh
               error "\t"
                ;;
	15|MAINMENU)
                        echo " PLEASE CHOOSE ONE OF THE FOLLOWING DATABASE INSTANCE OPTIONS: "
                        if [ "./lbaas.sh" ]; then
                        source ./lbaas.sh
                                loadbalancers
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

