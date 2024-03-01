#include <iostream>
#include <string>
#include <curl/curl.h>

// Colors for terminal output
#define RED "\033[1;31m"
#define GREEN "\033[1;32m"
#define RESET "\033[0m"

// Callback function to handle the HTTP response
size_t writeCallback(void *contents, size_t size, size_t nmemb, std::string *output) {
    size_t totalSize = size * nmemb;
    output->append((char*)contents, totalSize);
    return totalSize;
}

// Function to check if the response indicates potential SSRF vulnerability
bool checkForSSRF(const std::string& response, const std::string& contentType, long httpCode) {
    // Check if the content type is text-based
    if (contentType.find("text/") != std::string::npos) {
        // Check if the response contains localhost or 127.0.0.1
        if (response.find("localhost") != std::string::npos || response.find("127.0.0.1") != std::string::npos) {
            return true; // Potential SSRF vulnerability detected
        }
    }

    // Check if the HTTP status code indicates a redirect (3xx)
    if (httpCode >= 300 && httpCode < 400) {
        return true; // Potential SSRF vulnerability detected
    }

    return false; // No potential SSRF vulnerability detected
}

int main() {
    CURL *curl;
    CURLcode res;
    std::string response;
    std::string targetUrl;
    long httpCode;
    char *contentType;

    // Prompt the user to enter the target website URL
    std::cout << "Enter your target website URL: ";
    std::getline(std::cin, targetUrl);

    // Initialize curl
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();

    if (curl) {
        // Set the URL to test
        curl_easy_setopt(curl, CURLOPT_URL, targetUrl.c_str());

        // Set the write callback function to capture the response
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        // Perform the HTTP GET request
        res = curl_easy_perform(curl);

        // Check for errors
        if (res != CURLE_OK) {
            std::cerr << RED << "Failed to perform HTTP request: " << curl_easy_strerror(res) << RESET << std::endl;
        } else {
            // Get HTTP status code
            curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);

            // Get content type
            curl_easy_getinfo(curl, CURLINFO_CONTENT_TYPE, &contentType);

            // Output the HTTP status code
            std::cout << "HTTP Status Code: " << httpCode << std::endl;

            // Output the Content-Type
            std::cout << "Content-Type: " << contentType << std::endl;

            // Output the response
            std::cout << "Response: " << response << std::endl;

            // Check for potential SSRF vulnerability
            if (checkForSSRF(response, contentType, httpCode)) {
                std::cout << RED << "Potential SSRF vulnerability detected!" << RESET << std::endl;
            } else {
                std::cout << GREEN << "No potential SSRF vulnerability detected." << RESET << std::endl;
            }
        }

        // Cleanup
        curl_easy_cleanup(curl);
    }

    // Cleanup curl
    curl_global_cleanup();

    return 0;
}
