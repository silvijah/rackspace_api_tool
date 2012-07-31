#! /bin/bash

function createdbexistinginstance() {

read -p "Please Enter your New Database name " DB2


newdb="
{
\"databases\": [
{
\"character_set\": \"utf8\",
\"collate\": \"utf8_general_ci\",
\"name\": \"$DB2\"
}
]
}
"
export newdb
}

