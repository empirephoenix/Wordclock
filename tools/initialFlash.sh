#!/bin/bash

LUATOOL=./tools/luatool.py

DEVICE=$1

# check the serial connection

if [ ! -c $DEVICE ]; then
 echo "$DEVICE does not exist"
 exit 1
fi


if [ $# -ne 1 ]; then
    echo ""
    echo "e.g. usage $0 <device>"
    exit 1
fi

FILES="displayword.lua main.lua timecore.lua webpage.html webserver.lua wordclock.lua init.lua"

# Format filesystem first
echo "Format the complete ESP"
$LUATOOL -p $DEVICE -w -b 115200
if [ $? -ne 0 ]; then
    echo "STOOOOP"
    exit 1
fi

echo 
echo "Start Flasing ..."
for f in $FILES; do
    if [ ! -f $f ]; then
        echo "Cannot find $f"
        echo "place the terminal into the folder where the lua files are present"
        exit 1
    fi
    echo "------------- $f ------------"
    $LUATOOL -p $DEVICE -f $f -b 115200 -t $f 
    if [ $? -ne 0 ]; then
        echo "STOOOOP"
        exit 1
    fi
done

echo "Reboot the ESP"
$LUATOOL -p $DEVICE -r -b 115200

exit 0
