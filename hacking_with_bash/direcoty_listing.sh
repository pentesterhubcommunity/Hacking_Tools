#!/bin/bash

# Function to print colored output
print_color() {
    color=$1
    shift
    echo -e "\033[${color}m$@\033[0m"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if curl is installed
if ! command_exists curl; then
    print_color 91 "Error: curl is not installed. Please install curl to continue."
    exit 1
fi

# Prompt user for target website URL
read -p "$(print_color 94 "Enter your target website URL: ")" target_url

# Set common directory names to check
directories=("images" "admin" "backup" "uploads" "config" "data" "logs" "temp" "resources" "private" "system" "files" "docs" "assets" "scripts" "styles" "includes" "public" "wp-content" "cgi-bin" "images/uploads")

# Set User-Agent headers
user_agents=("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" 
             "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0" 
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" 
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15" 
             "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" 
             "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0" 
             "Mozilla/5.0 (iPhone; CPU iPhone OS 14_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Mobile/15E148 Safari/604.1" 
             "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36")

# Set timeout for HTTP request (in seconds)
timeout=10

# Loop through common directories and User-Agent strings to check for directory listing vulnerability
vulnerability_found=false
for dir in "${directories[@]}"; do
    for ua in "${user_agents[@]}"; do
        response=$(curl -s -o /dev/null -w "%{http_code}" --max-time $timeout -A "$ua" "${target_url}/${dir}/")
        if [ "$response" == "200" ]; then
            print_color 92 "Directory listing vulnerability found on ${target_url}!"
            echo "Vulnerable directory: ${target_url}/${dir}/"
            vulnerability_found=true
            break 2
        fi
    done
done

# If no vulnerability found, display a message
if [ "$vulnerability_found" = false ]; then
    print_color 91 "Directory listing vulnerability not found on ${target_url}."
fi
