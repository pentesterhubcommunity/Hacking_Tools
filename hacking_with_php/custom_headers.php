<?php

// Function to send HTTP request with custom headers
function sendRequest($url, $headers) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

// Function to check if custom headers are reflected in the response
function checkVulnerability($url, $header, $value) {
    $headers = [
        "$header: $value"
    ];
    $response = sendRequest($url, $headers);
    if (strpos($response, "$header: $value") !== false) {
        return true;
    } else {
        return false;
    }
}

// Function to display messages with color
function displayMessage($message, $color = "white") {
    $colors = [
        "black" => "\033[0;30m",
        "red" => "\033[0;31m",
        "green" => "\033[0;32m",
        "yellow" => "\033[0;33m",
        "blue" => "\033[0;34m",
        "purple" => "\033[0;35m",
        "cyan" => "\033[0;36m",
        "white" => "\033[0;37m",
    ];
    echo $colors[$color] . $message . "\033[0m\n";
}

// Predefined malicious headers
$maliciousHeaders = [
    "X-XSS-Protection: 1; mode=block",
    "X-Content-Type-Options: nosniff",
    "Content-Security-Policy: default-src 'self'",
    "Strict-Transport-Security: max-age=31536000; includeSubDomains; preload",
    "X-Frame-Options: DENY"
];

// Main program
displayMessage("Enter your target website URL:", "cyan");
$targetURL = trim(fgets(STDIN));

$headers = get_headers($targetURL);
if ($headers) {
    displayMessage("Target website headers:", "yellow");
    foreach ($headers as $header) {
        displayMessage($header);
    }

    displayMessage("\nChoose a predefined malicious header to test:");
    foreach ($maliciousHeaders as $index => $maliciousHeader) {
        displayMessage(($index + 1) . ". $maliciousHeader");
    }
    displayMessage(count($maliciousHeaders) + 1 . ". Add a new custom header");

    displayMessage("\nEnter your choice (1-" . (count($maliciousHeaders) + 1) . "):", "cyan");
    $choice = trim(fgets(STDIN));

    if ($choice >= 1 && $choice <= count($maliciousHeaders)) {
        $selectedHeader = $maliciousHeaders[$choice - 1];
        $headerParts = explode(':', $selectedHeader);
        $customHeader = trim($headerParts[0]);
        $customValue = trim($headerParts[1]);

        displayMessage("\nTesting for vulnerability...", "cyan");
        if (checkVulnerability($targetURL, $customHeader, $customValue)) {
            displayMessage("The target website is vulnerable to Custom Header Vulnerabilities.", "red");
            displayMessage("To test the vulnerability, send a request to the target URL with the custom header '$customHeader' and value '$customValue'. If the header is reflected in the response, the vulnerability is confirmed.", "green");
        } else {
            displayMessage("The target website is not vulnerable to Custom Header Vulnerabilities.", "green");
        }
    } elseif ($choice == count($maliciousHeaders) + 1) {
        displayMessage("Enter custom header you want to test (e.g., X-TestHeader):", "cyan");
        $customHeader = trim(fgets(STDIN));
        displayMessage("Enter the value for the custom header:", "cyan");
        $customValue = trim(fgets(STDIN));

        displayMessage("\nTesting for vulnerability...", "cyan");
        if (checkVulnerability($targetURL, $customHeader, $customValue)) {
            displayMessage("The target website is vulnerable to Custom Header Vulnerabilities.", "red");
            displayMessage("To test the vulnerability, send a request to the target URL with the custom header '$customHeader' and value '$customValue'. If the header is reflected in the response, the vulnerability is confirmed.", "green");
        } else {
            displayMessage("The target website is not vulnerable to Custom Header Vulnerabilities.", "green");
        }
    } else {
        displayMessage("Invalid choice. Please choose a number between 1 and " . (count($maliciousHeaders) + 1) . ".", "red");
    }
} else {
    displayMessage("Failed to retrieve headers for the target website. Please check the URL and try again.", "red");
}
?>
