#!/bin/bash

echo "Your network info is: "
ifconfig

read -p "Do you want to change these info? (Y/N) " answer
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
    echo "Changing..."
    # Generate random values for the last two octets of the IP address
    random_octet3=$((RANDOM % 256))
    random_octet4=$((RANDOM % 256))
    new_ip="192.168.$random_octet3.$random_octet4"

    # Generate random netmask (e.g., between 16 and 24)
    random_netmask=$((RANDOM % 9 + 16))
    netmask="255.255.$((256 - 2**(24 - random_netmask))).0"
    
    # Generate random broadcast address within the subnet
    random_broadcast=$((RANDOM % 256))
    broadcast="192.168.$random_octet3.$random_broadcast"
    
    sudo ifconfig wlan0 $new_ip netmask $netmask broadcast $broadcast
    echo "Network configuration changed."
    echo "Your new network info is"
    ifconfig
else
    echo "Sorry, your network info didn't change."
fi
