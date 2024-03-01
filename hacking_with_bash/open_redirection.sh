#!/bin/bash

echo "Enter your target website link: "
read target_url

redirect_url="https://www.bbc.com"

# Send a request with the redirection URL
response=$(curl -s -L -o /dev/null -w "%{http_code} %{url_effective}" "$target_url?redirect=$redirect_url")

# Extract status code and effective URL from the response
status_code=$(echo "$response" | awk '{print $1}')
effective_url=$(echo "$response" | awk '{print $2}')

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the response status code indicates a successful redirection
if [[ "$status_code" -ge 300 && "$status_code" -lt 400 && "$effective_url" == "$redirect_url" ]]; then
  echo -e "${GREEN}Vulnerable: Open Redirection exists${NC}"
elif [[ "$status_code" -ge 300 && "$status_code" -lt 400 ]]; then
  echo -e "${RED}Potentially Vulnerable: Redirection occurred but not to the specified URL${NC}"
elif [[ "$status_code" -lt 200 || "$status_code" -ge 400 ]]; then
  echo -e "${RED}Not Vulnerable: HTTP request failed with status code $status_code${NC}"
else
  echo -e "${RED}Not Vulnerable: Redirection did not occur${NC}"
fi
