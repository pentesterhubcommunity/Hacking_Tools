#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0"
    echo "Options:"
    echo "  -m METHOD    Specify HTTP method (default: POST)"
    exit 1
}

# Parse command-line options
while getopts ":m:" opt; do
    case ${opt} in
        m )
            METHOD=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Set default HTTP method if not specified
METHOD=${METHOD:-POST}

# Prompt user for target website URL
read -p "Enter your target website URL: " URL

# Check if URL is provided
if [ -z "$URL" ]; then
    echo "Error: Target website URL is required."
    exit 1
fi

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Example payloads for SSTI testing
payloads=(
    '{{7*7}}'
    '{{7*'7'}}'
    '${{7*7}}'
    '${{7*'7'}}'
    '{{7+7}}'
    '{{7+7}}'
    '{{7**7}}'
    '{{7**'7'}}'
    '{{7//7}}'
    '{{7//'7'}}'
)

# Send HTTP request with each payload and capture response
for payload in "${payloads[@]}"; do
    response=$(curl -s -X "$METHOD" "$URL" --data-urlencode "$payload")

    # Check if response contains any indicators of successful injection
    if [[ $response == *"[SSTI]"* ]]; then
        echo -e "${GREEN}Server-Side Template Injection vulnerability found with payload: $payload${NC}"
        echo -e "Response: $response"
    fi
done

echo "Testing completed."
