#!/bin/bash
# This is a comment

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform HTTP Security Headers Misconfiguration detection
detect_http_security_headers_misconfig() {
    echo "Detecting HTTP Security Headers Misconfiguration..."
    echo "Sending a request to $1 and analyzing response headers..."
    # Send a request and analyze the response headers
    response_headers=$(curl -s -I "$1")
    
    # Check for misconfigured security headers
    if grep -q 'X-XSS-Protection: 0' <<< "$response_headers"; then
        echo -e "${RED}X-XSS-Protection Header misconfiguration detected: $1${NC}"
        echo -e "${YELLOW}Suggested Action: Enable XSS Protection by setting X-XSS-Protection header.${NC}"
    fi
    
    if grep -q 'X-Frame-Options: DENY' <<< "$response_headers"; then
        echo -e "${RED}X-Frame-Options Header misconfiguration detected: $1${NC}"
        echo -e "${YELLOW}Suggested Action: Set X-Frame-Options header to DENY to prevent Clickjacking.${NC}"
    fi
    
    if grep -q 'X-Content-Type-Options: nosniff' <<< "$response_headers"; then
        echo -e "${RED}X-Content-Type-Options Header misconfiguration detected: $1${NC}"
        echo -e "${YELLOW}Suggested Action: Enable MIME sniffing protection by setting X-Content-Type-Options header to nosniff.${NC}"
    fi
    
    if grep -q 'Content-Security-Policy:' <<< "$response_headers"; then
        echo -e "${RED}Content-Security-Policy Header misconfiguration detected: $1${NC}"
        echo -e "${YELLOW}Suggested Action: Implement a Content Security Policy to mitigate XSS and other code injection attacks.${NC}"
    fi
    
    if ! grep -q 'X-XSS-Protection: 0' <<< "$response_headers" && \
        ! grep -q 'X-Frame-Options: DENY' <<< "$response_headers" && \
        ! grep -q 'X-Content-Type-Options: nosniff' <<< "$response_headers" && \
        ! grep -q 'Content-Security-Policy:' <<< "$response_headers"; then
        echo -e "${GREEN}No HTTP Security Headers misconfiguration detected.${NC}"
    fi
}


# Function to check for SSL/TLS configuration
check_ssl_tls_config() {
    echo "Checking SSL/TLS Configuration..."
    echo "Establishing SSL/TLS connection to $1 and examining certificate details..."
    # Check SSL/TLS configuration by examining certificate details
    ssl_info=$(openssl s_client -connect "$1" </dev/null 2>/dev/null | openssl x509 -noout -text)
    if grep -q 'Signature Algorithm: sha1' <<< "$ssl_info"; then
        echo -e "${RED}Weak SSL/TLS configuration detected: $1${NC}"
        echo -e "${YELLOW}Suggested Action: Upgrade to a stronger SSL/TLS configuration (e.g., SHA-256).${NC}"
    else
        echo -e "${GREEN}SSL/TLS configuration is strong.${NC}"
    fi
}


# Function to check for vulnerable services
check_vulnerable_services() {
    echo "Checking for Vulnerable Services..."
    echo "Scanning $1 for open ports and services using nmap..."
    # Check for vulnerable services by scanning for open ports
    nmap_output=$(nmap -p- "$1" 2>/dev/null)
    if echo "$nmap_output" | grep -q 'open'; then
        echo -e "${RED}Vulnerable services detected on $1:${NC}"
        echo "$nmap_output"
        echo -e "${YELLOW}Suggested Action: Further investigate the detected open ports for vulnerabilities.${NC}"
    else
        echo -e "${GREEN}No vulnerable services detected.${NC}"
    fi
}


# Main function
main() {
    echo "Security Assessment Tool"
    echo "------------------------"

    # Prompt for target website link
    read -p "Enter your target website link: " target_url

    # Execute each security check automatically
    detect_http_security_headers_misconfig "$target_url"
    check_ssl_tls_config "$target_url"
    check_vulnerable_services "$target_url"
}

# Call main function
main
