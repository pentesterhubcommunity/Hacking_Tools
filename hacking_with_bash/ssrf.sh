#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Prompt for the target website URL
echo -e "${GREEN}Enter your target website URL:${NC}"
read url

# Attacker-controlled URL
attacker_controlled_url="https://www.bbc.com"

# Replace the vulnerable parameter with the attacker-controlled URL
final_url="${url}?param=${attacker_controlled_url}"

# Send a request and observe the response
echo -e "${GREEN}Sending request to:${NC} ${final_url}"
response=$(curl -i $final_url 2>&1)

# Check if request was successful
if [[ $response == *"200 OK"* ]]; then
    echo -e "${GREEN}Request successful! Response:${NC}\n$response"
else
    echo -e "${RED}Request failed:${NC}\n$response"
fi
