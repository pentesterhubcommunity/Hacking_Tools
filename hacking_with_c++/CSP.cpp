#include <iostream>
#include <string>
#include <cstdlib>
#include <curl/curl.h>

// Function to perform HTTP GET request with timeout
std::string performGetRequest(const std::string& url) {
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

        // Set timeout for the request (in seconds)
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L); // Adjust timeout as needed

        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            std::cerr << "Error: " << curl_easy_strerror(res) << std::endl;
        }

        curl_easy_cleanup(curl);
    }

    return response;
}


// Function to check if CSP bypass is possible
bool checkCSPBypass(const std::string& url) {
    std::string response = performGetRequest(url);
    std::string cspHeader;

    // Retrieve Content-Security-Policy header from response
    CURL *curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_NOBODY, 1L);
        curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, [](void *buffer, size_t size, size_t nmemb, void *userp) -> size_t {
            size_t headerSize = size * nmemb;
            std::string headerLine((char*)buffer, headerSize);
            std::string& cspHeader = *((std::string*)userp);
            if (headerLine.find("Content-Security-Policy:") != std::string::npos) {
                cspHeader = headerLine.substr(headerLine.find(":") + 1);
            }
            return headerSize;
        });
        curl_easy_setopt(curl, CURLOPT_HEADERDATA, &cspHeader);

        CURLcode res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            std::cerr << "Error: " << curl_easy_strerror(res) << std::endl;
        }

        curl_easy_cleanup(curl);
    }

    // Analyze CSP directives for potential bypass
    if (!cspHeader.empty()) {
        // Example: Check if 'unsafe-inline' is present in script-src directive
        if (cspHeader.find("script-src") != std::string::npos && cspHeader.find("unsafe-inline") != std::string::npos) {
            return true;
        }
        // Add more checks for other directives as needed
    }

    return false;
}


int main() {
    // Ask for target website URL
    std::cout << "\033[1;36mEnter your target website URL: \033[0m";
    std::string targetUrl;
    std::cin >> targetUrl;

    // Check for CSP bypass vulnerability
    bool isVulnerable = checkCSPBypass(targetUrl);

    // Display result
    if (isVulnerable) {
        std::cout << "\033[1;32mThe target website is vulnerable to CSP bypass!\033[0m" << std::endl;
        std::cout << "\033[1;33mTo test this vulnerability, try injecting inline scripts or manipulating the CSP header.\033[0m" << std::endl;
    } else {
        std::cout << "\033[1;31mThe target website is not vulnerable to CSP bypass.\033[0m" << std::endl;
    }

    return 0;
}
