#!/bin/bash

# Define colors for better visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a header is present
check_header() {
    header="$1"
    website="$2"
    echo -e "${YELLOW}[+] Checking $header header...${NC}"
    response=$(curl -s -I "$website" | grep -i "$header")
    if [ -z "$response" ]; then
        echo -e "${RED}[!] $header header is missing!${NC}"
    else
        echo -e "${GREEN}[✓] $header header is present.${NC}"
    fi
}

# Function to exploit identified vulnerabilities
exploit_vulnerabilities() {
    website="$1"
    echo -e "${YELLOW}[+] Attempting to exploit identified vulnerabilities...${NC}"
    
    # Exploit techniques
    # Technique 1: Clickjacking via X-Frame-Options
    response=$(curl -s -I "$website" | grep -i "X-Frame-Options: SAMEORIGIN")
    if [ -z "$response" ]; then
        echo -e "${GREEN}[✓] X-Frame-Options is not set to SAMEORIGIN, potential clickjacking vulnerability.${NC}"
        echo -e "${YELLOW}[!] To test this vulnerability, try embedding the target website in an iframe:${NC}"
        echo -e "${YELLOW}    <iframe src='$website' width='800' height='600'></iframe>${NC}"
    fi
    
    # Technique 2: XSS via X-XSS-Protection
    response=$(curl -s -I "$website" | grep -i "X-XSS-Protection: 0")
    if [ -z "$response" ]; then
        echo -e "${GREEN}[✓] X-XSS-Protection header is not set to 0, potential XSS vulnerability.${NC}"
        echo -e "${YELLOW}[!] To test this vulnerability, try injecting a XSS payload in input fields:${NC}"
        echo -e "${YELLOW}    <script>alert('XSS');</script>${NC}"
    fi
    
    # Technique 3: MIME-sniffing via X-Content-Type-Options
    response=$(curl -s -I "$website" | grep -i "X-Content-Type-Options: nosniff")
    if [ -z "$response" ]; then
        echo -e "${GREEN}[✓] X-Content-Type-Options is not set to nosniff, potential MIME-sniffing vulnerability.${NC}"
        echo -e "${YELLOW}[!] To test this vulnerability, try uploading a file with incorrect MIME type:${NC}"
        echo -e "${YELLOW}    Upload a file with .txt extension containing HTML/JavaScript content.${NC}"
    fi
    
    # Technique 4: CSP Bypass via Content-Security-Policy
    response=$(curl -s -I "$website" | grep -i "Content-Security-Policy:.*unsafe-inline")
    if [ -z "$response" ]; then
        echo -e "${GREEN}[✓] Content-Security-Policy does not restrict 'unsafe-inline', potential CSP bypass vulnerability.${NC}"
        echo -e "${YELLOW}[!] To test this vulnerability, try injecting inline JavaScript in the website:${NC}"
        echo -e "${YELLOW}    <script>alert('CSP Bypass');</script>${NC}"
    fi
    
    # Technique 5: HTTP Public Key Pinning (HPKP) bypass
    response=$(curl -s -I "$website" | grep -i "Public-Key-Pins")
    if [ -z "$response" ]; then
        echo -e "${GREEN}[✓] Public-Key-Pins header is missing, potential HPKP bypass vulnerability.${NC}"
        echo -e "${YELLOW}[!] To test this vulnerability, try accessing the website using a different domain with a forged certificate:${NC}"
        echo -e "${YELLOW}    Example: curl -H 'Host: forgeddomain.com' $website${NC}"
    fi
    
    # Add more exploit techniques as needed
    
    echo -e "${GREEN}[✓] Exploitation attempt complete.${NC}"
}

# Main function
main() {
    echo -e "${YELLOW}[+] Welcome to HTTP Security Headers Misconfiguration Vulnerability Tester${NC}"
    read -p "Enter your target website URL: " website
    echo -e "${YELLOW}[+] Testing security headers for $website${NC}"
    
    # Check for security headers
    check_header "Strict-Transport-Security" "$website"
    check_header "X-Frame-Options" "$website"
    check_header "X-XSS-Protection" "$website"
    check_header "X-Content-Type-Options" "$website"
    check_header "Content-Security-Policy" "$website"
    check_header "Referrer-Policy" "$website"
    check_header "Feature-Policy" "$website"
    check_header "Expect-CT" "$website"
    check_header "X-Permitted-Cross-Domain-Policies" "$website"
    check_header "Public-Key-Pins" "$website"

    # Attempt to exploit identified vulnerabilities
    exploit_vulnerabilities "$website"
}

# Run the main function
main
