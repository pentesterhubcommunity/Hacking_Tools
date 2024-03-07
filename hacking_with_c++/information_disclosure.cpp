#include <iostream>
#include <string>
#include <regex>
#include <curl/curl.h>

// Function to perform HTTP GET request
size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *data) {
    data->append((char*)contents, size * nmemb);
    return size * nmemb;
}

// Function to perform HTTP GET request to the target URL
std::string httpRequest(const std::string& url) {
    CURL *curl;
    CURLcode res;
    std::string response;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        // Set timeout and follow redirects
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L);
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        // Spoof User-Agent
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");

        // Enable SSL certificate verification
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2L);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK)
            std::cerr << "Failed to perform HTTP request: " << curl_easy_strerror(res) << std::endl;

        curl_easy_cleanup(curl);
    }

    return response;
}

// Function to check for SQL injection vulnerability
bool checkSQLInjection(const std::string& response) {
    // Add logic to analyze the response for SQL injection vulnerabilities
    // For demonstration purposes, we'll simply look for common SQL error messages
    std::regex sqlErrorRegex("(SQL syntax|mysql_fetch_array|mysql_fetch_assoc|You have an error in your SQL syntax)");
    return std::regex_search(response, sqlErrorRegex);
}

// Function to check for XSS vulnerability
bool checkXSS(const std::string& response) {
    // Add logic to analyze the response for XSS vulnerabilities
    // For demonstration purposes, we'll simply look for common XSS payloads
    std::regex xssPayloadRegex("(<script>|alert\\()");
    return std::regex_search(response, xssPayloadRegex);
}

// Function to check for directory traversal vulnerability
bool checkDirectoryTraversal(const std::string& response) {
    // Add logic to analyze the response for directory traversal vulnerabilities
    // For demonstration purposes, we'll simply look for common directory traversal strings
    std::regex directoryTraversalRegex("(\\.\\./|\\.\\./|\\.\\./)");
    return std::regex_search(response, directoryTraversalRegex);
}

// Function to check for command injection vulnerability
bool checkCommandInjection(const std::string& response) {
    // Add logic to analyze the response for command injection vulnerabilities
    // For demonstration purposes, we'll simply look for common command injection indicators
    std::regex commandInjectionRegex("(system\\(|exec\\(|shell_exec\\()");
    return std::regex_search(response, commandInjectionRegex);
}

// Function to check for file inclusion vulnerability
bool checkFileInclusion(const std::string& response) {
    // Add logic to analyze the response for file inclusion vulnerabilities
    // For demonstration purposes, we'll simply look for common file inclusion strings
    std::regex fileInclusionRegex("(include\\(|require\\(|require_once\\(|include_once\\()");
    return std::regex_search(response, fileInclusionRegex);
}

// Function to check for server misconfigurations
bool checkServerMisconfigurations(const std::string& response) {
    // Add logic to analyze the response for server misconfigurations
    // For demonstration purposes, we'll simply look for common server error messages
    std::regex serverErrorRegex("(Internal Server Error|Server Misconfiguration)");
    return std::regex_search(response, serverErrorRegex);
}

int main() {
    // Prompt user to enter target website URL
    std::cout << "\033[1;36mEnter your target website URL: \033[0m";
    std::string targetUrl;
    std::cin >> targetUrl;

    // Perform HTTP GET request to the target URL
    std::cout << "\033[1;32m[*] Performing HTTP GET request to " << targetUrl << "...\033[0m" << std::endl;
    std::string response = httpRequest(targetUrl);

    // Display the response
    std::cout << "\033[1;32m[*] Response from " << targetUrl << ":\033[0m" << std::endl;
    std::cout << response << std::endl;

    // Check for SQL injection vulnerability
    if (checkSQLInjection(response)) {
        std::cout << "\033[1;31m[!] SQL Injection Vulnerability Detected!\033[0m" << std::endl;
    }

    // Check for XSS vulnerability
    if (checkXSS(response)) {
        std::cout << "\033[1;31m[!] XSS Vulnerability Detected!\033[0m" << std::endl;
    }

    // Check for directory traversal vulnerability
    if (checkDirectoryTraversal(response)) {
        std::cout << "\033[1;31m[!] Directory Traversal Vulnerability Detected!\033[0m" << std::endl;
    }

    // Check for command injection vulnerability
    if (checkCommandInjection(response)) {
        std::cout << "\033[1;31m[!] Command Injection Vulnerability Detected!\033[0m" << std::endl;
    }

    // Check for file inclusion vulnerability
    if (checkFileInclusion(response)) {
        std::cout << "\033[1;31m[!] File Inclusion Vulnerability Detected!\033[0m" << std::endl;
    }

    // Check for server misconfigurations
    if (checkServerMisconfigurations(response)) {
        std::cout << "\033[1;31m[!] Server Misconfiguration Detected!\033[0m" << std::endl;
    }

    // Show how to exploit the vulnerabilities
    std::cout << "\033[1;31m[!] Exploit:\033[0m" << std::endl;
    std::cout << "   - Analyze the response to identify potential vulnerabilities such as SQL injection, XSS, directory traversal, etc." << std::endl;
    std::cout << "   - Exploit the vulnerabilities found to gain unauthorized access or perform malicious actions." << std::endl;

    return 0;
}
