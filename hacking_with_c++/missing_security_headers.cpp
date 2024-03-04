#include <iostream>
#include <string>
#include <curl/curl.h>

// Colors for console output
#define RED "\033[1;31m"
#define GREEN "\033[1;32m"
#define YELLOW "\033[1;33m"
#define RESET "\033[0m"

// Function to perform HTTP GET request using libcurl
std::string performHttpGet(const std::string& url) {
    CURL *curl;
    CURLcode res;
    std::string response;

    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](void *buffer, size_t size, size_t nmemb, void *userp) -> size_t {
            ((std::string*)userp)->append((char*)buffer, size * nmemb);
            return size * nmemb;
        });
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if(res != CURLE_OK) {
            std::cerr << RED << "Failed to perform HTTP GET request: " << curl_easy_strerror(res) << RESET << std::endl;
        }
    }

    return response;
}

// Function to check for missing security headers
void checkSecurityHeaders(const std::string& url) {
    std::string response = performHttpGet(url);

    // Check for missing security headers
    bool missingHeaders = false;
    if (response.find("X-Content-Type-Options") == std::string::npos) {
        std::cout << YELLOW << "Missing X-Content-Type-Options header" << RESET << std::endl;
        missingHeaders = true;
    }
    if (response.find("X-Frame-Options") == std::string::npos) {
        std::cout << YELLOW << "Missing X-Frame-Options header" << RESET << std::endl;
        missingHeaders = true;
    }
    if (response.find("X-XSS-Protection") == std::string::npos) {
        std::cout << YELLOW << "Missing X-XSS-Protection header" << RESET << std::endl;
        missingHeaders = true;
    }

    if (!missingHeaders) {
        std::cout << GREEN << "No missing security headers found" << RESET << std::endl;
    }

    // Information on how to exploit the vulnerability
    std::cout << "To exploit this vulnerability, an attacker could inject malicious content or perform clickjacking attacks." << std::endl;
}

int main() {
    std::string targetWebsite;

    std::cout << "Enter your target website URL: ";
    std::cin >> targetWebsite;

    // Check for missing security headers
    std::cout << "Checking for missing security headers on: " << targetWebsite << std::endl;
    checkSecurityHeaders(targetWebsite);

    return 0;
}
