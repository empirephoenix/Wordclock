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

FILES="displayword.lua main.lua timecore.lua webpage.lua webserver.lua wordclock.lua init.lua"
for f in $FILES; do
    if [ ! -f $f ]; then
        echo "Cannot find $f"
        echo "place the terminal into the folder where the lua files are present"
        exit 1
    fi
    echo "------------- $f ------------"
    $LUATOOL -p $DEVICE -f $f -t $f
    if [ $? -ne 0 ]; then
        echo "STOOOOP"
        exit 1
    fi
done

exit 0
