#include <iostream>
#include <string>
#include <cstdlib>
#include <curl/curl.h>

using namespace std;

// ANSI escape codes for text colors
#define RED_TEXT "\033[1;31m"
#define GREEN_TEXT "\033[1;32m"
#define YELLOW_TEXT "\033[1;33m"
#define DEFAULT_TEXT "\033[0m"

// Callback function to handle HTTP response
size_t writeCallback(char* buf, size_t size, size_t nmemb, void* up) {
    // Print the response with green text
    cout << GREEN_TEXT << string(buf, size * nmemb) << DEFAULT_TEXT;
    return size * nmemb;
}

int main() {
    // Prompt the user to enter the target website URL
    cout << "Enter your target website URL: ";
    string targetUrl;
    getline(cin, targetUrl);

    // Prompt the user to choose between GET or POST requests
    cout << "Select HTTP method (GET/POST): ";
    string httpMethod;
    getline(cin, httpMethod);

    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    CURL* curl = curl_easy_init();
    if (!curl) {
        cerr << RED_TEXT << "Failed to initialize libcurl." << DEFAULT_TEXT << endl;
        return 1;
    }

    // Set the URL to test
    curl_easy_setopt(curl, CURLOPT_URL, targetUrl.c_str());

    // Set custom headers or parameters for SSI Injection testing
    struct curl_slist* headers = NULL;
    headers = curl_slist_append(headers, "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3");
    // Add more headers as needed

    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    // Set HTTP method
    if (httpMethod == "POST") {
        curl_easy_setopt(curl, CURLOPT_POST, 1);
        // Optionally, set POST parameters
        // curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "param1=value1&param2=value2");
    }

    // Set callback function to handle HTTP response
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);

    // Perform the HTTP request
    CURLcode res = curl_easy_perform(curl);

    // Check for errors
    if (res != CURLE_OK) {
        cerr << RED_TEXT << "Failed to perform HTTP request: " << curl_easy_strerror(res) << DEFAULT_TEXT << endl;
    }

    // Cleanup
    curl_easy_cleanup(curl);
    curl_global_cleanup();

    return 0;
}
