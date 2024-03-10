<?php
// Color codes for output
class Color {
    const RESET = "\033[0m";
    const RED = "\033[0;31m";
    const GREEN = "\033[0;32m";
}

// Function to send HTTP request
function sendRequest($url) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return [$httpCode, $response];
}

// Function to test for WAF evasion
function testWAFEvasion($url) {
    echo "Testing WAF evasion on $url...\n";
    $response = sendRequest($url);
    $httpCode = $response[0];
    $htmlResponse = htmlspecialchars($response[1]);
    if ($httpCode == 200) {
        echo Color::GREEN . "Target website is accessible.\n" . Color::RESET;
        echo "Response from the server:\n$htmlResponse\n";
    } else {
        echo Color::RED . "Target website is not accessible or blocked by WAF.\n" . Color::RESET;
        echo "Response status code: $httpCode\n";
    }
}

// Main program
echo "Enter your target website URL: ";
$targetWebsite = trim(fgets(STDIN));
testWAFEvasion($targetWebsite);
?>
