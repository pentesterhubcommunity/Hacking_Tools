#!/bin/bash

# Define colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to test CSP bypass
test_csp_bypass() {
    echo -e "${YELLOW}Testing Content Security Policy (CSP) Bypass...${NC}"
    target_url=$1
    # Send a request to the target URL
    curl_output=$(curl -s -I -X GET $target_url)
    # Check if the response headers contain Content-Security-Policy
    if [[ $curl_output == *"Content-Security-Policy"* ]]; then
        echo -e "${GREEN}The website's Content Security Policy (CSP) is enabled.${NC}"
        echo -e "${YELLOW}Testing for CSP bypass vulnerability...${NC}"
        # Attempt to inject a script tag and check if it's executed
        injected_output=$(curl -s -X GET $target_url"<script>alert('CSP Bypass Test')</script>")
        if [[ $injected_output == *"CSP Bypass Test"* ]]; then
            echo -e "${RED}The website is vulnerable to CSP bypass.${NC}"
            echo -e "${YELLOW}To test the vulnerability, try injecting a script tag and see if it's executed.${NC}"
        else
            echo -e "${GREEN}The website is not vulnerable to CSP bypass.${NC}"
        fi
    else
        echo -e "${RED}The website does not have Content Security Policy (CSP) enabled.${NC}"
    fi
}

# Main script starts here
echo -e "${GREEN}Welcome to CSP Bypass Tester!${NC}"
echo -e "${YELLOW}Please enter the target website URL:${NC}"
read target_website

# Test CSP bypass for the provided URL
test_csp_bypass $target_website
