#!/bin/bash

# Color variables
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prompt user for the target website link
echo -e "Enter your ${RED}target website link:${NC} "
read URL

# Extract parameter from the URL
PARAM=$(echo "$URL" | awk -F '[?]' '{print $2}' | awk -F '[=&]' '{print $1}')

# Check if the parameter is empty
if [ -z "$PARAM" ]; then
    echo -e "${RED}No parameter found in the URL.${NC}"
    exit 1
fi

# Submitting multiple parameters with the same name
curl -X POST "$URL" -d "$PARAM=value1" -d "$PARAM=value2" -d "$PARAM=value3"
