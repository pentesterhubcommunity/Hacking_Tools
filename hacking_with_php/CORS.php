<?php
// Function to send HTTP request and check CORS headers
function checkCORS($url) {
    $methods = ['GET', 'POST', 'OPTIONS'];
    $vulnerable = false; // Flag to track vulnerability

    foreach ($methods as $method) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $headers = curl_getinfo($ch, CURLINFO_HEADER_OUT);
        curl_close($ch);

        // Check if CORS headers are present
        $corsHeaders = [];
        foreach (explode("\n", $headers) as $header) {
            if (stripos($header, 'Access-Control-Allow-Origin:') !== false ||
                stripos($header, 'Access-Control-Allow-Methods:') !== false ||
                stripos($header, 'Access-Control-Allow-Headers:') !== false) {
                $corsHeaders[] = trim($header);
            }
        }

        // Output result
        if (!empty($corsHeaders)) {
            echo "\033[0;32m[+] CORS headers found for $method request:\033[0m\n";
            foreach ($corsHeaders as $corsHeader) {
                echo "$corsHeader\n";
            }
            echo "\n\033[0;32m[+] The website may be vulnerable to Misconfigured CORS.\033[0m\n";
            echo "\033[0;33m[!] To mitigate the vulnerability, ensure CORS headers are properly configured.\033[0m\n";
            $vulnerable = true;
        } else {
            echo "\033[0;31m[-] No CORS headers found for $method request.\033[0m\n";
        }

        // Check if bypass is possible
        if ($httpCode === 200) {
            echo "\033[0;32m[+] HTTP $method request succeeded (Status code: $httpCode).\033[0m\n";
        } else {
            echo "\033[0;31m[-] HTTP $method request failed (Status code: $httpCode).\033[0m\n";
        }
    }

    // Output vulnerability status
    if ($vulnerable) {
        echo "\033[0;31m[!] The website is vulnerable to Misconfigured CORS.\033[0m\n";
    } else {
        echo "\033[0;32m[+] The website is not vulnerable to Misconfigured CORS.\033[0m\n";
    }

    // Manual testing instructions
    echo "\n\033[0;36m[+] Manual Testing Instructions:\033[0m\n";
    echo "1. Use a web browser's developer tools to inspect network requests.\n";
    echo "2. Send cross-origin requests (e.g., using a tool like cURL or Postman) with different HTTP methods.\n";
    echo "3. Check if the server responds with appropriate CORS headers (Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers).\n";
    echo "4. If CORS headers are overly permissive (e.g., allowing all origins or methods), the website is likely vulnerable.\n";
}

// Function to prompt user for target website URL
function promptTargetWebsite() {
    echo "Enter your target website URL: ";
    $url = trim(fgets(STDIN));
    return $url;
}

// Main function
function main() {
    echo "\033[0;36mStarting Misconfigured CORS vulnerability test...\033[0m\n";
    $targetUrl = promptTargetWebsite();
    echo "\033[0;36mTesting $targetUrl for Misconfigured CORS vulnerability...\033[0m\n";
    checkCORS($targetUrl);
    echo "\033[0;36mTest complete.\033[0m\n";
}

// Run the main function
main();
?>
