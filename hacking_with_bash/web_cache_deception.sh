#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to send HTTP requests and check responses
function test_cache_deception {
    local url="$1"
    local cache_header="$2"
    
    # Send HTTP request with the specified Cache-Control header
    response=$(curl -s -I -X GET -H "Cache-Control: $cache_header" --max-time 10 "$url")
    local exit_code=$?

    # Check if curl command was successful
    if [[ $exit_code -ne 0 ]]; then
        echo -e "${RED}Error: Failed to send HTTP request for cache header: $cache_header${NC}"
        return
    fi
    
    # Check if the response indicates a cache hit or miss
    if [[ $response == *"X-Cache: Miss from"* ]]; then
        echo -e "${GREEN}Cache MISS: $cache_header${NC}"
    elif [[ $response == *"X-Cache: Hit from"* ]]; then
        echo -e "${RED}Cache HIT: $cache_header${NC}"
    else
        echo -e "${RED}Unable to determine cache status for: $cache_header${NC}"
    fi
    
    # Print response headers for further analysis
    echo -e "Response Headers:"
    echo -e "$response"
    echo -e "-----------------------------------------"
}

echo -e "Web Cache Deception Testing Tool"
echo -e "------------------------------"

# Prompt user to enter the target website URL
read -p "Enter your target website URL: " TARGET_URL

echo -e "Testing Web Cache Deception for $TARGET_URL..."

# Define cache control headers to test
CACHE_HEADERS=("no-store" "no-cache" "max-age=0" "max-age=0, no-cache" "max-age=0, no-store, must-revalidate" "public, s-maxage=0")

# Test each cache control header concurrently
for header in "${CACHE_HEADERS[@]}"; do
    test_cache_deception "$TARGET_URL" "$header" &
done

# Wait for all tests to complete
wait

echo -e "Web Cache Deception testing complete."
