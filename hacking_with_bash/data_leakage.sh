#!/bin/bash

# Color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to test for data leakage vulnerability
test_data_leakage() {
    local target_url="$1"
    local vulnerable=false
    
    echo -e "${YELLOW}[+] Testing for Data Leakage Vulnerability${NC}"
    echo -e "${YELLOW}    - Performing various tests...${NC}"
    
    # Check for exposed directories
    echo -e "${GREEN}[+] Checking for exposed directories...${NC}"
    directories=("cgi-bin" "admin" "phpmyadmin" "wp-admin" ".git" "backup" "uploads" "temp")
    for dir in "${directories[@]}"; do
        if curl -sS --head "$target_url/$dir" | grep "200 OK" &> /dev/null; then
            echo -e "${RED}[!] Vulnerable directory found: $target_url/$dir${NC}"
            vulnerable=true
        fi
    done
    
    # Check for sensitive files
    echo -e "${GREEN}[+] Checking for sensitive files...${NC}"
    files=("config.php" "wp-config.php" ".env" ".gitignore" "database.yml")
    for file in "${files[@]}"; do
        if curl -sS --head "$target_url/$file" | grep "200 OK" &> /dev/null; then
            echo -e "${RED}[!] Sensitive file found: $target_url/$file${NC}"
            vulnerable=true
        fi
    done
    
    if [ "$vulnerable" = false ]; then
        echo -e "${GREEN}[+] No data leakage vulnerabilities detected.${NC}"
    fi
}

# Main function
main() {
    echo -e "${GREEN}== Data Leakage Vulnerability Tester ==${NC}"
    read -p "Enter your target website URL: " target_url
    echo -e "${GREEN}[+] Target website: ${target_url}${NC}"
    
    # Test for data leakage vulnerability
    test_data_leakage "$target_url"
    
    echo -e "${GREEN}[+] Testing complete.${NC}"
}

# Run the main function
main
