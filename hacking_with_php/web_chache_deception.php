<?php

// Define ANSI color escape codes
const COLOR_RED = "\033[0;31m";
const COLOR_GREEN = "\033[0;32m";
const COLOR_RESET = "\033[0m";

// Function to send HTTP request and return response headers
function sendHttpRequest($url, $method = 'GET', $headers = array()) {
    $options = array(
        'http' => array(
            'method' => $method,
            'header' => implode("\r\n", $headers),
        )
    );
    $context = stream_context_create($options);
    return get_headers($url, 1, $context);
}

// Function to check for Web Cache Deception
function checkWebCacheDeception($url, $method, $modification, $followRedirects, $useCookies, $userAgent) {
    // Send a request with the modified URL
    $modifiedUrl = $url . $modification;
    $headers = array();

    // Add cookies if requested
    if ($useCookies) {
        $headers[] = 'Cookie: test=1'; // Replace 'test=1' with actual cookies if needed
    }

    // Add User-Agent header
    $headers[] = 'User-Agent: ' . $userAgent;

    // Follow redirects if requested
    if ($followRedirects) {
        $response = followRedirections($modifiedUrl, $method, $headers);
    } else {
        $response = sendHttpRequest($modifiedUrl, $method, $headers);
    }

    // Check if the response contains the original URL
    $originalUrl = isset($response['Location']) ? $response['Location'] : null;
    if ($originalUrl === $url) {
        echo COLOR_RED . "Vulnerable to Web Cache Deception: Original URL detected in response.\n" . COLOR_RESET;
        echo "Detected Location Header: $originalUrl\n";
    } else {
        echo COLOR_GREEN . "Not vulnerable to Web Cache Deception.\n" . COLOR_RESET;
    }
}

// Function to follow redirections recursively and return final response headers
function followRedirections($url, $method = 'GET', $headers = array(), $maxRedirects = 5) {
    $response = sendHttpRequest($url, $method, $headers);

    // Check if redirection occurred
    if (isset($response['Location']) && $maxRedirects > 0) {
        return followRedirections($response['Location'], $method, $headers, $maxRedirects - 1);
    }

    return $response;
}

// Prompt user for the target website URL
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Prompt user for the HTTP method
echo "Enter HTTP method (GET/POST): ";
$method = strtoupper(trim(fgets(STDIN)));

// Prompt user for the URL modification string
echo "Enter URL modification string (e.g., /index.php%3fa%3d1): ";
$modification = trim(fgets(STDIN));

// Prompt user whether to follow redirects
echo "Follow redirects? (yes/no): ";
$followRedirectsInput = strtolower(trim(fgets(STDIN)));
$followRedirects = ($followRedirectsInput === 'yes');

// Prompt user whether to include cookies
echo "Include cookies? (yes/no): ";
$useCookiesInput = strtolower(trim(fgets(STDIN)));
$useCookies = ($useCookiesInput === 'yes');

// Prompt user for the User-Agent header
echo "Enter User-Agent header (press Enter to use default): ";
$userAgent = trim(fgets(STDIN));

// Use default User-Agent if not provided
if (empty($userAgent)) {
    $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36";
}

// Test the target website for Web Cache Deception
echo "\nTesting $targetUrl for Web Cache Deception...\n";
checkWebCacheDeception($targetUrl, $method, $modification, $followRedirects, $useCookies, $userAgent);

?>
