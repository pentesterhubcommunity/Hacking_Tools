<?php
// Prompt the user to enter the target website link
echo "Enter your target website link: ";
$target_url = trim(fgets(STDIN));

// Check if the URL is allowed to be fetched (optional, to simulate a security control)
$allowed_domains = ['example.com', 'trusteddomain.com']; // List of allowed domains
$parsed_url = parse_url($target_url);
if (!in_array($parsed_url['host'], $allowed_domains)) {
    die('Access to this domain is not allowed.');
}

// Perform the request (vulnerable to SSRF if user-controlled)
$response = file_get_contents($target_url);

// Output the response
echo $response;
?>
