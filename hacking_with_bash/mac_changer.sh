#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to generate a random MAC address
generate_random_mac() {
    printf '%02x:%02x:%02x:%02x:%02x:%02x\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

# Display current network interfaces
echo "Available network interfaces:"
ifconfig -a | grep -E '^[a-zA-Z0-9]+'

# Prompt the user to select a network interface
read -p "Enter the name of the interface whose MAC address you want to change (e.g., eth0, wlan0): " interface

# Display current MAC address
echo "Current MAC Address for $interface:"
ifconfig $interface | grep ether

# Generate a random MAC address
new_mac=$(generate_random_mac)

# Change MAC address
echo "Changing MAC Address of $interface to $new_mac..."
ifconfig $interface down
ifconfig $interface hw ether $new_mac
ifconfig $interface up

# Display new MAC address
echo "New MAC Address for $interface:"
ifconfig $interface | grep ether
