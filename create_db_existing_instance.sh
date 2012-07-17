#! /bin/bash

function createdbexistinginstance() {

read -p "Please Enter your New Database name " DB1
read -p "Second DB server " DB2

sed -i "6 s/\"name\":.*/\"name\": \"$DB1\"/" create_db_on_existing_instance
sed -i "9 s/\"name\":.*/\"name\": \"$DB2\"/" create_db_on_existing_instance

}

