#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test for insecure file handling vulnerability
test_vulnerability() {
    local target_url="$1"
    local sensitive_files=("config.php" "database.conf" "credentials.txt")
    local vulnerable_files=()

    echo -e "${YELLOW}[+] Testing for insecure file handling vulnerability...${NC}"
    
    for file in "${sensitive_files[@]}"; do
        response_code=$(curl -s -o /dev/null -w "%{http_code}" "$target_url/$file")
        
        if [ "$response_code" -eq 200 ]; then
            echo -e "${RED}[!] Vulnerability Detected: $target_url/$file is accessible!${NC}"
            vulnerable_files+=("$file")
        else
            echo -e "${GREEN}[+] $target_url/$file is not accessible.${NC}"
        fi
    done

    if [ ${#vulnerable_files[@]} -eq 0 ]; then
        echo -e "${GREEN}[+] No insecure file handling vulnerabilities found.${NC}"
    else
        echo -e "${YELLOW}[!] Potential exploits:${NC}"
        for file in "${vulnerable_files[@]}"; do
            echo -e "${RED}[!] Exploit: Try accessing $target_url/$file directly through the browser.${NC}"
        done
    fi
}

# Main function
main() {
    echo -e "${YELLOW}[*] Welcome to Insecure File Handling Vulnerability Tester${NC}"
    read -p "Enter your target website URL: " target_website

    # Remove trailing slash if present
    target_website="${target_website%/}"

    test_vulnerability "$target_website"
}

# Call main function
main
