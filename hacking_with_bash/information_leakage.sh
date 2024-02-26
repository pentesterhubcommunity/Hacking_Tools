#!/bin/bash
# This is a comment

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform directory bruteforcing using Gobuster
bruteforce_directories_gobuster() {
    echo -e "${YELLOW}Bruteforcing directories with Gobuster...${NC}"
    # Use Gobuster with aggressive options to brute force directories
    gobuster dir -u "$1" -w /usr/share/wordlists/dirb/common.txt -t 50 -o gobuster_results.txt -x php,html,txt --status-codes-blacklist "404"
}

# Function to perform directory bruteforcing using Dirsearch
bruteforce_directories_dirsearch() {
    echo -e "${YELLOW}Bruteforcing directories with Dirsearch...${NC}"
    # Use Dirsearch to recursively search for directories
    python -W ignore /usr/lib/python3/dist-packages/dirsearch/dirsearch.py -u "$1" -w /usr/share/wordlists/dirb/common.txt -t 50 -o dirsearch_results.txt -x "403,404,500"
}

# Function to perform directory bruteforcing using WFuzz
bruteforce_directories_wfuzz() {
    echo -e "${YELLOW}Bruteforcing directories with WFuzz...${NC}"
    # Use WFuzz to brute force directories
    wfuzz -c -z file,/usr/share/wordlists/dirb/common.txt -t 50 "$1/FUZZ" > wfuzz_results.txt
}

# Function to perform Data Leakage detection
detect_data_leakage() {
    echo -e "${YELLOW}Detecting Data Leakage in $1...${NC}"
    # Scan files for sensitive information using regex patterns
    sensitive_info=$(grep -E -r '\b[0-9]{16}\b|\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b|\bpassword\b' "$1")
    if [ -n "$sensitive_info" ]; then
        echo -e "${RED}Potential data leakage detected in $1:${NC}"
        echo "$sensitive_info"
    else
        echo -e "${GREEN}No potential data leakage detected in $1.${NC}"
    fi
}

# Main function
main() {
    echo -e "${YELLOW}Data Leakage Detection Tool${NC}"
    echo "----------------------------"

    # Prompt user to enter target website
    read -p "Enter your target website: " target_website

    # Perform directory bruteforcing with Gobuster
    bruteforce_directories_gobuster "$target_website"

    # Perform directory bruteforcing with Dirsearch
    bruteforce_directories_dirsearch "$target_website"

    # Perform directory bruteforcing with WFuzz
    bruteforce_directories_wfuzz "$target_website"

    # Perform Data Leakage detection
    detect_data_leakage "discovered_directories/"
}

# Call main function
main
