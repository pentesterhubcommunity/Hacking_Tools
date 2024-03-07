<?php

// Function to fetch HTTP headers of a URL
function getHeaders($url) {
    $headers = [];
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADERFUNCTION,
      function($curl, $header) use (&$headers) {
        $len = strlen($header);
        $header = explode(':', $header, 2);
        if (count($header) < 2) // Ignore invalid headers
            return $len;
        $headers[strtolower(trim($header[0]))][] = trim($header[1]);
        return $len;
      }
    );
    curl_exec($ch);
    $statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return [$headers, $statusCode];
}

// Function to check if a given header is present
function hasHeader($headers, $header) {
    return isset($headers[strtolower($header)]);
}

// Function to display colored output
function colorize($text, $color) {
    $colors = [
        'red' => "\033[0;31m",
        'green' => "\033[0;32m",
        'yellow' => "\033[0;33m",
        'blue' => "\033[0;34m",
        'reset' => "\033[0m"
    ];
    return $colors[$color] . $text . $colors['reset'];
}

// Main program

// Prompt user for target website URL
echo "Enter your target website URL: ";
$target = trim(fgets(STDIN));

// Fetch HTTP headers of the target website
echo "Fetching HTTP headers for $target...\n";
list($headers, $statusCode) = getHeaders($target);

// Check for specific security headers
echo "Checking for security headers...\n";
$securityHeaders = [
    'x-frame-options' => 'X-Frame-Options',
    'x-xss-protection' => 'X-XSS-Protection',
    'content-security-policy' => 'Content-Security-Policy',
    'strict-transport-security' => 'Strict-Transport-Security',
    'x-content-type-options' => 'X-Content-Type-Options',
    'referrer-policy' => 'Referrer-Policy'
];

$vulnerable = false;

foreach ($securityHeaders as $headerKey => $headerName) {
    if (hasHeader($headers, $headerKey)) {
        echo colorize("✓ $headerName header found: " . implode(", ", $headers[$headerKey]) . "\n", 'green');
    } else {
        echo colorize("✗ $headerName header missing\n", 'red');
        $vulnerable = true;
    }
}

// Display vulnerability status
if ($vulnerable) {
    echo colorize("The website is vulnerable to HTTP Security Headers Misconfiguration.\n", 'red');
} else {
    echo colorize("The website is not vulnerable to HTTP Security Headers Misconfiguration.\n", 'green');
}

// Instructions to test the vulnerability
echo "To test the vulnerability, you can use tools like SecurityHeaders.io or Mozilla Observatory.\n";

?>
