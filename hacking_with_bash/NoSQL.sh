#!/bin/bash

# Function to print messages in color
print_color() {
    case $2 in
        "green") echo -e "\e[32m$1\e[0m";;
        "red") echo -e "\e[31m$1\e[0m";;
        "yellow") echo -e "\e[33m$1\e[0m";;
        *) echo "$1";;
    esac
}

# Function to test for NoSQL Injection vulnerability
test_nosql_injection() {
    # Payloads to collect sensitive information
    payloads=("admin' || 1==1" "admin' && $neq" "admin' || true" "admin' || $gt" "admin' || $nin" "admin' || $regex" "admin' || $where" "admin' || $text")

    # Extracting response content
    print_color "Sending request to $1..." "yellow"
    response=$(curl -s "$1")

    # Checking for sensitive information in the response content
    sensitive_info_found=false
    for payload in "${payloads[@]}"; do
        if [[ $response == *"$payload"* ]]; then
            print_color "Sensitive information found in the response content: $payload" "red"
            sensitive_info_found=true
        fi
    done

    if ! $sensitive_info_found; then
        print_color "No sensitive information found in the response content." "green"
    fi
}

# Main function
main() {
    echo "Enter your target website URL: "
    read target_url
    echo "Initiating NoSQL Injection vulnerability test on $target_url..."
    test_nosql_injection "$target_url"
}

# Execute the main function
main
