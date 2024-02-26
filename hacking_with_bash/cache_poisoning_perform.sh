#!/bin/bash
# This is a comment

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to perform Browser Cache Poisoning
perform_browser_cache_poisoning() {
    echo -e "${GREEN}Performing Browser Cache Poisoning for $target_website...${NC}"
    # Check if Nginx configuration file exists
    if [ -f "/etc/nginx/nginx.conf" ]; then
        # Inject cache poisoning headers into the Nginx configuration file
        # Example: Adding "Cache-Control: no-cache" header to all responses
        sudo sed -i 's|^\(\s*\)#\?\(.*\)\(expires\s\+\).*|\1\2\3|g' /etc/nginx/nginx.conf
        echo -e "${GREEN}Cache poisoning headers injected successfully.${NC}"
    else
        echo -e "${RED}Error: Nginx configuration file not found.${NC}"
        exit 1
    fi
}

# Function to suggest testing for cache poisoning vulnerabilities
suggest_testing() {
    echo -e "${GREEN}Suggestions for Testing Cache Poisoning Vulnerabilities:${NC}"
    echo "1. Use a web browser to visit the target website and observe if the expected caching behavior changes."
    echo "   Example: Visit $target_website in a web browser, navigate through different pages, and check if content is reloaded instead of being served from cache."
    echo "2. Send HTTP requests to the target website using tools like cURL or Postman, and inspect the response headers to see if cache control directives are present."
    echo "   Example: Use cURL to send a request to $target_website and examine the 'Cache-Control' header in the response."
    echo "   Example Command: curl -I $target_website"
    echo "3. Perform security scanning and testing using specialized tools like OWASP ZAP or Burp Suite, which can help identify and exploit cache poisoning vulnerabilities."
    echo "   Example: Use OWASP ZAP to intercept and manipulate HTTP requests and responses, injecting cache poisoning payloads."
}

# Function to test for cache poisoning vulnerability
test_cache_poisoning_vulnerability() {
    echo -e "${GREEN}Testing for Cache Poisoning Vulnerability...${NC}"
    
    # Test 1: Use cURL to send a request and check cache control directives
    echo -e "${GREEN}Test 1: Sending HTTP request to $target_website and inspecting response headers...${NC}"
    response_headers=$(curl -I $target_website)
    if echo "$response_headers" | grep -qiE 'Cache-Control:.*no-cache'; then
        echo -e "${GREEN}Cache poisoning vulnerability detected!${NC}"
        echo -e "${GREEN}Proof: The 'Cache-Control' header contains 'no-cache' directive.${NC}"
    else
        echo -e "${RED}No cache poisoning vulnerability detected.${NC}"
    fi

    # Test 2: Visit the website in a web browser and observe caching behavior
    echo -e "${GREEN}Test 2: Please visit $target_website in a web browser and observe caching behavior.${NC}"
    echo -e "${GREEN}If content is reloaded instead of being served from cache, it indicates a potential cache poisoning vulnerability.${NC}"
}

# Main function
main() {
    echo -e "${GREEN}Browser Cache Poisoning Tool${NC}"
    echo "--------------------------------------"

    # Ask for target website link
    read -p "Enter your target website link: " target_website

    # Perform basic validation of the target website link
    if [ -z "$target_website" ]; then
        echo -e "${RED}Error: Target website link cannot be empty.${NC}"
        exit 1
    fi

    # Perform Browser Cache Poisoning
    perform_browser_cache_poisoning

    # Suggest testing for cache poisoning vulnerabilities
    suggest_testing

    # Test for cache poisoning vulnerability
    test_cache_poisoning_vulnerability
}

# Call main function
main
