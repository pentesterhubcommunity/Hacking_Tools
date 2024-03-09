#include <iostream>
#include <curl/curl.h>

// Function to perform HTTP GET request and check for vulnerability
bool checkVulnerability(const std::string& url) {
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());

        // Set custom header to test vulnerability
        struct curl_slist *headers = NULL;
        headers = curl_slist_append(headers, "X-Test-Vulnerability: true");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        // Perform the request
        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            std::cerr << "Failed to perform HTTP request: " << curl_easy_strerror(res) << std::endl;
            curl_easy_cleanup(curl);
            curl_slist_free_all(headers);
            return false;
        }

        // Check if vulnerable
        long http_code;
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
        if (http_code == 200) {
            std::cout << "\x1B[32mTarget website is vulnerable to Custom Header Vulnerabilities!\x1B[0m" << std::endl;
        } else {
            std::cout << "\x1B[31mTarget website is not vulnerable to Custom Header Vulnerabilities.\x1B[0m" << std::endl;
        }

        // Clean up
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
    } else {
        std::cerr << "Failed to initialize curl." << std::endl;
        return false;
    }

    return true;
}

int main() {
    std::string target_url;

    // Ask for target website URL
    std::cout << "Enter your target website URL: ";
    std::getline(std::cin, target_url);

    // Perform vulnerability check
    std::cout << "Performing vulnerability check..." << std::endl;
    if (!checkVulnerability(target_url)) {
        std::cerr << "Vulnerability check failed." << std::endl;
        return 1;
    }

    return 0;
}
