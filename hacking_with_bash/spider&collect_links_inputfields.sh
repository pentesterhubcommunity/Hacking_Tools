#!/bin/bash

# Function to display messages in color
print_color() {
    case "$2" in
        "green") color="\e[32m" ;;
        "red") color="\e[31m" ;;
        "yellow") color="\e[33m" ;;
        *) color="\e[0m" ;;
    esac
    echo -e "$color$1\e[0m"
}

# Function to spider the website and collect links, parameters, input fields, sensitive information, and hidden fields
spider_website() {
    target_website="$1"
    print_color "Spidering $target_website..." "green"
    # Fetch the webpage
    content=$(curl -s -L "$target_website")
    # Extract links
    links=$(echo "$content" | grep -oE 'href="([^"#]+)"' | cut -d'"' -f2)
    print_color "Links found:" "green"
    echo "$links"
    # Extract parameters
    parameters=$(echo "$content" | grep -oE 'name="[^"]+"' | cut -d'"' -f2)
    print_color "Parameters found:" "green"
    echo "$parameters"
    # Extract input fields
    input_fields=$(echo "$content" | grep -oE '<input[^>]+>')
    print_color "Input fields found:" "green"
    echo "$input_fields"
    # Extract sensitive information
    sensitive_info=$(echo "$content" | grep -oE '(password|secret|apikey)[[:alnum:]_]*')
    print_color "Sensitive information found:" "yellow"
    echo "$sensitive_info"
    # Extract hidden fields
    hidden_fields=$(echo "$content" | grep -oE '<input[^>]+type="hidden"[^>]*>')
    print_color "Hidden fields found:" "yellow"
    echo "$hidden_fields"
}

# Main function
main() {
    clear
    print_color "Spidering and Collecting Links, Parameters, Input Fields, Sensitive Information, and Hidden Fields" "green"
    read -p "Enter your target website URL: " target_url
    spider_website "$target_url"
}

# Execute main function
main
