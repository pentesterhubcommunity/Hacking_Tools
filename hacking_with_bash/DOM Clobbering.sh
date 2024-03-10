#!/bin/bash

# Colors for formatting output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Welcome to DOM Clobbering Vulnerability Tester${NC}"
echo "---------------------------------------------"

# Prompt user for target website URL
read -p "Enter your target website URL: " TARGET_URL

echo "Testing for DOM Clobbering vulnerability on $TARGET_URL..."

# Fetch the target website content
echo "Fetching website content..."
WEBSITE_CONTENT=$(curl -s $TARGET_URL)

# Check for signs of DOM Clobbering vulnerability
if [[ $WEBSITE_CONTENT == *"<script>"* && $WEBSITE_CONTENT == *".body"* ]]; then
    echo -e "${RED}The target website may be vulnerable to DOM Clobbering.${NC}"
    echo "You can test the vulnerability by injecting JavaScript code to modify the DOM."
    echo "For example, inject the following code in the browser console:"
    echo "document.body = 'Hacked!';"
else
    echo -e "${GREEN}The target website does not appear to be vulnerable to DOM Clobbering.${NC}"
fi

# Show verbose output for debugging
echo "Verbose output:"
echo "$WEBSITE_CONTENT"
