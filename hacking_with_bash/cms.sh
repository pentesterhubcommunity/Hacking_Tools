#!/bin/bash

# Function to print output in color
print_color() {
    printf "\033[1;32m$1\033[0m\n"
}

# Function to check if a URL returns a valid response
check_url() {
    local url="$1"
    local response

    # Use wget to check the URL
    response=$(wget --spider -S "$url" 2>&1)

    # Check if the response contains a valid HTTP status code
    if echo "$response" | grep "HTTP/" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to test for CMS Information Disclosure Vulnerabilities
test_vulnerability() {
    local target="$1"
    local vulnerable=0

    # Common files and directories to check for CMS
    files=("wp-config.php" "wp-login.php" "wp-admin" "wp-includes" "wp-content" "robots.txt" "phpinfo.php" "config.php" "admin.php" "administrator" "drupal" "joomla" "typo3" "modx")

    print_color "Testing for CMS Information Disclosure Vulnerabilities on $target..."

    # Iterate through files and directories
    for file in "${files[@]}"; do
        if check_url "$target/$file"; then
            print_color "Found potential vulnerability: $target/$file"
            vulnerable=1
        fi
    done

    if [ "$vulnerable" -eq 1 ]; then
        print_color "The target website is potentially vulnerable to CMS Information Disclosure."
    else
        print_color "The target website does not seem to be vulnerable to CMS Information Disclosure."
    fi

    print_color "To test the vulnerability manually, try accessing these files/directories on the target website."
}

# Main function
main() {
    read -p "Enter your target website URL: " target_url

    if [[ "$target_url" =~ ^https?:// ]]; then
        if check_url "$target_url"; then
            test_vulnerability "$target_url"
        else
            print_color "Error: Unable to connect to the target website. Please check the URL and try again."
        fi
    else
        print_color "Error: Invalid URL format. Please make sure to include 'http://' or 'https://' in the URL."
    fi
}

# Execute the main function
main
