#! /bin/bash

function createuserforinstance() {

read -p "Please Enter your Existing Database Name " DB3
read -p "Please Enter your New Username " USER
read -p "New Password " PASSWORD

createuser="
{
\"users\": [
{
\"databases\": [
{
\"name\": \"$DB3\"
}
],
\"name\": \"$USER\",
\"password\": \"$PASSWORD\"
}
]
}
"
export createuser
}

