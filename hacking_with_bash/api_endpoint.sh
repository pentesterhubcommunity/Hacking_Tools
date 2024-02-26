#!/bin/bash
# This is a comment

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to extract hostname or IP address from URL
extract_hostname() {
    echo "$1" | sed -e 's!^[^/]*//!!' -e 's!/.*!!'
}

# Function to perform Unprotected API Endpoint detection
detect_unprotected_api_endpoints() {
    echo "Detecting Unprotected API Endpoints..."
    # Send a request and analyze the response body
    response_body=$(curl -s "$1")
    
    # Check for common indicators of unprotected API endpoints
    if grep -q '"error":' <<< "$response_body" || grep -q '"status":' <<< "$response_body"; then
        echo -e "${RED}Unprotected API endpoint detected: $1${NC}"
    else
        echo -e "${GREEN}No unprotected API endpoint detected.${NC}"
    fi
}

# Function to perform port scanning using Nmap
perform_port_scan() {
    echo "Performing port scan..."
    nmap_result=$(nmap -p- -T4 "$(extract_hostname "$1")")
    echo "$nmap_result"
}

# Function to perform vulnerability scanning using Nikto
perform_vulnerability_scan() {
    echo "Performing vulnerability scan..."
    nikto_result=$(nikto -h "$(extract_hostname "$1")")
    echo "$nikto_result"
}

# Main function
main() {
    echo "Security Assessment Tool"
    echo "------------------------"

    # Prompt user for target URL
    read -rp "Enter your target URL or IP address: " target

    # Perform Unprotected API Endpoint detection
    detect_unprotected_api_endpoints "$target"

    # Perform port scanning
    perform_port_scan "$target"

    # Perform vulnerability scanning
    perform_vulnerability_scan "$target"
}

# Call main function
main
