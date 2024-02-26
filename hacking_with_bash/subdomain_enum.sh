#!/bin/bash
# This is a comment
rm valid-subdomain.txt
# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to simulate Sub-domain Enumeration
simulate_subdomain_enumeration() {
    echo "Simulating Sub-domain Enumeration..."
    read -p "Enter your target website link: " target_link
    # Extract domain from the link
    target_domain=$(echo "$target_link" | awk -F[/:] '{print $4}')
    
    # Technique 1: DNS queries for common sub-domains
    dns_enum "$target_domain"
    
    # Technique 2: Web crawling for sub-domains
    web_crawl "$target_domain"
}

# Function for DNS enumeration of common sub-domains
dns_enum() {
    domain="$1"
    echo "Performing DNS enumeration for common sub-domains of $domain..."
    # Example: Perform DNS queries for common sub-domains
    # Replace this with actual commands or tools for DNS enumeration
    # For demonstration, we'll use dig command for basic enumeration
    subdomains=$(dig +short -t A www.$domain; dig +short -t A mail.$domain)
    validate_subdomains "$subdomains"
}

# Function for web crawling to discover sub-domains
web_crawl() {
    domain="$1"
    echo "Performing web crawling to discover sub-domains of $domain..."
    # Example: Use web crawling tools like Sublist3r, Amass, or Subfinder
    # Replace this with actual commands or tools for web crawling
    # For demonstration, we'll assume a basic web crawling technique
    subdomains=$(curl -s "https://crt.sh/?q=%.$domain" | grep -oE "(\w+\.\w+\.\w+)" | sort -u)
    validate_subdomains "$subdomains"
}

# Function to validate sub-domains and save valid subdomains to a file
validate_subdomains() {
    subdomains="$1"
    echo "Validating sub-domains..."
    while IFS= read -r subdomain; do
        if dig +short "$subdomain" | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
            echo -e "${GREEN}Valid subdomain found: $subdomain${NC}"
            echo "$subdomain" >> valid-subdomain.txt
        fi
    done <<< "$subdomains"
}

# Main function
main() {
    echo "Sub-domain Enumeration Tool"
    echo "--------------------------"

    # Perform Sub-domain Enumeration
    simulate_subdomain_enumeration
}

# Call main function
main
echo -e "\e[33m=============================\e[0m"
echo ""
echo -e "\e[32mValid Sub-domains are:\e[0m"
echo ""
echo -e "\e[33m=============================\e[0m"
echo ""
cat valid-subdomain.txt
echo ""
echo -e "\e[33m=============================\e[0m"
