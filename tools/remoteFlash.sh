#!/bin/bash

IP=$1

FLASHTOOL=./tools/tcpFlash.py

if [ ! -f $FLASHTOOL ]; then
 echo "Execute the script in root folder of the project"
 exit 2
fi

if [ "$IP" == "" ]; then
 echo "IP address of ESP required"
 echo "usage:"
 echo "$0 <IP>"
 echo "$0 192.168.0.2"
 exit 1
fi

# check the connection
echo "Searching $IP ..."
ping $IP -c 2 >> /dev/null
if [ $? -ne 0 ]; then
 echo "Entered IP address: $IP is NOT online"
 exit 2
fi
echo "Upgrading $IP"

echo "stopWordclock()" | nc $IP 80

FILES="displayword.lua main.lua timecore.lua webpage.html webserver.lua wordclock.lua init.lua"

echo "Start Flasing ..."
for f in $FILES; do
    if [ ! -f $f ]; then
        echo "Cannot find $f"
        echo "place the terminal into the folder where the lua files are present"
        exit 1
    fi
    echo "------------- $f ------------"
    $FLASHTOOL -t $IP -f $f 
    if [ $? -ne 0 ]; then
        echo "STOOOOP"
        exit 1
    fi
done

echo "TODO: Reboot the ESP"
#echo "node.restart()" | nc $IP 80

exit 0
