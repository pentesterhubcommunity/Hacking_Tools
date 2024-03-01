#include <iostream>
#include <string>
#include <vector>
#include <thread>
#include <mutex>
#include <curl/curl.h>

// Mutex for thread-safe output
std::mutex mtx;

// ANSI color escape codes
#define RED_COLOR "\033[1;31m"
#define GREEN_COLOR "\033[1;32m"
#define RESET_COLOR "\033[0m"

// Callback function to receive response data
size_t WriteCallback(void *contents, size_t size, size_t nmemb, std::string *response) {
    size_t total_size = size * nmemb;
    response->append((char*)contents, total_size);
    return total_size;
}

// Function to send HTTP request and return the response
std::string SendHTTPRequest(const std::string& url, const std::string& method, const std::vector<std::string>& headers) {
    CURL *curl;
    CURLcode res;
    std::string response;

    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, method.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        // Set request headers
        struct curl_slist *chunk = NULL;
        for (const auto& header : headers) {
            chunk = curl_slist_append(chunk, header.c_str());
        }
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);

        // Follow redirects
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        // Set timeout (10 seconds)
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 10L);

        res = curl_easy_perform(curl);

        curl_slist_free_all(chunk);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            std::cerr << RED_COLOR << "Failed to send HTTP request: " << curl_easy_strerror(res) << RESET_COLOR << std::endl;
            return "";
        }
    }

    return response;
}

// Function to perform Web Cache Deception test
void PerformCacheDeceptionTest(const std::string& target_url, const std::string& method, const std::vector<std::string>& headers) {
    // Send initial request to get the original response
    std::string original_response = SendHTTPRequest(target_url, method, headers);

    if (original_response.empty()) {
        std::lock_guard<std::mutex> lock(mtx);
        std::cout << RED_COLOR << "Failed to retrieve the original response for URL: " << target_url << RESET_COLOR << std::endl;
        return;
    }

    // Manipulate the URL to simulate Web Cache Deception
    std::string manipulated_url = target_url + "/index.html%20";

    // Send manipulated request
    std::string manipulated_response = SendHTTPRequest(manipulated_url, method, headers);

    if (manipulated_response.empty()) {
        std::lock_guard<std::mutex> lock(mtx);
        std::cout << RED_COLOR << "Failed to retrieve the manipulated response for URL: " << manipulated_url << RESET_COLOR << std::endl;
        return;
    }

    // Compare original and manipulated responses
    if (original_response == manipulated_response) {
        std::lock_guard<std::mutex> lock(mtx);
        std::cout << GREEN_COLOR << "Web Cache Deception vulnerability detected for " << target_url << RESET_COLOR << std::endl;
    } else {
        std::lock_guard<std::mutex> lock(mtx);
        std::cout << GREEN_COLOR << "No Web Cache Deception vulnerability detected for " << target_url << RESET_COLOR << std::endl;
    }
}

int main() {
    std::string target_url;
    std::cout << "Enter your target website URL (including http/https): ";
    std::cin >> target_url;

    std::string method;
    std::cout << "Enter HTTP method (GET, POST, etc.): ";
    std::cin >> method;

    int num_threads;
    std::cout << "Enter the number of threads for concurrent requests: ";
    std::cin >> num_threads;

    std::vector<std::string> headers;
    headers.push_back("User-Agent: Mozilla/5.0");

    // Create threads to perform cache deception test concurrently
    std::vector<std::thread> threads;
    for (int i = 0; i < num_threads; ++i) {
        threads.emplace_back(PerformCacheDeceptionTest, target_url, method, headers);
    }

    // Join threads
    for (auto& thread : threads) {
        thread.join();
    }

    return 0;
}
