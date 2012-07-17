#! /bin/bash

function createdbexistinginstance() {

read -p "Please Enter your New Database name " DB1

sed -i "6 s/\"name\":.*/\"name\": \"$DB1\"/" create_db_on_existing_instance

}

