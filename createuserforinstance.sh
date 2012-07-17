#! /bin/bash

function createuserforinstance() {

read -p "Please Enter your Existing Database Name " DB1
read -p "Please Enter your New Username " USER
read -p "New Password " PASS

sed -i "6 s/\"name\":.*/\"name\": \"$DB1\"/" create_user_for_instance
sed -i "9 s/\"name\":.*/\"name\": \"$USER\",/" create_user_for_instance
sed -i "10 s/\"name\":.*/\"name\": \"$PASS\",/" create_user_for_instance

}

