#!/bin/bash
# This is a comment

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check if the target website is reachable
check_website_reachable() {
    echo "Checking if the target website is reachable..."
    if output=$(curl -s -I "$1"); then
        echo "curl output: $output"
        echo -e "${GREEN}Website is reachable.${NC}"
    else
        echo -e "${RED}Website is not reachable. Please check the URL and try again.${NC}"
        exit 1
    fi
}

# Function to perform Misconfigured CORS Control detection
detect_misconfigured_cors() {
    echo "Detecting Misconfigured CORS Control..."
    # Send a request and analyze the response headers
    response_headers=$(curl -s -I "$1" $2)
    
    # Check for misconfigured CORS headers
    if grep -q 'Access-Control-Allow-Origin: \*' <<< "$response_headers" || grep -q 'Access-Control-Allow-Origin:' <<< "$response_headers"; then
        echo -e "${RED}Misconfigured CORS control detected: $1${NC}"
    else
        echo -e "${GREEN}No misconfigured CORS control detected.${NC}"
    fi
}

# Main function
main() {
    echo "Misconfigured CORS Control Detection Tool"
    echo "----------------------------------------"
    echo "Cross-Origin Resource Sharing (CORS) is a security mechanism that allows resources on a web page to be requested from another domain."
    echo "A misconfigured CORS policy can lead to potential security vulnerabilities by allowing unauthorized access to resources."
    echo "To manually check for CORS misconfiguration, you can use the following curl command:"
    echo "  curl -I <URL>"
    echo "For example:"
    echo "  curl -I https://example.com"
    echo ""

    # Prompt user for the target website link
    read -p "Enter your target website link: " target_url

    # Check if SSL certificate verification should be bypassed
    read -p "Bypass SSL certificate verification? (yes/no): " bypass_ssl_verification
    ssl_option=""
    if [[ $bypass_ssl_verification == "yes" ]]; then
        ssl_option="-k"
    fi

    # Check if the target website is reachable
    check_website_reachable "$target_url"

    # Perform Misconfigured CORS Control detection
    detect_misconfigured_cors "$target_url" "$ssl_option"
}

# Call main function
main
