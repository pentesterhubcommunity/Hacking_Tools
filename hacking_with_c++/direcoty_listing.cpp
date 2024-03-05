#include <iostream>
#include <curl/curl.h>
#include <string>
#include <vector>
#include <thread>
#include <mutex>

// Mutex for synchronized output
std::mutex mtx;

// Function to handle HTTP responses
size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *buffer) {
    buffer->append((char *)contents, size * nmemb);
    return size * nmemb;
}

// Function to test directory listing vulnerability for a single URL
void TestDirectoryListing(const std::string& url, const std::string& userAgent) {
    CURL *curl = curl_easy_init();
    CURLcode res;
    std::string readBuffer;

    if (curl) {
        // Setting the URL to test
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());

        // Setting user agent
        curl_easy_setopt(curl, CURLOPT_USERAGENT, userAgent.c_str());

        // Setting the write callback function to handle the response
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);

        // Setting timeout for the request
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L); // 10 seconds timeout

        // Sending the HTTP request
        std::lock_guard<std::mutex> lock(mtx);
        std::cout << "\033[1;36m[*] Testing URL: " << url << "\033[0m" << std::endl;
        res = curl_easy_perform(curl);

        // Checking if the request was successful
        if (res == CURLE_OK) {
            // Checking if the response contains directory listing
            if (readBuffer.find("<title>Index of") != std::string::npos) {
                std::lock_guard<std::mutex> lock(mtx);
                std::cout << "\033[1;31m[+] Directory Listing Vulnerability Detected!\033[0m" << std::endl;
                std::cout << "\033[1;31m[!] URL: " << url << "\033[0m" << std::endl;
                std::cout << "\033[1;31m[!] Exploit: You can navigate through directories and access sensitive files.\033[0m" << std::endl;
            } else {
                std::lock_guard<std::mutex> lock(mtx);
                std::cout << "\033[1;32m[-] No Directory Listing Vulnerability Detected.\033[0m" << std::endl;
                std::cout << "\033[1;32m[-] URL: " << url << "\033[0m" << std::endl;
            }
        } else {
            std::lock_guard<std::mutex> lock(mtx);
            std::cerr << "\033[1;33m[!] Error testing URL: " << url << " - " << curl_easy_strerror(res) << "\033[0m" << std::endl;
        }

        // Clean up
        curl_easy_cleanup(curl);
    } else {
        std::cerr << "Failed to initialize libcurl." << std::endl;
    }
}

int main() {
    // Initialize libcurl
    curl_global_init(CURL_GLOBAL_DEFAULT);

    // List of target URLs to test
    std::vector<std::string> targetUrls;

    // Prompting user for the target website URL
    std::string targetUrl;
    std::cout << "Enter your target website URL: ";
    std::getline(std::cin >> std::ws, targetUrl);
    targetUrls.push_back(targetUrl);

    // Predefined user agents
    std::vector<std::string> userAgents = {
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Trident/7.0; rv:11.0) like Gecko",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"
    };

    // Prompting user to select a user agent
    std::cout << "Select a User-Agent or enter a custom one:" << std::endl;
    for (size_t i = 0; i < userAgents.size(); ++i) {
        std::cout << i+1 << ". " << userAgents[i] << std::endl;
    }
    std::cout << "Enter the number corresponding to the User-Agent: ";
    size_t choice;
    std::cin >> choice;
    std::string userAgent;
    if (choice >= 1 && choice <= userAgents.size()) {
        userAgent = userAgents[choice - 1];
    } else {
        std::cout << "Enter a custom User-Agent: ";
        std::getline(std::cin >> std::ws, userAgent);
    }

    // Creating threads to test each URL concurrently
    std::vector<std::thread> threads;
    for (const auto& url : targetUrls) {
        threads.emplace_back(TestDirectoryListing, url, userAgent);
    }

    // Waiting for all threads to finish
    for (auto& thread : threads) {
        thread.join();
    }

    // Clean up libcurl
    curl_global_cleanup();

    return 0;
}
