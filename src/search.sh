#!/bin/bash
set -e

if [ $# -ne 1 ]; then
    echo "Script takes one argument: a string to search the mod archive for"
    exit 1
fi

MOD_INDEX="./mod_index.html"

searchString=$1

# Names
namesString=$(grep -i -o "^.*$searchString[^<]*" $MOD_INDEX | tr -d '\t')

# Download Links
downloadString=$(grep -i -A6 "^.*$searchString[^<]*" $MOD_INDEX | grep -oe "href=[^>]*" | cut -c6-)

SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line
names=($namesString) # split to array $names
download=($downloadString) # split to array $download
IFS=$SAVEIFS   # Restore IFS

if [ "X${#names[@]}" != "X${#download[@]}" ]; then
    echo "Download link number and name number don't match"
    exit 2
fi

if [ "X${#names[@]}" = "X0" ]; then
    echo "No mods matching that string"
    exit 0
fi

echo "===================================================="
echo "Found the following matching mods: "
echo "===================================================="
for (( i=0; i<${#names[@]}; i++ ))
do
    echo "$i: ${names[$i]}"
done
