#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to parse parameters from the URL
parse_parameters() {
    target_url="$1"
    
    # Extract parameters from the URL
    parameters=$(echo "$target_url" | grep -oP '\?.*')
    
    echo "$parameters"
}

# Function to perform WAF evasion test
perform_waf_evasion_test() {
    target_url="$1"
    parameters="$2"
    
    echo -e "${YELLOW}Performing WAF evasion test on: ${target_url}${NC}"
    
    # 1. Use Different HTTP Methods
    echo -e "${YELLOW}Testing different HTTP methods...${NC}"
    curl -X POST "${target_url}" 2>/dev/null
    
    # 2. Obfuscate Payloads
    echo -e "${YELLOW}Obfuscating payloads...${NC}"
    curl -X GET "${target_url}${parameters}" 2>/dev/null
    
    # 3. Use Alternate Encodings
    echo -e "${YELLOW}Testing alternate encodings...${NC}"
    curl -X GET "${target_url}${parameters}" 2>/dev/null
    
    # 4. HTTP Parameter Pollution (HPP)
    echo -e "${YELLOW}Testing HTTP parameter pollution...${NC}"
    curl -X GET "${target_url}?param=value&param=value${parameters}" 2>/dev/null
    
    # Insert more techniques as needed
    
    # For demonstration purposes, let's assume it's vulnerable
    vulnerable=true
    
    if [ "$vulnerable" = true ]; then
        echo -e "${RED}The target website may be vulnerable to WAF evasion.${NC}"
        echo -e "${YELLOW}To test the vulnerability further, try using other WAF evasion techniques.${NC}"
    else
        echo -e "${GREEN}The target website does not appear to be vulnerable to WAF evasion.${NC}"
    fi
}

# Main function
main() {
    echo -e "${GREEN}Welcome to the WAF Evasion Tester${NC}"
    read -p "Enter your target website url: " target_url
    
    # Parse parameters from the URL
    parameters=$(parse_parameters "$target_url")
    
    perform_waf_evasion_test "$target_url" "$parameters"
}

# Execute main function
main
