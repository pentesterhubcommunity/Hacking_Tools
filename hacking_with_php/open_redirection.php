#!/usr/bin/php
<?php

echo "Enter your target website link: ";
$target_url = trim(fgets(STDIN));

$redirect_url = "https://www.bbc.com";

// Send a request with the redirection URL
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $target_url . "?redirect=" . $redirect_url);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
$response = curl_exec($ch);

// Extract status code and effective URL from the response
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$effective_url = curl_getinfo($ch, CURLINFO_EFFECTIVE_URL);

// Color codes
define("RED", "\033[0;31m");
define("GREEN", "\033[0;32m");
define("NC", "\033[0m"); // No Color

// Check if the response status code indicates a successful redirection
if ($http_code >= 300 && $http_code < 400 && $effective_url == $redirect_url) {
  echo GREEN . "Vulnerable: Open Redirection exists" . NC . "\n";
} elseif ($http_code >= 300 && $http_code < 400) {
  echo RED . "Potentially Vulnerable: Redirection occurred but not to the specified URL" . NC . "\n";
} elseif ($http_code < 200 || $http_code >= 400) {
  echo RED . "Not Vulnerable: HTTP request failed with status code $http_code" . NC . "\n";
} else {
  echo RED . "Not Vulnerable: Redirection did not occur" . NC . "\n";
}

curl_close($ch);
