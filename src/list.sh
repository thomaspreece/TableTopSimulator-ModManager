#!/bin/bash
set -e

workshopJson=`cat ./settings/workshopJson.txt`
read -p "Where is your WorkshopFileInfos.json file? " -i "$workshopJson" -e workshopJson
echo $workshopJson > ./settings/workshopJson.txt

yarn ttsbackup list -w "$workshopJson"
