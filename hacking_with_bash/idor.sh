#!/bin/bash
# This is a comment

# Color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to perform Insecure Direct Object Reference (IDOR) detection
detect_idor() {
    echo "Detecting Insecure Direct Object References (IDOR)..."
    # Check for sequential or predictable object references in URLs
    if grep -E -q '/[0-9]+' <<< "$1"; then
        echo -e "${RED}Insecure Direct Object Reference (IDOR) detected: $1${NC}"
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) detected.${NC}"
    fi
}

# Function to perform IDOR detection using ffuf
detect_idor_ffuf() {
    echo "Detecting Insecure Direct Object References (IDOR) using ffuf..."

    # Run ffuf to discover hidden or sensitive endpoints
    ffuf_output=$(ffuf -w /usr/share/wordlists/dirb/common.txt -u "$1/FUZZ" -recursion -recursion-depth 1 -e .php,.html,.txt)

    # Check if any vulnerable endpoints were discovered
    if echo "$ffuf_output" | grep -q 'Status: 200'; then
        echo -e "${RED}Potential Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
        echo "$ffuf_output"
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
    fi
}

# Function to perform IDOR detection using dirb
detect_idor_dirb() {
    echo "Detecting Insecure Direct Object References (IDOR) using dirb..."

    # Run dirb to discover hidden or sensitive endpoints
    dirb_output=$(dirb "$1" /usr/share/wordlists/dirb/common.txt)

    # Check if any vulnerable endpoints were discovered
    if echo "$dirb_output" | grep -q '==>.*'; then
        echo -e "${RED}Potential Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
        echo "$dirb_output" | grep '==>'
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
    fi
}

# Function to perform IDOR detection using gobuster
detect_idor_gobuster() {
    echo "Detecting Insecure Direct Object References (IDOR) using gobuster..."

    # Run gobuster to discover hidden or sensitive endpoints
    gobuster_output=$(gobuster dir -u "$1" -w /usr/share/wordlists/dirb/common.txt -x php,txt,html)

    # Check if any vulnerable endpoints were discovered
    if echo "$gobuster_output" | grep -q 'Status: 200'; then
        echo -e "${RED}Potential Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
        echo "$gobuster_output"
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
    fi
}

# Function to perform IDOR detection using nikto
detect_idor_nikto() {
    echo "Detecting Insecure Direct Object References (IDOR) using nikto..."

    # Run nikto to scan for vulnerabilities
    nikto_output=$(nikto -h "$1")

    # Check if any potential vulnerabilities were discovered
    if echo "$nikto_output" | grep -q 'OSVDB'; then
        echo -e "${RED}Potential vulnerabilities detected.${NC}"
        echo "$nikto_output"
    else
        echo -e "${GREEN}No vulnerabilities detected.${NC}"
    fi
}


# Function to perform IDOR detection using sqlmap
detect_idor_sqlmap() {
    echo "Detecting Insecure Direct Object References (IDOR) using sqlmap..."

    # Run sqlmap to scan for SQL injection vulnerabilities
    sqlmap_output=$(sqlmap -u "$1" --batch --level 5 --risk 3)

    # Check if any potential vulnerabilities were discovered
    if echo "$sqlmap_output" | grep -q 'Parameter: .*?Type: (error-based )?inference'; then
        echo -e "${RED}Potential Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
        echo "$sqlmap_output"
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
    fi
}

# Function to perform IDOR detection using OWASP ZAP
detect_idor_zap() {
    echo "Detecting Insecure Direct Object References (IDOR) using OWASP ZAP..."

    # Run OWASP ZAP to scan for vulnerabilities
    zap_output=$(zap-cli quick-scan --spider -r "$1")

    # Check if any potential vulnerabilities were discovered
    if echo "$zap_output" | grep -q 'Insecure Direct Object Reference'; then
        echo -e "${RED}Potential Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
        echo "$zap_output"
    else
        echo -e "${GREEN}No Insecure Direct Object Reference (IDOR) vulnerabilities detected.${NC}"
    fi
}

# Main function
main() {
    echo "Security Vulnerability Detection Tool"
    echo "------------------------------------"

    # Prompt user to enter the target URL
    read -p "Enter your target URL: " target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}Error: Target URL cannot be empty.${NC}"
        exit 1
    fi

    # Perform security vulnerability checks
    detect_idor "$target_url"
    detect_idor_ffuf "$target_url"
    detect_idor_dirb "$target_url"
    detect_idor_gobuster "$target_url"
    detect_idor_nikto "$target_url"
    detect_idor_sqlmap "$target_url"
    detect_idor_zap "$target_url"
}

# Call main function
main
