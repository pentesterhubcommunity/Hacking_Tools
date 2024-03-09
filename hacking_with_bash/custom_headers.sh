#!/bin/bash

# Function to display colored output
print_color() {
    color=$1
    message=$2
    case $color in
        "red")
            echo -e "\033[0;31m$message\033[0m"
            ;;
        "green")
            echo -e "\033[0;32m$message\033[0m"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Function to test for Custom Header Vulnerabilities
test_custom_header_vulnerability() {
    target_url=$1

    # Array of custom headers to test
    custom_headers=("X-Test-Header" "X-Custom-Header" "Custom-Header" "X-Auth" "Authorization" "X-Token" "X-Secret" "User-Token" "Custom-Token")

    # Initialize a variable to track if the target is vulnerable
    vulnerable=false

    # Loop through each custom header and check if the target URL is vulnerable
    for header in "${custom_headers[@]}"; do
        # Send a request with the current custom header and capture the response
        response=$(curl -s -I -H "$header: test" "$target_url")

        # Check if the header is present in the response
        if [[ $response == *"$header"* ]]; then
            # Print a message indicating that the target is vulnerable with the current header
            print_color "green" "Target website is vulnerable to Custom Header vulnerabilities with header: $header."
            print_color "green" "To test this vulnerability, try adding a custom header like '$header: test' in your requests."
            # You can add more instructions here based on the specific vulnerability you're targeting
            # Set the vulnerable flag to true
            vulnerable=true
            # Print the response headers and content
            print_color "green" "Response for header $header:"
            echo "$response"
        fi
    done

    # Check if the target is not vulnerable to any of the tested headers
    if [[ "$vulnerable" == "false" ]]; then
        # Print a message indicating that the target is not vulnerable
        print_color "red" "Target website is not vulnerable to Custom Header vulnerabilities."
    fi
}

# Main script starts here

# Prompt user for the target website URL
read -p "Enter your target website URL: " target_url

# Print a message indicating that the testing process is starting
print_color "green" "Testing for Custom Header Vulnerabilities on $target_url..."

# Perform tests for Custom Header Vulnerabilities
test_custom_header_vulnerability "$target_url"
