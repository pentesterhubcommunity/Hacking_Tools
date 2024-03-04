<?php

// Function to check if a URL uses HTTPS
function isHttps($url) {
    $parsedUrl = parse_url($url);
    return isset($parsedUrl['scheme']) && $parsedUrl['scheme'] === 'https';
}

// Function to check for Unencrypted Data Storage vulnerability
function checkUnencryptedDataStorage($url) {
    // Check if the website uses HTTPS
    if (!isHttps($url)) {
        return "The website does not use HTTPS, making it vulnerable to Unencrypted Data Storage.";
    }

    // Simulate scanning for unencrypted data storage vulnerabilities
    $vulnerabilities = [
        "unencrypted_form_action" => false,
        "http_urls" => [],
    ];

    // Placeholder for actual vulnerability detection logic
    // Simulated logic: check for unencrypted form actions and HTTP URLs
    $htmlContent = file_get_contents($url); // Get HTML content of the website (this might not work for all websites)
    if ($htmlContent !== false) {
        // Check for unencrypted form actions
        preg_match_all('/<form[^>]*action="http:\/\/[^"]*"/', $htmlContent, $matches);
        if (!empty($matches[0])) {
            $vulnerabilities["unencrypted_form_action"] = true;
        }
        
        // Check for HTTP URLs
        preg_match_all('/href="http:\/\/[^"]*"/', $htmlContent, $matches);
        if (!empty($matches[0])) {
            $vulnerabilities["http_urls"] = $matches[0];
        }
    }

    // Generate vulnerability message based on scan results
    $vulnerabilityMessage = "No unencrypted data storage vulnerabilities found on $url.";
    if ($vulnerabilities["unencrypted_form_action"] || !empty($vulnerabilities["http_urls"])) {
        $vulnerabilityMessage = "Unencrypted data storage vulnerabilities found on $url:\n";
        if ($vulnerabilities["unencrypted_form_action"]) {
            $vulnerabilityMessage .= "- Unencrypted form actions\n";
        }
        if (!empty($vulnerabilities["http_urls"])) {
            $vulnerabilityMessage .= "- HTTP URLs:\n";
            foreach ($vulnerabilities["http_urls"] as $httpUrl) {
                $vulnerabilityMessage .= "  $httpUrl\n";
            }
        }
    }

    return $vulnerabilityMessage;
}

// Function to prompt user for target website URL
function promptForWebsite() {
    echo "\nEnter your target website URL: ";
    $url = trim(fgets(STDIN));
    return $url;
}

// Function to display result message with color
function displayResult($message) {
    echo "\nResult: ";
    if (strpos($message, "vulnerability found") !== false) {
        echo "\033[0;31m"; // Red color for vulnerability found
    } else {
        echo "\033[0;32m"; // Green color for no vulnerability found
    }
    echo $message . "\033[0m\n"; // Reset color
}

// Main function to execute the program
function main() {
    // Prompt user for target website URL
    $targetWebsite = promptForWebsite();

    // Check for Unencrypted Data Storage vulnerability
    $resultMessage = checkUnencryptedDataStorage($targetWebsite);

    // Display result with appropriate color
    displayResult($resultMessage);
}

// Execute the main function
main();

?>
