#!/bin/bash

# Function to print colored output
print_color() {
    case "$2" in
        "red") echo -e "\033[0;31m$1\033[0m" ;;
        "green") echo -e "\033[0;32m$1\033[0m" ;;
        *) echo "$1" ;;
    esac
}

# Function to test for exposed debug endpoints
test_debug_endpoints() {
    local target=$1
    local debug_endpoints=("debug" "info" "test" "admin" "dashboard" "logs" "trace" "console" "status" "debug_info" "debug_test" "debug_admin" "debug_dashboard" "debug_logs" "debug_trace" "debug_console" "debug_status" "debug_metrics") # Add more debug endpoints as needed
    
    for endpoint in "${debug_endpoints[@]}"; do
        response=$(curl -s -o /dev/null -w "%{http_code}" "$target/$endpoint")
        if [ "$response" == "200" ]; then
            print_color "Vulnerability Found: Exposed debug endpoint at $target/$endpoint" "red"
            print_color "How to test this vulnerability: Try accessing $target/$endpoint and observe if sensitive information is exposed." "green"
            return 0
        fi
    done
    
    print_color "No exposed debug endpoints found on $target" "green"
    return 1
}

# Main function
main() {
    read -p "Enter your target website URL: " target_url
    print_color "Testing for exposed debug endpoints on $target_url..." "green"
    test_debug_endpoints "$target_url"
}

# Run the main function
main
