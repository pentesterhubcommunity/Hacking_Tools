#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if required tools are installed
check_dependencies() {
    local dependencies=("subfinder" "amass" "assetfinder" "parallel")
    for tool in "${dependencies[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}$tool is not installed. Please install it first.${NC}"
            exit 1
        fi
    done
}

# Prompt user for target domain
prompt_target_domain() {
    read -p "$(echo -e ${GREEN}"Enter your target domain: "${NC})" domain
}

# Main function
main() {
    check_dependencies
    prompt_target_domain

    echo -e "${GREEN}Target domain: $domain${NC}"

    # Perform subdomain enumeration tasks in parallel
    echo -e "${YELLOW}Enumerating subdomains for $domain using subfinder ...${NC}"
    subfinder -d "$domain" -o subdomains_subfinder.txt &

    echo -e "${YELLOW}Enumerating subdomains for $domain using amass ...${NC}"
    amass enum -d "$domain" -o subdomains_amass.txt &

    echo -e "${YELLOW}Enumerating subdomains for $domain using assetfinder ...${NC}"
    assetfinder "$domain" > subdomains_assetfinder.txt &

    wait

    echo -e "${GREEN}Subdomain enumeration completed.${NC}"
}

# Execute main function
main
