#!/bin/bash

# Function to display colored output
print_color() {
    color="$1"
    text="$2"
    echo -e "\033[${color}m${text}\033[0m"
}

# Function to test for session hijacking vulnerability
test_session_hijacking() {
    url="$1"

    # Step 1: Make a request to the target website
    response=$(curl -s "$url")

    # Step 2: Search for session identifiers
    session_id=$(echo "$response" | grep -oP 'sessionid=\K\w+')

    # Step 3: Check if session identifier is found
    if [ -z "$session_id" ]; then
        print_color "31" "[!] Session identifier not found. Vulnerability may not be present."
    else
        print_color "32" "[+] Session identifier found: $session_id"
        print_color "32" "[+] Vulnerability may be present. Further testing is recommended."
    fi
}

# Main script
clear
print_color "33" "Session Hijacking Vulnerability Tester"
echo ""

# Ask for target website URL
read -p "Enter your target website url: " target_url

# Perform the test
echo ""
print_color "33" "Testing $target_url for Session Hijacking vulnerability..."
test_session_hijacking "$target_url"
