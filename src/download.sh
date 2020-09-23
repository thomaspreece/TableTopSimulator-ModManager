#!/bin/bash
set -e

if [ $# -ne 1 ]; then
    echo "Script takes one argument: a string to search the mod archive for"
    exit 1
fi

searchString=$1

MOD_INDEX="./mod_index.html"
OFFLINE_MOD_FOLDER="./TTS_All_Workshop_Mods"

function sanitize_file_name {
    echo -n $1 | perl -pe 's/[\?\[\]\/\\=<>:;,''"&\$#*()|~`!{}%+]//g;' -pe 's/[\r\n\t -]+/-/g;'
}

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
echo "Download the following matching files: "
echo "===================================================="
for (( i=0; i<${#names[@]}; i++ ))
do
    echo "$i: ${download[$i]} ${names[$i]}"
done

echo "Are you sure you want to download all of the above mods?"
read -p "Continue (y/n)? " choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "user cancelled"; exit 0;;
  * ) echo "invalid"; exit 1;;
esac

# Download
echo "===================================================="
echo "Downloading"
echo "===================================================="
searchString=$(sanitize_file_name "${searchString}")
mkdir -p "./output/$searchString"
for (( i=0; i<${#names[@]}; i++ ))
do
    fileObtained=1
    cleanedName=$(sanitize_file_name "${names[$i]}")
    if [ -f "./output/${i}_${cleanedName}" ] || [  -f "$OFFLINE_MOD_FOLDER/${names[$i]}" ] ; then
        echo "Downloading ($i/${#names[@]}): File already exists, not downloading"
        if [ -f "$OFFLINE_MOD_FOLDER/${names[$i]}" ]; then
            cp "$OFFLINE_MOD_FOLDER/${names[$i]}" "./output/${i}_${cleanedName}"
        fi
    else
        echo "Downloading ($i/${#names[@]}): ${names[$i]} to ./output/${i}_${cleanedName}"
        set +e
        wget -O "./output/${i}_${cleanedName}" ${download[$i]}
        set -e
        if [ $? -neq 0 ]; then
            echo "Download Failed ($i/${#names[@]}): status $status"
            fileObtained=0
        fi
        sleep 5
    fi

    if [ $fileObtained -eq 1 ]; then
        echo "Extracting ($i/${#names[@]}): ./output/${i}_${cleanedName}"
        7z -o"./output/$searchString/" e "./output/${i}_${cleanedName}"
    fi
done

echo "===================================================="
echo "Importing the following matching files to TTS "
echo "===================================================="
for i in ./output/$searchString/*.json; do
     if [ -f "$i" ]; then
         echo "$i";
     fi
done

echo "Are you sure you want to import all of the above mods into your TTS?"
read -p "Continue (y/n)? " choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "user cancelled"; exit 0;;
  * ) echo "invalid"; exit 1;;
esac

workshopJson=`cat ./settings/workshopJson.txt`

read -p "Where is your WorkshopFileInfos.json file? " -i "$workshopJson" -e workshopJson

echo $workshopJson > ./settings/workshopJson.txt

for i in ./output/$searchString/*.json; do
     if [ -f "$i" ]; then
         echo "Adding $i to TTS, you'll be prompted for the name to import the mod as:";
         yarn ttsbackup install -w "/home/tom/.local/share/Tabletop Simulator/Mods/Workshop/WorkshopFileInfos.json" "$i"
     fi
done
