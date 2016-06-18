#!/bin/bash

if [ $# -ne 1 ]; then
 echo "One parameter required: the device of the serial interface"
 echo "$0 <device>"
 echo "e.g.:"
 echo "$0 ttyUSB0"
 exit 1
fi

DEVICE=$1
#BAUD="--baud 57600"
#BAUD="--baud 921600"

# check the serial connection

if [ ! -c /dev/$DEVICE ]; then
 echo "/dev/$DEVICE does not exist"
 exit 1
fi

if [ ! -f esptool.py ]; then
 echo "Cannot found the required tool:"
 echo "esptool.py"
 exit 1
fi

./esptool.py --port /dev/$DEVICE $BAUD read_mac

if [ $? -ne 0 ]; then
 echo "Error reading the MAC -> set the device into the bootloader!"
 exit 1
fi

#./esptool.py --port /dev/$DEVICE $BAUD write_flash 0x00000 nodemcu-master-enduser_setup,file,gpio,net,node,rtcfifo,rtcmem,rtctime,sntp,spi,tmr,uart,wifi,ws2812-integer.bin
./esptool.py --port /dev/ttyUSB0 $BAUD write_flash 0x00000 0x00000.bin 0x10000 0x10000.bin
