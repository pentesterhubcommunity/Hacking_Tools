#!/bin/bash

# Colors for formatting output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if the target website is vulnerable to CSTI
check_vulnerability() {
    local target_url="$1"

    echo -e "${YELLOW}[+] Checking for Client-Side Template Injection vulnerability...${NC}"

    # Send a request to the target URL and analyze the response
    local response=$(curl -s -i "$target_url")

    # Check if the response contains signs of CSTI vulnerability
    if [[ $response =~ "{{" ]]; then
        echo -e "${RED}[!] The target website is potentially vulnerable to Client-Side Template Injection.${NC}"
        # Additional checks or analysis can be performed here
        # For example, analyzing JavaScript files for potential injection points
        # This could involve parsing HTML and JavaScript content for known injection patterns
        # For demonstration purposes, let's assume a simple check for JavaScript files
        check_js_files "$target_url"
    else
        echo -e "${GREEN}[*] The target website is not vulnerable to Client-Side Template Injection.${NC}"
    fi
}

# Function to check JavaScript files for potential injection points
check_js_files() {
    local target_url="$1"

    echo -e "${YELLOW}[+] Checking JavaScript files for potential injection points...${NC}"
    
    # Extract JavaScript file URLs from the target website
    local js_files=$(curl -s "$target_url" | grep -oP '(?<=src=")[^"]+\.js')

    # Check each JavaScript file for known injection patterns
    for js_file in $js_files; do
        local js_content=$(curl -s "$target_url/$js_file")
        if [[ $js_content =~ "{{" ]]; then
            echo -e "${RED}[!] Potential injection point found in JavaScript file: $js_file.${NC}"
            echo -e "${YELLOW}[*] Further manual analysis may be required.${NC}"
        fi
    done
}

# Function to demonstrate how to test the vulnerability
demonstrate_testing() {
    echo -e "${YELLOW}[+] Demonstrating how to test the vulnerability...${NC}"
    
    # This is where you would demonstrate how to exploit the CSTI vulnerability
    # For demonstration purposes, let's assume the exploitation involves injecting a payload into a form field
    echo -e "${GREEN}[*] To test the vulnerability, try injecting {{7*7}} into a form field.${NC}"
}

# Main function
main() {
    # Prompt user for the target website URL
    read -p "Enter your target website URL: " target_url
    
    echo -e "${GREEN}[*] Testing for Client-Side Template Injection vulnerability on $target_url...${NC}"
    
    # Check for vulnerability
    check_vulnerability "$target_url"
    
    # Demonstrate how to test the vulnerability
    demonstrate_testing
}

# Call the main function
main
