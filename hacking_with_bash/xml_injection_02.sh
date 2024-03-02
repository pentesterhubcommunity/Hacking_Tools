#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to send HTTP requests and display response
send_request() {
    local url="$1"
    local payload="$2"
    local method="$3"
    local content_type="$4"
    local timeout="$5"

    if [ "$method" == "GET" ]; then
        curl -s -X GET "$url$payload" -H "Content-Type: $content_type" --connect-timeout "$timeout" -o response.txt -D headers.txt
    elif [ "$method" == "POST" ]; then
        curl -s -X POST "$url" -H "Content-Type: $content_type" -d "$payload" --connect-timeout "$timeout" -o response.txt -D headers.txt
    else
        echo "Invalid method specified."
        exit 1
    fi
}

# Function to check if response contains signs of successful injection
check_response() {
    local success_string="$1"

    if grep -q "$success_string" response.txt; then
        echo -e "${GREEN}Vulnerability found: XML Injection successful!${NC}"
    else
        echo -e "${YELLOW}No vulnerability found.${NC}"
    fi
}

# Main function
main() {
    local url="$1"
    local content_type="$2"
    local payloads=("${@:3}")
    local success_string="$4"
    local timeout=10

    echo -e "${YELLOW}Testing for XML Injection vulnerability on $url...${NC}"

    for payload in "${payloads[@]}"; do
        method="GET"
        if [[ "$payload" == *"<"* ]]; then
            method="POST"
        fi

        send_request "$url" "$payload" "$method" "$content_type" "$timeout"
        echo -e "Payload: ${YELLOW}$payload${NC}"
        echo -e "HTTP Request Headers:"
        cat headers.txt
        echo -e "HTTP Response Headers:"
        cat headers.txt
        echo -e "Response Content:"
        cat response.txt
        check_response "$success_string"
        echo "----------------------------------"
    done
}

# Prompt user for target website URL
read -p "Enter your target website URL: " target_url

# Validate URL format
if [[ ! "$target_url" =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,} ]]; then
    echo -e "${RED}Invalid URL format. Please enter a valid URL starting with http:// or https://.${NC}"
    exit 1
fi

# Example usage: ./xml_injection_test.sh "http://example.com/page.php" "application/xml" "<user><name>John</name><password>123456</password></user>" "Injection Successful"
# Parameters: URL, Content-Type, Payloads (multiple), Success string in the response indicating successful injection

# Uncomment the following line and provide necessary inputs to run the test
main "$target_url" "$2" "${@:3}" "$5"
