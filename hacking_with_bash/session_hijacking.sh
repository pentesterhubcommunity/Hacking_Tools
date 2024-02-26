#!/bin/bash
# This is a comment

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to perform Session Hijacking detection
detect_session_hijacking() {
    echo -e "${CYAN}Detecting Session Hijacking...${NC}"
    # Retrieve session cookie
    session_cookie=$(curl -s -k -I "$1" | grep -iE '^Set-Cookie:' | sed 's/Set-Cookie: //' | tr -d '\r')

    # Monitor session activity
    while true; do
        # Check for changes in session cookie
        current_session_cookie=$(curl -s -k -I "$1" | grep -iE '^Set-Cookie:' | sed 's/Set-Cookie: //' | tr -d '\r')
        if [ "$session_cookie" != "$current_session_cookie" ]; then
            echo -e "${RED}Session hijacking detected!${NC}"
            break
        fi
        sleep 5  # Check every 5 seconds
    done
}

# Function to perform header analysis
perform_header_analysis() {
    echo -e "${CYAN}Performing Header Analysis...${NC}"
    # Retrieve headers
    headers=$(curl -s -k -I "$1")

    # Output headers
    echo -e "${GREEN}Headers:${NC}"
    echo "$headers"
}

# Function to perform SSL certificate validation
validate_ssl_certificate() {
    echo -e "${CYAN}Validating SSL Certificate...${NC}"
    # Check SSL certificate using OpenSSL
    openssl s_client -connect "$1" -servername "$1" -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text
}

# Function to perform vulnerability scan using Nikto
perform_vulnerability_scan() {
    echo -e "${CYAN}Performing Vulnerability Scan with Nikto...${NC}"
    # Run Nikto scan
    nikto -h "$1"
}

# Main function
main() {
    echo -e "${GREEN}Security Assessment Tool${NC}"
    echo "--------------------------------"

    # Prompt user for target URL
    read -p "Enter your target URL: " target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}Target URL cannot be empty.${NC}"
        exit 1
    fi

    # Perform Header Analysis
    perform_header_analysis "$target_url"

    # Perform SSL Certificate Validation
    validate_ssl_certificate "$target_url"

    # Perform Vulnerability Scan with Nikto
    perform_vulnerability_scan "$target_url"

    # Perform Session Hijacking detection
    detect_session_hijacking "$target_url"
}

# Call main function
main
