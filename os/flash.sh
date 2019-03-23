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
echo "Flashing the old one"
./esptool.py --port /dev/$DEVICE $BAUD write_flash 0x00000 0x00000.bin 0x10000 0x10000.bin
sleep 1
echo "Flashing the new"
./esptool.py --port /dev/$DEVICE $BAUD write_flash -fm dio 0x00000 nodemcu2.bin
# 0x3fc000 esp_init_data_default_v08.bin 0x07e000 blank.bin 0x3fe000 blank.bin
#./esptool.py --port /dev/$DEVICE $BAUD write_flash 0x00000 0x00000.bin 0x10000 0x10000.bin
