#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include <curl/curl.h>

// ANSI color codes for console output
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Callback function to handle HTTP response
size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* response) {
    response->append((char*)contents, size * nmemb);
    return size * nmemb;
}

int main() {
    CURL* curl;
    CURLcode res;
    std::string response;
    std::string targetUrl;
    std::string customHeaders;
    std::string requestData;
    std::string method;
    std::string outputFile;

    // Prompt user for target website URL
    std::cout << "Enter your target website URL: ";
    std::getline(std::cin, targetUrl);

    // Prompt user for HTTP method
    std::cout << "Enter HTTP method (GET, POST, PUT, DELETE): ";
    std::getline(std::cin, method);

    // Prompt user for custom headers (if any)
    std::cout << "Enter custom headers (if any), separated by semicolons (;): ";
    std::getline(std::cin, customHeaders);

    // If method requires data, prompt user for request data
    if (method == "POST" || method == "PUT") {
        std::cout << "Enter request data: ";
        std::getline(std::cin, requestData);
    }

    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if (curl) {
        // Craft malicious HTTP request with manipulated headers and data (if applicable)
        std::string maliciousRequest = method + " / HTTP/1.1\r\n"
                                       "Host: " + targetUrl + "\r\n"
                                       "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Safari/537.36\r\n"
                                       "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\n"
                                       // Add custom headers here
                                       + customHeaders +
                                       "\r\n" +
                                       requestData;

        // Set the URL for the request
        curl_easy_setopt(curl, CURLOPT_URL, targetUrl.c_str());

        // Set the custom headers
        struct curl_slist* headers = NULL;
        headers = curl_slist_append(headers, "Cache-Control: no-cache"); // Ensure no caching by proxies
        headers = curl_slist_append(headers, "Pragma: no-cache"); // Ensure no caching by browsers
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

        // Set the request type
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, method.c_str());

        // Set the request payload
        if (method == "POST" || method == "PUT") {
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, requestData.c_str());
        }

        // Set callback function to receive response
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        // Set timeout
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L); // Timeout in seconds

        // Perform the request
        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            std::cerr << ANSI_COLOR_RED << "curl_easy_perform() failed: " << curl_easy_strerror(res) << ANSI_COLOR_RESET << std::endl;
        }
        else {
            // Print the response
            std::cout << ANSI_COLOR_GREEN << "Response:\n" << response << ANSI_COLOR_RESET << std::endl;

            // Prompt user to save response to file
            std::cout << "Do you want to save the response to a file? (y/n): ";
            char saveResponse;
            std::cin >> saveResponse;
            if (saveResponse == 'y' || saveResponse == 'Y') {
                // Prompt user for output file name
                std::cout << "Enter output file name: ";
                std::cin.ignore(); // Clear input buffer
                std::getline(std::cin, outputFile);

                // Write response to file
                std::ofstream outFile(outputFile);
                if (outFile.is_open()) {
                    outFile << response;
                    std::cout << ANSI_COLOR_GREEN << "Response saved to " << outputFile << ANSI_COLOR_RESET << std::endl;
                    outFile.close();
                }
                else {
                    std::cerr << ANSI_COLOR_RED << "Unable to open file for writing: " << outputFile << ANSI_COLOR_RESET << std::endl;
                }
            }
        }

        // Clean up
        curl_easy_cleanup(curl);
        curl_global_cleanup();
    }
    else {
        std::cerr << ANSI_COLOR_RED << "Failed to initialize libcurl" << ANSI_COLOR_RESET << std::endl;
        return 1;
    }

    return 0;
}
