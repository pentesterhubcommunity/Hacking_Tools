<?php
// Function to log activity to a file
function logActivity($message) {
    $log_file = 'directory_listing_vulnerability_log.txt';
    $timestamp = date('[Y-m-d H:i:s]');
    $log_message = "$timestamp $message\n";
    file_put_contents($log_file, $log_message, FILE_APPEND);
}

// Function to check if directory listing is enabled
function checkDirectoryListing($url) {
    logActivity("Checking directory listing for $url");
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt($ch, CURLOPT_NOBODY, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_USERAGENT, getRandomUserAgent());

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($http_code == 200) {
        if(strpos($response, "<title>Index of") !== FALSE) {
            logActivity("Directory listing is ENABLED for $url");
            echo "\033[0;32mDirectory listing is ENABLED.\033[0m\n";
            echo "\033[1;33mVulnerable URLs:\033[0m\n";
            echo extractVulnerableURLs($url, $response);
        } else {
            logActivity("Directory listing is DISABLED for $url");
            echo "\033[0;31mDirectory listing is DISABLED.\033[0m\n";
        }
    } else {
        logActivity("Error: Could not connect to $url. HTTP code: $http_code");
        echo "\033[0;31mError: Could not connect to the target website. HTTP code: $http_code\033[0m\n";
    }
}

// Function to extract vulnerable URLs from directory listing
function extractVulnerableURLs($url, $response) {
    $vulnerable_urls = array();
    preg_match_all('/<a href=\"([^\"]+)\"/i', $response, $matches);
    foreach ($matches[1] as $match) {
        if ($match !== '../' && $match !== './') {
            $vulnerable_urls[] = $url . '/' . $match;
        }
    }
    return implode("\n", $vulnerable_urls) . "\n";
}

// Function to generate a random user-agent header
function getRandomUserAgent() {
    $user_agents = array(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
    );
    return $user_agents[array_rand($user_agents)];
}

// Function to try bypassing protection systems
function bypassProtectionSystems($url) {
    // You can implement various techniques here to bypass protection systems
    // For example, try adding /index.php, /index.html, /?something, etc.
    $bypass_urls = array(
        $url . '/index.php',
        $url . '/index.html',
        $url . '/?something',
    );

    foreach($bypass_urls as $bypass_url) {
        logActivity("Trying to bypass protection systems for $bypass_url");
        echo "Trying $bypass_url\n";
        checkDirectoryListing($bypass_url);
    }
}

// Main program
echo "\033[1;36mDirectory Listing Vulnerability Tester\033[0m\n";
echo "Enter your target website URL: ";
$target_url = trim(fgets(STDIN));

echo "Checking directory listing for $target_url\n";
checkDirectoryListing($target_url);

echo "Trying to bypass protection systems...\n";
bypassProtectionSystems($target_url);

// Exploitation demonstration
echo "\n\033[1;33mExploitation Demonstration:\033[0m\n";
echo "To exploit the directory listing vulnerability, navigate to the vulnerable URLs identified above in a web browser. If directory listing is enabled, you will see a list of files and directories that should otherwise be hidden.\n";

// Display background information from log file
echo "\n\033[1;33mBackground Information:\033[0m\n";
$log_file = 'directory_listing_vulnerability_log.txt';
if (file_exists($log_file)) {
    echo file_get_contents($log_file);
} else {
    echo "No background information available.\n";
}
?>
