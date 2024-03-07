#!/bin/bash

# Function to display messages in green color
green_msg() {
    echo -e "\e[32m$1\e[0m"
}

# Function to display messages in yellow color
yellow_msg() {
    echo -e "\e[33m$1\e[0m"
}

# Function to display messages in red color
red_msg() {
    echo -e "\e[31m$1\e[0m"
}

# Function to test for Information Disclosure vulnerability
test_vulnerability() {
    target_url=$1
    # Define array of sensitive files and directories
    sensitive_paths=(
        "/etc/passwd"
        "/etc/shadow"
        "/etc/group"
        "/etc/hostname"
        "/etc/hosts"
        "/etc/apache2/apache2.conf"
        "/etc/apache2/sites-available"
        "/etc/nginx/nginx.conf"
        "/etc/nginx/sites-available"
        "/etc/mysql/my.cnf"
        "/etc/php/php.ini"
        "/etc/ssl/private"
        "/etc/ssl/certs"
        "/etc/ssh/sshd_config"
        "/etc/ssh/ssh_config"
        "/var/log"
        "/var/www/html"
        "/var/www/config.php"
        "/var/www/wp-config.php"
        "/var/www/.htaccess"
        "/var/www/.env"
        "/var/www/.git/config"
        "/var/www/.gitignore"
        "/var/www/.svn"
        "/var/www/.DS_Store"
        "/var/www/cgi-bin"
        "/.htaccess"
        "/phpinfo.php"
        "/server-status"
    )

    # Try to access common sensitive files and directories
    yellow_msg "Testing for Information Disclosure vulnerability on $target_url..."
    for path in "${sensitive_paths[@]}"; do
        response_code=$(curl -s -o /dev/null -w "%{http_code}" $target_url$path)
        if [ "$response_code" != "404" ]; then
            green_msg "HTTP $response_code - $path"
        fi
    done

    # Perform directory enumeration using multiple tools
    green_msg "Performing directory enumeration using multiple tools"
    echo "Dirsearch results:" > dirsearch_results.txt
    dirsearch -u $target_url -e php,html,txt -w /usr/share/wordlists/dirb/common.txt | grep '[+] Found' >> dirsearch_results.txt
    echo "Gobuster results:" > gobuster_results.txt
    gobuster dir -u $target_url -w /usr/share/wordlists/dirb/common.txt -q -o gobuster_results.txt

    # Check for robots.txt file
    green_msg "Checking robots.txt for disallowed directories"
    curl -s $target_url/robots.txt

    # Check for server headers that may disclose information
    green_msg "Checking server headers"
    curl -I $target_url

    # Attempt to bypass protection systems
    yellow_msg "Attempting to bypass protection systems..."
    green_msg "Trying URL encoding"
    curl -s -o /dev/null -w "%{http_code}" "$target_url/%65%74%63/passwd"
    green_msg "Trying adding custom headers"
    curl -s -o /dev/null -w "%{http_code}" -H "User-Agent: Mozilla/5.0" $target_url/etc/passwd
    green_msg "Trying different HTTP methods"
    curl -s -o /dev/null -w "%{http_code}" -X POST $target_url/etc/passwd

    # Provide guidance on exploitation
    yellow_msg "To exploit Information Disclosure vulnerability:"
    green_msg "1. Use the obtained sensitive information to gather more data."
    green_msg "2. Identify misconfigured files or directories containing sensitive data."
}

# Main script starts here
clear
green_msg "Welcome to Information Disclosure Vulnerability Tester"
read -p "Enter your target website URL: " website_url

if [ -z "$website_url" ]; then
    red_msg "Error: Target website URL cannot be empty."
    exit 1
fi

green_msg "Testing Information Disclosure vulnerability for $website_url..."
test_vulnerability $website_url
