#include <iostream>
#include <string>
#include <curl/curl.h>
#include <regex>
#include <sstream>

// Function to perform HTTP GET request
size_t curlCallback(void *contents, size_t size, size_t nmemb, std::string *buffer) {
    size_t totalSize = size * nmemb;
    buffer->append((char*)contents, totalSize);
    return totalSize;
}

bool testDOMClobbering(const std::string& url) {
    CURL *curl;
    CURLcode res;
    std::string responseBuffer;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curlCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &responseBuffer);

        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if (res == CURLE_OK) {
            // Use regular expressions to check if the vulnerability exists in the response
            std::regex domClobberingRegex("<script>var document = new Object\\(\\);<\\/script>");
            if (std::regex_search(responseBuffer, domClobberingRegex)) {
                return true;
            }
        }
    }

    return false;
}

int main() {
    std::cout << "\x1B[36mEnter your target website url: \x1B[0m";
    std::string targetUrl;
    std::getline(std::cin, targetUrl);

    std::cout << "Testing for DOM Clobbering vulnerability on: " << targetUrl << std::endl;

    if (testDOMClobbering(targetUrl)) {
        std::cout << "\x1B[32mThe target website is vulnerable to DOM Clobbering.\x1B[0m" << std::endl;
        std::cout << "\x1B[33mTo test the vulnerability, inject the following code into a vulnerable input field or URL parameter:\n"
                  << "javascript:document=Object();\x1B[0m" << std::endl;
    } else {
        std::cout << "\x1B[31mThe target website is not vulnerable to DOM Clobbering.\x1B[0m" << std::endl;
    }

    return 0;
}
