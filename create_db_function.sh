#! /bin/bash

function createdbinstance() {

read -p "Please Enter your New Database name " DB1
read -p "Second DB server " DB2
read -p "Please Enter your New Instance name " INSTANCE
read -p "Please Enter your New Username " USER
read -p "New Password " PASS
read -p "Specify your location LON/DFW/ORD " LOCATION
read -p "Specify your Account Number " ACCOUNT

sed -i "7 s/\"name\":.*/\"name\": \"$DB1\"/" createdbinstance
sed -i "10 s/\"name\":.*/\"name\": \"$DB2\"/" createdbinstance
sed -i "14 s/\"name\":.*/\"name\": \"$INSTANCE\",/" createdbinstance
sed -i "19 s/\"name\":.*/\"name\": \"$DB1\"/" createdbinstance
sed -i "22 s/\"name\":.*/\"name\": \"$USER\",/" createdbinstance
sed -i "23 s/\"password\":.*/\"password\": \"$PASS\"/" createdbinstance
sed -i "13 s/\"flavorRef\":.*/\"flaforRef\": \"https://$LOCATION.databases.api.rackspacecloud.com/v1.0/$ACCOUNT/flavors/1\",/" createdbinstance

}

