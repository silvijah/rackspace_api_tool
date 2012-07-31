#! /bin/bash

function resizevolume() {

read -p "Please specify The Size of the Volume You require " VOLUME


volumeresize="
{
    \"resize\": {
        \"volume\": {
            \"size\": $VOLUME
        }
    }
}
"
export volumeresize
}
