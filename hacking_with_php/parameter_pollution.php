<?php

// Prompt the user to enter the target website URL
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Fetch the parameters from the target website
$parameters = fetchParameters($targetUrl);

// Function to fetch parameters from a website
function fetchParameters($url) {
    $parameters = array();

    // Fetch the HTML content of the target website
    $html = file_get_contents($url);

    // Use DOMDocument to parse HTML and extract parameters
    $dom = new DOMDocument();
    @$dom->loadHTML($html);

    // Extract parameters from query strings in links and forms
    foreach ($dom->getElementsByTagName('a') as $link) {
        $queryString = parse_url($link->getAttribute('href'), PHP_URL_QUERY);
        if ($queryString) {
            parse_str($queryString, $params);
            $parameters = array_merge($parameters, $params);
        }
    }

    foreach ($dom->getElementsByTagName('form') as $form) {
        $queryString = parse_url($form->getAttribute('action'), PHP_URL_QUERY);
        if ($queryString) {
            parse_str($queryString, $params);
            $parameters = array_merge($parameters, $params);
        }
    }

    return array_unique($parameters);
}

// Function to send HTTP GET requests with different parameter combinations
function sendRequests($url, $params) {
    $queryString = http_build_query($params);
    $fullUrl = $url . '?' . $queryString;

    // Send HTTP GET request
    $response = file_get_contents($fullUrl);

    // Output the response (you can modify this to check for specific behaviors)
    echo "URL: $fullUrl\n";
    echo "Response: $response\n\n";
}

// Send requests with different parameter combinations
echo "Testing for parameter pollution...\n\n";
foreach ($parameters as $param => $value) {
    // Send request with each parameter individually
    sendRequests($targetUrl, array($param => $value));

    // Send request with multiple parameters
    foreach ($parameters as $param2 => $value2) {
        if ($param != $param2) {
            sendRequests($targetUrl, array($param => $value, $param2 => $value2));
        }
    }
}
