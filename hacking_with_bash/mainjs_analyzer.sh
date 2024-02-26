#!/bin/bash
# This is a comment
rm main.js
# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to simulate Main.js File Analyzer
simulate_main_js_analyzer() {
    echo -e "${GREEN}Simulating Main.js File Analyzer...${NC}"
    
    # Prompt user for the target website link
    read -p "$(echo -e "${YELLOW}Enter your target website link: ${NC}")" target_website
    
    # Download the main.js file from the target website
    download_main_js "$target_website"
    
    # Analyze the main.js file for sensitive information
    analyze_main_js
}

# Function to download the main.js file from a website
download_main_js() {
    website="$1"
    echo -e "${GREEN}Downloading main.js from ${BLUE}$website${NC}..."
    # Use curl to download the main.js file
    curl -s -o main.js "$website/main.js"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Download ${BLUE}successful${NC}"
    else
        echo -e "${RED}Download ${BLUE}failed${NC}"
        exit 1
    fi
}

# Function to analyze the main.js file for sensitive information
analyze_main_js() {
    echo -e "${GREEN}Analyzing main.js for sensitive information...${NC}"
    # Check for sensitive information in the main.js file
    # Example: Search for API keys, endpoints, and configuration details
    local sensitive_info=""
    sensitive_info+="$(search_api_keys)"
    sensitive_info+="$(search_endpoints)"
    sensitive_info+="$(search_configuration)"
    sensitive_info+="$(search_files)"
    sensitive_info+="$(search_links)"
    sensitive_info+="$(search_paths)"
    sensitive_info+="$(search_urls)"
    
    if [ -n "$sensitive_info" ]; then
        echo -e "\n${GREEN}Sensitive Information Found:${NC}"
        echo -e "${RED}$sensitive_info${NC}"
        echo -e "${YELLOW}Please verify the found sensitive information and take necessary actions.${NC}"
    else
        echo -e "${GREEN}No sensitive information found.${NC}"
    fi
}

# Function to search for API keys
search_api_keys() {
    local api_keys=$(grep -nE 'API_KEY|apiKey|APIKEY' main.js)
    if [ -n "$api_keys" ]; then
        echo -e "${GREEN}API Keys Found:${NC}\n$api_keys\n"
        echo -e "${YELLOW}To verify the found API keys, you can check if they are valid by attempting to use them against the respective API.${NC}"
    fi
}

# Function to search for endpoints
search_endpoints() {
    local endpoints=$(grep -nE 'ENDPOINT|endpoint' main.js)
    if [ -n "$endpoints" ]; then
        echo -e "${GREEN}Endpoints Found:${NC}\n$endpoints\n"
        echo -e "${YELLOW}To verify the found endpoints, you can attempt to access them or check their validity against the API documentation.${NC}"
    fi
}

# Function to search for configuration details
search_configuration() {
    local config_details=$(grep -nE 'CONFIG|config' main.js)
    if [ -n "$config_details" ]; then
        echo -e "${GREEN}Configuration Details Found:${NC}\n$config_details\n"
        echo -e "${YELLOW}To verify the found configuration details, you can review the related code or documentation.${NC}"
    fi
}

# Function to search for interesting files
search_files() {
    local interesting_files=$(grep -nE '\.pdf|\.doc|\.xls|\.xlsx|\.ppt|\.pptx' main.js)
    if [ -n "$interesting_files" ]; then
        echo -e "${GREEN}Interesting Files Found:${NC}\n$interesting_files\n"
        echo -e "${YELLOW}To verify the found files, you can review their contents or assess their relevance to the application.${NC}"
    fi
}

# Function to search for links
search_links() {
    local links=$(grep -nE 'http[s]?://[^ >]+' main.js)
    if [ -n "$links" ]; then
        echo -e "${GREEN}Links Found:${NC}\n$links\n"
        echo -e "${YELLOW}To verify the found links, you can visit them to determine their destination.${NC}"
    fi
}

# Function to search for interesting paths
search_paths() {
    local paths=$(grep -nE '/[^ ]+' main.js)
    if [ -n "$paths" ]; then
        echo -e "${GREEN}Paths Found:${NC}\n$paths\n"
        echo -e "${YELLOW}To verify the found paths, you can explore them to understand their relevance.${NC}"
    fi
}

# Function to search for URLs
search_urls() {
    local urls=$(grep -nE 'http[s]?://[^ ]+' main.js)
    if [ -n "$urls" ]; then
        echo -e "${GREEN}URLs Found:${NC}\n$urls\n"
        echo -e "${YELLOW}To verify the found URLs, you can visit them to determine their destination.${NC}"
    fi
}

# Main function
main() {
    echo -e "${GREEN}Main.js File Analyzer Tool${NC}"
    echo -e "${GREEN}--------------------------${NC}"

    # Perform Main.js File Analyzer
    simulate_main_js_analyzer
}

# Call main function
main
