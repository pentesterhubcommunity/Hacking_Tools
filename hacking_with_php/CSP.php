<?php

// Function to check if CSP is bypassed
function testCSPBypass($url) {
    // Fetch the headers of the target website
    $headers = get_headers($url, 1);
    
    // Check if the website has a Content-Security-Policy header
    if (isset($headers['Content-Security-Policy'])) {
        // If CSP header is found, check if it's vulnerable to bypass
        if (strpos($headers['Content-Security-Policy'], "'unsafe-inline'") !== false) {
            // If 'unsafe-inline' directive is found, it's vulnerable
            echo "\033[0;32mThe target website is vulnerable to CSP bypass!\033[0m\n";
            echo "To test the vulnerability, try injecting inline scripts or styles.\n";
        } else {
            // If 'unsafe-inline' directive is not found, it's not vulnerable
            echo "\033[0;31mThe target website is not vulnerable to CSP bypass.\033[0m\n";
        }
    } else {
        // If no CSP header is found, it's not vulnerable
        echo "\033[0;31mThe target website does not have a Content-Security-Policy header, hence not vulnerable.\033[0m\n";
    }
}

// Prompt user to enter the target website URL
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Test CSP bypass vulnerability
testCSPBypass($targetUrl);

?>
