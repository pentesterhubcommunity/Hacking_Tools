<?php

// Function to make HTTP requests
function makeRequest($url, $method = 'GET', $data = null) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);

    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }

    $response = curl_exec($ch);
    $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    return array('status' => $statusCode, 'response' => $response, 'error' => $error);
}

// Function to extract API endpoints from HTML content
function extractEndpoints($htmlContent, $baseUrl) {
    $endpoints = array();
    $pattern = '/"((?:\/|\.)*api\/[a-zA-Z0-9\/?=&_-]+)"/';
    preg_match_all($pattern, $htmlContent, $matches);

    foreach ($matches[1] as $match) {
        $endpoint = ltrim($match, '/');
        $endpoints[] = $baseUrl . '/' . $endpoint;
    }

    return $endpoints;
}

// Function to test unprotected endpoints
function testUnprotectedEndpoints($targetUrl, $endpoints, $verbose = false) {
    echo "\n[+] Testing Unprotected Endpoints...\n";
    foreach ($endpoints as $endpoint) {
        $response = makeRequest($endpoint);
        $statusCode = $response['status'];

        echo "[GET] $endpoint - Response Code: $statusCode\n";
        if ($statusCode == 200) {
            echo "[GET] $endpoint - Endpoint is likely unprotected!\n";
            if ($verbose) {
                echo "Response Body: " . $response['response'] . "\n";
            }
        } elseif ($statusCode >= 400) {
            echo "[GET] $endpoint - Request failed: " . $response['error'] . "\n";
        }
    }
}

// Main Program
echo "\033[1;33mEnter your target website URL: \033[0m";
$targetUrl = trim(fgets(STDIN));

echo "\033[1;36m\n[*] Initiating Unprotected API Endpoint Vulnerability Testing for: $targetUrl \033[0m\n";

// Make request to target website to retrieve HTML content
$htmlResponse = makeRequest($targetUrl)['response'];

// Extract API endpoints from HTML content
$baseUrl = rtrim($targetUrl, '/');
$extractedEndpoints = extractEndpoints($htmlResponse, $baseUrl);

// Test Unprotected Endpoints
testUnprotectedEndpoints($targetUrl, $extractedEndpoints, true);

echo "\n\033[1;32m[+] Vulnerability testing completed.\n\033[0m";

?>
