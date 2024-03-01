#!/bin/bash

# Output log file
LOG_FILE="sensitive_data_test.log"

# Function to check if a URL returns a valid response
check_url() {
    local url=$1
    local response=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36" --connect-timeout 10 --max-time 20 "$url")
    if [[ $response -eq 200 ]]; then
        echo "[$(date)] $url is reachable"
    else
        echo "[$(date)] $url is not reachable or returned a non-200 status code"
        echo "[$(date)] $url is not reachable or returned a non-200 status code" >> "$LOG_FILE"
    fi
}

# Function to check for sensitive data exposure
check_sensitive_data() {
    local url=$1

    # Check if robots.txt file exists
    echo "[$(date)] Checking robots.txt"
    check_url "${url}/robots.txt"

    # Check for common sensitive files
    echo "[$(date)] Checking common sensitive files"
    files=(".git/config" ".svn/entries" ".DS_Store" ".env" "wp-config.php" "configuration.php" "web.config" "phpinfo.php")

    for file in "${files[@]}"; do
        check_url "${url}/${file}" &
    done
    wait
}

# Main function
main() {
    read -p "Enter your target website URL: " url

    if [[ -z "$url" ]]; then
        echo "URL cannot be empty"
        exit 1
    fi

    echo "[$(date)] Starting sensitive data exposure test for $url"
    echo "[$(date)] Starting sensitive data exposure test for $url" >> "$LOG_FILE"
    check_sensitive_data "$url"
    echo "[$(date)] Sensitive data exposure test completed"
    echo "[$(date)] Sensitive data exposure test completed" >> "$LOG_FILE"
    echo "Check $LOG_FILE for detailed results."
}

# Run main function
main
