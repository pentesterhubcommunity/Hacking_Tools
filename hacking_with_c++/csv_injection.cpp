#include <iostream>
#include <curl/curl.h>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
#include <iterator>

// Function to perform HTTP GET request
std::string httpRequest(const std::string& url) {
    CURL *curl;
    CURLcode res;
    std::string response;
    
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char* ptr, size_t size, size_t nmemb, std::string* data) {
            data->append(ptr, size * nmemb);
            return size * nmemb;
        });
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }

    return response;
}

// Function to check if the CSV data contains potential CSV Injection vulnerability
bool checkVulnerability(const std::string& csvData) {
    // Split CSV data into rows
    std::istringstream iss(csvData);
    std::vector<std::string> rows;
    std::string row;
    while (std::getline(iss, row)) {
        rows.push_back(row);
    }
    
    // Check each row for potential injection
    for (const auto& r : rows) {
        if (r.find("<script") != std::string::npos || r.find("&lt;script") != std::string::npos) {
            return true; // Potential injection found
        }
    }
    
    return false;
}

int main() {
    // Prompt user for target website URL
    std::cout << "\033[1;36mEnter your target website url: \033[0m";
    std::string targetUrl;
    std::cin >> targetUrl;

    // Perform HTTP request
    std::cout << "\033[1;33mPerforming HTTP request...\033[0m" << std::endl;
    std::string response = httpRequest(targetUrl);

    // Check for vulnerability
    std::cout << "\033[1;33mChecking for vulnerability...\033[0m" << std::endl;
    bool isVulnerable = checkVulnerability(response);

    // Display result
    if (isVulnerable) {
        std::cout << "\033[1;31mThe target website is vulnerable to CSV Injection!\033[0m" << std::endl;
        std::cout << "\033[1;33mTo test the vulnerability, inject malicious CSV data into a vulnerable form or input field.\033[0m" << std::endl;
    } else {
        std::cout << "\033[1;32mThe target website is not vulnerable to CSV Injection.\033[0m" << std::endl;
    }

    return 0;
}
