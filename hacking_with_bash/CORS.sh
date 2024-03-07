#!/bin/bash

# Function to print in color
print_color() {
    color=$1
    shift
    echo -e "\e[${color}m$@\e[0m"
}

# Function to test CORS misconfiguration
test_cors_vulnerability() {
    target_url=$1

    # Step 1: Send a test request with Origin header
    print_color "1;34" "[*] Sending test request with Origin header..."
    response=$(curl -s -I -X GET -H "Origin: https://www.bbc.com" "$target_url")

    # Step 2: Check if Access-Control-Allow-Origin header is present
    if [[ $response =~ "Access-Control-Allow-Origin: https://www.bbc.com" ]]; then
        print_color "1;32" "[+] CORS vulnerability detected!"
        print_color "1;32" "[+] Access-Control-Allow-Origin header allows requests from https://www.bbc.com."
    else
        print_color "1;31" "[-] CORS vulnerability not detected."
        return
    fi

    # Step 3: Attempt to bypass any protection systems
    print_color "1;34" "[*] Attempting to bypass any protection systems..."
    bypass_techniques=("Origin Header Spoofing" "CORS Preflight Cache Poisoning" "Subdomain Takeover")
    for technique in "${bypass_techniques[@]}"; do
        print_color "1;34" "[*] Trying $technique..."
        case "$technique" in
            "Origin Header Spoofing")
                # Send request with fake Origin header
                response=$(curl -s -I -X GET -H "Origin: https://example.com" "$target_url")
                if [[ $response =~ "Access-Control-Allow-Origin: https://example.com" ]]; then
                    print_color "1;32" "[+] Origin Header Spoofing successful!"
                    print_color "1;32" "[+] Access-Control-Allow-Origin header allows requests from fake origin."
                else
                    print_color "1;31" "[-] Origin Header Spoofing failed."
                fi
                ;;
            "CORS Preflight Cache Poisoning")
                # Send OPTIONS request with fake Origin header
                response=$(curl -s -I -X OPTIONS -H "Origin: https://example.com" "$target_url")
                if [[ $response =~ "Access-Control-Allow-Origin: https://example.com" ]]; then
                    print_color "1;32" "[+] CORS Preflight Cache Poisoning successful!"
                    print_color "1;32" "[+] Access-Control-Allow-Origin header allows requests from fake origin."
                else
                    print_color "1;31" "[-] CORS Preflight Cache Poisoning failed."
                fi
                ;;
            "Subdomain Takeover")
                # Check if subdomain is available for takeover
                # You need to implement this based on your knowledge and tools available
                print_color "1;31" "[-] Subdomain Takeover not implemented."
                ;;
            *)
                print_color "1;31" "[-] Unknown technique: $technique"
                ;;
        esac
    done

    # Step 4: Show how to check the vulnerability
    print_color "1;33" "[*] How to check for this vulnerability:"
    print_color "1;33" "    - Send a request to the target URL with a custom Origin header."
    print_color "1;33" "    - If the response contains 'Access-Control-Allow-Origin' header with the value 'https://www.bbc.com', the vulnerability is present."

    # Additional steps or techniques can be added here
}


# Main function
main() {
    # Prompt user for target website URL
    print_color "1;35" "Enter your target website URL: "
    read target_url

    # Test for CORS vulnerability
    test_cors_vulnerability "$target_url"
}

# Execute main function
main
