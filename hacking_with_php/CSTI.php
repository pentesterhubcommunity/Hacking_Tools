<?php
// Function to send HTTP requests
function sendRequest($url, $method = 'GET', $data = null) {
    $options = array(
        'http' => array(
            'method' => $method,
            'ignore_errors' => true // Ignore HTTP errors to capture the response
        )
    );

    if ($data !== null) {
        $options['http']['content'] = http_build_query($data);
    }

    $context = stream_context_create($options);
    return file_get_contents($url, false, $context);
}

// Function to check for CSTI vulnerability
function testCSTIVulnerability($url) {
    $response = sendRequest($url);
    if (strpos($response, '{{') !== false && strpos($response, '}}') !== false) {
        echo "\033[0;32mThe target website may be vulnerable to Client-Side Template Injection!\033[0m\n\n";
        echo "Here's how to test the vulnerability:\n";
        echo "1. Inject a simple expression like {{1+1}} in input fields or URL parameters.\n";
        echo "2. If the website evaluates the expression and displays the result (e.g., 2), it's likely vulnerable.\n";
        echo "3. Perform further testing by injecting more complex expressions to confirm the extent of vulnerability.\n";
    } else {
        echo "\033[0;31mThe target website does not appear to be vulnerable to Client-Side Template Injection.\033[0m\n";
    }
}

// Main program
echo "Enter your target website URL: ";
$targetWebsite = trim(fgets(STDIN));

echo "Testing for CSTI vulnerability on $targetWebsite...\n\n";

// Performing the vulnerability test
testCSTIVulnerability($targetWebsite);
