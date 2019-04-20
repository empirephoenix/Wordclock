# ESP Wordclock
## Setup

### Initial Setup
Install the firmware on the ESP:
The ESP must be set into the bootloader mode, like [this](https://www.ccc-mannheim.de/wiki/ESP8266#Boot_Modi)

The firmware can be downloaded with the following script:
<pre>
cd os/
./flash.sh ttyUSB0
</pre>

Reboot the ESP, with a serial terminal,
format the filesystem with the following command and reboot it:
<pre>
file.format()
node.reboot()
</pre>

Then disconnect the serial terminal and copy the required files to the microcontroller:
<pre>
./tools/initialFlash.sh /dev/ttyUSB0
</pre>

### Upgrade

Determine the IP address of your clock and execute the following script:
<pre>
./tools/remoteFlash.sh IP-Address
</pre>

## Internal Setup
* GPIO2     LEDs
