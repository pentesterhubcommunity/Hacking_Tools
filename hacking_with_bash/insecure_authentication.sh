#!/bin/bash
# This is a comment

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to crawl the website and analyze each page
crawl_and_analyze() {
    echo "Crawling and Analyzing Website: $1"
    
    # Create a temporary directory for downloaded files
    temp_dir=$(mktemp -d)
    
    # Crawl the website and download its content
    wget -r -l inf --no-check-certificate -P "$temp_dir" "$1" >/dev/null 2>&1
    
    # Analyze each downloaded file
    while IFS= read -r -d '' file; do
        echo "Analyzing: $file"
        # Perform analysis here, e.g., check for sensitive information
        if grep -q 'password' "$file"; then
            echo -e "${RED}Sensitive information (e.g., password) found in: $file${NC}"
        else
            echo -e "${GREEN}No sensitive information found in: $file${NC}"
        fi
    done < <(find "$temp_dir" -type f -print0)
    
    # Clean up temporary directory
    rm -rf "$temp_dir"
}

# Main function
main() {
    echo "Website Crawler and Analyzer"
    echo "-----------------------------"

    # Prompt user for target URL
    read -p "Enter the website URL to crawl and analyze: " website_url

    # Validate input
    if [ -z "$website_url" ]; then
        echo "Error: Website URL is empty."
        exit 1
    fi

    # Crawl and analyze the website
    crawl_and_analyze "$website_url"
}

# Call main function
main
