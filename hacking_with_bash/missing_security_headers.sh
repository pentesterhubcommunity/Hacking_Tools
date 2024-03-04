#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to test Missing Security Headers vulnerability
test_missing_security_headers() {
    local url="$1"
    local headers=$(curl -sI "$url")

    # Check for errors during the HTTP request
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Unable to connect to $url.${NC}"
        return
    fi

    echo "Testing for Missing Security Headers vulnerability in: $url"

    # Check for specific headers
    if [[ $headers == *"X-Frame-Options"* ]]; then
        echo -e "${GREEN}✓ X-Frame-Options header is present.${NC}"
    else
        echo -e "${RED}✗ Missing X-Frame-Options header.${NC}"
        echo -e "${YELLOW}Potential Exploit:${NC} Clickjacking attacks can be performed if this header is missing."
        echo -e "${YELLOW}Suggestion:${NC} Add 'X-Frame-Options: DENY' or 'X-Frame-Options: SAMEORIGIN' to your server configuration."
    fi

    if [[ $headers == *"X-XSS-Protection"* ]]; then
        echo -e "${GREEN}✓ X-XSS-Protection header is present.${NC}"
    else
        echo -e "${RED}✗ Missing X-XSS-Protection header.${NC}"
        echo -e "${YELLOW}Potential Exploit:${NC} Cross-site scripting (XSS) attacks can be more effective if this header is missing."
        echo -e "${YELLOW}Suggestion:${NC} Enable XSS protection by adding 'X-XSS-Protection: 1; mode=block' to your server configuration."
    fi

    if [[ $headers == *"Content-Security-Policy"* ]]; then
        echo -e "${GREEN}✓ Content-Security-Policy header is present.${NC}"
    else
        echo -e "${RED}✗ Missing Content-Security-Policy header.${NC}"
        echo -e "${YELLOW}Potential Exploit:${NC} Without a Content-Security-Policy, the website is more vulnerable to various attacks such as XSS and data injection attacks."
        echo -e "${YELLOW}Suggestion:${NC} Implement a Content Security Policy to restrict the sources from which content can be loaded."
    fi
}

# Main script
read -p "Enter target website URLs separated by space: " target_urls

# Split the input URLs into an array
IFS=' ' read -r -a urls <<< "$target_urls"

# Iterate over each URL and test for the vulnerability
for url in "${urls[@]}"; do
    test_missing_security_headers "$url"
    echo ""
done
