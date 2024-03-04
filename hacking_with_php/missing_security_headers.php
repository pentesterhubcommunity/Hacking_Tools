<?php

// Function to check if a header is present in the response
function isHeaderPresent($headers, $header) {
    return isset($headers[$header]) && !empty($headers[$header]);
}

// Function to display colored text
function displayColoredText($text, $color) {
    switch ($color) {
        case 'red':
            echo "\033[0;31m$text\033[0m";
            break;
        case 'green':
            echo "\033[0;32m$text\033[0m";
            break;
        case 'yellow':
            echo "\033[1;33m$text\033[0m";
            break;
        default:
            echo $text;
    }
}

// Function to test for Missing Security Headers vulnerability
function testSecurityHeaders($url, $displayExplanation = true) {
    // Set timeout for fetching headers (5 seconds)
    $context = stream_context_create(['http' => ['timeout' => 5]]);

    // Fetch headers of the target website
    $headers = @get_headers($url, 1, $context);

    if ($headers === false) {
        displayColoredText("Error: Unable to fetch headers for $url. Please check the URL and try again.\n", 'red');
        return;
    }

    // List of security headers to check
    $securityHeaders = array(
        'X-Content-Type-Options',
        'X-Frame-Options',
        'X-XSS-Protection',
        'Content-Security-Policy',
        'Strict-Transport-Security',
        'Referrer-Policy',
        'Feature-Policy',
        'Permissions-Policy'
    );

    $vulnerabilityFound = false;

    echo "Results for $url:\n";

    foreach ($securityHeaders as $header) {
        if (!isHeaderPresent($headers, $header)) {
            displayColoredText("[$header] header is missing!\n", 'red');
            $vulnerabilityFound = true;
            if ($displayExplanation) {
                echo "Recommendation: Configure the web server to include the '$header' header in HTTP responses.\n";
            }
        } else {
            displayColoredText("[$header] header is present.\n", 'green');
        }
    }

    if (!$vulnerabilityFound) {
        echo "No Missing Security Headers vulnerability found.\n";
    } else {
        echo "Potential Missing Security Headers vulnerability found.\n";
        if ($displayExplanation) {
            // Provide instructions on how to exploit the vulnerability
            echo "An attacker can exploit Missing Security Headers vulnerability to perform various attacks such as Cross-Site Scripting (XSS), Clickjacking, MIME Sniffing, etc.\n";
            echo "To fix the missing headers, ensure that the web server is properly configured to include these headers in HTTP responses.\n";
        }
    }
}

// Main program
echo "Enter your target website URL (press Enter to finish): \n";

$websites = [];

while (true) {
    $targetWebsite = trim(fgets(STDIN));
    if (empty($targetWebsite)) {
        break;
    }
    $websites[] = $targetWebsite;
}

echo "Do you want to display detailed explanations? (yes/no): ";
$choice = trim(fgets(STDIN));

foreach ($websites as $website) {
    testSecurityHeaders($website, strtolower($choice) === 'yes');
}

?>
