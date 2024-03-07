<?php
// Function to fetch URL contents
function fetchURL($url) {
    $options = array(
        CURLOPT_RETURNTRANSFER => true,   // return web page
        CURLOPT_HEADER         => false,  // don't return headers
        CURLOPT_FOLLOWLOCATION => true,   // follow redirects
        CURLOPT_ENCODING       => "",     // handle all encodings
        CURLOPT_USERAGENT      => "InfoDisclosureTester", // who am i
        CURLOPT_AUTOREFERER    => true,   // set referer on redirect
        CURLOPT_CONNECTTIMEOUT => 30,     // timeout on connect
        CURLOPT_TIMEOUT        => 30,     // timeout on response
        CURLOPT_MAXREDIRS      => 10,     // stop after 10 redirects
        CURLOPT_SSL_VERIFYPEER => false,  // ignore SSL verification
    );

    $ch = curl_init($url);
    curl_setopt_array($ch, $options);

    $content  = curl_exec($ch);
    $err      = curl_errno($ch);
    $errmsg   = curl_error($ch);
    $header   = curl_getinfo($ch);
    curl_close($ch);

    $header['errno']   = $err;
    $header['errmsg']  = $errmsg;
    $header['content'] = $content;
    
    return $header;
}

// Function to check for information disclosure
function checkInfoDisclosure($url) {
    echo "\033[1;36m[*] Testing for Information Disclosure vulnerability on: $url\n";
    $response = fetchURL($url);
    $status_code = $response['http_code'];

    // Check if response is successful (200 OK)
    if ($status_code == 200) {
        echo "\033[0;32m[+] Information Disclosure vulnerability found!\n";
        echo "\033[0;33m[*] Content:\n";
        echo $response['content'];
    } elseif ($status_code == 404) {
        echo "\033[0;31m[-] The specified URL does not exist (HTTP code $status_code)\n";
    } elseif ($status_code >= 400 && $status_code < 500) {
        echo "\033[0;31m[-] Client error occurred (HTTP code $status_code)\n";
    } elseif ($status_code >= 500 && $status_code < 600) {
        echo "\033[0;31m[-] Server error occurred (HTTP code $status_code)\n";
    } else {
        echo "\033[0;31m[-] Unable to retrieve content (HTTP code $status_code)\n";
    }
}

// Main program
echo "\033[1;36mEnter your target website URL: ";
$target_url = trim(fgets(STDIN));

// Check for information disclosure
checkInfoDisclosure($target_url);
?>
