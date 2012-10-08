#!/bin/bash

function loadbalancers()
{

echo -e -n "\n\n\t1 Load Balancers "
echo -e -n "\n\t2 Error Page "
echo -e -n "\n\t3 Nodes "
echo -e -n "\n\t4 Virtual IPs "
echo -e -n "\n\t5 Allowed Domains and Access Lists "
echo -e -n "\n\t7 SSL Termination "
echo -e -n "\n\t8 Metadata"
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
        4|virtualIPs)
                        source ./lbaas.sh
                        virtualips
                        ;;
        5|domainsect)
                        source ./lbaas.sh
                        domainsadnother
                        ;;
        6|ssltermination)
                        source ./lbaas.sh
                        ssltermination
                        ;;
	7|metadata)	source ./lbaas.sh
			metadata
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
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address" ;
                        read -p "Choose LoadBalancer ID: " LBID
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        nodes "\t"
                        ;;
	2|details)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address" ;
                        read -p "Choose LoadBalancer ID: " LBID;
        curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
			read -p "Specify a Node ID: " NODEID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes/$NODEID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        nodes "\t"
                        ;;
	3|addnode)
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
                read -p "Choose LoadBalancer ID: " LBID;
		echo  "NextGen Servers  "
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/detail |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|addr";
                echo  "FirstGen Servers       "
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/xml' -H 'Accept: application/xml' "https://$LOCATION.servers.api.rackspacecloud.com/v1.0/$ACCOUNT/servers/detail" |tr "<" "\n" |tr "/>" "\n" |egrep "name|addr";
		read -p "Which IP you want to add: " IPADDR;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/protocols" |tr "{[" "\t" |tr "[}" "\t" |tr "," "\t\t";
		read -p "Specify a Port to use: 
" PORT;
		echo "Choose a Condition: "
		echo -e -n "\n1 Enabled "
		echo -e -n "\n2 Disabled "
		echo -e -n "\n3 Draining \n\n>>>\t"
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
	esac
done
			;;

	4|edit)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
                read -p "Choose LoadBalancer ID: " LBID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/nodes" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                read -p "Specify a Node ID: " NODEID;

echo -e -n "please select your option:
1) enabled 
2) disabled 
3) draining\n\n>>>\t"

read condition

echo -e -n "Please Select your Type of a Server:
1) primary
2) secondary\n\n>>>\t"

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
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
                read -p "Choose LoadBalancer ID: " LBID;
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

echo -e -n "\n\n\t1 List All LoadBalancers"
echo -e -n "\n\t2 Information about A Specific LoadBalancer"
echo -e -n "\n\t3 Create A LoadBalancer"
echo -e -n "\n\t4 Update A LoadBalancer"
echo -e -n "\n\t6 Delete A LoadBalancer"
echo -e -n "\n\t7 LoadBalancer Statistics"
echo -e -n "\n\t8 Virtual IPs"
echo -e -n "\n\t9 Allowed Domains"
echo -e -n "\n\t10 Add IPv6 VirtualIP option"
echo -e -n "\n\t11 Remove an IPv6 IP address"
echo -e -n "\n \t------"
echo -e -n "\n\t15 Back to LoadBalancers Options Menu"
echo -e -n "\n\t0 Exit\n\n\n >>\t"


while true
do
        read CONFIRM
        case $CONFIRM in
        
        1|alllbaas)
                curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        loadbalancerinfo "\t"
                        ;;
	2|detaillbaas)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address" ;
			read -p "Choose LoadBalancer ID: " LBID
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
                        source ./lbaas.sh
                        loadbalancerinfo "\t"
			;;
	3|createlbaas)
		read -p "LoadBalancer Name:	" LBAASNAME;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/protocols" |tr "{[" "\t" |tr "[}" "\t" |tr "," "\t\t";
        	read -p "
Choose a New Protocol:         " PROTOCOL;
        	read -p "Choose a new Port:       " PORT;
		read -p "Which Type of VirtualIP You would Like to Use: PUBLIC/PRIVATE?	" VIRTUALIP;
		echo  "NextGen Servers	"
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' https://$LOCATION.servers.api.rackspacecloud.com/v2/$ACCOUNT/servers/detail |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "id|name|addr";
		echo \n "FirstGen Servers	" \n
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/xml' -H 'Accept: application/xml' "https://$LOCATION.servers.api.rackspacecloud.com/v1.0/$ACCOUNT/servers/detail" |tr "<" "\n" |tr "/>" "\n" |egrep "name|addr";
		read -p "Which Node you Would like to add? (Choose private IP of the Server)	" PRIVATEIP ;
			
	curl -s -XPOST -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"loadBalancer": { "name": "'$LBAASNAME'", "port": '$PORT', "protocol": "'$PROTOCOL'", "virtualIps": [ { "type": "'$VIRTUALIP'" } ], "nodes": [ { "address": "'$PRIVATEIP'", "port": '$PORT', "condition": "ENABLED" } ] }}' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
			source ./lbaas.sh
                        loadbalancerinfo "\t"
                        ;;
	4|updatelbaas)
		echo -e -n "Choose an Algorithm:
