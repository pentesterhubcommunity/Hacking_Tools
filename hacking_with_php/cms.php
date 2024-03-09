<?php
// Function to test for CMS Information Disclosure Vulnerabilities
function testCMSInfoDisclosure($url) {
    $headers = get_headers($url, 1);

    // Check if the server header is present
    if(isset($headers['Server'])) {
        echo "\033[1;33mServer Header:\033[0m " . $headers['Server'] . "\n";
    } else {
        echo "\033[1;31mServer Header not found!\033[0m\n";
    }

    // Check if X-Powered-By header is present
    if(isset($headers['X-Powered-By'])) {
        echo "\033[1;33mX-Powered-By Header:\033[0m " . $headers['X-Powered-By'] . "\n";
    } else {
        echo "\033[1;31mX-Powered-By Header not found!\033[0m\n";
    }

    // Check if any CMS-specific headers are present
    $cms_headers = array('X-Drupal-Cache', 'X-Joomla-Cache', 'X-Drupal-Dynamic-Cache', 'X-Pingback');
    $vulnerable = false;
    foreach($cms_headers as $header) {
        if(isset($headers[$header])) {
            $vulnerable = true;
            echo "\033[1;31mVulnerable Header Found:\033[0m " . $header . "\n";
        }
    }

    if(!$vulnerable) {
        echo "\033[1;32mTarget is not vulnerable to CMS Information Disclosure!\033[0m\n";
    } else {
        echo "\033[1;31mTarget may be vulnerable to CMS Information Disclosure!\033[0m\n";
    }
}

// Ask for target website URL
echo "\033[1;34mEnter your target website URL: \033[0m";
$target_url = trim(fgets(STDIN));

// Test for CMS Information Disclosure Vulnerabilities
echo "\n\033[1;36mTesting for CMS Information Disclosure Vulnerabilities...\033[0m\n";
testCMSInfoDisclosure($target_url);

// Explanation on how to test the vulnerability
echo "\n\033[1;36mTo test this vulnerability, you can analyze the response headers of the target website.\033[0m\n";
echo "\033[1;36mLook for headers such as 'Server', 'X-Powered-By', and any CMS-specific headers like 'X-Drupal-Cache', 'X-Joomla-Cache', etc.\033[0m\n";
echo "\033[1;36mIf any of these headers are present, it indicates potential CMS Information Disclosure Vulnerabilities.\033[0m\n";
