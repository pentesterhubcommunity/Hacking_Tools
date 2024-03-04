#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to test Cookie Theft vulnerability
test_cookie_theft() {
    # Extract cookies from the target website
    cookies=$(curl -s -i "$1" | grep -i 'Set-Cookie')

    # Check if cookies are vulnerable to theft
    if [[ -n "$cookies" ]]; then
        echo -e "${RED}Cookie Theft Vulnerability Detected!${NC}"
        echo -e "${YELLOW}Cookies Found:${NC}"
        echo "$cookies"
        echo -e "${GREEN}How to Test the Vulnerability:${NC}"
        echo -e "1. Visit the website and login."
        echo -e "2. Capture the cookies using a tool like Burp Suite or browser developer tools."
        echo -e "3. Use the stolen cookies to authenticate as the user without knowing their password."
    else
        echo -e "${GREEN}No Cookie Theft Vulnerability Detected.${NC}"
    fi
}

# Main function
main() {
    echo -e "${GREEN}-- Cookie Theft Vulnerability Tester --${NC}"
    echo -e "${YELLOW}Note: This script is for educational purposes only.${NC}"

    # Prompt for target website URL
    read -p "Enter the target website URL: " target_url

    # Check if the URL is valid
    if [[ ! "$target_url" =~ ^(http|https):// ]]; then
        echo -e "${RED}Invalid URL. Please enter a valid URL starting with http:// or https://.${NC}"
        exit 1
    fi

    echo -e "\n${GREEN}Testing for Cookie Theft Vulnerability...${NC}"
    test_cookie_theft "$target_url"
}

# Execute main function
main