1 LEAST_CONNECTIONS  "
		echo -e -n "\n2 RANDOM "
		echo -e -n "\n3 ROUND_ROBIN "
		echo -e -n "\n4 WEIGHTED_LEAST_CONNECTIONS "
		echo -e -n "\n5 WEIGHTED_ROUND_ROBIN \n>>>\t"

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

esac
done


		;;
		
	6|deletelbaas)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
        read -p "Choose LoadBalancer ID (the ID right after the "'name'"):        " LBID;
	curl -s -i -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
	source ./lbaas.sh
                        loadbalancerinfo "\t"
		;;
	7|stats)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
        read -p "Choose LoadBalancer ID (the ID right after the "'name'"):        " LBID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/stats" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
	source ./lbaas.sh
        	loadbalancerinfo "\t"
                ;;
	8|virtualips)	
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
        read -p "Choose LoadBalancer ID (the ID right after the "'name'"):        " LBID;
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/virtualips" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
	9|alloweddomains)
	echo -e "\n\n\t\t\t\tINFORMATION\t\t\t\n\nThe allowed domains are restrictions set for the allowed domain names used for adding load balancer nodes. In order to submit a domain name as an address for the load balancer node to add, the user must verify that the domain is valid by using the List Allowed Domains call. Once verified, simply supply the domain name in place of the node's address in the Add Nodes call. \n\n"
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/alloweddomains" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
		source ./lbaas.sh
                loadbalancerinfo "\t"
                ;;
	10|addipv6)	
		curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
        read -p "Choose LoadBalancer ID (the ID right after the "'name'"):        " LBID;

echo -e -n "Choose The type of VirtualIP to add:
\n1\tPUBLIC
2\tSERVICENET\n"

read type1

case $type1 in
	1)ipVersion=PUBLIC
	;;
	2)ipVersion=SERVICENET
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
	11|removeipv6)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id|address";
        read -p "Choose LoadBalancer ID (the ID right after the "'name'"):        " LBID;
	read -p "Choose a IPV6 VirtualIP ID: " vipid
	curl -s -XDELETE -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/virtualips/$vipid" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
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
    *) echo " UNFORTUNATELY THIS IS NOT A VALID ENTRY. CLOSING. GOOD BYE "
  esac

done

}

function algorithms()

{
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id";
        read -p "Choose LoadBalancer ID:	" LBID;
        read -p "New LoadBalancer Name:	" LBNAME;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/protocols" |tr "{[" "\t" |tr "[}" "\t" |tr "," "\t\t";
	read -p "Choose a New Protocol: 	" NEWPROTOCOL;
	read -p "Choose a new Port: 80/443	" PORT;
	curl -s -i -XPUT -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "loadBalancer": { "name": "'$LBNAME'", "algorithm": "'$algorithm'", "protocol": "'$NEWPROTOCOL'" } }' "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID" |egrep "HTTP|Date";
	source ./lbaas.sh
               loadbalancerinfo "\t"	
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
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id";
        read -p "Choose LoadBalancer ID:        " LBID;
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers/$LBID/errorpage" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n";
	source ./lbaas.sh
               error "\t"
		;;
	2|adderror)
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id";
        read -p "Choose LoadBalancer ID:        " LBID;
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
	curl -s -XGET -H "X-Auth-Token: $APITOKEN" -H 'Content-Type: application/json' -H 'Accept: application/json'  "https://$LOCATION.loadbalancers.api.rackspacecloud.com/v1.0/$ACCOUNT/loadbalancers" |tr "{[" "\n" |tr "[}" "\n" |tr "," "\n" |egrep "name|id";
        read -p "Choose LoadBalancer ID:        " LBID;
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

