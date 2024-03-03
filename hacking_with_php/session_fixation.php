<?php
// Clear previous session data
session_start();
session_unset();
session_destroy();

// Initialize session
session_start();

// Generate a new session ID
session_regenerate_id();

// Display color-enhanced output
echo "\033[0;33mSession Fixation Vulnerability Tester\033[0m\n\n";

// Prompt user for target website URL
echo "Enter your target website URL: ";
$targetWebsite = trim(fgets(STDIN));

echo "\nTarget Website: \033[0;36m$targetWebsite\033[0m\n";

// Display the generated session ID
$sessionID = session_id();
echo "\033[0;32mSession ID Set: $sessionID\033[0m\n\n";

// Display manual testing instructions
echo "To test the vulnerability manually:\n";
echo "1. Visit the target website and note down the session ID set by the server.\n";
echo "2. Replace the session ID in the URL with the session ID generated by this tool.\n";
echo "3. Reload the page and observe if the session variables remain intact.\n";
echo "4. If the session variables remain intact, the website may be vulnerable to Session Fixation.\n";

?>
