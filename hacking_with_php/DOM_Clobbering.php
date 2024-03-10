<?php

// Function to send HTTP requests
function sendRequest($url) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

// Function to check if a given URL is vulnerable to DOM clobbering
function checkForDOMClobbering($url) {
    $target = $url . "?_dom_clobbering_test_=true";
    $response = sendRequest($target);
    
    // Check if the response contains the injected DOM element
    if (strpos($response, 'dom_clobbering_test_element') !== false) {
        echo "\033[0;32mThe target website is vulnerable to DOM clobbering!\033[0m\n";
    } else {
        echo "\033[0;31mThe target website is not vulnerable to DOM clobbering.\033[0m\n";
    }
}

// Function to explain how to test the vulnerability
function explainTesting() {
    echo "To test the vulnerability, inject a DOM element with a specific ID into the target URL.\n";
    echo "For example, add '?_dom_clobbering_test_=true' to the end of the URL.\n";
    echo "Then, check if the injected element exists in the response HTML.\n";
}

// Main function
function main() {
    echo "\033[0;33mEnter your target website URL: \033[0m";
    $targetURL = trim(fgets(STDIN));
    
    echo "\n\033[0;36mTesting for DOM clobbering vulnerability on $targetURL...\033[0m\n";
    
    // Checking vulnerability
    checkForDOMClobbering($targetURL);
    
    // Explaining testing process
    echo "\n\033[0;36mTesting Process:\033[0m\n";
    explainTesting();
}

// Execute the main function
main();

?>
