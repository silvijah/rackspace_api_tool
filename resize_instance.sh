#! /bin/bash

function resizeinstance() {

read -p "Provide us with the Size of the Flavor you require " FLAVOR

resize="
{
    \"resize\": {
        \"flavorRef\": \"https:\/\/$LOCATION.databases.api.rackspacecloud.com\/v1.0\/$ACCOUNT\/flavors\/$FLAVOR\"
    }
}
"
}
export resize
