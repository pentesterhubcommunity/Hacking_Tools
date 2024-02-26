#!/bin/bash
# This is a comment

# Define color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to perform Missing Security Headers detection
detect_missing_security_headers() {
    echo "Detecting Missing Security Headers..."
    # Send a request and analyze the response headers
    response=$(curl -s -i "$1")
    response_code=$(echo "$response" | head -n 1 | awk '{print $2}')
    response_headers=$(echo "$response" | sed '1,/\r\?$/d')
    response_content=$(echo "$response" | sed -n '/^\r\?$/,$p' | tail -n +2)

    # Check for missing security headers
    missing_headers=""
    if ! grep -q 'Content-Security-Policy' <<< "$response_headers"; then
        missing_headers+="Content-Security-Policy "
        echo -e "${RED}Missing Content-Security-Policy header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Inject the payload <script>alert('XSS')</script> into input fields or parameters that reflect user-controlled data and observe if the XSS payload gets executed."
        echo
    fi
    if ! grep -q 'X-Content-Type-Options' <<< "$response_headers"; then
        missing_headers+="X-Content-Type-Options "
        echo -e "${RED}Missing X-Content-Type-Options header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Upload a file with the extension .html but with the content-type image/png. Access the uploaded file and check if the browser interprets it as HTML and executes any scripts within the file."
        echo
    fi
    if ! grep -q 'X-Frame-Options' <<< "$response_headers"; then
        missing_headers+="X-Frame-Options "
        echo -e "${RED}Missing X-Frame-Options header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Create an attacker-controlled HTML page (attacker.html) containing an iframe. Set the src attribute of the iframe to the target website's URL. Open attacker.html in a browser and observe if the target website is embedded within the iframe without any restrictions."
        echo
    fi
    if ! grep -q 'X-XSS-Protection' <<< "$response_headers"; then
        missing_headers+="X-XSS-Protection "
        echo -e "${RED}Missing X-XSS-Protection header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Inject XSS payloads into input fields or parameters similar to testing for CSP vulnerabilities. For example, inject the payload <script>alert('XSS')</script> into input fields and observe if the XSS payload gets executed."
        echo
    fi
    if ! grep -q 'Strict-Transport-Security' <<< "$response_headers"; then
        missing_headers+="Strict-Transport-Security "
        echo -e "${RED}Missing Strict-Transport-Security header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Ensure the website is accessed over HTTPS. If not, try accessing the website over HTTP and observe if it redirects to HTTPS."
        echo
    fi
    if ! grep -q 'X-Content-Security-Policy' <<< "$response_headers"; then
        missing_headers+="X-Content-Security-Policy "
        echo -e "${RED}Missing X-Content-Security-Policy header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Similar to testing for Content-Security-Policy (CSP), inject XSS payloads and observe if they get executed."
        echo
    fi
    if ! grep -q 'Referrer-Policy' <<< "$response_headers"; then
        missing_headers+="Referrer-Policy "
        echo -e "${RED}Missing Referrer-Policy header.${NC}"
        echo -e "${YELLOW}URL:${NC} $1"
        echo -e "${YELLOW}How to Test:${NC} Navigate from one page to another within the website and observe if the referrer header is sent. If sent, check if it contains sensitive information."
        echo
    fi
    
    if [ -z "$missing_headers" ]; then
        echo -e "${GREEN}No missing security headers detected.${NC}"
    fi

    # Analyze response content
    echo -e "${YELLOW}Response Code:${NC} $response_code"
    echo -e "${YELLOW}Response Content:${NC}"
    echo "$response_content"
}

# Main function
main() {
    echo -e "${GREEN}Missing Security Headers Detection Tool${NC}"
    echo "---------------------------------------"

    # Prompt the user to enter the target website link
    read -p "Enter your target website link: " target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}URL cannot be empty.${NC}"
        exit 1
    fi

    # Perform Missing Security Headers detection
    detect_missing_security_headers "$target_url"
}

# Call main function
main
