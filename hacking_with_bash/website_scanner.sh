#!/bin/bash
# This is a comment

# Check if running with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "Error: This script requires root privileges to run."
    exit 1
fi

# Function to perform port scan
perform_port_scan() {
    echo "Performing port scan..."
    nmap -Pn -T4 -v -sV -O -A "$1"
}

# Function to scan for common web vulnerabilities
scan_web_vulnerabilities() {
    echo "Scanning for web vulnerabilities..."
    nikto -h "$1" -ssl -Display V
    wpscan --url "$2" --aggressive --verbose --enumerate p,vt,tt,u,m
    dirb "$2" -d 5 -w /usr/share/wordlists/dirb/common.txt
    dirsearch -u "$2" -w /usr/share/wordlists/dirb/common.txt
    sqlmap -u "$2" --tamper=space2comment,between,randomcase --level=5 --risk=3 -b
    wfuzz -c -z file,/usr/share/wordlists/wfuzz/general/common.txt --hc 404 "$2" -v -t 10
    zaproxy -quickurl "$2" -p 10010
    davtest -url "$2" -ssl
    xsser -u "$2" -v
    w3af_console -s xss "$2"
    dotdotpwn -m http -h "$2"
    sqlninja -m http -u "$2" -v
    uniscan -u "$2" -q
    joomscan -u "$2" -ec -tc
    golismero scan "$2" -o detailed
    cmseek -u "$2" -v
    wafw00f "$2" -a
    testssl.sh "$1" --quiet
    grabber -u "$2" -l 3
    faraday-cli "$2" -n
    reaver -i "$2" -vv
    theHarvester -d "$1" -l 500 -b all
    httrack "$2" -O "$2"
    sslscan --no-failed "$1"
    davtest -url "$2"
    wapiti -u "$2" -n 3
    ffuf -w /usr/share/wordlists/dirb/common.txt -u "$2/FUZZ" -t 50
}

# Function to analyze HTTP headers
analyze_http_headers() {
    echo "Analyzing HTTP headers..."
    curl -I "$2"
    whatweb "$2"
}

# Main function
main() {
    echo "Website Vulnerability Scanner"
    echo "-----------------------------"

    # Prompt the user for target domain and URL
    read -rp "Enter your target domain: " target_domain
    read -rp "Enter the target URL: " target_url

    # Validate input
    if [ -z "$target_domain" ] || [ -z "$target_url" ]; then
        echo "Error: Both target domain and target URL must be provided."
        exit 1
    fi

    # Perform vulnerability scans
    perform_port_scan "$target_domain"
    scan_web_vulnerabilities "$target_domain" "$target_url"
    analyze_http_headers "$target_domain" "$target_url"
}

# Call main function
main
