#!/bin/bash

# Function to print colored output
print_color() {
    color=$1
    message=$2
    case $color in
        "green") echo -e "\033[0;32m$message\033[0m" ;;
        "red") echo -e "\033[0;31m$message\033[0m" ;;
        "blue") echo -e "\033[0;34m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}

# Function to check if the target website is vulnerable
check_vulnerability() {
    target_url=$1
    print_color "blue" "Checking vulnerability for: $target_url"
    # Use curl to fetch the target website and check if it allows cross-origin messaging
    response=$(curl -s -H "Origin: https://www.bbc.com" -H "Content-Type: application/json" -X POST -d '{"message":"Hello"}' "$target_url")
    if [[ $response == *"Hello"* ]]; then
        print_color "red" "Target website is vulnerable to HTML5 Cross-Origin Messaging!"
        print_color "blue" "To test the vulnerability, you can use a script or tool like 'PostMessageTester'."
    else
        print_color "green" "Target website is not vulnerable to HTML5 Cross-Origin Messaging."
    fi
}

# Main function
main() {
    print_color "blue" "Enter your target website url: "
    read target_website
    check_vulnerability "$target_website"
}

# Run the main function
main
