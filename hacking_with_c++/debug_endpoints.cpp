#include <iostream>
#include <string>
#include <vector>
#include <curl/curl.h>

// ANSI escape codes for color
#define RED_TEXT "\033[1;31m"
#define GREEN_TEXT "\033[1;32m"
#define RESET_TEXT "\033[0m"

// Function to check if the response contains debug endpoints
bool hasDebugEndpoints(const std::string& response) {
    // Define a list of common debug endpoints to check against
    std::vector<std::string> debugEndpoints = {
        "/debug", "/admin/debug", "/dev/debug",
        "/debug.php", "/admin/debug.php", "/dev/debug.php",
        "/debug.html", "/admin/debug.html", "/dev/debug.html",
        "/debug.jsp", "/admin/debug.jsp", "/dev/debug.jsp",
        "/debug.aspx", "/admin/debug.aspx", "/dev/debug.aspx",
        "/debug.cgi", "/admin/debug.cgi", "/dev/debug.cgi",
        "/debug.txt", "/admin/debug.txt", "/dev/debug.txt",
        "/debug.log", "/admin/debug.log", "/dev/debug.log",
        "/debug.yaml", "/admin/debug.yaml", "/dev/debug.yaml"
    };

    // Check if any of the debug endpoints are found in the response
    for (const std::string& endpoint : debugEndpoints) {
        if (response.find(endpoint) != std::string::npos) {
            return true;
        }
    }
    return false;
}

// CURL write callback function to capture response
size_t writeCallback(void* contents, size_t size, size_t nmemb, std::string* response) {
    size_t totalSize = size * nmemb;
    response->append((char*)contents, totalSize);
    return totalSize;
}

int main() {
    CURL* curl;
    CURLcode res;
    std::string targetWebsite;
    std::string responseBuffer; // Buffer to store response chunks

    // Initialize CURL
    curl = curl_easy_init();
    if (!curl) {
        std::cerr << RED_TEXT << "Failed to initialize CURL." << RESET_TEXT << std::endl;
        return 1;
    }

    // Get target website URL from user
    std::cout << "Enter your target website url: ";
    std::cin >> targetWebsite;

    // Set CURL options
    curl_easy_setopt(curl, CURLOPT_URL, targetWebsite.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseBuffer);

    // Perform HTTP request
    res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        std::cerr << RED_TEXT << "Failed to perform HTTP request: " << curl_easy_strerror(res) << RESET_TEXT << std::endl;
        curl_easy_cleanup(curl);
        return 1;
    }

    // Get response code
    long responseCode;
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &responseCode);
    if (responseCode == 200) {
        std::cout << GREEN_TEXT << "HTTP request successful." << RESET_TEXT << std::endl;

        // Analyze response for debug endpoints
        if (hasDebugEndpoints(responseBuffer)) {
            std::cout << RED_TEXT << "The target website may be vulnerable to exposed debug endpoints." << RESET_TEXT << std::endl;
            std::cout << "To test the vulnerability, try accessing debug endpoints like '/debug', '/admin/debug', '/debug.php', etc." << std::endl;
        } else {
            std::cout << GREEN_TEXT << "The target website is not vulnerable to exposed debug endpoints." << RESET_TEXT << std::endl;
        }
    } else {
        std::cerr << RED_TEXT << "Failed to get HTTP response: " << responseCode << RESET_TEXT << std::endl;
    }

    // Cleanup CURL
    curl_easy_cleanup(curl);

    return 0;
}
