#!/bin/bash

# Function to print messages in color
print_color_message() {
    local color=$1
    shift
    echo -e "\e[${color}m$@\e[0m"
}

# Function to check if session cookie remains same
check_session_fixation() {
    local url=$1
    local session_cookie=$2

    # Make a request to the target website
    local response=$(curl -s -i $url)

    # Extract the session cookie from the response
    local extracted_cookie=$(echo "$response" | grep -oP '(?<=Set-Cookie:\s).*?(?=\;)')

    # Check if the extracted cookie matches the provided session cookie
    if [[ "$extracted_cookie" == "$session_cookie" ]]; then
        print_color_message 32 "[+] Session Fixation Vulnerability Detected!"
    else
        print_color_message 31 "[-] Session Fixation Vulnerability Not Detected."
    fi
}

# Main function
main() {
    print_color_message 33 "Enter your target website URL: "
    read url

    print_color_message 33 "Enter the session cookie: "
    read session_cookie

    print_color_message 33 "Testing for Session Fixation Vulnerability on $url ..."
    check_session_fixation "$url" "$session_cookie"
}

# Run the main function
main
