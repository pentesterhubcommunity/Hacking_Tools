#include <iostream>
#include <string>
#include <curl/curl.h>

// ANSI escape codes for colors
const std::string ANSI_COLOR_RED = "\033[1;31m";
const std::string ANSI_COLOR_GREEN = "\033[1;32m";
const std::string ANSI_COLOR_RESET = "\033[0m";

// Callback function to write response data into a string
size_t writeCallback(char* ptr, size_t size, size_t nmemb, std::string* data) {
    data->append(ptr, size * nmemb);
    return size * nmemb;
}

// Function to perform an HTTP GET request to the specified URL
std::string makeHttpRequest(const std::string& url) {
    CURL* curl = curl_easy_init();
    std::string response;

    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        CURLcode res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            std::cerr << "Error: " << curl_easy_strerror(res) << std::endl;
        }

        curl_easy_cleanup(curl);
    }

    return response;
}

int main() {
    std::string targetWebsiteUrl;

    std::cout << "Enter your target website URL: ";
    std::getline(std::cin, targetWebsiteUrl);

    // Make an HTTP GET request to the target website
    std::string response = makeHttpRequest(targetWebsiteUrl);

    // Analyze the response for signs of HTML injection vulnerability
    if (response.find("<script>") != std::string::npos) {
        std::cout << ANSI_COLOR_RED << "The website may be vulnerable to HTML injection!" << ANSI_COLOR_RESET << std::endl;
    } else {
        std::cout << ANSI_COLOR_GREEN << "No signs of HTML injection vulnerability found." << ANSI_COLOR_RESET << std::endl;
    }

    return 0;
}
