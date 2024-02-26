#!/bin/bash
# This is a comment

# Perform network scan
network_scan() {
    local ip_prefix="$1"
    trap 'echo "Scan stopped."; exit' INT  # Trap Ctrl+C to stop the scan
    for ((i=1; i<=254; i++)); do
        ip="$ip_prefix$i"
        ping -c 1 -W 1 "$ip" >/dev/null 2>&1 && echo "Host $ip is up"
    done
}

# Main function
main() {
    read -rp "Enter the IP's first 3 blocks (e.g., 192.168.10.): " ip_prefix
    echo "Network Scanner"
    echo "---------------"
    network_scan "$ip_prefix"
}

# Call main function
main

